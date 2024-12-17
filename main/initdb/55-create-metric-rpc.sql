create or replace function
mirante.metrics(period_from timestamptz, period_to timestamptz) returns json as $$

declare

    total_responses numeric;
    correct_responses numeric;
    total_days numeric;
    days_with_responses numeric;

begin

    select count(*) into total_responses from response
    where creation_date >= period_from and
    creation_date <= period_to;

    select count(*) into correct_responses from response
    join option on response.option = option.id
    where option.correct = true
    and response.creation_date >= period_from
    and response.creation_date <= period_to
    group by option.id;

    select extract(days from (period_to - period_from)) + 1 into total_days;

    select count(distinct date_trunc('day', creation_date))
    into days_with_responses from response
    where creation_date >= period_from and
    creation_date <= period_to;

    if not found or total_responses = 0 then
      raise exception 'Nenhuma resposta encontrada no período';
    end if;

    return json_build_object(
        'metrics', json_build_object(
            'accuracy', json_build_object(
              'index', correct_responses / total_responses,
              'correct', correct_responses,
              'total', total_responses),
            'assiduity', json_build_object(
              'index', (days_with_responses/total_days) * 0.75 +
                        (total_responses/total_days ) * 0.25,
              'intensity', total_responses / total_days,
              'spread', days_with_responses / total_days,
              'total_days', total_days,
              'days_with_responses', days_with_responses
            )
            -- 'retention', json_build_object('a', 0, 'b', '1', 'c', '2')
        )::jsonb
    );

end

$$ language plpgsql immutable;

revoke all privileges on function mirante.metrics(timestamptz, timestamptz) from public;
grant execute on function mirante.metrics(timestamptz, timestamptz) to base_user;
