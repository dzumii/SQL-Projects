SELECT
p.ProductID,
p.Name,
p.ProductNumber,
p.Size,
p.Color,
p.ProductSubcategoryID,
ps.Name AS Subcategory,
pc.Name AS Category
FROM
adwentureworks_db.product p
JOIN
adwentureworks_db.productsubcategory ps
ON
p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN
adwentureworks_db.productcategory pc
ON
ps.ProductCategoryID = pc.ProductCategoryID
ORDER BY
Category;