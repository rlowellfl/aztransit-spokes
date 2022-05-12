# Environmental variables
location    = "eastus2"
environment = "prod"

# Tag names and values
required_tags = {
  WorkloadName       = "Transit Hub"
  DataClassification = "Sensitive"
  Criticality        = "Business-Critical"
  BusinessUnit       = "Information Technology"
  OpsTeam            = "Network Team"
  ApplicationName    = "Transit Hub"
  Approver           = "some@guy.com"
  BudgetAmount       = "1234"
  CostCenter         = "99999"
  DR                 = "Mission-Critical"
  Env                = "Production"
  EndDate            = "2025-12-31"
  Owner              = "some@gal.com"
  Requester          = "someother@dude.com"
  TicketNumber       = "54321"
}

# Spoke network variables
spoke_network = {
  sharedsvcs = {
    workloadname   = "sharedsvcs"
    spokeVnetRange = ["10.0.2.0/24"]
    spokeSubName   = "subnet1"
    spokeSubRange  = ["10.0.2.0/24"]
  }

  app1 = {
    workloadname   = "app1"
    spokeVnetRange = ["10.0.3.0/24"]
    spokeSubName   = "subnet1"
    spokeSubRange  = ["10.0.3.0/24"]
  }

  app2 = {
    workloadname   = "app2"
    spokeVnetRange = ["10.0.4.0/24"]
    spokeSubName   = "subnet1"
    spokeSubRange  = ["10.0.4.0/24"]
  }
}