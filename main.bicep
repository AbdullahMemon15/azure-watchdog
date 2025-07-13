// main.bicep
targetScope = 'subscription'

@description('Azure region')
param location string = 'canadaeast'

@secure()
@description('Admin password for the VMs')
param adminPassword string

// @description('Monthly budget (USD)')
// param budgetAmount int = 5

// @description('Budget start date (YYYY-MM-DD)')
// param budgetStartDate string = '2025-07-10'

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

// 3. Subscription-level cost budget
// resource budget 'Microsoft.Consumption/budgets@2021-10-01' = {
//   name: 'watchdog-budget'
//   scope: subscription()
//   properties: {
//     category: 'Cost'
//     amount: budgetAmount
//     timeGrain: 'Monthly'
//     timePeriod: {
//       startDate: budgetStartDate
//     }
//     notifications: {
//       threshold80: {
//         enabled: true
//         operator: 'GreaterThan'
//         threshold: 80
//         thresholdType: 'Percentage'
//         contactEmails: [
//           'abdullahakhund@Gmail.com'   
//         ]
//       }
//     }
//   }
// }

