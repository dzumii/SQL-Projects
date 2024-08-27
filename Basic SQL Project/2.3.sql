SELECT
WorkOrderID,
ActualCost
FROM
adwentureworks_db.workorderrouting
WHERE
CAST(ModifiedDate AS DATE) >= '2004-01-01'
AND CAST(ModifiedDate AS DATE) < '2004-02-01'
AND ActualCost > 300;