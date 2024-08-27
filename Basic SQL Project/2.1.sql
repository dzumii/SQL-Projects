SELECT
LocationID,
COUNT(DISTINCT WorkOrderID) AS no_work_orders,
COUNT(DISTINCT ProductID) AS no_unique_products,
SUM(ActualCost) AS actual_cost,
FROM
adwentureworks_db.workorderrouting
WHERE
DATE(ModifiedDate) >= '2004-01-01' AND DATE(ModifiedDate) < '2004-02-01'
GROUP BY
LocationID;