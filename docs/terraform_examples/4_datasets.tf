resource "google_bigquery_dataset" "common" {
  dataset_id    = "common"
  friendly_name = "common"
  location      = "EU"

  access {
    role          = "OWNER"
    user_by_email = google_service_account.bigquery.email
  }

  access {
    role          = "OWNER"
    user_by_email = google_service_account.composer.email
  }

  depends_on = [
    google_service_account.bigquery,
    google_service_account.composer
  ]
}


resource "google_bigquery_dataset" "gnosischain" {
  dataset_id    = "crypto_gnosischain"
  friendly_name = "crypto_gnosischain"
  location      = "EU"

  access {
    role          = "OWNER"
    user_by_email = google_service_account.bigquery.email
  }

  access {
    role          = "OWNER"
    user_by_email = google_service_account.composer.email
  }

  depends_on = [
    google_service_account.bigquery,
    google_service_account.composer
  ]
}


resource "google_bigquery_dataset" "gnosischain_raw" {
  dataset_id    = "crypto_gnosischain_raw"
  friendly_name = "crypto_gnosischain_raw"
  location      = "EU"

  access {
    role          = "OWNER"
    user_by_email = google_service_account.bigquery.email
  }

  access {
    role          = "OWNER"
    user_by_email = google_service_account.composer.email
  }

  depends_on = [
    google_service_account.bigquery,
    google_service_account.composer
  ]
}


resource "google_bigquery_dataset" "gnosischain_temp" {
  dataset_id    = "crypto_gnosischain_temp"
  friendly_name = "crypto_gnosischain_temp"
  location      = "EU"

  access {
    role          = "OWNER"
    user_by_email = google_service_account.bigquery.email
  }

  access {
    role          = "OWNER"
    user_by_email = google_service_account.composer.email
  }

  depends_on = [
    google_service_account.bigquery,
    google_service_account.composer
  ]
}


resource "google_bigquery_dataset" "gnosischain_partitioned" {
  dataset_id    = "crypto_gnosischain_partitioned"
  friendly_name = "crypto_gnosischain_partitioned"
  location      = "EU"

  access {
    role          = "OWNER"
    user_by_email = google_service_account.bigquery.email
  }

  access {
    role          = "OWNER"
    user_by_email = google_service_account.composer.email
  }

  depends_on = [
    google_service_account.bigquery,
    google_service_account.composer
  ]
}


# ===============================
#  PERMISSIONS BETWEEN DATASETS
# ===============================


resource "google_bigquery_dataset_access" "gnosischain_access_common" {
  dataset_id = google_bigquery_dataset.common.dataset_id
  dataset {
    dataset {
      project_id = google_bigquery_dataset.gnosischain.project
      dataset_id = google_bigquery_dataset.gnosischain.dataset_id
    }
    target_types = ["VIEWS"]
  }
}

resource "google_bigquery_dataset_access" "gnosischain_raw_access_common" {
  dataset_id = google_bigquery_dataset.common.dataset_id
  dataset {
    dataset {
      project_id = google_bigquery_dataset.gnosischain_raw.project
      dataset_id = google_bigquery_dataset.gnosischain_raw.dataset_id
    }
    target_types = ["VIEWS"]
  }
}

resource "google_bigquery_dataset_access" "gnosischain_temp_access_common" {
  dataset_id = google_bigquery_dataset.common.dataset_id
  dataset {
    dataset {
      project_id = google_bigquery_dataset.gnosischain_temp.project
      dataset_id = google_bigquery_dataset.gnosischain_temp.dataset_id
    }
    target_types = ["VIEWS"]
  }
}

resource "google_bigquery_dataset_access" "gnosischain_partitioned_common" {
  dataset_id = google_bigquery_dataset.common.dataset_id
  dataset {
    dataset {
      project_id = google_bigquery_dataset.gnosischain_partitioned.project
      dataset_id = google_bigquery_dataset.gnosischain_partitioned.dataset_id
    }
    target_types = ["VIEWS"]
  }
}
