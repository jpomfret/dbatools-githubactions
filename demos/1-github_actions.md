# demos

## GitHub Actions

Create simple actions in the browser

### Mark stale issues and pull requests

- Go to [Actions](https://github.com/jpomfret/dbatools-githubactions/actions) for the repo
- Click `New workflow` 
  - If you've got a repo with no actions you'll see `Get started with GitHub Actions`
- search `stale issue`
- configure the action
- talk about the yml file
  - cron schedule
  - add `workflow_dispatch:` so we can kick it off
  - look at the parameters for the action
    - what controls how many days we consider stale?
  - search for the action  `actions/stale`
  - pin version - talk about supply chain attacks
  - look for params - change stale days to 1
- `Commit changes...` to the repo
- Kick off the workflow and see what it does

## 

- add `AI issue summary`
  - look at the workflow created
    - on: issues: opened
    - uses an action called ai-inference
    - passes a prompt - you can also pass prompt files in that are more complicated and include [json schema support](https://github.com/actions/ai-inference?tab=readme-ov-file#promptyml-with-json-schema-support)
    - uses gh cli to add a comment to the issue
  - `Commit changes...` to the repo
  - Have GitHub Copilot in VSCode generate a funny issue for us to summarize
    - open the [issue.md](issue.md) file
    - use the prompt below

      ```text
        can you create a title and a summary for a funny issue I can add to this sample github repo
        the issue should be quite long and can be formatted in markdown. Make me laugh.
        I should be able to copy the markdown and paste it into github issue
      ```

    - create a new issue with the generated markdown
    - look at the action
    - look at the issue comment
