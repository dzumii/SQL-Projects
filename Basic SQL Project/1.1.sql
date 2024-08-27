SELECT
p.ProductID,
p.Name,
p.ProductNumber,
p.Size,
p.Color,
p.ProductSubcategoryID,
ps.Name AS Subcategory
FROM
adwentureworks_db.product p
JOIN
adwentureworks_db.productsubcategory ps
ON
p.ProductSubcategoryID = ps.ProductSubcategoryID