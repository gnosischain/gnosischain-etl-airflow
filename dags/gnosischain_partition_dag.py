from __future__ import print_function

import logging

from airflow.models import Variable

from gnosischainetl_airflow.build_partition_dag import build_partition_dag

logging.basicConfig()
logging.getLogger().setLevel(logging.DEBUG)

# airflow DAG
DAG = build_partition_dag(
    dag_id='gnosischain_partition_dag',
    partitioned_project_id='blockchain-etl-internal',
    partitioned_dataset_name = 'crypto_gnosischain_partitioned',
    public_project_id = 'bigquery-public-data',
    public_dataset_name = 'crypto_gnosischain',
    load_dag_id='gnosischain_load_dag',
    notification_emails=Variable.get('notification_emails', None),
    schedule_interval='30 9 * * *',
)
