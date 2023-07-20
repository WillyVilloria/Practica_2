resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.azurerm_kubernetes_cluster
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.azurerm_kubernetes_cluster

  default_node_pool {
    name       = "default"
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
resource "azurerm_role_assignment" "aksrole" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_kubernetes_cluster.aks.id
  skip_service_principal_aad_check = true
}