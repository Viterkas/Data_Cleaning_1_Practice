/* 
Cleaning data in SQL Queries
*/

Select*
From [Portfolio Project].[dbo].[NashvilleHousing]


-- Standardize Date Format

Select SaleDateconverted, Convert(date, saledate)
From [Portfolio Project].[dbo].[NashvilleHousing]


Update NashvilleHousing
SET Saledate = Convert (Date, saledate)

Alter Table NashvilleHousing
Add SaledateConverted Date;

Update NashvilleHousing
SET SaledateConverted = Convert (Date, saledate)


-- Populate Property Address data


Select *
From [Portfolio Project].[dbo].[NashvilleHousing]
-- Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portfolio Project].[dbo].[NashvilleHousing]a
Join [Portfolio Project].[dbo].[NashvilleHousing]b
	ON a.ParcelID = b. ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Portfolio Project].[dbo].[NashvilleHousing]a
Join [Portfolio Project].[dbo].[NashvilleHousing]b
	ON a.ParcelID = b. ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From [Portfolio Project].[dbo].[NashvilleHousing]
-- Where PropertyAddress is null
order by ParcelID

Select 
Substring (PropertyAddress, 1, CHARINDEX (',', PropertyAddress) - 1 ) as Address
, Substring (PropertyAddress, CHARINDEX (',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From [Portfolio Project].[dbo].[NashvilleHousing]

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [Portfolio Project].[dbo].[NashvilleHousing]


Alter Table [Portfolio Project].[dbo].[NashvilleHousing]
Add PropertySplitAddress nvarchar (255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 


Alter Table NashvilleHousing
Add PropertySplitCity nvarchar (255);


Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) 


Select *
From NashvilleHousing

Select 
Parsename (Replace(OwnerAddress,',','.'),3)
, Parsename (Replace(OwnerAddress,',','.'),2)
, Parsename (Replace(OwnerAddress,',','.'),1)
From NashvilleHousing

Alter Table [Portfolio Project].[dbo].[NashvilleHousing]
Add OwnerSplitAddress nvarchar (255);

Update NashvilleHousing
SET OwnerSplitAddress = Parsename (Replace(OwnerAddress,',','.'),3)


Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar (255);


Update NashvilleHousing
SET OwnerSplitCity = Parsename (Replace(OwnerAddress,',','.'),2)


Alter Table NashvilleHousing
Add OwnerSplitState nvarchar (255);

Update NashvilleHousing
SET OwnerSplitState = Parsename (Replace(OwnerAddress,',','.'),1)

Select *
From NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select distinct (SoldAsVacant), COUNT(SoldAsVacant)
FROM [Portfolio Project]..NashvilleHousing
Group by SoldAsVacant
Order by 2


Select soldasvacant 
, CASE When SoldAsVacant ='Y' THEN 'YES'
	   WHEN SoldAsVacant ='N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
From NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant ='Y' THEN 'YES'
	   WHEN SoldAsVacant ='N' THEN 'NO'
	   ELSE SoldAsVacant
	   END



-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


-- Delete Unused columns


Select *
From NashvilleHousing

ALTER TABLE Nashvillehousing
Drop Column OwnerAddress, Taxdistrict, PropertyAddress

ALTER TABLE Nashvillehousing
Drop Column Saledate

ALTER TABLE Nashvillehousing
Drop Column PropertySplitAddress

