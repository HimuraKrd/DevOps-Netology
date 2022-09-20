resource "yandex_storage_object" "my-picture" {
  depends_on = [
    yandex_storage_bucket.bucket
  ]
  access_key   = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key   = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "bagirov-netology-2022"
  key    = "one-piece.jpg"
  source = "./pic/ace.jpg"
  acl = "public-read"
  content_type = "image/jpeg"
}
