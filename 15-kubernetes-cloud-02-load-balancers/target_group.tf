resource "yandex_lb_target_group" "lamp" {
  name = "lamp"

  dynamic "target" {
    for_each = yandex_compute_instance_group.LAMP.instances
    content {
      subnet_id = target.value.network_interface.0.subnet_id
      address   = target.value.network_interface.0.ip_address
    }
  }
}