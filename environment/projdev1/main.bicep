param adminUsername string
param adminPassword string
param location string = resourceGroup().location

param vm1Name string = 'vm1'
param vm2Name string = 'vm2'

param vm1Size string = 'Standard_B1s'
param vm2Size string = 'Standard_B2s'

param diskSizeGB int = 20  // Size of the data disk in GB
param diskSku string = 'Standard_LRS'  // SKU for the disk

// Create the Virtual Network and Subnet
resource myVnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'myVnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

// Create Network Security Group (NSG)
resource myNsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'myNsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-RDP'
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          sourcePortRange: '*'
          destinationPortRange: '3389'
        }
      }
      {
        name: 'Allow-SSH'
        properties: {
          priority: 110
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          sourcePortRange: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

// Network Interfaces for VM1 and VM2
resource networkInterface1 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: '${vm1Name}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: myVnet.properties.subnets[0].id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: myNsg.id  // Associate NSG with Network Interface 1
    }
  }
}

resource networkInterface2 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: '${vm2Name}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: myVnet.properties.subnets[0].id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: myNsg.id  // Associate NSG with Network Interface 2
    }
  }
}

// VM1 Definition
/*resource vm1 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: vm1Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vm1Size
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      dataDisks: [
        {
          name: 'vm1-data-disk-1'
          diskSizeGB: diskSizeGB
          lun: 0 // First data disk
          createOption: 'Empty'
          managedDisk: {
            storageAccountType: diskSku
          }
        }
        {
          name: 'vm1-data-disk-2'
          diskSizeGB: diskSizeGB
          lun: 1 // Second data disk
          createOption: 'Empty'
          managedDisk: {
            storageAccountType: diskSku
          }
        }
      ]
    }
    osProfile: {
      computerName: vm1Name
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface1.id
        }
      ]
    }
  }
}

// VM2 Definition
resource vm2 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: vm2Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vm2Size
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      dataDisks: [
        {
          name: 'vm2-data-disk-1'
          diskSizeGB: diskSizeGB
          lun: 0 // First data disk
          createOption: 'Empty'
          managedDisk: {
            storageAccountType: diskSku
          }
        }
        {
          name: 'vm2-data-disk-2'
          diskSizeGB: diskSizeGB
          lun: 1 // Second data disk
          createOption: 'Empty'
          managedDisk: {
            storageAccountType: diskSku
          }
        }
      ]
    }
    osProfile: {
      computerName: vm2Name
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface2.id
        }
      ]
    }
  }
}*/


