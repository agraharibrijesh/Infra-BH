// Parameters for admin username and password
param adminUsername string
@secure()
param adminPassword string

// Define the virtual network
resource myVnet 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  name: 'myVnet'
  location: 'East US'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

// Define the public subnet
resource publicSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-03-01' = {
  parent: myVnet
  name: 'publicSubnet'
  properties: {
    addressPrefix: '10.0.1.0/24'
  }
}

// Create a Public IP for the public NIC
resource publicIp 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: 'publicIp'
  location: 'East US'
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Define the public NIC for the VM
resource publicNic 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: 'publicNic'
  location: 'East US'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: publicSubnet.id
          }
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
  }
}

// Define the Virtual Machine in the public subnet (using the public NIC)
resource myVM 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'myVM'
  location: 'East US'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
    }
    osProfile: {
      computerName: 'myVM'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: publicNic.id
        }
      ]
    }
  }
}
