USE GroupConcatTest
GO

SELECT  'top 3 ranked elapsed time performers in each category for each row count' AS header ;
WITH    cte
          AS (SELECT    method,
                        dataset_row_count,
                        uniqueness,
                        sort_order,
                        AVG(elapsed_time_ms) AS avg_elapsed_time_ms,
                        AVG(cpu_time_ms) AS avg_cpu_time_ms,
                        ROW_NUMBER() OVER (PARTITION BY dataset_row_count, uniqueness, sort_order ORDER BY AVG(elapsed_time_ms)) AS row_num
              FROM      dbo.clr_xml_test_results
              GROUP BY  method,
                        dataset_row_count,
                        uniqueness,
                        sort_order
             )
    SELECT  dataset_row_count,
            uniqueness,
            sort_order,
            method,
            avg_elapsed_time_ms,
            avg_cpu_time_ms,
            row_num
    FROM    cte
    WHERE   row_num IN (1, 2, 3)
    ORDER BY dataset_row_count,
            uniqueness,
            sort_order,
            row_num ;


SELECT  'top 3 ranked cpu time performers in each category for each row count' AS header ;
WITH    cte
          AS (SELECT    method,
                        dataset_row_count,
                        uniqueness,
                        sort_order,
                        AVG(elapsed_time_ms) AS avg_elapsed_time_ms,
                        AVG(cpu_time_ms) AS avg_cpu_time_ms,
                        ROW_NUMBER() OVER (PARTITION BY dataset_row_count, uniqueness, sort_order ORDER BY AVG(cpu_time_ms)) AS row_num
              FROM      dbo.clr_xml_test_results
              GROUP BY  method,
                        dataset_row_count,
                        uniqueness,
                        sort_order
             )
    SELECT  dataset_row_count,
            uniqueness,
            sort_order,
            method,
            avg_elapsed_time_ms,
            avg_cpu_time_ms,
            row_num
    FROM    cte
    WHERE   row_num IN (1, 2, 3)
    ORDER BY dataset_row_count,
            uniqueness,
            sort_order,
            row_num ;

SELECT  'avg and min cpu and elapsed times for all queries in all categories' AS header ;
SELECT  method,
        dataset_row_count,
        uniqueness,
        sort_order,
        AVG(cpu_time_ms) AS avg_cpu_time_ms,
        AVG(elapsed_time_ms) AS avg_elapsed_time_ms,
        MIN(cpu_time_ms) AS min_cpu_time_ms,
        MIN(elapsed_time_ms) AS min_elapsed_time_ms
FROM    dbo.clr_xml_test_results
GROUP BY method,
        dataset_row_count,
        uniqueness,
        sort_order
ORDER BY dataset_row_count,
        uniqueness,
        sort_order ;
GO

