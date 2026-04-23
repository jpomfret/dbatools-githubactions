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

# gh cli to test if issues have stale label?
describe "Check if there are issues with 'no-issue-activity' label" {
    It "There should be no issues with the 'no-issue-activity' label" {
        $issues = gh issue list -l no-issue-activity --json number | ConvertFrom-Json
        $issues.Count | Should Be 0
    }
}