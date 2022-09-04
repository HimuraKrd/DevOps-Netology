resource "yandex_lb_network_load_balancer" "lamp" {
  name = "my-network-load-balancer"

  listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.lamp.id

    healthcheck {
      name                = "http"
      timeout             = 1
      healthy_threshold   = 3
      unhealthy_threshold = 4
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
