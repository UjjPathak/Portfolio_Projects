# Select nasville table
select *
from nasville;
#Issue with dateformat
# Standardization of Date format by casting new saledateconverted column as date type of SaleDate

select SaleDate
from nasville;

Select saledate, cast(SaleDate as Date)
from nasville;

alter table nasville
add SaleDateConverted Date;

update nasville
set SaleDateConverted= cast(SaleDate as Date);

select SaleDate, SaleDateConverted
from nasville;

#Some property address has null value
#So Populate property address data according to property with same parcelID
select * 
from nasville
where propertyaddress is null;

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from nasville a
join nasville b
on a.ParcelID = b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null;

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from nasville a
join nasville b
on a.ParcelID = b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null;

update nasville a
join nasville b
on a.ParcelID = b.ParcelID
and a.UniqueID<>b.UniqueID
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
where a.PropertyAddress is null;

# Spliting Address into individual columns such as address and city from address columns
select PropertyAddress
from nasville;

#Using Substring

select 
substr(PropertyAddress, 1, locate(',',PropertyAddress)-1) as address
, substr(PropertyAddress,locate(',',PropertyAddress)+1, length(PropertyAddress)) as address
from nasville;

alter table nasville
add propertysplitaddress varchar(255);

update nasville 
set propertysplitaddress = substr(PropertyAddress, 1, locate(',',PropertyAddress)-1);

alter table nasville
add propertysplitcity varchar(255);

update nasville 
set propertysplitcity = substr(PropertyAddress,locate(',',PropertyAddress)+1, length(PropertyAddress));

select *
from nasville;

# Using Substring_index split Address into individual columns such as address and city from address columns

select OwnerAddress
from nasville;
select 
substring_index(OwnerAddress,',',1) as ownersplitaddress,
substring_index(substring_index(OwnerAddress,',',-2),',',1) as ownersplitcity
from nasville;

alter table nasville
add ownersplitaddress varchar(255);

update nasville 
set ownersplitaddress = substring_index(OwnerAddress,',',1);

alter table nasville
add ownersplitcity varchar(255);

update nasville
set ownersplitcity = substring_index(substring_index(OwnerAddress,',',-2),',',1);

select * 
from nasville;

#Changing Y and N to Yes and No in column, 'SoldAsVacant'
select distinct(SoldAsVacant),count(SoldAsVacant)
from nasville
group by SoldAsVacant
order by 2;

Select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from nasville;

update nasville
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end;

# Removing Duplicates
WITH RowCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
    PropertyAddress,
    SalePrice,
    SaleDate,
    LegalReference
	ORDER BY
	UniqueID) row_num

From nasville)
delete
From RowCTE
Where row_num > 1;

WITH RowCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
    PropertyAddress,
    SalePrice,
    SaleDate,
    LegalReference
	ORDER BY
	UniqueID) row_num
From nasville)
Select *
From RowCTE
Where row_num > 1
Order by PropertyAddress;

# Deleating unused columns
select *
from nasville;
alter table nasville
drop column OwnerAddress, 
drop column TaxDistrict, 
drop column PropertyAddress, 
drop column SaleDate;

select *
from nasville;