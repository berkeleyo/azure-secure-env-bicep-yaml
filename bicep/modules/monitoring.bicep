@description('Location for monitoring resources.')
param location string

@description('Tags to apply to monitoring resources.')
param tags object

resource logWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'sec-${uniqueString(deployment().name)}-logs'
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

output logAnalyticsWorkspaceId string = logWorkspace.id
