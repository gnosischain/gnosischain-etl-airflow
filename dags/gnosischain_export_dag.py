from __future__ import print_function

from gnosischainetl_airflow.build_export_dag import build_export_dag
from gnosischainetl_airflow.variables import read_export_dag_vars

# airflow DAG
DAG = build_export_dag(
    dag_id='gnosischain_export_dag',
    **read_export_dag_vars(
        var_prefix='gnosischain_',
        export_schedule_interval='0 8 * * *',
        export_start_date='2016-10-08',
        export_max_workers=10,
        export_batch_size=10,
        export_retries=5,
    )
)
