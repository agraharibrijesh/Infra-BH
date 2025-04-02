param adminUsername string
param adminPassword string
param location string = resourceGroup().location

param vm1Name string = 'vm1'
param vm2Name string = 'vm2'
param vm3Name string = 'vm3'
param vm4Name string = 'vm4'

param vm1Size string = 'Standard_B1s'
param vm2Size string = 'Standard_B2s'
param vm3Size string = 'Standard_B2ms'
param vm4Size string = 'Standard_A2_v2'

param diskSizeGB1 int = 20  // Data disk size for VM1 in GB
param diskSizeGB2 int = 30  // Data disk size for VM2 in GB
param diskSizeGB3 int = 50  // Data disk size for VM3 in GB
param diskSizeGB4 int = 25  // Data disk size for VM4 in GB

param diskSku string = 'Standard_LRS'  // SKU for the disks

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

// Network Interfaces for VMs
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
      id: myNsg.id
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
      id: myNsg.id
    }
  }
}

resource networkInterface3 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: '${vm3Name}-nic'
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
      id: myNsg.id
    }
  }
}

resource networkInterface4 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: '${vm4Name}-nic'
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
      id: myNsg.id
    }
  }
}

// VM1 Definition
resource vm1 'Microsoft.Compute/virtualMachines@2021-07-01' = {
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
          name: 'vm1-data-disk'
          diskSizeGB: diskSizeGB1
          lun: 0
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
          name: 'vm2-data-disk'
          diskSizeGB: diskSizeGB2
          lun: 0
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
}

// VM3 Definition
resource vm3 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: vm3Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vm3Size
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
          name: 'vm3-data-disk'
          diskSizeGB: diskSizeGB3
          lun: 0
          createOption: 'Empty'
          managedDisk: {
            storageAccountType: diskSku
          }
        }
      ]
    }
    osProfile: {
      computerName: vm3Name
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface3.id
        }
      ]
    }
  }
}

// VM4 Definition
resource vm4 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: vm4Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vm4Size
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
          name: 'vm4-data-disk'
          diskSizeGB: diskSizeGB4
          lun: 0
          createOption: 'Empty'
          managedDisk: {
            storageAccountType: diskSku
          }
        }
      ]
    }
    osProfile: {
      computerName: vm4Name
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface4.id
        }
      ]
    }
  }
}
