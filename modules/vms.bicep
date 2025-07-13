// modules/vms.bicep
@description('Deployment region')
param location string

@description('Log Analytics workspace ID')
param logAnalyticsWorkspaceId string

@description('Admin username for the VMs')
param adminUsername string = 'azureuser'

@secure()
@description('Admin password for the VMs')
param adminPassword string

// NICs
resource nic 'Microsoft.Network/networkInterfaces@2023-05-01' = [
  for i in range(0, 2): {
    name: 'watchdog-nic${i}'
    location: location
    properties: {
      ipConfigurations: [
        {
          name: 'ipconfig1'
          properties: {
            subnet: {
              id: resourceId('Microsoft.Network/virtualNetworks/subnets',
                             'watchdog-vnet', 'default')
            }
            privateIPAllocationMethod: 'Dynamic'
          }
        }
      ]
    }
  }
]

// VMs
resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = [
  for i in range(0, 2): {
    name: 'watchdog-vm${i}'
    location: location
    properties: {
      hardwareProfile: {
        vmSize: 'Standard_B1s'
      }
      osProfile: {
        computerName: 'watchdog${i}'
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      storageProfile: {
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer:     'WindowsServer'
          sku:       '2019-Datacenter'
          version:   'latest'
        }
        osDisk: { createOption: 'FromImage' }
      }
      networkProfile: {
        networkInterfaces: [
          { id: nic[i].id }
        ]
      }
      diagnosticsProfile: {
        bootDiagnostics: { enabled: true }
      }
    }
  }
]

// Log Analytics extension -- FIXED LOOP
resource laExt 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = [
  for i in range(0, 2): {
    parent: vm[i]
    name: 'OmsAgentForWindows${i}'
    location: location
    properties: {
      publisher: 'Microsoft.Azure.Monitor'
      type: 'OmsAgentForWindows'
      typeHandlerVersion: '1.0'
      autoUpgradeMinorVersion: true
      settings: {
        workspaceId: logAnalyticsWorkspaceId
      }
    }
  }
]

