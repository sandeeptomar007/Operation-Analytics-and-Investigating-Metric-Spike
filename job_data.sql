SELECT * FROM metric.job_data;

-- #1

SELECT 
   time(time_spent) AS per_hour,
   day(ds) as per_day, 
   COUNT(*) AS jobs_reviewed
FROM metric.job_data
WHERE ds BETWEEN '2020/11/01' AND '2020/11/30'
GROUP BY per_hour
Order BY ds;

-- #2

SELECT  
   day(ds) as per_day, 
   time(time_spent) / 86400 AS throughput_per_second,
   AVG(COUNT(*)) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_throughput
FROM metric.job_data
GROUP BY per_day
ORDER BY per_day;

-- #3

SELECT language, COUNT(*) / CAST(SUM(COUNT(*)/100) OVER () AS FLOAT) as percentage_share
FROM 
 metric.job_data
WHERE ds >= DATE_SUB('2020-11-30', INTERVAL 30 DAY)
GROUP BY language
ORDER BY percentage_share DESC;

-- #4
SELECT job_id, actor_id, event, language, time_spent, org, ds, COUNT(*) AS num_duplicates
FROM 
metric.job_data
GROUP BY job_id, actor_id, event, language, time_spent, org, ds
HAVING COUNT(*) > 1;
