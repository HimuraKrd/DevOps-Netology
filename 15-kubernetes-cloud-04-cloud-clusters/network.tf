resource "yandex_vpc_network" "vpc-netology" {
  name = "vpc-netology"
}

resource "yandex_vpc_subnet" "lab-subnet-a" {
  name           = "public-a"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.vpc-netology.id}"
}

resource "yandex_vpc_subnet" "lab-subnet-b" {
  name           = "public-b"
  v4_cidr_blocks = ["192.168.11.0/24"]
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.vpc-netology.id}"
}

resource "yandex_vpc_subnet" "lab-subnet-c" {
  name           = "public-c"
  v4_cidr_blocks = ["192.168.12.0/24"]
  zone           = "ru-central1-c"
  network_id     = "${yandex_vpc_network.vpc-netology.id}"
}

resource "yandex_vpc_subnet" "lab-subnet-pa" {
  name           = "private-a"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.vpc-netology.id}"
  route_table_id = "${yandex_vpc_route_table.internet-for-private.id}"
}

resource "yandex_vpc_subnet" "lab-subnet-pb" {
  name           = "private-b"
  v4_cidr_blocks = ["192.168.21.0/24"]
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.vpc-netology.id}"
  route_table_id = "${yandex_vpc_route_table.internet-for-private.id}"
}

resource "yandex_vpc_subnet" "lab-subnet-pc" {
  name           = "private-c"
  v4_cidr_blocks = ["192.168.22.0/24"]
  zone           = "ru-central1-c"
  network_id     = "${yandex_vpc_network.vpc-netology.id}"
  route_table_id = "${yandex_vpc_route_table.internet-for-private.id}"
}

resource "yandex_vpc_route_table" "internet-for-private" {
  name       = "private-nat"
  network_id = "${yandex_vpc_network.vpc-netology.id}"

  static_route  { 
    destination_prefix = "0.0.0.0/0"
    next_hop_address = yandex_compute_instance.nat-instance.network_interface.0.ip_address
  }
}
