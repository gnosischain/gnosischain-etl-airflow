from pathlib import Path

import pytest
from airflow.models import DagBag, Variable

DAGS_FOLDER = f"{Path(__file__).resolve().parent.parent}/dags"


@pytest.fixture(autouse=True)
def env_vars_setup(monkeypatch):
    mock_env_vars = {
        "AIRFLOW_CONN_GOOGLE_CLOUD_DEFAULT": "google-cloud-platform://",
        "DAGS_FOLDER": DAGS_FOLDER,
    }
    for k, v in mock_env_vars.items():
        monkeypatch.setenv(k, v)


@pytest.fixture(autouse=True)
def airflow_vars_setup(monkeypatch):
    mock_airflow_vars = {
        "gnosischain_destination_dataset_project_id": "test",
        "gnosischain_load_all_partitions": False,
        "gnosischain_output_bucket": "test",
        "gnosischain_parse_destination_dataset_project_id": "test",
        "gnosischain_provider_uris": "test",
    }
    monkeypatch.setattr(Variable, "get", mock_airflow_vars.get)


@pytest.fixture
def dag_bag():
    yield DagBag(dag_folder=DAGS_FOLDER, include_examples=False)


def test_no_import_errors(dag_bag):
    assert len(dag_bag.import_errors) == 0, "No Import Failures"
