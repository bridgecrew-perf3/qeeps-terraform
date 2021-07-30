terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_frontdoor" "example" {
  name                                         = var.name
  resource_group_name                          = var.resource_group
  enforce_backend_pools_certificate_name_check = false

  routing_rule {
    name               = "uiRoute"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["fdFrontend"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "swaBackendPool"
    }
  }

  backend_pool_load_balancing {
    name = "swaBackendPoolLoadBalancingSetting"
  }

  backend_pool_health_probe {
    name = "swaBackendPoolHealthProbeSetting"
  }


  backend_pool {
    name = "swaBackendPool"

    dynamic "backend" {
      for_each = toset(var.swa_hostnames)
      content {
        host_header = backend.value
        address     = backend.value
        http_port   = 80
        https_port  = 443
      }
    }


    load_balancing_name = "swaBackendPoolLoadBalancingSetting"
    health_probe_name   = "swaBackendPoolHealthProbeSetting"
  }

  frontend_endpoint {
    name      = "fdFrontend"
    host_name = "${var.name}.azurefd.net"
  }
}
