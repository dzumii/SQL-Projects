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
  JOIN adwentureworks_db.address a ON soh.shiptoaddressid = a.addressid
  JOIN adwentureworks_db.stateprovince sp ON a.stateprovinceid = sp.stateprovinceid
  JOIN adwentureworks_db.salesterritory st ON soh.territoryid = st.territoryid
  GROUP BY order_month, CountryRegionCode, Region
),
EnrichedMonthlySales AS (
  SELECT
    order_month,
    CountryRegionCode,
    Region,
    number_orders,
    number_customers,
    no_salesPersons,
    Total_w_tax,
    ROUND(SUM(Total_w_tax) OVER (PARTITION BY CountryRegionCode, Region ORDER BY order_month), 2) AS Cumulative_Total_w_tax,
    RANK() OVER (PARTITION BY CountryRegionCode, Region ORDER BY Total_w_tax DESC) AS Sales_Rank
  FROM MonthlySales
),
TaxInfo AS (
  SELECT
    sp.countryregioncode AS CountryRegionCode,
    cr.name AS Country,
    sp.name AS Region,
    MAX(t.taxrate) AS TaxRate
  FROM adwentureworks_db.salestaxrate t
  JOIN adwentureworks_db.stateprovince sp ON t.stateprovinceid = sp.stateprovinceid
  JOIN adwentureworks_db.countryregion cr ON sp.countryregioncode = cr.countryregioncode
  GROUP BY sp.countryregioncode, cr.name, sp.name
),
CountryTaxSummary AS (
  SELECT
    t.CountryRegionCode,
    ROUND(AVG(t.TaxRate),2) AS MeanTaxRate,
    COUNT(t.Region) AS NumberOfRegionsWithTax,
    COUNT(DISTINCT sp.stateprovinceid) AS TotalRegions
  FROM TaxInfo t
  JOIN adwentureworks_db.stateprovince sp ON t.CountryRegionCode = sp.countryregioncode
  GROUP BY t.CountryRegionCode
)
SELECT
  ems.order_month,
  ems.CountryRegionCode,
  ems.Region,
  ems.number_orders,
  ems.number_customers,
  ems.no_salesPersons,
  ROUND(ems.Total_w_tax, 2) AS Total_w_tax,
  ems.Cumulative_Total_w_tax,
  ems.Sales_Rank,
  cts.MeanTaxRate,
  cts.NumberOfRegionsWithTax / NULLIF(cts.TotalRegions, 0) AS PercProvincesWithTax
FROM EnrichedMonthlySales ems
JOIN CountryTaxSummary cts ON ems.CountryRegionCode = cts.CountryRegionCode
ORDER BY ems.order_month, ems.CountryRegionCode, ems.Region;
