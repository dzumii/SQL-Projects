WITH LatestAddresses AS (
  SELECT 
    customerid,
    MAX(addressid) AS addressid
  FROM adwentureworks_db.customeraddress
  GROUP BY customerid
),
CustomerOrders AS (
  SELECT
    soh.customerid,
    COUNT(soh.salesorderid) AS NumberOfOrders,
    ROUND(SUM(soh.totaldue), 2) AS TotalAmountWithTax,
    MAX(soh.orderdate) AS LastOrderDate
  FROM adwentureworks_db.salesorderheader soh
  GROUP BY soh.customerid
),
CustomerDetails AS (
  SELECT
    c.customerid,
    ct.firstname,
    ct.lastname,
    CONCAT(ct.firstname, ' ', ct.lastname) AS FullName,
    CASE 
      WHEN ct.title IS NULL THEN CONCAT('Dear ', ct.lastname)
      ELSE CONCAT(ct.title, ' ', ct.lastname)
    END AS Addressing_Title,
    ct.emailaddress,
    ct.phone,
    c.accountnumber,
    c.customertype,
    a.city,
    sp.name AS State,
    cr.name AS Country,
    cr.countryregioncode AS CountryRegionCode,
    a.addressline1
  FROM adwentureworks_db.customer c
  JOIN adwentureworks_db.individual i ON c.customerid = i.customerid
  JOIN adwentureworks_db.contact ct ON i.contactid = ct.contactid
  JOIN LatestAddresses la ON c.customerid = la.customerid
  JOIN adwentureworks_db.address a ON la.addressid = a.addressid
  JOIN adwentureworks_db.stateprovince sp ON a.stateprovinceid = sp.stateprovinceid
  JOIN adwentureworks_db.countryregion cr ON sp.countryregioncode = cr.countryregioncode
  WHERE c.customertype = 'I'
)
SELECT
  cd.customerid,
  cd.firstname,
  cd.lastname,
  cd.fullname,
  cd.addressing_title,
  cd.emailaddress,
  cd.phone,
  cd.accountnumber,
  cd.customertype,
  cd.city,
  cd.state,
  cd.country,
  cd.addressline1 AS address,
  SPLIT(cd.addressline1, ' ')[OFFSET(0)] AS address_number,
  ARRAY_TO_STRING(ARRAY(SELECT part FROM UNNEST(SPLIT(cd.addressline1, ' ')) part WITH OFFSET WHERE OFFSET > 0), ' ') AS address_street,
  co.numberoforders,
  co.totalamountwithtax,
  co.lastorderdate,
  td.Group AS TerritoryGroup
FROM CustomerDetails cd
JOIN CustomerOrders co ON cd.customerid = co.customerid
JOIN adwentureworks_db.salesterritory td ON cd.CountryRegionCode = td.CountryRegionCode
WHERE td.Group = 'North America'
  AND (co.totalamountwithtax >= 2500 OR co.numberoforders >5)
ORDER BY cd.country, cd.state, co.lastorderdate;
