WITH MonthlySales AS (
  SELECT
    DATE_TRUNC(soh.orderdate, MONTH) AS order_month,
    st.countryregioncode AS CountryRegionCode,
    st.name AS Region,
    COUNT(soh.salesorderid) AS number_orders,
    COUNT(DISTINCT soh.customerid) AS number_customers,
    COUNT(DISTINCT soh.salespersonid) AS no_salesPersons,
    SUM(soh.totaldue) AS Total_w_tax
  FROM adwentureworks_db.salesorderheader soh
  JOIN adwentureworks_db.salesterritory st ON soh.territoryid = st.territoryid
  JOIN adwentureworks_db.address a ON soh.shiptoaddressid = a.addressid
  JOIN adwentureworks_db.stateprovince sp ON a.stateprovinceid = sp.stateprovinceid
  JOIN adwentureworks_db.countryregion cr ON sp.countryregioncode = cr.countryregioncode
  GROUP BY order_month, CountryRegionCode, Region
)
SELECT
  order_month,
  CountryRegionCode,
  Region,
  number_orders,
  number_customers,
  no_salesPersons,
  ROUND(Total_w_tax, 2) AS Total_w_tax,
  ROUND(SUM(Total_w_tax) OVER (PARTITION BY CountryRegionCode, Region ORDER BY order_month),2) AS Cumulative_Total_w_tax,
  RANK() OVER (PARTITION BY CountryRegionCode, Region ORDER BY Total_w_tax DESC) AS Sales_Rank
FROM MonthlySales
ORDER BY order_month, CountryRegionCode, Region;
