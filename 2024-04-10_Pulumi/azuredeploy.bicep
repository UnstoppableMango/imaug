param location string = resourceGroup().location
param name string = 'default-value'

@secure()
param password string

var sku = {
  tier: 'Basic'
  name: 'B1'
}

resource appPlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: 'plan-${name}'
  location: location
  sku: sku
}

resource app 'Microsoft.Web/sites@2021-03-01' = {
  name: 'app-${name}'
  location: location
  properties: {
    serverFarmId: appPlan.id
  }

  resource settings 'config' = {
    name: 'appsettings'
    properties: {
      Password: password
    }
  }
}

resource webSettings 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'web'
  parent: app
  properties: {
    minTlsVersion: '1.2'
  }
}
