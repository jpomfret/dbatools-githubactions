# create a self-hosted runner

# docs here:
https://github.com/organizations/JessAndRob/settings/actions/runners/new?arch=x64&os=win

# Create a folder under the drive root
Set-Location C:\
New-Item -Path actions-runner-jpomfret -ItemType Directory
Set-Location actions-runner-jpomfret

# Download the latest runner package
Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.328.0/actions-runner-win-x64-2.328.0.zip -OutFile actions-runner-win-x64-2.328.0.zip
# Optional: Validate the hash
if((Get-FileHash -Path actions-runner-win-x64-2.328.0.zip -Algorithm SHA256).Hash.ToUpper() -ne 'a73ae192b8b2b782e1d90c08923030930b0b96ed394fe56413a073cc6f694877'.ToUpper()){ throw 'Computed checksum did not match' }

# Extract the installer
Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.328.0.zip", "$PWD")

# Create the runner and start the configuration experience
./config.cmd --url https://github.com/jpomfret/dbatools-githubactions --token ** # get this from the url above

# Run it!
./run.cmd

## current articles
Get-DbaReplArticle -SqlInstance sql1 -Publication testPub | Format-Table

## look at the issue template
code .\.github\ISSUE_TEMPLATE\AddArticle.yaml

## look at the action
code .\.github\workflows\replication.yaml

## GO CREATE AN ISSUE and watch the workflow
    # Database: AdventureWorksLT2022
    # Publication: testPub
    # Schema: SalesLT
    # Article: Product

## check on the articles
Get-DbaReplArticle -SqlInstance sql1 -Publication testPub | Format-Table

## look at replication monitor