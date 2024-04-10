--Cleaning DAta in SQL Queries
select *
from NashvilleHousing



--Standardiza Date Format
alter table nashvillehousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = convert(Date, saledate)




--Populate Property Address Date
select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress
from NashvilleHousing a
join NashvilleHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = ISNULL(a.propertyaddress,b.propertyaddress)
from NashvilleHousing a
join NashvilleHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null



--Breaking out Address into Individual Columns (Address, City, State)
select propertyaddress
from NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress= SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress)-1)

alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(propertyaddress, charindex(',',propertyaddress)+1, len(propertyaddress))


select *
from NashvilleHousing







select owneraddress
from NashvilleHousing


alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress= PARSENAME(REPLACE(owneraddress, ',', '.'), 3)


alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(owneraddress, ',', '.'), 2)


alter table NashvilleHousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(owneraddress, ',', '.'), 1)


select *
from NashvilleHousing






--Change Y and N to Yes and No in 'Sold as Vacnt' field.
select distinct (soldasvacant), count(soldasvacant)
from NashvilleHousing
group by SoldAsVacant
order by 2


update NashvilleHousing
set SoldAsVacant = 
                   CASE when SoldAsVacant = 'Y' Then 'Yes'
				        when SoldAsVacant = 'N' Then 'No'
						Else SoldAsVacant
						End



--Remove Duplicates
With RowNumCTE As(
select *, 
         Row_Number() over (
		 Partition By ParcelID,
		              PropertyAddress,
					  SalePrice,
					  SaleDate,
					  LegalReference
					  order by
					           UniqueID
							   ) RowNumber
from NashvilleHousing
)
select *
from RowNumCTE
where RowNumber > 1
order by PropertyAddress



select *
from NashvilleHousing







--Delete Unused Columns
select *
from NashvilleHousing

Alter Table NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate