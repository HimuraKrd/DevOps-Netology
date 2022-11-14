// DB cluster
resource "yandex_mdb_mysql_cluster" "cluster-mysql-netology" {
  name                = "mysql-netology"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.vpc-netology.id
  version             = "8.0"
  folder_id           = var.folder_id
  deletion_protection = true // защита от непреднамеренного удаления

  backup_window_start {
    hours   = 23
    minutes = 59
  }

  resources {
    resource_preset_id = "b1.medium" // Intel Broadwell с производительнотью CPU до 50%
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  maintenance_window {
    type = "ANYTIME"
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.lab-subnet-pa.id
  }

  host {
    zone      = "ru-central1-b"
    subnet_id = yandex_vpc_subnet.lab-subnet-pb.id
  }

}

// Database
resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.cluster-mysql-netology.id
  name       = "netology_db"
#   depends_on = [yandex_mdb_mysql_cluster.cluster-mysql-netology]
}


// Database user account
resource "yandex_mdb_mysql_user" "test_user" {
  cluster_id = yandex_mdb_mysql_cluster.cluster-mysql-netology.id
  name       = var.mdb_mysql_user
  password   = var.mdb_mysql_password


  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }


  connection_limits {
    max_questions_per_hour   = 10
    max_updates_per_hour     = 20
    max_connections_per_hour = 30
    max_user_connections     = 40
  }

  global_permissions = ["PROCESS"]

  authentication_plugin = "SHA256_PASSWORD"
}

resource "yandex_vpc_security_group" "mysql-sg" {
  name       = "mysql-sg"
  network_id = yandex_vpc_network.vpc-netology.id

  ingress {
    description    = "phpmyadmin"
    port           = 3306
    protocol       = "TCP"
    v4_cidr_blocks = [ "0.0.0.0/0" ]
  }
}