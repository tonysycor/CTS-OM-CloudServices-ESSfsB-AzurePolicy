#############################################################################
# TERRAFORM CONFIG
#############################################################################
provider "azurerm" {

  features {}
  client_id       = "dcf924c4-ecb8-41c2-abd7-2f79e859f444"
  client_secret   = "66T8Q~03-bJA5Mw71cWAo0EsOR6CdDlRQPkx0diw"
  tenant_id       = "c36f15bc-e241-410e-ae73-2880bf88ef78"
  subscription_id = "4903d38f-fec1-4a2c-bd9f-79bb9eda788b"
}



provider "http" {}

  #############################################################################