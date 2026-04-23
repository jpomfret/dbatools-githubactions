# demos

## Automation - Big Boss Level

- talk through the slide

- GO TO GITHUB
  - Show the database devops process that's waiting for approval to test
    - [GHA cats](https://github.com/jpomfret/dbatools-githubactions/actions/workflows/deploy-cotw-database.yml)
    - talk about approvals
    - show the jobs & the steps

- show the folder setup
  - database folder
    - CatsOfTheWorld - a SQL Database Project
      - contains our SQL definition files

- show the GitHub Actions
  - deploy-cotw-database.yml

- FINAL DEMO - Create a database & connect to it in SSMS
  - AddDatabase.yml Issue template
  - createdatabase.yml workflow
  - create a database to dev\test with and deploy the latest sql project
