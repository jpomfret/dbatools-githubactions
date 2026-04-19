# Database Deployment - Cats of the World

This guide covers deploying the CatsOfTheWorld database to the Azure SQL infrastructure created by Terraform.

## Overview

After deploying the Azure infrastructure with Terraform, this workflow:
1. Builds the CatsOfTheWorld database project (.dacpac)
2. Deploys to the target environment using SqlPackage
3. Generates a database summary using dbatools

## Prerequisites

- Azure SQL infrastructure deployed (see [README.md](README.md))
- GitHub Secrets configured:
  - `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`
  - `SQL_ADMIN_PASSWORD` - SQL Server admin password (set during Terraform deployment)

## Database Project Structure

```
demos/database/CatsOfTheWorld/
├── CatsOfTheWorld.sqlproj      # Database project file
├── dbo/
│   ├── Tables/
│   │   ├── Breeds.sql          # Cat breeds reference table
│   │   ├── Cats.sql            # Main cats table
│   │   ├── Memes.sql           # Cat memes tracking
│   │   ├── ToyPreferences.sql  # Cat toy preferences junction table
│   │   └── Toys.sql            # Available cat toys
│   └── StoredProcedures/
│       ├── GetCatPopularityReport.sql
│       └── GetTopMemedCats.sql
└── bin/Debug/
    └── CatsOfTheWorld.dacpac   # Compiled database package
```

## Deployment Workflow

### 1. Manual Deployment via GitHub Actions

```yaml
name: Deploy Database to Environment
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Target environment'
        required: true
        type: choice
        options:
          - dev
          - test
          - prod
```

**Workflow Steps:**
1. Checkout code
2. Build database project (.dacpac)
3. Get SQL Server connection info from Terraform state
4. Deploy database using SqlPackage
5. Run dbatools verification and reporting

### 2. Local Deployment with SqlPackage

```powershell
# Build the database project
dotnet build demos/database/CatsOfTheWorld/CatsOfTheWorld.sqlproj -c Release

# Deploy to dev environment
sqlpackage.exe /Action:Publish `
  /SourceFile:"demos/database/CatsOfTheWorld/bin/Debug/CatsOfTheWorld.dacpac" `
  /TargetServerName:"sql-cotw-dev-xxxxxx.database.windows.net" `
  /TargetDatabaseName:"sqldb-cotw-dev" `
  /TargetUser:"sqladmin" `
  /TargetPassword:"YourPassword" `
  /p:DropObjectsNotInSource=false `
  /p:BlockOnPossibleDataLoss=true
```

### 3. Local Deployment with dbatools

```powershell
# Import required modules
Import-Module dbatools

# Set connection parameters (from Terraform outputs)
$sqlServer = "sql-cotw-dev-xxxxxx.database.windows.net"
$database = "sqldb-cotw-dev"
$credential = Get-Credential -UserName "sqladmin"

# Deploy database using Publish-DbaDacPackage
Publish-DbaDacPackage -SqlInstance $sqlServer `
  -Database $database `
  -SqlCredential $credential `
  -Path "demos/database/CatsOfTheWorld/bin/Debug/CatsOfTheWorld.dacpac" `
  -PublishXml "demos/database/CatsOfTheWorld/CatsOfTheWorld.publish.xml"
```

## Database Verification with dbatools

After deployment, verify and gather information using dbatools:

### Connect to Azure SQL Database

```powershell
# Connect to the deployed database
$splat = @{
    SqlInstance   = "sql-cotw-dev-xxxxxx.database.windows.net"
    SqlCredential = Get-Credential -UserName "sqladmin"
    Database      = "sqldb-cotw-dev"
}

# Test connection
Test-DbaConnection @splat
```

### Get Database Summary

```powershell
# Get database properties
Get-DbaDatabase @splat | Select-Object Name, Status, RecoveryModel, Collation, CompatibilityLevel

# Get table information
Get-DbaDbTable @splat | Select-Object Schema, Name, RowCount, DataSpaceUsed, IndexSpaceUsed

# Get stored procedures
Get-DbaDbStoredProcedure @splat | Select-Object Schema, Name, CreateDate, LastModified

# Get database size and space usage
Get-DbaDbSpace @splat | Format-Table

# Check last backup (Azure SQL auto-backups)
Get-DbaDbBackupHistory @splat | Select-Object -First 5
```

### Generate Database Documentation

```powershell
# Export database schema as scripts
Export-DbaScript @splat -Path ".\cotw-dev-schema\" -Passthru

# Get detailed table schema
Get-DbaDbTable @splat | ForEach-Object {
    [PSCustomObject]@{
        Table      = "$($_.Schema).$($_.Name)"
        Columns    = ($_ | Get-DbaDbTableColumn).Count
        Indexes    = ($_ | Get-DbaDbIndex).Count
        RowCount   = $_.RowCount
        SizeMB     = [math]::Round($_.DataSpaceUsed.Megabyte + $_.IndexSpaceUsed.Megabyte, 2)
    }
} | Format-Table -AutoSize
```

### Health Checks

```powershell
# Check database integrity (not available in Azure SQL Database)
# Use Azure-specific monitoring instead

# Query performance insights
$query = @"
SELECT TOP 10
    query_stats.query_hash AS 'Query Hash',
    SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count) AS 'Avg CPU Time',
    MIN(query_stats.statement_text) AS 'Query Text'
FROM (
    SELECT QS.*, 
    SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,
    ((CASE statement_end_offset 
        WHEN -1 THEN DATALENGTH(ST.text)
        ELSE QS.statement_end_offset END 
        - QS.statement_start_offset)/2) + 1) AS statement_text
    FROM sys.dm_exec_query_stats AS QS
    CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) as ST
) as query_stats
GROUP BY query_stats.query_hash
ORDER BY 2 DESC;
"@

Invoke-DbaQuery @splat -Query $query
```

## Sample Data

After deployment, you can populate the database with sample data:

```powershell
# Insert sample cat breeds
$insertBreed = @"
INSERT INTO dbo.Breeds (BreedName, Origin, Description)
VALUES 
    ('Maine Coon', 'United States', 'Large, gentle giants with tufted ears'),
    ('Siamese', 'Thailand', 'Vocal and social cats with blue eyes'),
    ('Persian', 'Iran', 'Long-haired cats with flat faces'),
    ('British Shorthair', 'United Kingdom', 'Chunky cats with dense coats'),
    ('Ragdoll', 'United States', 'Large, docile cats that go limp when held');
"@

Invoke-DbaQuery @splat -Query $insertBreed

# Insert sample cats
$insertCats = @"
INSERT INTO dbo.Cats (CatName, BreedId, BirthDate, Color, AdoptionStatus)
VALUES 
    ('Whiskers', 1, '2020-05-15', 'Brown Tabby', 'Adopted'),
    ('Luna', 2, '2021-03-22', 'Seal Point', 'Available'),
    ('Oliver', 3, '2019-11-30', 'White', 'Adopted'),
    ('Mittens', 4, '2022-01-10', 'Blue', 'Available'),
    ('Shadow', 5, '2020-08-05', 'Seal', 'Adopted');
"@

Invoke-DbaQuery @splat -Query $insertCats

# Verify data
Invoke-DbaQuery @splat -Query "SELECT c.CatName, b.BreedName, c.Color FROM dbo.Cats c JOIN dbo.Breeds b ON c.BreedId = b.BreedId"
```

## GitHub Actions Workflow Example

Create `.github/workflows/deploy-database.yml`:

```yaml
name: Deploy CatsOfTheWorld Database

on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy database'
        required: true
        type: choice
        options:
          - dev
          - test
          - prod

env:
  DATABASE_PROJECT: './demos/database/CatsOfTheWorld/CatsOfTheWorld.sqlproj'
  DACPAC_PATH: './demos/database/CatsOfTheWorld/bin/Debug/CatsOfTheWorld.dacpac'

jobs:
  deploy-database:
    name: 'Deploy Database - ${{ inputs.environment }}'
    runs-on: windows-latest
    environment: ${{ inputs.environment }}
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Build database project
        run: |
          dotnet build ${{ env.DATABASE_PROJECT }} -c Debug
      
      - name: Install dbatools
        shell: pwsh
        run: |
          Install-Module dbatools -Force -Scope CurrentUser
          Import-Module dbatools
      
      - name: Get SQL Server from Terraform outputs
        shell: pwsh
        run: |
          # Alternative: Read from Terraform outputs artifact
          # For now, using environment-specific values
          $envName = "${{ inputs.environment }}"
          # You would fetch these from Terraform state or outputs
          echo "SQL_SERVER=sql-cotw-$envName-xxxxxx.database.windows.net" >> $env:GITHUB_ENV
          echo "SQL_DATABASE=sqldb-cotw-$envName" >> $env:GITHUB_ENV
      
      - name: Deploy database with SqlPackage
        uses: azure/sql-action@v2.3
        with:
          connection-string: 'Server=${{ env.SQL_SERVER }};Database=${{ env.SQL_DATABASE }};User Id=sqladmin;Password=${{ secrets.SQL_ADMIN_PASSWORD }};Encrypt=true;'
          path: ${{ env.DACPAC_PATH }}
          action: 'publish'
          arguments: '/p:DropObjectsNotInSource=false /p:BlockOnPossibleDataLoss=true'
      
      - name: Generate database summary with dbatools
        shell: pwsh
        run: |
          $securePassword = ConvertTo-SecureString "${{ secrets.SQL_ADMIN_PASSWORD }}" -AsPlainText -Force
          $credential = New-Object System.Management.Automation.PSCredential ("sqladmin", $securePassword)
          
          $splat = @{
              SqlInstance   = "${{ env.SQL_SERVER }}"
              SqlCredential = $credential
              Database      = "${{ env.SQL_DATABASE }}"
          }
          
          Write-Host "## Database Deployment Summary - ${{ inputs.environment }} :cat:" >> $env:GITHUB_STEP_SUMMARY
          Write-Host "" >> $env:GITHUB_STEP_SUMMARY
          
          # Get table count and info
          $tables = Get-DbaDbTable @splat
          Write-Host "**Tables:** $($tables.Count)" >> $env:GITHUB_STEP_SUMMARY
          Write-Host "" >> $env:GITHUB_STEP_SUMMARY
          
          foreach ($table in $tables) {
              Write-Host "- **$($table.Schema).$($table.Name)** - $($table.RowCount) rows" >> $env:GITHUB_STEP_SUMMARY
          }
          
          Write-Host "" >> $env:GITHUB_STEP_SUMMARY
          
          # Get stored procedures
          $procs = Get-DbaDbStoredProcedure @splat
          Write-Host "**Stored Procedures:** $($procs.Count)" >> $env:GITHUB_STEP_SUMMARY
          Write-Host "" >> $env:GITHUB_STEP_SUMMARY
          
          foreach ($proc in $procs) {
              Write-Host "- **$($proc.Schema).$($proc.Name)**" >> $env:GITHUB_STEP_SUMMARY
          }
          
          # Get database size
          $dbInfo = Get-DbaDatabase @splat
          Write-Host "" >> $env:GITHUB_STEP_SUMMARY
          Write-Host "**Database Size:** $([math]::Round($dbInfo.Size, 2)) MB" >> $env:GITHUB_STEP_SUMMARY
          Write-Host "**Compatibility Level:** $($dbInfo.CompatibilityLevel)" >> $env:GITHUB_STEP_SUMMARY
```

## Troubleshooting

### Connection Issues

```powershell
# Test firewall rules
Test-DbaConnection -SqlInstance "sql-cotw-dev-xxxxxx.database.windows.net" -SqlCredential $credential

# Check if your IP is allowed
# Add your IP in Azure Portal > SQL Server > Networking > Firewall rules
```

### Deployment Failures

```powershell
# Review deployment script
sqlpackage.exe /Action:Script `
  /SourceFile:"CatsOfTheWorld.dacpac" `
  /TargetServerName:"sql-cotw-dev-xxxxxx.database.windows.net" `
  /TargetDatabaseName:"sqldb-cotw-dev" `
  /OutputPath:"deploy-script.sql"

# Review the generated SQL script before applying
```

### dbatools Module Not Found

```powershell
# Install dbatools
Install-Module dbatools -Scope CurrentUser -Force

# Update to latest version
Update-Module dbatools
```

## Next Steps

1. ✅ Deploy your database to dev environment
2. ✅ Run verification scripts with dbatools
3. ✅ Populate with sample data
4. ✅ Test stored procedures
5. ✅ Deploy to test and prod environments
6. 📊 Set up monitoring and alerts
7. 🔄 Integrate with CI/CD pipeline

## Resources

- [SqlPackage Documentation](https://learn.microsoft.com/sql/tools/sqlpackage)
- [dbatools Documentation](https://dbatools.io)
- [Azure SQL Database Documentation](https://learn.microsoft.com/azure/azure-sql/database/)
- [SQL Database Projects Extension](https://marketplace.visualstudio.com/items?itemName=ms-mssql.sql-database-projects-vscode)

## Related Files

- [Infrastructure README](README.md) - Terraform deployment guide
- [Deploy Database Workflow](../../.github/workflows/deploydatabase.yml) - Existing deployment workflow
- [Database Project](../database/CatsOfTheWorld/) - Source database project
