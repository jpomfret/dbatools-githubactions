# Cats of the World - Database DevOps Demo

This demo showcases Infrastructure as Code (IaC) for database deployments using Terraform and GitHub Actions.

## Overview

This infrastructure deploys Azure SQL Database environments for the Cats of the World (COTW) project across three environments: dev, test, and prod.

**Two-Part Deployment:**
1. **Infrastructure** (this guide) - Deploys Azure resources using Terraform
2. **Database** ([Database Deployment Guide](DATABASE-DEPLOYMENT.md)) - Deploys database schema using SqlPackage and dbatools

## Architecture

Each environment includes:
- **Resource Group**: Following Azure naming conventions `rg-cotw-{env}-{region}`
- **Azure SQL Database**: Serverless configuration for cost optimization
- **Storage Account**: For database backups and artifacts

```mermaid
graph TB
    subgraph GitHub["GitHub Actions"]
        Deploy["Deploy Workflow<br/>terraform-apply.yml"]
        Destroy["Destroy Workflow<br/>terraform-destroy.yml"]
    end
    
    subgraph Azure["Azure Subscription"]
        subgraph Dev["Development Environment"]
            RG_Dev["Resource Group<br/>rg-cotw-dev-eastus"]
            subgraph DevResources["Resources"]
                SQL_Dev["SQL Server<br/>sql-cotw-dev-xxxxxx"]
                DB_Dev["SQL Database<br/>sqldb-cotw-dev<br/>GP_S_Gen5_1 (1 vCore)<br/>32GB, Auto-pause: 60min"]
                ST_Dev["Storage Account<br/>stcatsoftheworlddevxxxxxx"]
            end
            RG_Dev --> SQL_Dev
            RG_Dev --> ST_Dev
            SQL_Dev --> DB_Dev
        end
        
        subgraph Test["Test Environment"]
            RG_Test["Resource Group<br/>rg-cotw-test-eastus"]
            subgraph TestResources["Resources"]
                SQL_Test["SQL Server<br/>sql-cotw-test-yyyyyy"]
                DB_Test["SQL Database<br/>sqldb-cotw-test<br/>GP_S_Gen5_2 (2 vCore)<br/>64GB, Auto-pause: 120min"]
                ST_Test["Storage Account<br/>stcatsoftheworldtestyyyyyy"]
            end
            RG_Test --> SQL_Test
            RG_Test --> ST_Test
            SQL_Test --> DB_Test
        end
        
        subgraph Prod["Production Environment"]
            RG_Prod["Resource Group<br/>rg-cotw-prod-eastus"]
            subgraph ProdResources["Resources"]
                SQL_Prod["SQL Server<br/>sql-cotw-prod-zzzzzz"]
                DB_Prod["SQL Database<br/>sqldb-cotw-prod<br/>GP_S_Gen5_4 (4 vCore)<br/>128GB, No Auto-pause"]
                ST_Prod["Storage Account<br/>stcatsoftheworldprodzzzzzz"]
            end
            RG_Prod --> SQL_Prod
            RG_Prod --> ST_Prod
            SQL_Prod --> DB_Prod
        end
    end
    
    Deploy -.->|Terraform Apply| Dev
    Deploy -.->|Terraform Apply| Test
    Deploy -.->|Terraform Apply| Prod
    Destroy -.->|Terraform Destroy| Dev
    Destroy -.->|Terraform Destroy| Test
    Destroy -.->|Terraform Destroy| Prod
    
    style GitHub fill:#2dba4e,stroke:#1a7f37,color:#fff
    style Deploy fill:#0969da,stroke:#0550ae,color:#fff
    style Destroy fill:#cf222e,stroke:#a40e26,color:#fff
    style Azure fill:#0078d4,stroke:#005a9e,color:#fff
    style Dev fill:#ffd43b,stroke:#e6bc00,color:#000
    style Test fill:#ff8c00,stroke:#d97400,color:#000
    style Prod fill:#dc3545,stroke:#b02a37,color:#fff
```

## Prerequisites

1. **Azure Subscription**: Active Azure subscription with appropriate permissions
2. **GitHub Secrets**: Configure the following secrets in your repository:
   - `AZURE_CREDENTIALS`: Azure service principal credentials (JSON format)
   - `SQL_ADMIN_PASSWORD`: SQL Server administrator password

### Setting up Azure Credentials

Create a service principal and configure GitHub secrets:

```bash
az ad sp create-for-rbac --name "github-actions-cotw" `
  --role contributor `
  --scopes /subscriptions/{subscription-id} `
  --sdk-auth
```

Copy the JSON output and save it as the `AZURE_CREDENTIALS` secret in GitHub.

### Setting up Terraform State Storage (One-Time Setup)

**CRITICAL**: Before running any workflows, you must set up Azure Storage for Terraform state:

```bash
# Navigate to bootstrap directory
cd demos/databaseDevops/terraform/backend-bootstrap

# Login to Azure
az login

# Initialize and apply the bootstrap configuration
terraform init
terraform apply

# Confirm the resources are created
```

This creates:
- **Resource Group**: `rg-terraform-state` 
- **Storage Account**: `stcotwterraformstate` (with versioning enabled)
- **Container**: `tfstate`

**Important Notes:**
- This is a **one-time setup** that must be done before running GitHub Actions workflows
- The storage account stores state for ALL environments (dev/test/prod)
- State files are versioned for safety
- Do NOT destroy these resources unless completely done with the project
- The backend is already configured in `providers.tf` to use these values

## Configuration Files

### Terraform Variables (`data/` folder)

- **general.tfvars**: Common infrastructure settings across all environments
- **dev.tfvars**: Development environment (smallest, auto-pause enabled)
- **test.tfvars**: Test environment (medium sizing)
- **prod.tfvars**: Production environment (larger, auto-pause disabled)

## Deployment

### Deploy Infrastructure

1. Go to **Actions** tab in GitHub
2. Select **Deploy COTW Infrastructure** workflow
3. Click **Run workflow**
4. Choose environment (dev/test/prod)
5. Optionally enable auto-approve
6. Click **Run workflow**

The workflow will:
- Initialize Terraform
- Create a plan
- Apply the infrastructure
- Output resource details

### Destroy Infrastructure (Single Environment)

1. Go to **Actions** tab in GitHub
2. Select **Destroy COTW Infrastructure** workflow
3. Click **Run workflow**
4. Choose environment to destroy
5. Type "destroy" to confirm
6. Click **Run workflow**

⚠️ **WARNING**: This permanently deletes all resources and data in the selected environment!

### Destroy All Environments (Scheduled)

A scheduled workflow runs **daily at 21:00 UTC** to destroy all environments and save costs overnight.

**Manual Trigger:**
1. Go to **Actions** tab in GitHub
2. Select **Scheduled Destroy All Environments** workflow
3. Click **Run workflow**
4. Type "destroy-all" to confirm
5. Click **Run workflow**

The workflow will destroy environments in sequence:
1. Development
2. Test
3. Production

⚠️ **CRITICAL**: This destroys **ALL** infrastructure across all three environments! Use with extreme caution.

**Schedule**: Automatically runs at 21:00 UTC every day to minimize costs during off-hours.

## Environment Specifications

### Development
- **SQL Database**: GP_S_Gen5_1 (1 vCore, Serverless)
- **Max Size**: 32 GB
- **Auto-pause**: 60 minutes
- **Min Capacity**: 0.5 vCore

### Test
- **SQL Database**: GP_S_Gen5_2 (2 vCore, Serverless)
- **Max Size**: 64 GB
- **Auto-pause**: 120 minutes
- **Min Capacity**: 0.5 vCore

### Production
- **SQL Database**: GP_S_Gen5_4 (4 vCore, Serverless)
- **Max Size**: 128 GB
- **Auto-pause**: Disabled
- **Min Capacity**: 1.0 vCore

## Cost Optimization

This setup uses Azure SQL Database Serverless tier to minimize costs:
- **Auto-pause**: Automatically pauses during inactivity (dev/test only)
- **Auto-resume**: Resumes on first connection
- **Serverless pricing**: Pay only for compute used
- **LRS Storage**: Locally redundant storage for cost savings

## Terraform State Management

This project uses **Azure Storage Backend** for Terraform state, which provides:

✅ **Persistent State**: State is preserved across GitHub Actions workflow runs  
✅ **State Locking**: Prevents concurrent modifications  
✅ **Versioning**: State file history with blob versioning  
✅ **Team Collaboration**: Shared state accessible to all team members

### State Configuration

The backend is configured in [providers.tf](demos/databaseDevops/terraform/providers.tf):

```hcl
backend "azurerm" {
  resource_group_name  = "rg-terraform-state"
  storage_account_name = "stcotwterraformstate"
  container_name       = "tfstate"
  key                  = "cotw.terraform.tfstate"
}
```

### State Files

All three environments (dev/test/prod) share the same state file: `cotw.terraform.tfstate`

Terraform uses **workspaces** or **resource targeting** to manage different environments within the same state file. Each environment's resources are tracked by their unique names (e.g., `rg-cotw-dev-uksouth` vs `rg-cotw-prod-uksouth`).

### Viewing State

To view the current state:

```bash
cd demos/databaseDevops/terraform
terraform init
terraform state list
```

### State Locking

Azure Storage automatically provides state locking via blob leases, preventing concurrent modifications that could corrupt state.

## Manual Terraform Commands

```bash
# Navigate to terraform directory
cd demos/databaseDevops/terraform

# Initialize
terraform init

# Plan for dev environment
terraform plan \
  -var-file="../data/general.tfvars" \
  -var-file="../data/dev.tfvars" \
  -var="sql_server_admin_password=YourSecurePassword123!"

# Apply
terraform apply \
  -var-file="../data/general.tfvars" \
  -var-file="../data/dev.tfvars" \
  -var="sql_server_admin_password=YourSecurePassword123!"

# Destroy
terraform destroy \
  -var-file="../data/general.tfvars" \
  State is managed in Azure Storage with automatic locking
- If a workflow fails, the state lock may need manual release
- Check Azure Storage blob leases if you see "state locked" errors"
```

## Connecting to SQL Database

After deployment, use the outputs to connect:

```powershell
# Get connection details from Terraform outputs
$serverName = terraform output -raw sql_server_fqdn
$databaseName = terraform output -raw sql_database_name

# Using dbatools
Connect-DbaInstance -SqlInstance $serverName -Database $databaseName -SqlCredential $credential
```

## Troubleshooting

### Authentication Errors
- Verify `AZURE_CREDENTIALS` secret is properly formatted
- Ensure service principal has Contributor role on subscription

### SQL Password Errors
- Verify `SQL_ADMIN_PASSWORD` secret meets complexity requirements (uppercase, lowercase, number, special character)

### Terraform State Conflicts
- Ensure only one workflow runs at a time per environment
- Consider implementing state locking with Azure Storage

## Next Steps

1. ✅ Configure remote state backend (Completed - using Azure Storage)
2. ✅ Add database deployment via SQLPackage/dacpac - **[See Database Deployment Guide](DATABASE-DEPLOYMENT.md)**
3. Implement database migrations
4. Add monitoring and alerting
5. Configure backup retention policies
6. Set up automated testing for database changes

## Related Documentation

- **[Database Deployment Guide](DATABASE-DEPLOYMENT.md)** - Deploy CatsOfTheWorld database using SqlPackage and dbatools
- **[Deploy Database Workflow](../../.github/workflows/deploy-cotw-database.yml)** - Automated database deployment pipeline
- **[Infrastructure Workflow](../../.github/workflows/terraform-apply.yml)** - Infrastructure deployment pipeline
