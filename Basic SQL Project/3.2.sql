SELECT
v.VendorId AS Id,
vc.ContactId,
vc.ContactTypeId,
v.Name,
v.CreditRating,
v.ActiveFlag,
va.AddressId,
a.City
FROM
adwentureworks_db.vendor AS v
LEFT JOIN
adwentureworks_db.vendorcontact AS vc
ON v.VendorId = vc.VendorId
LEFT JOIN
adwentureworks_db.vendoraddress AS va
ON v.VendorId = va.VendorId
LEFT JOIN
adwentureworks_db.address AS a
ON va.AddressId = a.AddressId;