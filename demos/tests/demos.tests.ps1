# write a test to make sure there isn't files in the workflows folder called stale.yml or summary.yml
describe "Check for unwanted files in .github/workflows" {
    $unwantedFiles = @("stale.yml", "summary.yml")
    $workflowPath = Join-Path -Path (Get-Location) -ChildPath ".github\workflows"
    
    foreach ($file in $unwantedFiles) {
        $filePath = Join-Path -Path $workflowPath -ChildPath $file
        It "File '$file' should not exist in .github/workflows" {
            Test-Path -Path $filePath | Should Be False
        }
    }
}

# make sure there isn't a CatOwners.sql file in the tables database folder
describe "Check for unwanted CatOwners.sql file in tables database folder" {
    $filePath = Join-Path -Path (Get-Location) -ChildPath "demos\database\CatsOfTheWorld\dbo\Tables\CatOwners.sql"

    It "File 'CatOwners.sql' should not exist in databases/CatsOfTheWorld/dbo/tables" {
        Test-Path -Path $filePath | Should Be False
    }
}

# test replication is enabled on sql1
describe "Check if replication is enabled on sql1" {
    $replication = Get-DbaReplServer -SqlInstance sql1
    It "sql1 should be a publisher" {
        $replication.IsPublisher | Should Be $true
    }
    It "sql1 should be a distributor" {
        $replication.IsDistributor | Should Be $true
    }
}

# test there is a testpub publication
describe "Check for testpub publication" {
    $publication = Get-DbaReplPublication -SqlInstance sql1
    It "There should be a publication named 'testpub'" {
        $publication | Where-Object { $_.Name -eq 'testpub' } | Should Not BeNullOrEmpty
    }
}

# gh cli to test if issues have stale label?
describe "Check if there are issues with 'no-issue-activity' label" {
    It "There should be no issues with the 'no-issue-activity' label" {
        $issues = gh issue list -l no-issue-activity --json number | ConvertFrom-Json
        $issues.Count | Should Be 0
    }
}