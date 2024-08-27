SELECT
l.Name AS Location,
w.LocationID,
COUNT(DISTINCT WorkOrderID) AS no_work_orders,
COUNT(DISTINCT ProductID) AS no_unique_products,
SUM(ActualCost) AS actual_cost,
AVG(DATE_DIFF(w.ActualEndDate, w.ActualStartDate, DAY)) AS avg_days_diff
FROM
adwentureworks_db.workorderrouting w
JOIN
adwentureworks_db.location l
ON
w.LocationID = l.LocationID
WHERE
w.ActualStartDate >= '2004-01-01' AND w.ActualStartDate < '2004-02-01'
GROUP BY
l.Name, w.LocationID;