SELECT * FROM `nashville.housing`.`nashville housing data for data cleaning`;

-- Make sure all of the columns are stored as the correct data type.
DESCRIBE `nashville.housing`.`nashville housing data for data cleaning`;


-- check for missing values in the data
 SELECT 
  count(*) - count(UniqueID) as missing_UniqueID,
  count(*) - count(ParcelID) as missing_ParcelID,
  count(*) - count(LandUse) as missing_LandUse,
  count(*) - count(PropertyAddress) as missing_PropertyAddress,
  count(*) - count(SaleDate) as missing_SaleDate,
  count(*) - count(SalePrice) as missing_SalePrice,
  count(*) - count(LegalReference) as missing_LegalReference,
  count(*) - count(SoldAsVacant) as missing_SoldAsVacant,
  count(*) - count(OwnerName) as missing_OwnerName,
  count(*) - count(OwnerAddress) as missing_OwnerAddress,
  count(*) - count(Acreage) as missing_Acreage,
  count(*) - count(TaxDistrict) as missing_TaxDistrict,
  count(*) - count(LandValue) as missing_LandValue,
  count(*) - count(BuildingValue) as missing_BuildingValue,
  count(*) - count(TotalValue) as missing_TotalValue,
  count(*) - count(YearBuilt) as missing_YearBuilt,
  count(*) - count(Bedrooms) as missing_Bedrooms,
  count(*) - count(FullBath) as missing_FullBath,
  count(*) - count(HalfBath) as missing_HalfBath
FROM `nashville.housing`.`nashville housing data for data cleaning`;

-- check the duplicate rows

SELECT UniqueID, ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice, LegalReference, SoldAsVacant, OwnerName, OwnerAddress, Acreage, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath, count(*)
FROM `nashville.housing`.`nashville housing data for data cleaning`
GROUP BY UniqueID, ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice, LegalReference, SoldAsVacant, OwnerName, OwnerAddress, Acreage, TaxDistrict, LandValue, BuildingValue, TotalValue, YearBuilt, Bedrooms, FullBath, HalfBath
HAVING count(*) > 1;

-- indentivyfiyng year in database
ALTER TABLE `nashville.housing`.`nashville housing data for data cleaning`
ADD COLUMN SalesYear date;

UPDATE `nashville.housing`.`nashville housing data for data cleaning`
set SaleDate = str_to_date(concat(replace(SaleDate, ',', ' '), ' 00:00:00'), '%M %d %Y %H:%i:%s');

UPDATE `nashville.housing`.`nashville housing data for data cleaning`
SET SalesYear = STR_TO_DATE(SaleDate, '%Y-%m-%d');

ALTER TABLE `nashville.housing`.`nashville housing data for data cleaning` ADD COLUMN SaleYear YEAR;
UPDATE `nashville.housing`.`nashville housing data for data cleaning` SET SaleYear = YEAR(STR_TO_DATE(CONCAT(SUBSTRING(SaleDate, 7), '-', SUBSTRING(SaleDate, 1, 3), '-', SUBSTRING(SaleDate, 4, 2)), '%Y-%b-%d'));


SELECT EXTRACT(YEAR FROM SaleDate) AS SalesYear
FROM `nashville.housing`.`nashville housing data for data cleaning`;

SELECT EXTRACT(MONTH FROM SaleDate) AS SalesMonth
FROM `nashville.housing`.`nashville housing data for data cleaning`;

ALTER TABLE `nashville.housing`.`nashville housing data for data cleaning` DROP COLUMN `SaleYear`;

--------------------------------------------------------------------------------------------------------------------
-- Summarize the data: (mean, median, mode, standard deviation, and quartiles)

SELECT AVG(SalePrice) AS AverageSalePrice
FROM `nashville.housing`.`nashville housing data for data cleaning`
GROUP BY SalesYear;

SELECT 
  EXTRACT(YEAR FROM SaleDate) AS SalesYear,
  SUM(SalePrice) AS TotalSales
FROM `nashville.housing`.`nashville housing data for data cleaning`
GROUP BY SalesYear, SaleDate;


-- WHERE PropertyAddress is null

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, COALESCE(a.PropertyAddress, b.PropertyAddress) AS PropertyAddress_Coalesced
FROM `nashville.housing`.`nashville housing data for data cleaning` a
JOIN `nashville.housing`.`nashville housing data for data cleaning` b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE `nashville.housing`.`nashville housing data for data cleaning` a
JOIN `nashville.housing`.`nashville housing data for data cleaning` b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID != b.UniqueID
SET a.PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;


------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)

-- Select property address


-- Split property address into two parts
ALTER TABLE `nashville.housing`.`nashville housing data for data cleaning`
ADD PropertySplitAddress VARCHAR(255);

UPDATE `nashville.housing`.`nashville housing data for data cleaning`
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress, ',') - 1);

ALTER TABLE `nashville.housing`.`nashville housing data for data cleaning`
ADD PropertySplitCity VARCHAR(255);

UPDATE `nashville.housing`.`nashville housing data for data cleaning`
SET PropertySplitCity = TRIM(SUBSTRING(PropertyAddress, INSTR(PropertyAddress, ',') + 1));

-- Select owner address
SELECT OwnerAddress
FROM `nashville.housing`.`nashville housing data for data cleaning`;

-- Split owner address into three parts
ALTER TABLE `nashville.housing`.`nashville housing data for data cleaning`
ADD OwnerSplitAddress VARCHAR(255);

UPDATE `nashville.housing`.`nashville housing data for data cleaning`
SET OwnerSplitAddress = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -3));

ALTER TABLE `nashville.housing`.`nashville housing data for data cleaning`
ADD OwnerSplitCity VARCHAR(255);

UPDATE `nashville.housing`.`nashville housing data for data cleaning`
SET OwnerSplitCity = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -2));

ALTER TABLE `nashville.housing`.`nashville housing data for data cleaning`
ADD OwnerSplitState VARCHAR(255);


UPDATE `nashville.housing`.`nashville housing data for data cleaning`
SET OwnerSplitState = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));

SELECT *
FROM `nashville.housing`.`nashville housing data for data cleaning`;