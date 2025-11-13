@description('Location for network resources.')
param location string

@description('Tags to apply to network resources.')
param tags object

@description('Address space for the secure environment VNet.')
param vnetAddressPrefix string = '10.10.0.0/22'

resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: 'sec-${uniqueString(deployment().name)}-vnet'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: 'management'
        properties: {
          addressPrefix: '10.10.0.0/24'
        }
      }
      {
        name: 'workload'
        properties: {
          addressPrefix: '10.10.1.0/24'
        }
      }
    ]
  }
}

output vnetId string = vnet.id
