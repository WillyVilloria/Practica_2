resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.azurerm_kubernetes_cluster
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.azurerm_kubernetes_cluster

  default_node_pool {
    name       = "node1"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }
  
  identity {
    type = "SystemAssigned"
  }
  tags = {
    Environment = "Develop"
  }
}