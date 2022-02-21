terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "lab.tfstate"
    region     = "us-east-1"
    key        = "08-ansible-03.tfstate" #имя созданного бакета для хранения состояния терраформ
    access_key = "m0_X_6FKgQDzjKtCG3J7"
    secret_key = "0Nych967VIbyBcVVbpDHp-B73VpPDmeMMxMQhNJ1"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token     = "AQAAAAAEWZH1AATuwWn-d4vEB0OYib301rMAFiw"
  cloud_id  = "b1gaj35hl8uhfc0jmst6"
  folder_id = "b1g7u88ib1ta65lt0em6"
  zone      = "ru-central1-a"
}