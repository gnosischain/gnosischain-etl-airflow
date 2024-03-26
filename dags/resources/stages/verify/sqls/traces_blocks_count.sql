select if(
(
select count(distinct(block_number))
from `{{params.destination_dataset_project_id}}.{{params.dataset_name}}.traces`
where trace_type = 'reward' and reward_type = 'block'
    and date(block_timestamp) <= '{{ds}}'
    and value > 0
) =
(
select count(*)
from `{{params.destination_dataset_project_id}}.{{params.dataset_name}}.blocks`
where date(timestamp) <= '{{ds}}'
    and number <= 15537393 -- The Merge block number
) - 1, 1,
cast((select 'Total number of unique blocks in traces is not equal to block count minus 1 on {{ds}}') as int64))
