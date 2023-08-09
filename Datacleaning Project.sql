
Use [Portfolio Project]

---Cleaning the data

--select * from Nashvillee;

----Property Address--

select * 
from Nashvillee a
join Nashvillee b
on a.parcelID=b.parcelID
And a.uniqueID <>b.uniqueID

select a.parcelID, a.PropertyAddress, b.parcelID, b.PropertyAddress ,ISnull(a.propertyaddress,b.propertyaddress)
from Nashvillee a
join Nashvillee b
on a.parcelID=b.parcelID
And a.uniqueID <>b.uniqueID
where a.propertyaddress is null

Update a 
set propertyaddress = ISnull(a.propertyaddress,b.propertyaddress)
from Nashvillee a
join Nashvillee b
on a.parcelID=b.parcelID
And a.uniqueID <>b.uniqueID
where a.propertyaddress is null


---Breaking out Address into Individual columns(address,city,state)---PropertyADdress and OwnerAddress


select PropertyAddress from Nashvillee;

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) As Address, 

SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from Nashvillee;  


ALTER table Nashvillee
Add PropertySplitAddress nvarchar(255);

Update Nashvillee
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER table Nashvillee
Add PropertySplitCity nvarchar(255);


Update Nashvillee
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

-----
---select * from Nashvillee;

---select OwnerAddress from Nashvillee;

select
PARSENAME(REPLACE(OwnerAddress,',','.'),3) , 
PARSENAME(REPLACE(OwnerAddress,',','.'),2) ,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) 
from Nashvillee;

ALTER table Nashvillee
Add OwnerSplitAddress nvarchar(255);

Update Nashvillee
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER table Nashvillee
Add OwnerSplitCity nvarchar(255);


Update Nashvillee
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER table Nashvillee
Add OwnerSplitState nvarchar(255);


Update Nashvillee
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


select * from Nashvillee;

--Change Y and N to Yes and No in "Sold as Vacant" field

--select SoldAsVacant
--from Nashvillee;

select SoldAsVacant,
CASE When SoldAsVacant = '0' THEN 'NO'
     When SoldAsVacant = '1' THEN 'Yes'
	 --ELSE SolsAsVacant
	 END
from Nashvillee;

ALTER table Nashvillee
Add SoldVacant nvarchar(20);


Update Nashvillee
set SoldVacant = CASE When SoldAsVacant = '0' THEN 'NO'
     When SoldAsVacant = '1' THEN 'Yes'
	 END


----

------------Remove Duplicates
----CTE

With RowNumCTE As (
select *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER By
			 UniqueID
			 ) row_num

from Nashvillee
)
--Delete
select * 
from RowNumCTE
where row_num >1


------
----Delete Unused columns

ALTER TABLE Nashvillee
DROP COLUMN OwnerAddress,PropertyAddress

ALTER TABLE Nashvillee
DROP COLUMN TaxDistrict