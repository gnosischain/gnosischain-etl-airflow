locals {
  project_number                = "__PROJECT_NUMBER__" # taken from landing page: https://console.cloud.google.com/welcome
  composer_service_account_name = "gnosischain-composer"
  composer_environment_name     = "blockchain-etl-0"
  composer_image_version        = "composer-2.6.5-airflow-2.5.3"
  # Airflow environment: https://airflow.apache.org/docs/apache-airflow/stable/howto/variable.html#storing-variables-in-environment-variables
  composer_airflow_environemt_prefix = "AIRFLOW_VAR_"
}

data "google_compute_network" "vpc" {
  name = "__VPC_NAME__"
}

data "google_compute_subnetwork" "subnet" {
  name   = "__SUBNET_NAME__"
  region = local.region
}
