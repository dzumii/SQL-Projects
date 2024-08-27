SELECT
sales_detail.SalesOrderId,
sales_detail.OrderQty,
sales_detail.UnitPrice,
sales_detail.LineTotal,
sales_detail.ProductId,
sales_detail.SpecialOfferID,
spec_offer.Category,
spec_offer.Description
FROM
adwentureworks_db.salesorderdetail as sales_detail
INNER JOIN
adwentureworks_db.specialoffer as spec_offer
ON
sales_detail.SpecialOfferID = spec_offer.SpecialOfferID
ORDER BY
LineTotal DESC;