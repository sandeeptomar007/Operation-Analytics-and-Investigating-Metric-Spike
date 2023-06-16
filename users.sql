SELECT * FROM metric.users;

SELECT 
    week(users.created_at) AS week, 
    COUNT(DISTINCT users.user_id) AS user_count
FROM 
    metric.users
Join 
   metric.events
   on events.user_id = users.user_id
Where event_type = 'singup flow'
GROUP BY 
    week
ORDER BY 
    week ASC;
    
SELECT
    DATE_FORMAT(u.created_at, '%M') AS Month,
    COUNT(DISTINCT u.user_id) AS monthly_user_growth
FROM metric.users u
GROUP BY Month
ORDER BY Month desc;