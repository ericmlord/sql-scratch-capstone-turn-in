-- 1.1 How many campaigns and sources does CoolTShirts use and how are they related?

SELECT COUNT(DISTINCT utm_campaign) AS 'Number of Campaigns'
FROM page_visits;

SELECT COUNT(DISTINCT utm_source) AS 'Number of Sources'
FROM page_visits;

SELECT DISTINCT utm_campaign AS 'Campaign', 
	utm_source AS 'Source'
FROM page_visits;

-- 1.2 What pages are on their website?

SELECT DISTINCT page_name AS 'Pages'
FROM page_visits;

-- 2.1 How many first touches is each campaign responsible for?

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
	SELECT ft.user_id,
		ft.first_touch_at,
		pv.utm_source,
		pv.utm_campaign
	FROM first_touch AS ft
	JOIN page_visits AS pv
		ON ft.user_id = pv.user_id
		AND ft.first_touch_at = pv.timestamp)
    
SELECT ft_attr.utm_source AS 'Source',
 	ft_attr.utm_campaign AS 'Campaign',
 	COUNT(*) AS 'First Touches'
FROM ft_attr
GROUP BY 2;

-- 2.2 How many last touches is each campaign responsible for?

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
	SELECT lt.user_id,
		lt.last_touch_at,
		pv.utm_source,
		pv.utm_campaign
	FROM last_touch AS lt
	JOIN page_visits AS pv
		ON lt.user_id = pv.user_id
		AND lt.last_touch_at = pv.timestamp)
    
SELECT lt_attr.utm_source AS 'Source',
	lt_attr.utm_campaign AS 'Campaign',
  COUNT(*) AS 'Last Touches'
FROM lt_attr
GROUP BY 2
ORDER BY 3 DESC;

-- 2.3 How many visitors make a purchase?

SELECT COUNT(*) AS 'Users who Purchased'
FROM page_visits
WHERE page_name LIKE '%purchase';


-- 2.4 How many users visitors make a purchase?

SELECT utm_campaign AS 'Campaign',
	utm_source AS 'Source',
  COUNT(*) AS 'Users who Purchased'
FROM page_visits
WHERE page_name LIKE '%purchase'
GROUP BY 1,2
ORDER BY 3 DESC;