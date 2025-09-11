# Actions and dbatools

## Self-Hosted Runner

- Docs are specific to your organisation or your repositoty
  - [https://github.com/jpomfret/dbatools-githubactions/settings/actions/runners/new](https://github.com/jpomfret/dbatools-githubactions/settings/actions/runners/new)
- Create a folder under the drive root
  
  ```PowerShell
  Set-Location C:\
  New-Item -Path actions-runner-jpomfret -ItemType Directory
  Set-Location actions-runner-jpomfret
  ```

- Download the latest runner package

  ```PowerShell
  Invoke-WebRequest -Uri https://github.com/actions/runner/releases/download/v2.328.0/actions-runner-win-x64-2.328.0.zip -OutFile actions-runner-win-x64-2.328.0.zip
  ```

- Optional: Validate the hash

  ```PowerShell
  if((Get-FileHash -Path actions-runner-win-x64-2.328.0.zip -Algorithm SHA256).Hash.ToUpper() -ne 'a73ae192b8b2b782e1d90c08923030930b0b96ed394fe56413a073cc6f694877'.ToUpper()){ throw 'Computed checksum did not match' }
  ```

- Extract the installer

  ```PowerShell
  Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD/actions-runner-win-x64-2.328.0.zip", "$PWD")
  ```

- Create the runner and start the configuration experience

  ```PowerShell
  ./config.cmd --url https://github.com/jpomfret/dbatools-githubactions --token ** # get this from the url above
  ```

- Run it!

  ```PowerShell
  ./run.cmd
  ```

## Create database from an issue on GitHub

- look at the [issue template](..\.github\ISSUE_TEMPLATE\AddDatabase.yaml)
- look at the [workflow](..\.github\workflows\createdatabase.yml)
- look at the self-hosted runner on sql1
  - start it up

    ```PowerShell
    cd C:\actions-runner-jpomfret\
    .\run.cmd
    ```

- Create an issue using the template
- Check the action results
- Check for a new database

## Add article to replication

- setup replication - done before the session
- look at articles in publication

  ```PowerShell
  Get-DbaReplArticle -SqlInstance sql1 -Publication testPub | Format-Table
  ```

- look at the issue template
  
  ```PowerShell
  code .\.github\ISSUE_TEMPLATE\AddArticle.yaml
  ```

- look at the action

  ```PowerShell
  code .\.github\workflows\replication.yaml
  ```

- GO CREATE AN ISSUE and watch the workflow
  - Database: AdventureWorksLT2022
  - Publication: testPub
  - Schema: SalesLT
  - Article: Product

- check on the articles
  
  ```PowerShell
  Get-DbaReplArticle -SqlInstance sql1 -Publication testPub | Format-Table
  ```

- look at replication monitor
