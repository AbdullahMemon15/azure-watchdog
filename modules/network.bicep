// modules/network.bicep
param location string

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: 'watchdog-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.10.0.0/16']
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.10.1.0/24'
        }
      }
    ]
  }
}

