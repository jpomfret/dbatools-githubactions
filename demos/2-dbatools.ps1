###################
# dbatools demos
###################

#region intro

## Find the module
Find-PSResource -Name dbatools

Find-Module -Name dbatools

## Install the module

Install-PSResource -Name dbatools
Install-PSResource -Name dbatools -Reinstall

Install-Module -Name dbatools

## Import the module
Import-Module dbatools
Get-Module

## Find commands

Get-Command -Module dbatools | Measure-Object

Get-Command -Module dbatools -Name *backup*
Find-DbaCommand -Pattern *backup*

## How do I use them?

Get-Help Get-DbaDatabase
Get-Help Get-DbaDatabase -Full
Get-Help Get-DbaDatabase -Examples
Get-Help Get-DbaDatabase -ShowWindow

#endregion

#region connect to a SQL instance

## Connect to a SQL instance
$inst = Connect-DbaInstance -SqlInstance sql1
$inst

<#
# Use a container
    $cred = New-Object System.Management.Automation.PSCredential(
        "sqladmin",
        (ConvertTo-SecureString "dbatools.IO" -AsPlainText -Force)
    )
    $inst = Connect-DbaInstance -SqlInstance "localhost,2500" -SqlCredential $cred
#>

#region create a database


## Create a database
New-DbaDatabase -SqlInstance $inst -Name PASS_NLDemos
Get-DbaDatabase -SqlInstance $inst | Select-Object Name, CreateDate

Get-Help New-DbaDatabase -ShowWindow

## But I have very specific needs!
$databaseParams = @{
    SqlInstance             = $inst
    Name                    = "verySpecificDatabase"
    LogSize                 = 32
    LogMaxSize              = 512
    PrimaryFilesize         = 64
    PrimaryFileMaxSize      = 512
    SecondaryFilesize       = 64
    SecondaryFileMaxSize    = 512
    LogGrowth               = 32
    PrimaryFileGrowth       = 64
    SecondaryFileGrowth     = 64
    DataFileSuffix          = "_PRIMARY"
    LogFileSuffix           = "_Log"
    SecondaryDataFileSuffix = "_MainData"
}
New-DbaDatabase @databaseParams

Get-DbaDatabase -SqlInstance $inst | Select-Object Name, CreateDate

Get-DbaDbFile -SqlInstance $inst -Database verySpecificDatabase |
Select-Object LogicalName, FileGroup, Size, MaxSize, Growth, FileGroupName

#endregion

#region backup a database

## Backup a database
Backup-DbaDatabase -SqlInstance $inst -Database verySpecificDatabase

## View backup history
Get-DbaDbBackupHistory -SqlInstance $inst -Database verySpecificDatabase

# this is an object, look how much more there is!
Get-DbaDbBackupHistory -SqlInstance $inst -Database verySpecificDatabase | 
Format-List *

# backup all the databases - copy only
Backup-DbaDatabase -SqlInstance $inst -CopyOnly

# There are a lot of options
Get-Help Backup-DbaDatabase -ShowWindow

#endregion

#region scale

# What if I have many instances?
$instances = "sql1", "sql2", "sql3"
$instances = $inst, $inst

# What if I need to get information from all of them?
Get-DbaDatabase -SqlInstance $instances |
Select-Object SqlInstance, Name, CreateDate, AutoShrink, AutoClose

# Check out all the other dbatools commands - as we saw there were almost 700

    Get-DbaAgentJob # Get info on jobs
    Get-DbaDbCompression # Get info on data compression
    Get-DbaAgReplica # Get info on availability group replicas

    Test-DbaSpn # Check SPNs are in place
    Set-DbaSpn # Fix SPNs - this command is pure gold

    Get-DbaDiskSpace # Check disk space

    Set-DbaAgentJobCategory # Change job categories
    Set-DbaAgentJob # Change jobs, including disabling/enabling

    Test-DbaBuild # Am I patched?
    Test-DbaPowerPlan # Am I using High Performance?
    Test-DbaDbCompatibility # Do my database compatibility levels match the engine version?

#endregion