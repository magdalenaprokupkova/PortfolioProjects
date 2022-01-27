/* CLEANING DATA IN SQL */

SELECT *
FROM [Portfolio Project 1].[dbo].[NashvilleHousing]

------------------------------------------------------

/* STANDARDIZE DATE FORMAT */
--time stamp unnecessary, convert and delete old column
SELECT SaleDate, CONVERT(Date, SaleDate)
FROM [Portfolio Project 1].[dbo].[NashvilleHousing]

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted =  CONVERT(Date, SaleDate)

SELECT *
FROM NashvilleHousing; --SaleDateConverted now holds the date information without the time stamp

-----------------------------------------------------

/* POPULATE PROPERTY ADRESS DATA */

SELECT *
FROM NashvilleHousing
--WHERE PropertyAddress IS NULL;
ORDER BY ParcelID -- notice that the same parcelID = same Property Address

--let's populate PropertyAddress based on the same ParcelID
-- self-join needed
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing AS a
JOIN NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID 
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing AS a
JOIN NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID 
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL


--check there is no null adress
SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL; -- all PropertyAddress fields are now populated

-------------------------------------------------------------------------------

/* BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE) */


SELECT PropertyAddress
FROM NashvilleHousing
--fromat is adress, city (and this comma is the only delimiter in this column)

--let's seperate using substring and character index or char index
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address --searches the substring from the first character (1) up to the comma (charindex(',')), add -1 to get rid of the comma at the end
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS City
FROM [Portfolio Project 1].[dbo].[NashvilleHousing]

-- need to add columns PropertyStreet and PropertyCity
ALTER TABLE NashvilleHousing
Add PropertyStreet Nvarchar(255);

Update NashvilleHousing
SET PropertyStreet = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertyCity Nvarchar(255);

Update NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

SELECT *
FROM NashvilleHousing

--the columns PropertyStreet and PropertyCity now hold the address information in more clear manner

--------------------------------------------------------------------------------------------------------------

-- now the same with the owner address
SELECT OwnerAddress
FROM NashvilleHousing
-- we have Street, City and State

SELECT --use parsename -- works only with '.' so need to change ',' to '.'
PARSENAME(REPLACE(OwnerAddress,',', '.'), 3) -- 123 order would seperate the address backwards so need 321 order that's just how parsename works
,PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerStreet Nvarchar(255);

Update NashvilleHousing
SET OwnerStreet = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)


ALTER TABLE NashvilleHousing
Add OwnerCity Nvarchar(255);

Update NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)


ALTER TABLE NashvilleHousing
Add OwnerState Nvarchar(255);

Update NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)

SELECT *
FROM NashvilleHousing

-------------------------------------------------------------------------

/* CHANGE Y AND N TO YES AND NO IN 'SOLD AS VACANT' FIELD */

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant) 
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2 DESC; -- mostly yes and no and only few y and n so lets change them to yes and no

-- use case statement
SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END 



------------------------------------------------------------------------
/* END */
