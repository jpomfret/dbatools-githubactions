# On the day - Jess do This

- Run infra action to build environment
- Boost jumpy power
- Run setup script on jumpy
- Build replication setup
- Test self-hosted runner
- Open [dbatools-githubactions](https://github.com/jpomfret/dbatools-githubactions/) in browser
- Make sure the simple actions from demo 1 are deleted
- remove stale issue labels - this needs to happen way before so issues aren't touched

    ```PowerShell
    gh issue list -l no-issue-activity --json number | ConvertFrom-Json | ForEach-Object { gh issue edit $_.number --remove-label "no-issue-activity" }
    ```

- remove CatOwners table
- zoomit
- database project extension
- connect to az sql in ssms
- GitHub signed in so we can push commits
