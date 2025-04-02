// Declare parameters matching the JSON file
// param admin_username string
param azure_region string
// param subnet_type string
// param instance_type string
param vnet_id string
param public_subnet string
param private_subnet string
param admin_username string
param instance_type string
param os_disk_size int
param os_disk_type string
param data_disk_size int
param data_disk_type string
param attach_data_disk bool
param subnet_type string
param ssh_public_key string
// param os_type string
// param nsg_id string


resource existingRg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  scope: subscription()
  name: 'Baker002'
}

output existingRgId string = existingRg.id

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnet_id
  location: azure_region
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

resource publicSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  parent: vnet
  name: public_subnet
  properties: {
    addressPrefix: '10.0.1.0/24'
 }
}

// Private Subnet - created only if subnetType equals "private"
resource privateSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  parent: vnet
  name: private_subnet
  properties: {
    addressPrefix: '10.0.2.0/24'
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'BH_NSG'
  location: azure_region
  properties: {
    securityRules: [] // Define rules as needed
  }
}

// Public IP (only if using a public subnet)
resource publicIP 'Microsoft.Network/publicIPAddresses@2021-05-01' = if (subnet_type == 'public') {
  name: 'centos-public-ip'
  location: azure_region
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Network Interface
resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'linux-nic'
  location: azure_region
  properties: {
    ipConfigurations: [
      {
        name: 'linux-ip-config'
        properties: {
          subnet: {
            id: subnet_type == 'private' ? privateSubnet.id : publicSubnet.id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: subnet_type == 'public' ? {
            id: publicIP.id
          } : null
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}



// Data Disk (if enabled)
resource dataDisk 'Microsoft.Compute/disks@2021-04-01' = if (attach_data_disk) {
  name: 'data-disk'
  location: azure_region
  sku: {
    name: data_disk_type
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: data_disk_size
  }
}

// Virtual Machine
resource linuxVM 'Microsoft.Compute/virtualMachines@2021-04-01' = {
  name: 'ubuntu-vm'
  location: azure_region
  properties: {
    hardwareProfile: {
      vmSize: instance_type
    }
    osProfile: {
      computerName: 'ubuntu-vm'
      adminUsername: admin_username
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${admin_username}/.ssh/authorized_keys'
              keyData: ssh_public_key
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: '18.04.202401161'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: os_disk_type
        }
        diskSizeGB: os_disk_size
      }
      dataDisks: attach_data_disk ? [
        {
          lun: 0
          createOption: 'Attach'
          managedDisk: {
            id: dataDisk.id
          }
        }
      ] : []
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

// // Virtual Machine
// resource linuxVM1 'Microsoft.Compute/virtualMachines@2021-04-01' = {
//   name: 'suse-vm'
//   location: azure_region
//   properties: {
//     hardwareProfile: {
//       vmSize: instance_type
//     }
//     osProfile: {
//       computerName: 'suse-vm'
//       adminUsername: admin_username
//       linuxConfiguration: {
//         disablePasswordAuthentication: true
//         ssh: {
//           publicKeys: [
//             {
//               path: '/home/${admin_username}/.ssh/authorized_keys'
//               keyData: ssh_public_key
//             }
//           ]
//         }
//       }
//     }
//     storageProfile: {
//       imageReference: {
//         publisher: 'suse'
//         offer: 'sles-15-sp4-byos'
//         sku: 'gen2'
//         version: '2024.08.09'
//       }
//       osDisk: {
//         createOption: 'FromImage'
//         managedDisk: {
//           storageAccountType: os_disk_type
//         }
//         diskSizeGB: os_disk_size
//       }
//       dataDisks: attach_data_disk ? [
//         {
//           lun: 0
//           createOption: 'Attach'
//           managedDisk: {
//             id: dataDisk.id
//           }
//         }
//       ] : []
//     }
//     networkProfile: {
//       networkInterfaces: [
//         {
//           id: nic.id
//         }
//       ]
//     }
//   }
// }



// resource nsg 'Microsoft.Network/networkSecurityGroups@2023-02-01' = {
//   name: nsgName
//   location: location
//   properties: {
//     securityRules: [
//       for rule in securityRules: {
//         name: rule.name
//         properties: {
//           priority: rule.priority
//           direction: rule.direction
//           access: rule.access
//           protocol: rule.protocol
//           sourcePortRange: rule.sourcePortRange
//           destinationPortRange: rule.destinationPortRange
//           sourceAddressPrefix: rule.sourceAddressPrefix
//           destinationAddressPrefix: rule.destinationAddressPrefix
//         }
//       }
//     ]
//   }
// }
