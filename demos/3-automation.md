# demos

## Automation - Big Boss Level

- show the folder setup
  - database folder
    - CatsOfTheWorld - a SQL Database Project
      - contains our SQL definition files

- show the GitHub Actions
  - deploy-cotw-database.yml
    - deploy the database to dev\test\prod environments

- GO TO GITHUB
- DEMO the infra creation - show one that did work and finished
  - [GHA-Infra Run](https://github.com/jpomfret/dbatools-githubactions/actions/runs/24627796604)
- Show the database devops process that's waiting for approval to test

- FINAL DEMO - Create a database & connect to it in SSMS
  - createdatabase.yml
    - create a database to dev\test with and deploy the latest sql project
