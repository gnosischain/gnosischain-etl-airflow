resource "random_id" "id" {
  byte_length = 8
}

locals {
  exports_bucket_name_prefix = "blockchain-etl-exports"
  exports_bucket_name        = "${local.exports_bucket_name_prefix}-${random_id.id.hex}"

  dags_bucket_name_prefix = "blockchain-etl-dags"
  dags_bucket_name        = "${local.dags_bucket_name_prefix}-${random_id.id.hex}"
}

resource "google_storage_bucket" "blockchain_etl_exports" {
  name          = local.exports_bucket_name
  location      = local.region
  force_destroy = false # When deleting a bucket, this option will delete all contained objects

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}


resource "google_storage_bucket" "blockchain_etl_dags" {
  name          = local.dags_bucket_name
  location      = local.region
  force_destroy = false # When deleting a bucket, this option will delete all contained objects

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}
