-- Discovering the data

Select * 
from PortfolioProject..NashvilleHousing

--------------------------------------------------------------------------------------

-- Changing the date format

Select SaleDateConverted, CONVERT(date, SaleDate)  
from PortfolioProject..NashvilleHousing

update NashvilleHousing 
set SaleDate =  CONVERT(date, SaleDate)

Alter table NashvilleHousing
Add SaleDateConverted date

update NashvilleHousing 
set SaleDateConverted =  CONVERT(date, SaleDate)

--------------------------------------------------------------------------------------

-- Populate property adress

Select *--PropertyAddress
from PortfolioProject..NashvilleHousing
where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL( a.PropertyAddress, b.PropertyAddress )
from PortfolioProject..NashvilleHousing as a
join  PortfolioProject..NashvilleHousing as b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

update  a 
set PropertyAddress = ISNULL( a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing as a
join  PortfolioProject..NashvilleHousing as b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null


 --------------------------------------------------------------------------------------

 -- Breaking down the property adress into (Adress, City, and State) using SUBSTRING

 select PropertyAddress
 from PortfolioProject..NashvilleHousing

 select 
 Substring(PropertyAddress,1, charindex(',', PropertyAddress)- 1) as Adress,
 SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+ 1,len(PropertyAddress)) as City
 from PortfolioProject..NashvilleHousing

Alter table PortfolioProject.dbo.NashvilleHousing
Add SplittedAddress Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing 
set SplittedAddress =  Substring(PropertyAddress,1, charindex(',', PropertyAddress)- 1)


Alter table PortfolioProject.dbo.NashvilleHousing
Add SplittedCity Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing 
set SplittedCity =  SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+ 1,len(PropertyAddress))



--------------------------------------------------------------------------------------

 -- Splitting the Owner Adress into (Adress, City, and State) using PARSENAME


select OwnerAddress
from PortfolioProject..NashvilleHousing

select 
PARSENAME(Replace(OwnerAddress,',', '.' ),3),
PARSENAME(Replace(OwnerAddress,',', '.' ),2),
PARSENAME(Replace(OwnerAddress,',', '.' ),1)
from PortfolioProject..NashvilleHousing


Alter table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplittedAddress Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing 
set OwnerSplittedAddress =  PARSENAME(Replace(OwnerAddress,',', '.' ),3)


Alter table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplittedCity Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing 
set OwnerSplittedCity =  PARSENAME(Replace(OwnerAddress,',', '.' ),2)

Alter table PortfolioProject.dbo.NashvilleHousing
Add OwnerSplittedState Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing 
set OwnerSplittedState =  PARSENAME(Replace(OwnerAddress,',', '.' ),1)

select * from PortfolioProject.dbo.NashvilleHousing



--------------------------------------------------------------------------------------


 -- Changing "Y" and "N" for Yes and No respectivily 

select distinct  SoldAsVacant, count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select  SoldAsVacant
,case when SoldAsVacant='Y' then 'Yes'
      when SoldAsVacant='N' then 'No'
 ELSE SoldAsVacant 
 END
from PortfolioProject.dbo.NashvilleHousing

UPDATE PortfolioProject.dbo.NashvilleHousing
Set SoldAsVacant = case when SoldAsVacant='Y' then 'Yes'
      when SoldAsVacant='N' then 'No'
 ELSE SoldAsVacant 
 END

 
--------------------------------------------------------------------------------------

-- Removing Dublicates

WITH RowNumCTE AS ( 
select *, Row_Number() OVER  (
partition by 
             ParcelID,
             PropertyAddress,
             SalePrice,
             SaleDate,
             LegalReference
             ORDER BY UniqueID ) row_num
from PortfolioProject.dbo.NashvilleHousing	)

DELETE 
FROM RowNumCTE
WHERE row_num>1


--------------------------------------------------------------------------------------

-- Deleting unused columns

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select * FROM PortfolioProject.dbo.NashvilleHousing