// main.bicep
targetScope = 'subscription'

@description('Azure region')
param location string = 'canadaeast'

@secure()
@description('Admin password for the VMs')
param adminPassword string

@description('Monthly budget in USD')
param budgetAmount int = 20    

@description('Start date for the budget (first day of current month)')
param budgetStartDate string = utcNow('yyyy-MM-01')



// 1. Create resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'watchdog-rg'
  location: location
  tags: {
    env:   'dev'
    owner: 'abdullah'
  }
}

// 2. Deploy all RG resources (network, LA, VMs, lock)
module core './modules/core.bicep' = {
  name: 'core'
  scope: rg
  params: {
    location: location
    adminPassword: adminPassword
  }
}

resource budget 'Microsoft.Consumption/budgets@2024-08-01' = {
  scope: subscription()
  name: 'watchdog-budget'
  properties: {
    amount: budgetAmount
    category: 'Cost'
    notifications: {
      Actual_GreaterThan_80_Percent: {
        contactEmails: [
          'abdullahkahund@gmail.com'
        ]
        enabled: true
        operator: 'GreaterThan'
        threshold: 80
        thresholdType: 'Actual'
      }
    }
    timeGrain: 'Monthly'
    timePeriod: {
      startDate: budgetStartDate
    }

  }
}


// 3. Deploy the Monitor Workbook
module workbookModule 'modules/workbook/workbook.bicep' = {
  name: 'workbook'
  scope: rg
  params: {
    workbookDisplayName: 'VM Health & Cost'
    workbookType:         'workbook'
    // associate your workbook with the Log-Analytics workspace
    workbookSourceId: core.outputs.logAnalyticsWorkspaceId
    // this param drives the *resource name*; make it stable:
    workbookId: guid(rg.id, 'VM Health & Cost')
    // location (defaults to RG location anyway)
    location: location
  }
}

// 4. Now you can consume the new workbook resource Id elsewhere:
output monitorWorkbookResourceId string = workbookModule.outputs.workbookId


