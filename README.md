# GnosisChain ETL Airflow

This project is based on the work from [Ethereum ETL Airflow](https://github.com/blockchain-etl/ethereum-etl-airflow), all the components have been renamed into `gnosischain_` and DAG code adapted to handle Gnosis Chain data. 

## Setting up Airflow DAGs using Google Cloud Composer

We have put together an extenstive documentation containing the terraform specs that are required to spin up a Google Composer instance of Airflow.

See [./docs/terraform_examples](./docs/terraform_examples) for more details.


### Running Tests

```bash
pip install \
    -r requirements_test.txt \
    -r requirements_local.txt \
    -r requirements_airflow.txt
pytest -vv -s
```

### Running locally
A docker compose definition has been provided to easily spin up a local Airflow instance.

To build the required image:
```bash
docker compose build
```
To start Airflow:
```bash
docker compose up airflow
```

The instance requires the `CLOUDSDK_CORE_PROJECT` environment variable to be set in most cases. Airflow Variables can be defined in [variables.json](./docker/variables.json).

