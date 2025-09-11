#region gets and info
# Import dev module
Import-Module dbatools

# Connect test
Connect-DbaInstance -SqlInstance sql1, sql2

# smo defaults
Set-DbatoolsConfig -FullName sql.connection.encrypt -Value $false
Set-DbatoolsConfig -FullName sql.connection.trustcert -Value $true

# Connect test
Connect-DbaInstance -SqlInstance sql1, sql2

# gets

# Get the distributor
Get-DbaReplDistributor -SqlInstance sql1

# view publications
Get-DbaReplPublication -SqlInstance sql1

# view articles
Get-DbaReplArticle -SqlInstance sql1

# get subscriptions
Get-DbaReplSubscription -SqlInstance sql1

#endregion

# enable distribution
Enable-DbaReplDistributor -SqlInstance sql1

# enable publishing
Enable-DbaReplPublishing -SqlInstance sql1

# Get the distributor
Get-DbaReplDistributor -SqlInstance sql1

# add a transactional publication
$pub = @{
    SqlInstance = 'sql1'
    Database    = 'AdventureWorksLT2022'
    Name        = 'testPub'
    Type        = 'Transactional'
}
New-DbaReplPublication @pub

# add a merge publication
$pub = @{
    SqlInstance = 'sql1'
    Database    = 'AdventureWorksLT2022'
    Name        = 'mergey'
    Type        = 'Merge'
}
New-DbaReplPublication @pub

# add a snapshot publication
$pub = @{
    SqlInstance = 'sql1'
    Database    = 'AdventureWorksLT2022'
    Name        = 'snappy'
    Type        = 'Snapshot'
}
New-DbaReplPublication @pub

# view publications
Get-DbaReplPublication -SqlInstance sql1

# add an article to each publication
$article = @{
    SqlInstance = 'sql1'
    Database    = 'AdventureWorksLT2022'
    Publication = 'testpub'
    Schema      = 'salesLT'
    Name        = 'customer'
    Filter      = "lastname = 'gates'"
}
Add-DbaReplArticle @article

$article = @{
    SqlInstance = 'sql1'
    Database    = 'AdventureWorksLT2022'
    Publication = 'Mergey'
    Schema      = 'salesLT'
    Name        = 'product'
}
Add-DbaReplArticle @article

$article = @{
    SqlInstance = 'sql1'
    Database    = 'AdventureWorksLT2022'
    Publication = 'snappy'
    Schema      = 'salesLT'
    Name        = 'address'
}
Add-DbaReplArticle @article

# add subscriptions
$sub = @{
    SqlInstance           = 'sql1'
    Database              = 'AdventureWorksLT2022'
    SubscriberSqlInstance = 'sql2'
    SubscriptionDatabase  = 'AdventureWorksLT2022'
    PublicationName       = 'testpub'
    Type                  = 'Push'
}
New-DbaReplSubscription @sub

$sub = @{
    SqlInstance           = 'sql1'
    Database              = 'AdventureWorksLT2022'
    SubscriberSqlInstance = 'sql2'
    SubscriptionDatabase  = 'AdventureWorksLT2022Merge'
    PublicationName       = 'Mergey'
    Type                  = 'Push'
}
New-DbaReplSubscription @sub

$sub = @{
    SqlInstance           = 'sql1'
    Database              = 'AdventureWorksLT2022'
    SubscriberSqlInstance = 'sql2'
    SubscriptionDatabase  = 'AdventureWorksLT2022Snap'
    PublicationName       = 'Snappy'
    Type                  = 'Push'
}
New-DbaReplSubscription @sub


# start snapshot agent
Get-DbaAgentJob -SqlInstance sql1 -Category repl-snapshot | Start-DbaAgentJob
