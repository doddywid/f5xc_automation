resource "volterra_origin_pool" "origin-tf-arcadia-app2" {
  name                   = "origin-tf-arcadia-app2"
  namespace              = "default"
  loadbalancer_algorithm = "ROUND ROBIN"
  origin_servers {
    k8s_service {
      inside_network  = false
      outside_network = false
      vk8s_networks   = true
      service_name    = "arcadia-app2-svc.default"
      site_locator {
        site {
          name      = "udf-cluster-mk8s"
          namespace = "system"
          tenant    = "<full-tenant-name>"
        }
      }
    }
  }
  port               = 8080
  no_tls             = true
  endpoint_selection = "LOCAL_PREFERRED"
}
resource "volterra_origin_pool" "origin-tf-arcadia-mainapp" {
  name                   = "origin-tf-arcadia-mainapp"
  namespace              = "default"
  loadbalancer_algorithm = "ROUND ROBIN"
  origin_servers {
    k8s_service {
      inside_network  = false
      outside_network = false
      vk8s_networks   = true
      service_name    = "arcadia-mainapp-svc.default"
      site_locator {
        site {
          name      = "udf-cluster-mk8s"
          namespace = "system"
          tenant    = "<full-tenant-name>"
        }
      }
    }
  }
  port               = 8080
  no_tls             = true
  endpoint_selection = "LOCAL_PREFERRED"
}
resource "volterra_app_firewall" "wafpolicy-tf" {
  name      = "waf-policy-tf"
  namespace = "default"
  allow_all_response_codes = true
  default_anonymization = true
  use_default_blocking_page = true
  default_bot_setting = true
  default_detection_settings = true
  blocking = true
}

resource "volterra_http_loadbalancer" "lb-mk8s-tf-https-routes" {
  depends_on = [volterra_origin_pool.origin-tf-arcadia-app2, volterra_origin_pool.origin-tf-arcadia-mainapp, volterra_app_firewall.wafpolicy-tf]
  name      = "lb-mk8s-tf-https-routes"
  namespace = "default"
  domains = ["arcadia-terraform-https.f5poc.id"]
  https_auto_cert {
    add_hsts = true
    http_redirect = true
    no_mtls = true
    enable_path_normalize = true
    tls_config {
        default_security = true
      }
  }
  advertise_on_public_default_vip = true
  no_service_policies = true
  no_challenge = true
  disable_rate_limit = true
  app_firewall {
    name = "waf-policy-tf"
    namespace = "default"
  }
  user_id_client_ip = true
  source_ip_stickiness = true

  routes {
    simple_route {
      disable_host_rewrite = true
      path {
        prefix = "/api"
      }
      origin_pools {
        pool {
          tenant = "<full-tenant-name>"
          namespace = "default"
          name = "origin-tf-arcadia-app2"
        }
      }
    }
  }

  routes {
    simple_route {
      disable_host_rewrite = true
      path {
        prefix = "/"
      }
      origin_pools {
        pool {
          tenant = "<full-tenant-name>"
          namespace = "default"
          name = "origin-tf-arcadia-mainapp"
        }
      }
    }
  }
}
