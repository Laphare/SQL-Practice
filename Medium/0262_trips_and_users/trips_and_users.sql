
WITH client AS(
    SELECT users_id as client_id 
    FROM Users
    WHERE role = 'client'
    AND banned = 'No'),
driver AS( SELECT users_id as driver_id 
    FROM Users
    WHERE role = 'driver'
    AND banned = 'No')
SELECT request_at AS Day,
ROUND(
        COUNT(CASE WHEN t1.status IN ('cancelled_by_driver', 'cancelled_by_client') THEN 1 END) * 1.0 
        / 
        NULLIF(COUNT(*), 0), 2) AS 'Cancellation Rate'
FROM (
    SELECT client_id,driver_id,status,request_at
FROM Trips
WHERE request_at between "2013-10-01" and "2013-10-03"
) as t1
JOIN client as c
ON c.client_id = t1.client_id
JOIN driver as d
ON d.driver_id = t1.driver_id
GROUP BY t1.request_at
ORDER BY t1.request_at
