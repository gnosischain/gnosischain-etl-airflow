from __future__ import print_function

import logging

from gnosischainetl_airflow.build_amend_dag import build_amend_dag
from gnosischainetl_airflow.variables import read_amend_dag_vars

logging.basicConfig()
logging.getLogger().setLevel(logging.DEBUG)

# airflow DAG
DAG = build_amend_dag(
    dag_id='gnosischain_amend_dag',
    chain='gnosischain',
    **read_amend_dag_vars(
        var_prefix='gnosischain_',
        schedule_interval='30 8 * * *'
    )
)
