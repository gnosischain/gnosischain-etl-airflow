import io
import logging
import os

import pytest

from gnosischainetl_airflow.common import read_json_file
from gnosischainetl_airflow.parse.parse_table_definition_logic import parse
from tests.gnosischainetl_airflow.mock_bigquery_client import MockBigqueryClient

sqls_folder = 'dags/resources/stages/parse/sqls'
table_definitions_folder = 'dags/resources/stages/parse/table_definitions'

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s [%(levelname)s] - %(message)s')

@pytest.mark.parametrize("table_definition_file,parse_all_partitions", [
    ('ens/Registrar0_event_NewBid.json', True),
    ('ens/Registrar0_event_NewBid.json', False),
    ('uniswap/Uniswap_event_AddLiquidity.json', True),
    ('uniswap/UniswapV2Pair_event_Swap.json', False),
    ('dydx/SoloMargin_event_LogTrade.json', True),
    ('idex/Exchange_call_trade.json', True),
])
def test_create_or_update_table_from_table_definition(table_definition_file, parse_all_partitions):
    bigquery_client = MockBigqueryClient()
    table_definition = read_json_file(os.path.join(table_definitions_folder, table_definition_file))

    parse(
        bigquery_client=bigquery_client,
        table_definition=table_definition,
        ds='2020-01-01',
        source_project_id='bigquery-public-data',
        source_dataset_name='crypto_gnosischain',
        destination_project_id='blockchain-etl',
        sqls_folder=sqls_folder,
        parse_all_partitions=parse_all_partitions,
        time_func=lambda: 1587556654.993
    )

    assert len(bigquery_client.queries) > 0

    for ind, query in enumerate(bigquery_client.queries):
        expected_filename = table_definition_file_to_expected_file(table_definition_file, parse_all_partitions, ind)
        print(query)
        assert trim(query) == trim(read_resource(expected_filename))


def table_definition_file_to_expected_file(table_definition_file, parse_all_partitions, ind):
    return '{file}_{parse_all_partitions}_{ind}.sql'.format(
        file=table_definition_file,
        parse_all_partitions=parse_all_partitions,
        ind=ind,
    )


def read_resource(filename):
    full_filepath = 'tests/resources/gnosischainetl_airflow/test_parse/' + filename
    return open(full_filepath).read()


def trim(content):
    stripped_lines = [line.strip() for line in io.StringIO(content)]
    return '\n'.join(stripped_lines)
