SELECT * FROM PortfolioProject..NashvilleHousing

--Convertir fecha

SELECT SaleDate, CONVERT(Date,SaleDate)
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing 
ADD SaleDate2 Date;

UPDATE NashvilleHousing
SET SaleDate2 = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing 
DROP COLUMN SaleDate

-- Rellenar direcciones

SELECT * 
FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress is null

SELECT a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null


--Limpiando la direccion

SELECT 
SUBSTRING(PropertyAddress, 1 , CHARINDEX(',', PropertyAddress)-1) as address
, SUBSTRING(PropertyAddress , CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as address

FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing 
ADD PropertyAddress2 Varchar(255);

UPDATE NashvilleHousing
SET PropertyAddress2 = SUBSTRING(PropertyAddress, 1 , CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing 
ADD PropertyCity Varchar(255);

UPDATE NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress , CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


-- Limpiando direccion de dueños

SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing 
ADD OwnerAddress2 Nvarchar(255);

ALTER TABLE PortfolioProject..NashvilleHousing  
ADD OwnerCity Varchar(255);

ALTER TABLE PortfolioProject..NashvilleHousing  
ADD OwnerState Varchar(255);

UPDATE PortfolioProject..NashvilleHousing 
SET OwnerAddress2 = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

UPDATE PortfolioProject..NashvilleHousing 
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

UPDATE PortfolioProject..NashvilleHousing 
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

-- Emparejar Valores en SoldasVacant


SELECT Distinct(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
					 When SoldAsVacant = 'N' Then 'No'
					 ELSE SoldAsVacant
						END

-- Eliminar duplicados

