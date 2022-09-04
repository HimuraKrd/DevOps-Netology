resource "yandex_compute_instance_group" "LAMP" {
  name                = "lamp"
  folder_id           = var.folder_id
  service_account_id  = "${yandex_iam_service_account.sa-0.id}"
  depends_on = [
    yandex_iam_service_account.sa-0
  ]
  deletion_protection = false
  
  instance_template {

    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }

    network_interface {
      subnet_ids = [ yandex_vpc_subnet.lab-subnet-a.id ]
      nat = true
    }

    metadata = {
      ssh-keys = "admin:${file("~/.ssh/id_rsa.pub")}"
      user-data = <<EOF
#!/bin/sh
PICURL="https://storage.yandexcloud.net/bagirov-netology-2022/one-piece.jpg"
cd /var/www/html/
echo "<html><body><img src='$PICURL'></body></html>" > index.html
EOF
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }
}