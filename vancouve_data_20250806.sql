# create the database /shema in MySQL:
CREATE SCHEMA `vancouver_house_income` ;

#2 Import these 3 dataset files into this Schema via Wizards


# in the table of "vancouver_income_2006_2023", rename the column of "Income Before Tax" to new name of "income_before_tax":
USE vancouver_house_income;

ALTER TABLE vancouver_income_2006_2023
RENAME COLUMN `Income Before Tax` to `income_before_tax`;

ALTER TABLE vancouver_house_prices_20
RENAME COLUMN `Market Price` to `market_price`;


# In the table of "vancouver_income_2006_2023", make sure the new column of "income_before_tax" should be INT datatype;
# In the table of "vancouver_house_prices_20", make sure the comumn of "Market Price" should be DOUBLE(30, 2) to handle decimal values. 
# In the table of "vancouver_neighborhoods_coordinates", both comumn of "Latitude" & "Longitude" should be DOUBLE(30, 4) to handle decimal values. 

#  Handle Missing Values, duplicates and Data Inconsistencies:
SELECT * 
FROM vancouver_house_prices_20
where market_price is null;

# find out and delete the duplicate records:
SELECT *
FROM vancouver_neighborhoods_coordinates
where Neighborhood ='Downtown' ;

delete
FROM vancouver_neighborhoods_coordinates
where Neighborhood ='Downtown' 
and Latitude ='49.2827'  ;

update vancouver_house_prices_20
set Neighborhood = trim(Neighborhood) ;

update vancouver_neighborhoods_coordinates
set Neighborhood = trim(Neighborhood) ;

# Create Relationships Between these 3 tables for the future data analysis:
# set up the column of "Neighborhood" in the table of "vancouver_neighborhoods_coordinates" is primary key, while "Neighborhood" in the table of "vancouver_house_prices_20" is kept as foreigh key. 
# set up the column of "Geography" in the table of "vancouver_income_2006_2023" is primary key, while "Geography" in the table of "vancouver_house_prices_20" is kept as foreigh key. 

# conduct some exploration data analysis:
# query1: Sales Volume by Property Type from year2004 to year 2023:
SELECT
	vancouver_house_prices_20.`Year`, 
	vancouver_house_prices_20.`Property Type` as Property_Type , 
	round(AVG(vancouver_house_prices_20.market_price), 2) as Average_Price,
	COUNT(*) as Sales_QTY
FROM
	vancouver_house_prices_20
	INNER JOIN
	vancouver_neighborhoods_coordinates
	ON 
		vancouver_house_prices_20.Neighborhood = vancouver_neighborhoods_coordinates.Neighborhood
GROUP BY
	vancouver_house_prices_20.`Year`, 
	vancouver_house_prices_20.`Property Type`

ORDER BY 1,2 ;

# comparision of Average_Price and Income_before_tax from year2006 to year2023:
SELECT
	t1.*,vancouver_income_2006_2023.income_before_tax as Income_Before_Tax
FROM
	(
		SELECT
			`Year`, 
			round(AVG(vancouver_house_prices_20.market_price), 2) AS Average_Price
		FROM
			vancouver_house_prices_20
		GROUP BY
			`Year`
	) AS t1
INNER JOIN
	vancouver_income_2006_2023
ON 
		t1.`Year` = vancouver_income_2006_2023.`Year`
where vancouver_income_2006_2023.Geography ='Vancouver' ;
    




