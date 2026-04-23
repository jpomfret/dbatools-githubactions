# On the day - Jess do This

- Start containers

    ```PowerShell
    docker run -p 2500:1433 --volume shared:/shared:z --name mssql1 --hostname mssql1 -d dbatools/sqlinstance
    docker run -p 2600:1433 --volume shared:/shared:z --name mssql2 --hostname mssql2 -d dbatools/sqlinstance2
    ```

- Create a couple of databases with autoshrink turned on

    ```PowerShell
    $cred = New-Object System.Management.Automation.PSCredential(
        "sqladmin",
        (ConvertTo-SecureString "dbatools.IO" -AsPlainText -Force)
        )
    $inst = Connect-DbaInstance -SqlInstance "localhost,2600" -SqlCredential $cred

    $dbs = New-DbaDatabase -SqlInstance $inst -Database Shrinky, Tiny

    # Enable AutoShrink using Invoke-DbaQuery
    Invoke-DbaQuery -SqlInstance $inst -Query "ALTER DATABASE tiny SET AUTO_SHRINK ON"
    Invoke-DbaQuery -SqlInstance $inst -Query "ALTER DATABASE shrinky SET AUTO_SHRINK ON"


    ```

- Open [dbatools-githubactions](https://github.com/jpomfret/dbatools-githubactions/) in browser
- Make sure the simple actions from demo 1 are deleted (stale & summary)
- remove stale issue labels - this needs to happen way before so issues aren't touched

    ```PowerShell
    gh issue list -l no-issue-activity --json number | ConvertFrom-Json | ForEach-Object { gh issue edit $_.number --remove-label "no-issue-activity" }
    ```

- zoomit

- make sure actions for big boss project are all folded up
- run the infra action all the way through
- run the deploy database but leave it pending approval to test
- connect to az dev sql in ssms
  - make sure you add rule for IP in networking


```
CREATE TABLE [dbo].[CatVideos] (
    [VideoId]          INT            IDENTITY (1, 1) NOT NULL,
    [CatId]            INT            NULL,
    [VideoTitle]       NVARCHAR (200) NOT NULL,
    [VideoUrl]         NVARCHAR (500) NULL,
    [Platform]         NVARCHAR (50)  DEFAULT ('YouTube') NULL,
    [ViewCount]        BIGINT         DEFAULT ((0)) NULL,
    [LikeCount]        INT            DEFAULT ((0)) NULL,
    [Duration]         INT            NULL,
    [DateUploaded]     DATE           DEFAULT (getdate()) NULL,
    [IsViral]          BIT            DEFAULT ((0)) NULL,
    [ThumbnailUrl]     NVARCHAR (500) NULL,
    [Description]      NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([VideoId] ASC),
    FOREIGN KEY ([CatId]) REFERENCES [dbo].[Cats] ([CatId])
);
GO
```