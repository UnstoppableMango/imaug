import * as pulumi from '@pulumi/pulumi';
import * as resources from '@pulumi/azure-native/resources';
import * as web from '@pulumi/azure-native/web';

const config = new pulumi.Config();
const resourceGroupName = config.require('resourceGroupName');

const currentResourceGroup = resources.getResourceGroupOutput({
    resourceGroupName: resourceGroupName,
});

const location = currentResourceGroup.apply(rg => rg.location);
const name = config.get('name') || 'imaug-pulumi';
const password = config.require('password');

const appPlan = new web.AppServicePlan('appPlan', {
    location,
    resourceGroupName,
    sku: {
        name: 'B1',
        tier: 'Basic',
    },
});

const app = new web.WebApp('app', {
    resourceGroupName,
    serverFarmId: appPlan.id,
    name,
});

const settings = new web.WebAppApplicationSettings('appsettings', {
    resourceGroupName,
    name: app.name,
    properties: {
        Password: password,
    },
});
