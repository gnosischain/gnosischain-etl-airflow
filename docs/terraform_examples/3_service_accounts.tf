# ===========
#  BIGUERY
# ===========

resource "google_service_account" "bigquery" {
  account_id = "bigquery"
}

# ===========
#  COMPOSER
# ===========
resource "google_project_service" "composer_api" {
  project = local.project
  service = "composer.googleapis.com"
  // Disabling Cloud Composer API might irreversibly break all other
  // environments in your project.
  // This parameter prevents automatic disabling
  // of the API when the resource is destroyed.
  // We recommend to disable the API only after all environments are deleted.
  disable_on_destroy = false
}


resource "google_service_account" "composer" {
  account_id   = "composer"
  display_name = "Service Account for Google Composer"
}


resource "google_project_iam_member" "composer" {
  project = local.project
  member  = format("serviceAccount:%s", google_service_account.composer.email)
  role    = "roles/composer.worker"
}

resource "google_project_iam_member" "composer_bigquery_user" {
  project = local.project
  member  = format("serviceAccount:%s", google_service_account.composer.email)
  role    = "roles/bigquery.user"
}

resource "google_project_iam_member" "composer_bigquery_dataowner" {
  project = local.project
  member  = format("serviceAccount:%s", google_service_account.composer.email)
  role    = "roles/bigquery.dataOwner"
}

resource "google_project_iam_member" "composer_iam_serviceaccountuser" {
  # Lets a principal attach a service account to a resource.
  # When the code running on that resource needs to authenticate,
  # it can get credentials for the attached service account.
  project = local.project
  member  = format("serviceAccount:%s", google_service_account.composer.email)
  role    = "roles/iam.serviceAccountUser"
}

# Guide
# https://cloud.google.com/composer/docs/composer-2/create-environments#grant-permissions
resource "google_service_account_iam_member" "composer_service_agent" {
  service_account_id = google_service_account.composer.id
  member             = "serviceAccount:service-${local.project_number}@cloudcomposer-accounts.iam.gserviceaccount.com"
  // Role for Public IP environments
  role = "roles/composer.ServiceAgentV2Ext"

  depends_on = [google_service_account.composer]
}
