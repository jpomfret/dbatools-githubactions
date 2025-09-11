# SQL Server Automation with PowerShell, dbatools and GitHub Actions

## Session Goals

- Understanding of what GitHub Actions are and how they can be used for database automation
- dbatools examples for SQL Server automation
- attendees will have ideas for their own automation projects

## Abstract

This talk demonstrates how GitHub Actions can be leveraged with PowerShell and SQL Server to streamline database operations and implement DevOps practices for your database environment.

What you'll learn:

- GitHub Actions – This powerful CI/CD platform enables automation triggered by code commits, issue creation and more.
- PowerShell and dbatools – We'll then add PowerShell and dbatools into the mix to extend the automation to managing SQL Server automation.
- Demos and Ideas – I'll show multiple demos, including adding articles to SQL Server replication and deploying database change with sqlpackage.

This session aims to give you a practical understanding of how to combine these technologies to reduce manual effort, minimize human error, and build more reliable and repeatable processes for your SQL Server environments.

## But what if I have Azure DevOps?

Don't worry these tools are similar that you can still take the concepts you learn today and apply to using Azure DevOps.

Translations:

| GitHub Actions      | Azure DevOps      |
|---------------------|-------------------|
| Workflow            | Pipeline          |
| Job                 | Stage             |
| Step                | Task              |
| Action              | Task/Extension    |
| Secret              | Variable (Secret) |
| Self-Hosted Runner  | Self-Hosted Agent |
