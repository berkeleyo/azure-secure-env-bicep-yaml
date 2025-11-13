targetScope = 'resourceGroup'

@description('Environment name (e.g. dev-sec, test-sec, prod-sec).')
param environmentName string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Common tags to apply to all resources.')
param tags object = {
  project: 'secure-env-bootstrap'
  environment: environmentName
}

module network 'modules/network.bicep' = {
  name: 'network-${environmentName}'
  params: {
    location: location
    tags: tags
  }
}

module security 'modules/security.bicep' = {
  name: 'security-${environmentName}'
  params: {
    location: location
    tags: tags
    vnetId: network.outputs.vnetId
  }
}

module monitoring 'modules/monitoring.bicep' = {
  name: 'monitoring-${environmentName}'
  params: {
    location: location
    tags: tags
  }
}

output environmentName string = environmentName
output vnetId string = network.outputs.vnetId
