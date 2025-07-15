@description ('The friendly name for the workbook that is used in the Gallery or Saved List.  This name must be unique within a resource group.')
param workbookDisplayName string = 'metric workbooks'

@description('The gallery that the workbook will been shown under. Supported values include workbook, tsg, etc. Usually, this is \'workbook\'')
param workbookType string = 'workbook'

@description('The id of resource instance to which the workbook will be associated')
param workbookSourceId string = 'azure monitor'

@description('The unique guid for this workbook instance')
param workbookId string

@description('Location for the workbook resource')
param location string = resourceGroup().location

resource workbookId_resource 'microsoft.insights/workbooks@2022-04-01' = {
  name: workbookId
  location: location
  kind: 'shared'
  properties: {
    displayName: workbookDisplayName
    serializedData: '{"version":"Notebook/1.0","items":[{"type":10,"content":{"chartId":"workbook1944b7e1-1d0b-4736-8545-7bb34a8c1eef","version":"MetricsItem/2.0","size":0,"chartType":2,"resourceType":"microsoft.compute/virtualmachines","metricScope":0,"resourceIds":["/subscriptions/7db537f3-cf39-4fec-9d98-9e2d131f4a4c/resourceGroups/watchdog-rg/providers/Microsoft.Compute/virtualMachines/watchdog-vm0"],"timeContext":{"durationMs":86400000},"metrics":[{"namespace":"microsoft.compute/virtualmachines","metric":"microsoft.compute/virtualmachines--Percentage CPU","aggregation":4,"columnName":" Percentage CPU metric"}],"title":"Percentage CPU chart","gridSettings":{"rowLimit":10000}},"name":"metric - 1"},{"type":10,"content":{"chartId":"workbook9aeb0290-4486-40e6-adfd-36219a1ce487","version":"MetricsItem/2.0","size":0,"chartType":2,"resourceType":"microsoft.compute/virtualmachines","metricScope":0,"resourceIds":["/subscriptions/7db537f3-cf39-4fec-9d98-9e2d131f4a4c/resourceGroups/watchdog-rg/providers/Microsoft.Compute/virtualMachines/watchdog-vm0"],"timeContext":{"durationMs":86400000},"metrics":[{"namespace":"microsoft.compute/virtualmachines","metric":"microsoft.compute/virtualmachines--Data Disk Read Bytes/sec","aggregation":4,"columnName":"Disk Read Bytes/sec metric"}],"title":"Disk Read Bytes/sec","gridSettings":{"rowLimit":10000}},"name":"metric - 2"},{"type":9,"content":{"version":"KqlParameterItem/1.0","parameters":[{"id":"08a19065-ed93-492e-9336-f9de35206764","version":"KqlParameterItem/1.0","name":"workspace","type":5,"typeSettings":{"additionalResourceOptions":[]},"timeContext":{"durationMs":86400000},"value":null}],"style":"pills","queryType":0,"resourceType":"microsoft.operationalinsights/workspaces"},"name":"parameters - 3"},{"type":10,"content":{"chartId":"workbook019ea4e9-f443-4a28-b555-71b50cb6f689","version":"MetricsItem/2.0","size":0,"chartType":2,"resourceType":"microsoft.compute/virtualmachines","metricScope":0,"resourceIds":["/subscriptions/7db537f3-cf39-4fec-9d98-9e2d131f4a4c/resourceGroups/watchdog-rg/providers/Microsoft.Compute/virtualMachines/watchdog-vm0"],"timeContext":{"durationMs":86400000},"metrics":[{"namespace":"microsoft.compute/virtualmachines","metric":"microsoft.compute/virtualmachines--Data Disk Write Bytes/sec","aggregation":4,"columnName":"disk write metric"}],"title":"disk wrte metrics","gridSettings":{"rowLimit":10000}},"name":"metric - 4"}],"isLocked":false,"defaultResourceIds":["/subscriptions/7db537f3-cf39-4fec-9d98-9e2d131f4a4c/resourceGroups/watchdog-rg/providers/Microsoft.OperationalInsights/workspaces/watchdog-law","Azure Monitor"],"fallbackResourceIds":["/subscriptions/7db537f3-cf39-4fec-9d98-9e2d131f4a4c/resourceGroups/watchdog-rg/providers/Microsoft.OperationalInsights/workspaces/watchdog-law","Azure Monitor"]}'
    version: '1.0'
    sourceId: workbookSourceId
    category: workbookType
  }
  dependsOn: []
}

output workbookId string = workbookId_resource.id
