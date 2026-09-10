resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "koala-aks"

  default_node_pool {
    name       = "system"
    node_count = var.node_count      # 3 nodes: staging + production each run 5 postgres PVCs
    vm_size    = var.vm_size          # Standard_B2s_v2 (2 vCPU) x3 = 6 vCPU, fits the quota
  }

  identity {
    type = "SystemAssigned"
  }
}

# Let the AKS kubelet pull images from ACR (prevents ImagePullBackOff)
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_storage_account" "storage" {
  name                      = var.storage_account_name
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  min_tls_version           = "TLS1_2"
  shared_access_key_enabled = true    # so Terraform can create the containers via account key
}

resource "azurerm_storage_container" "student_photos" {
  name                  = "student-profile-photos"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "lecturer_photos" {
  name                  = "lecturer-profile-photos"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}