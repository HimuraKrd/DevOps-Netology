terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "my_token"
  cloud_id  = "my_cloud"
  folder_id = "my_folder"
}

