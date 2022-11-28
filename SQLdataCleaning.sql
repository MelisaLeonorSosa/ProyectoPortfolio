-- Data Cleaning en SQL

Select*
From Portfolio.dbo.NashvilleHousing

-- Estandarizar el formato de fecha en SaleDate
Select SaleDateConverted, CONVERT (Date,SaleDate)
From Portfolio.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT (Date,SaleDate)

ALTER TABLE NashvilleHousing
add SaleDateConverted date 

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT (Date,SaleDate)

-- Populate PropertyAddress data
--Select*
--From Portfolio.dbo.NashvilleHousing
--where PropertyAddress is null

--select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
--from Portfolio.dbo.NashvilleHousing a 
--join Portfolio.dbo.NashvilleHousing b
--on a.ParcelID = b.ParcelID
--and a.[UniqueID ] < > a.[UniqueID ]

Select *
FROM Portfolio.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] < > b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] < > b.[UniqueID ]
WHERE a.PropertyAddress is null 

-- Breacking out address into individual columns (Address, City, State)
Select PropertyAddress
From Portfolio.dbo.NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From Portfolio.dbo.NashvilleHousing

ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD PropertySplitAddress varchar (255);

UPDATE Portfolio.dbo.NashvilleHousing
SET  PropertySplitAddress = SUBSTRING(PropertyAddress, 1 , CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD PropertySplitCity varchar (255);
UPDATE  Portfolio.dbo.NashvilleHousing
SET PropertySplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT*
from Portfolio.dbo.NashvilleHousing

--Separando el OwnerAddress en distintas columnas (dirección,ciudad, estado)
SELECT
PARSENAME(REPLACE( OwnerAddress,',','.'),3),
PARSENAME(REPLACE( OwnerAddress,',','.'),2),
PARSENAME(REPLACE( OwnerAddress,',','.'),1)
from Portfolio.dbo.NashvilleHousing

ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD OwnerSplitAddress varchar (255)
UPDATE Portfolio.dbo.NashvilleHousing
SET OwnerSplitAddress =PARSENAME(REPLACE( OwnerAddress,',','.'),3)

ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD OwnerSplitCity varchar (255)
UPDATE Portfolio.dbo.NashvilleHousing
SET OwnerSplitCity =PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE Portfolio.dbo.NashvilleHousing
ADD OwnerSplitState varchar (255)
UPDATE Portfolio.dbo.NashvilleHousing
SET OwnerSplitState =PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT*
from Portfolio.dbo.NashvilleHousing
-- SEGUIR A PARTIR DE MINUTO 34.09
--unificar respuesta para columna sold as vacant, solo con yes o no (estaba yes, no , y , n)
SELECT DISTINCT ( SoldAsVacant)
from Portfolio.dbo.NashvilleHousing

select SoldAsVacant,
CASE WHEN SoldAsVacant= 'Y' THEN 'Yes'
     WHEN SoldAsVacant= 'N' THEN 'No'
     ELSE SoldAsVacant
     END
from Portfolio.dbo.NashvilleHousing

UPDATE Portfolio.dbo.NashvilleHousing
SET SoldAsVacant=CASE WHEN SoldAsVacant= 'Y' THEN 'Yes'
     WHEN SoldAsVacant= 'N' THEN 'No'
     ELSE SoldAsVacant
     END

	 -- eliminar las filas duplicadas
	WITH RowNumCTE AS (
	 SELECT*,
	 ROW_NUMBER () OVER(
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY
				   UniqueID
				   ) row_num
	 FROM Portfolio..NashvilleHousing
	 --ORDER BY ParcelID
	 )
	--ver cuantos repetidos hay (PRIMERO PONGO SELECT* PARA VERLOS Y DESPUES DELETE PARA BORRARLOS Y DESPUES VOLVER A PONER SELECT* PARA VER SI QUEDO ALGUN DUPLICADO)
	SELECT*
	FROM RowNumCTE 
	WHERE row_num>1
	--ORDER BY PropertyAddress

	--SEGUIR DDE MIN 47.11
	--borrar columnas que no voy a usar y no son útiles.
	SELECT *
	FROM Portfolio..NashvilleHousing
	ALTER TABLE Portfolio..NashvilleHousing
	DROP COLUMN OwnerAddress,TaxDistrict,SaleDate