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

- look at the [issue template](..\.github\ISSUE_TEMPLATE\AddDatabase.yml)
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

- look at the [issue template](..\.github\ISSUE_TEMPLATE\AddArticle.yml)
- look at the [workflow](..\.github\workflows\replication.yml)


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

## On Commit deploy database code

- look at the [workflow](..\.github\workflows\deploydatabase.yml)
- SQL Connection is to database 'OliviaBenson' on server 'kc-ts-01.database.windows.net'.
- look at the folder `demos/database/`
  - we have a [sql project](..\demos\database\CatsOfTheWorld\CatsOfTheWorld.sqlproj)
  - and some sql objects like [Breeds.sql](..\demos\database\CatsOfTheWorld\dbo\Tables\Breeds.sql)
- look at the database project extension
- look at SSMS at the OliviaBenson database on kc-ts-01.database.windows.net
- run the workflow manually - [Build and deploy database](https://github.com/jpomfret/dbatools-githubactions/actions/workflows/deploydatabase.yml)
- add a new table called CatOwners

```sql
  CREATE TABLE [dbo].[CatOwners] (
      [OwnerId]                INT            IDENTITY (1, 1) NOT NULL,
      [CatId]                  INT            NOT NULL,
      [OwnerName]              NVARCHAR (100) NOT NULL,
      [OwnerEmail]             NVARCHAR (150) NULL,
      [YearsOwningCats]        INT            DEFAULT ((1)) NULL,
      [FavoriteTimeToFeedCat]  TIME           DEFAULT ('07:00:00') NULL,
      [NumberOfCatPhotosDaily] INT            DEFAULT ((15)) NULL,
      [HasCatTattoo]           BIT            DEFAULT ((0)) NULL,
      [SpeaksCatLanguage]      BIT            DEFAULT ((0)) NULL,
      [TreatsDispensedDaily]   INT            DEFAULT ((5)) NULL,
      [OwnershipStartDate]     DATE           DEFAULT (getdate()) NULL,
      [IsTrainedByCat]         BIT            DEFAULT ((1)) NULL,
      PRIMARY KEY CLUSTERED ([OwnerId] ASC),
      FOREIGN KEY ([CatId]) REFERENCES [dbo].[Cats] ([CatId]),
      CHECK ([YearsOwningCats]>=(0) AND [YearsOwningCats]<=(50)),
      CHECK ([NumberOfCatPhotosDaily]>=(0) AND [NumberOfCatPhotosDaily]<=(500)),
      CHECK ([TreatsDispensedDaily]>=(0) AND [TreatsDispensedDaily]<=(100))
  );
```

- build it
- push the code
- look at the action running
- check the table made it to OliviaBenson.
