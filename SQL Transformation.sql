-- Create Database for data
CREATE DATABASE Userdata;

-- Switch to Database
USE UserData;

-- Create table to load data in
CREATE TABLE Users( UserID INT PRIMARY KEY,
					UserName VARCHAR(100),
					Country VARCHAR(50),
					Saving VARCHAR(50))

-- Load data into table
INSERT INTO Users (UserID, UserName, Country, Saving)
SELECT UserID, UserName, Country, Saving
FROM OPENROWSET(BULK 'C:\Users\USER\Downloads\json_data.json', SINGLE_CLOB) AS json
CROSS APPLY OPENJSON(json.BulkColumn)
WITH (UserID INT '$.UserID',
	  UserName VARCHAR(200) '$.UserName',
	  Country VARCHAR(100) '$.Country',
	  Saving VARCHAR(10) '$.Saving');

-- Check if data is loaded correctly
SELECT *
FROM Users;

-- Remove '$" from Saving column and change datatype
UPDATE Users
SET Saving = REPLACE(Saving, '$', '')

-- Check if operation succeeded
SELECT *
FROM Users;

-- Change the datatype of the Saving column
ALTER TABLE Users
ALTER COLUMN Saving FLOAT;

-- Create new columns
ALTER TABLE Users
ADD FirstName VARCHAR(50),
	LastName VARCHAR(50);

-- Split the UserName column into the FirstName and LastName Column
UPDATE Users
SET FirstName = SUBSTRING(UserName, 1, CHARINDEX(' ', UserName) - 1)

UPDATE Users
SET LastName = SUBSTRING(UserName, CHARINDEX(' ', UserName) + 1, LEN(UserName) - CHARINDEX(' ', UserName))


-- Drop Username column
ALTER TABLE Users
DROP COLUMN UserName;

-- Check how the table looks now
SELECT *
FROM Users;

-- Rearrange the columns
CREATE TABLE Users_stg(UserID INT PRIMARY KEY,
						FirstName VARCHAR(50),
						LastName VARCHAR(50),
						Country VARCHAR(50),
						Saving FLOAT)

INSERT INTO Users_stg(UserID, FirstName, LastName, Country, Saving)
SELECT UserID, FirstName, LastName, Country, Saving
FROM Users;

DROP TABLE Users;

EXEC sp_rename 'Users_stg', 'Users';





