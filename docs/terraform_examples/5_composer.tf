resource "google_composer_environment" "gnosischain_etl_0" {
  name   = local.composer_environment_name
  region = local.region

  storage_config {
    bucket = google_storage_bucket.blockchain_etl_dags.id
  }

  config {
    environment_size = "ENVIRONMENT_SIZE_MEDIUM"

    software_config {
      image_version = local.composer_image_version

      airflow_config_overrides = {
        celery-worker_concurrency           = 8
        scheduler-dag_dir_list_interval     = 300
        scheduler-min_file_process_interval = 120
        email-email_conn_id                 = "sendgrid_default"
        email-email_backend                 = "airflow.providers.sendgrid.utils.emailer.send_email"
        email-from_email                    = "__EMAIL_SENDER_ADDRESS__"

      }
      # protobuf 4.25.0
      pypi_packages = {
        "eth-rlp"           = "==1.0.1"
        "eth-account"       = "==0.10.0"
        "eth-hash"          = "==0.7.0"
        "web3"              = "==6.15.1"
        "shapely"           = "<2.0.0"
        "ethereum-etl-temp" = "==2.3.4" # custom version of ethereum-etl containing updated libs
      }

      env_variables = {
        "${local.composer_airflow_environemt_prefix}gnosischain_destination_dataset_project_id"       = local.project
        "${local.composer_airflow_environemt_prefix}gnosischain_parse_destination_dataset_project_id" = local.project
        "${local.composer_airflow_environemt_prefix}gnosischain_export_start_date"                    = "2018-10-08" # yyyy-mm-dd
        "${local.composer_airflow_environemt_prefix}gnosischainexport_start_date"                     = "2018-10-08" # yyyy-mm-dd
        "${local.composer_airflow_environemt_prefix}gnosischain_output_bucket"                        = google_storage_bucket.gnosischain_blockchain_etl_exports.id
        "${local.composer_airflow_environemt_prefix}gnosischain_provider_uris"                        = "https://rpc.gnosischain.com"
        "${local.composer_airflow_environemt_prefix}gnosischain_provider_uris_archival"               = "__ARCHIVAL_RPC_URL__"
        "${local.composer_airflow_environemt_prefix}gnosischain_load_all_partitions"                  = true
        "${local.composer_airflow_environemt_prefix}notification_emails"                              = "__EMAIL_RECIPIENT_ADDRESS"

        # IF Using sendgrid, otherwise default SMTP
        "${local.composer_airflow_environemt_prefix}email__email_backend" = "airflow.providers.sendgrid.utils.emailer.send_email"
        "${local.composer_airflow_environemt_prefix}email__email_conn_id" = "sendgrid_default"
        "${local.composer_airflow_environemt_prefix}sendgrid_mail_from"   = "__EMAIL_SENDER_ADDRESS__"
      }

    }

    web_server_network_access_control {
      allowed_ip_range {
        description = "Allows access from all IPv4 addresses (default value)"
        value       = "0.0.0.0/0"
      }
      allowed_ip_range {
        description = "Allows access from all IPv6 addresses (default value)"
        value       = "::0/0"
      }
    }

    workloads_config {
      scheduler {
        cpu        = 2
        memory_gb  = 13
        storage_gb = 1
        count      = 1
      }

      web_server {
        cpu        = 1
        memory_gb  = 2
        storage_gb = 0.5
      }

      worker {
        cpu        = 2
        memory_gb  = 13
        storage_gb = 10
        min_count  = 1
        max_count  = 8
      }
    }

    node_config {
      service_account = google_service_account.composer.email
      network         = data.google_compute_network.vpc.id
      subnetwork      = data.google_compute_subnetwork.subnet.id
    }
  }

  depends_on = [
    google_project_service.composer_api,
    google_service_account_iam_member.composer_service_agent
  ]
}
