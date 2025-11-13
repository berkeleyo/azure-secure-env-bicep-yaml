@description('Location for security resources.')
param location string

@description('Tags to apply to security resources.')
param tags object

@description('ID of the virtual network created for this environment.')
param vnetId string

resource managementNsg 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: 'sec-mgmt-nsg'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowManagementFromTrusted'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

resource workloadNsg 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: 'sec-workload-nsg'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'DenyInternetInbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

output managementNsgId string = managementNsg.id
output workloadNsgId string = workloadNsg.id
