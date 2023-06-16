SELECT * FROM metric.events;

#1 User Engagement
SELECT 
  week(events.occurred_at) AS week,
  COUNT(DISTINCT events.user_id) AS active_users
FROM 
  metric.events
JOIN 
  metric.users 
    ON events.user_id = users.user_id 
WHERE 
  events.event_type = event_type 
GROUP BY 
  week;

SELECT
    week(users.activated_at) AS week,
    COUNT(DISTINCT events.user_id) AS weekly_active_users
FROM 

   metric.users
JOIN 
metric.events 
ON events.user_id = users.user_id
Where users.state = 'active'
GROUP BY week
ORDER BY week;

   
SELECT 
  WEEK(created_at) as week, 
  COUNT(DISTINCT users.user_id) as active_users
FROM metric.events
JOIN metric.users 
ON events.user_id = users.user_id
GROUP BY week
ORDER BY 
    week ASC;

#2 User Growth:
  
SELECT 
  event_type,
  COUNT(DISTINCT events.user_id) as new_users
FROM 
  metric.events
GROUP BY event_type;

#3 Weekly Retention

SELECT 
    DATE(events.occurred_at) AS week_start_date, 
    COUNT(DISTINCT events.user_id) AS weekly_retained_users
FROM 
    metric.events 
    INNER JOIN metric.users 
    ON events.user_id = users.user_id 
WHERE 
    events.event_type = 'signup_flow' 
    AND WEEK(users.created_at) = WEEK(events.occurred_at)
GROUP BY 
    week_start_date
ORDER BY 
    week_start_date ASC;
    
SELECT
signup_week,
retention_week,
COUNT(DISTINCT events.user_id) as active_users,
COUNT(DISTINCT CASE WHEN retention_week = 1 THEN events.user_id ELSE NULL END) as retained_users,
COUNT(DISTINCT CASE WHEN retention_week = 1 THEN events.user_id ELSE NULL END) / COUNT(DISTINCT events.user_id) as retention_rate
FROM (
SELECT
users.user_id,
WEEK(MIN(created_at)) as signup_week,
WEEK(occurred_at) - WEEK(MIN(created_at)) + 1 as retention_week
FROM metric.users
JOIN metric.events 
ON users.user_id = events.user_id
WHERE event_type = 'signup_flow'
GROUP BY event_type
) retention_table
GROUP BY active_users;

#4 weekly engagement per device

SELECT 
    WEEK(users.created_at) AS week, 
    events.device, 
    COUNT(DISTINCT events.user_id) AS weekly_engaged_users
FROM 
    metric.events
JOIN 
    metric.users 
ON events.user_id = users.user_id
GROUP BY 
    week,
    events.device
ORDER BY 
    week ASC;

SELECT WEEK(occurred_at) as week, device, COUNT(DISTINCT user_id) as active_users
FROM events
JOIN users ON events.user_id = users.user_id
GROUP BY week, device

