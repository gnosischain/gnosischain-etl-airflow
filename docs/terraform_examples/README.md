# GnosisChain ETL - Terraform

In this folder we keep a ready to use example of ETL pipelines for Gnosis Chain running on Google Composer and Big Query.

# Install DAGs

Review the source code on the terraform files, make sure to rename all variables having `__` prefix to the right value for your project.

## Terraform

Initialise and apply the terraform specs.

Terraform will create the following datasets:
- crypto_gnosischain
- crypto_gnosischain_raw
- crypto_gnosischain_temp
- crypto_gnosischain_partitioned

and 2 Buckets:
- 1 for the exported files
- 1 for the the Dags


Once done, Google Composer will provide you with a link to Airflow Web UI.

## Airflow

Go to the Airflow UI in the `Admin > Variables` section and make sure that the variables we had defined through Composer have now been reflected into Airflow.

Get the path to gnosischain-etl-airflow and run: `gsutil -m rsync -x 'airflow_monitoring|.*\.pyc$' -cr /path/to/gnosischain-etl-airflow/dags gs://$DAGS_BUCKET_NAME/dags`

Composer will automatically detect and load the dags onto Airflow.
