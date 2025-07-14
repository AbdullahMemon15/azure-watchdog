// modules/core.bicep
@description('Deployment region')
param location string

@secure()
@description('Admin password for the VMs')
param adminPassword string

// 1. Lock the resource group
resource rgLock 'Microsoft.Authorization/locks@2016-09-01' = {
  name: 'rg-readonly'
  properties: {
    level: 'CanNotDelete'
    notes: 'Prevent accidental deletes'
  }
}

// 2. Log Analytics workspace
resource la 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: 'watchdog-law'
  location: location
  properties: {
    sku: { name: 'PerGB2018' }
    retentionInDays: 30
  }
}

// 3. Network module
module network './network.bicep' = {
  name: 'network'
  params: {
    location: location
  }
}

// 4. VMs module
module vms './vms.bicep' = {
  name: 'vms'
  params: {
    location: location
    logAnalyticsWorkspaceId: la.id
    adminPassword: adminPassword
  }
}

module alerts './alerts.bicep' = {
  name: 'alerts'
  params: {
    // location: location
    actionGroupLocation     : 'global'
    alertRuleLocation       : 'eastus'
    notificationEmail: 'abdullahakhund@gmail.com'   // replace as needed
    teamsWebhookUri:  ''                            // paste connector URL later
    logAnalyticsWorkspaceId: la.id                 // ← pass LA workspace
  }
}

// modules/core.bicep
output actionGroupId string = alerts.outputs.actionGroupId
