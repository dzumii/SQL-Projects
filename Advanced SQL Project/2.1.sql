SELECT
  DATE_TRUNC(soh.orderdate, MONTH) AS order_month,
  st.countryregioncode AS CountryRegionCode,
  st.name AS Region,
  COUNT(soh.salesorderid) AS number_orders,
  COUNT(DISTINCT soh.customerid) AS number_customers,
  COUNT(DISTINCT soh.salespersonid) AS no_salesPersons,
  ROUND(SUM(soh.totaldue), 2) AS Total_w_tax
FROM adwentureworks_db.salesorderheader soh
JOIN adwentureworks_db.salesterritory st ON soh.territoryid = st.territoryid
GROUP BY order_month, CountryRegionCode, Region
ORDER BY order_month, CountryRegionCode, Region;
