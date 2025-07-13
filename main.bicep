// main.bicep
targetScope = 'subscription'

@description('Azure region')
param location string = 'canadaeast'

@secure()
@description('Admin password for the VMs')
param adminPassword string


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

