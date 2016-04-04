----------------------------------------------------------------------------
-- This is a script that creates a database for Imani Impressionz
--
-- This script can only be used in MSSQL Server
--
-- Author of Script ®Sheriff Ayew
--
-- Last Update 2016-03-08
--
-- All rights reserved ©Sheriff Ayew
--
-- References 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--Create Empty database "™SA67032016"
-----------------------------------------------------------------------------
--Steps to follow when creating the daabase using MSSQL server
-----------------------------------------------------------------------------
--1. Connect to MSSQL Server
--2. The following code below must be run to create an instance of the database

USE master; 

--To Drop the Database

IF DB_ID('SA67032016') IS NOT NULL DROP DATABASE SA67032016;

--If database could not be open due to open connections, abort

IF @@ERROR = 3702

   RAISERROR('Open connections not allowing database to be dropped.',127,127) WITH NOWAIT,LOG;

--Syntax to create the database

CREATE DATABASE SA67032016;
GO

USE SA67032016;
GO
------------------------------------------------------------------------------
--Creating Schemas
--                     --
--DP Stands for Department
--CP Stands for Company
--HR Stands for Human Resource 
--MN Stands for Maintenance
--JB Stands for Jobs
--INV Stands for Inventory
--Schemas in this database are deployed for the sole purpose of categorizing the tables in the database

------------------------------------------------------------------------------
CREATE SCHEMA DP AUTHORIZATION dbo;
GO
CREATE SCHEMA CP AUTHORIZATION dbo;
GO
CREATE SCHEMA HR AUTHORIZATION dbo;
GO
CREATE SCHEMA MN AUTHORIZATION dbo;
GO
CREATE SCHEMA JB AUTHORIZATION dbo;
GO
CREATE SCHEMA INV AUTHORIZATION dbo;
GO
------------------------------------------------------------------------------
--Creating tables
------------------------------------------------------------------------------
--Create table DP.Department -- 
CREATE TABLE DP.Department
(
did                    INT               IDENTITY,
departmentName         NVARCHAR(10)      NOT NULL CHECK (departmentName IN('Finance','Graphics','Printing','Human')), -- update
numberOfMembers        INT               NOT NULL,
empid                  INT               NOT NULL,
CONSTRAINT PK_Department PRIMARY KEY(did),
--CONSTRAINT FK_Department FOREIGN KEY(empid) REFERENCES HR.Employees(empid)
);

CREATE NONCLUSTERED INDEX idx_nc_numberOfMembers ON DP.Department(numberOfMembers);
CREATE NONCLUSTERED INDEX idx_nc_did ON DP.Department(did);


-- Creates the Job table --

CREATE TABLE JB.JOB
(

nameOfjob                 NVARCHAR(10)          , 
jid                       INT                   IDENTITY,
jobdescription            NVARCHAR(30)          ,
dateOfjob                 DATETIME              ,
price                     MONEY                 ,
dateOrdered               DATETIME              ,
dateSubmitted             DATETIME              ,
jobType                   NVARCHAR(20)          ,
brid                      INT                   ,
empid                     INT                   ,
CONSTRAINT PK_JOB PRIMARY KEY(jid), -- Primary key --
CONSTRAINT FK_JOB FOREIGN KEY(brid) REFERENCES CP.Company_Branch(brid),
CONSTRAINT FK_JOB2 FOREIGN KEY(empid) REFERENCES HR.EMPLOYEES(empid),
CONSTRAINT CHK_dateOrdered CHECK(dateOrdered <= CURRENT_TIMESTAMP), -- This constraint enables the date of order to be less than or equal to the current time -- 

);


CREATE NONCLUSTERED INDEX idx_nc_jobdescription ON JB.JOB(jobdescription);
CREATE NONCLUSTERED INDEX idx_nc_price ON JB.JOB(price);
CREATE NONCLUSTERED INDEX idx_nc_jobType ON JB.JOB(jobType);

 
--Create tabe HR.Employees
CREATE TABLE HR.Employees
(
empid                   INT               IDENTITY, -- The identity datatype ensures that, 
firstname               NVARCHAR(10)      NOT NULL,  -- Updated
lastname                NVARCHAR(10)      ,
gender                  CHAR(1)           NOT NULL,  -- Updated
initials                CHAR(2)           ,  -- Updated
address                 NVARCHAR(20)      ,  -- updated
dob                     DATETIME          ,
branch                  NVARCHAR(10)      NOT NULL CHECK (branch IN('Kokomlemle' , 'Newtown')),-- Only Kokomlemle and Newtown can be inputed in those fields -- 
jobWorkedOn             NVARCHAR(20)      ,
Salary                  MONEY             ,
dateEmployed            DATETIME          ,
employment_Status       NVARCHAR(4)       NOT NULL CHECK (employment_status IN('Full' , 'Part')), -- This is to ensure that only "Full or Part" can be inputed in those fields
email                   NVARCHAR(20)      ,
did                     INT               NOT NULL,
phone                   NVARCHAR(10)      ,  -- Updated
CONSTRAINT PK_Employees PRIMARY KEY(empid), -- Primary Key
CONSTRAINT FK_Employees FOREIGN KEY(did) REFERENCES DP.Department(did), -- Foreign key
CONSTRAINT CHK_dob CHECK(dob <= CURRENT_TIMESTAMP), -- The date of birth cannot be greater than or equal to the current date.... 
CONSTRAINT CHK_dateEmployed CHECK(dateEmployed <= CURRENT_TIMESTAMP) --  The date of employment cannot be greater than the date. eg "2020/1/1"

);

CREATE UNIQUE INDEX idx_nc_email ON HR.Employees(email); -- The email address of the employees must be unique --
CREATE UNIQUE INDEX idx_nc_phone ON HR.Employees(phone); -- The phone number of all the employees must be unique --
--CREATE CLUSTERED INDEX idx_nc_lastname ON HR.Employees(lastname); -- A Clustered Index on the table using lastname --
CREATE NONCLUSTERED INDEX idx_nc_jobWorkedOn  ON HR.Employees(jobWorkedOn);

--Create table JB.Client
CREATE TABLE JB.Client
(
cid                     INT                 IDENTITY,
firstname               NVARCHAR(10)        NOT NULL,
lastname                NVARCHAR(10)        ,
gender                  CHAR(1)             NOT NULL,
dob                     DATETIME            ,
initials                NVARCHAR(2)         ,
address                 NVARCHAR(20)        ,
jobOrdered              NVARCHAR(10)        ,
email                   NVARCHAR(15)        ,
phone                   NVARCHAR(13)        NOT NULL,
fax                     NVARCHAR(25)        , -- This column can assume null values
CONSTRAINT PK_Client PRIMARY KEY(cid),
CONSTRAINT CHK_dob CHECK(dob <= CURRENT_TIMESTAMP) -- This implies that, the date of birth of the client must not be greater than or equal to the current date --

);

CREATE UNIQUE INDEX idx_nc_email2 ON HR.Employees(email); -- Unique index created on email address... No two employees can hav the same email address -- 
CREATE UNIQUE INDEX idx_nc_phone2 ON HR.Employees(phone);
CREATE NONCLUSTERED INDEX idx_nc_jobOrdered  ON JB.Client(jobOrdered);
 --CREATE CLUSTERED INDEX idx_nc_lastname ON JB.Client(lastname); -- // For Query Effiecincy using names // -- 


--Create table INV.Inventory
CREATE TABLE INV.Inventory
(
itemId                 INT                   IDENTITY,
nameOfItem             NVARCHAR(10)          ,
datePurchased          DATETIME              NOT NULL,
supplier               NVARCHAR(10)          ,
Saddress               NVARCHAR(10)          ,
unitPrice              MONEY                 NOT NULL,
quantity               INT                   ,
--CONSTRAINT DFT_Inventory_UnitPrice DEFAULT(0), -- The Default unit price of items kept in the inventory is 0 --
priceOfItem            MONEY                 NOT NULL,
CONSTRAINT PK_Iventory PRIMARY KEY(itemId),
CONSTRAINT CHK_datePurchased CHECK(datePurchased <= CURRENT_TIMESTAMP) -- The date purchased should not be greater than the current date --
);

CREATE UNIQUE INDEX idx_nc_supplier on INV.Inventory(supplier) -- There must not be any repeating suppliers in the table -- 
CREATE NONCLUSTERED INDEX idx_nc_nameOfItem ON INV.Inventory(nameOfItem);
CREATE NONCLUSTERED INDEX idx_nc_priceOfItem ON INV.Inventory(priceOfItem);

--Ceate table CP.Company_branch

CREATE TABLE CP.Company_Branch
(
brid                   INT                  IDENTITY,
nameOfBranch           NVARCHAR(20)         ,
location               NVARCHAR(10)         ,
NumberOfEmployees      INT                  ,
CONSTRAINT PK_COMPANYBR PRIMARY KEY(brid),
CONSTRAINT CHK_NumberOfEmployees CHECK(NumberOfEmployees BETWEEN 15 AND 23) -- This constraint makes sure that, the number of employees in a particular branch has to be between 15 and 23 -- 
);

CREATE NONCLUSTERED INDEX idx_nc_nameOfBranch ON CP.Company_Branch(nameOfBranch);

-- Creates the Machine table --
CREATE TABLE MN.Machine
(

nameOfMachine           NVARCHAR(10)        ,
type                    NVARCHAR(10)        ,
manufacturer            NVARCHAR(50)        NOT NULL
);

--Creates the Finance_Department
CREATE TABLE DP.Finance_Department
(
did                    INT                  NOT NULL,
NumberOfMembers        INT                  NOT NULL,
CONSTRAINT FK_Finance_Department FOREIGN KEY(did) REFERENCES DP.Department(did)

);

-- creates the Graphic_Department table --
CREATE TABLE DP.Graphic_Department

(

did                   INT                   NOT NULL,
numberofMembers       INT                   NOT NULL,
CONSTRAINT FK_Graphic_department FOREIGN KEY(did) REFERENCES DP.Department(did)

);

-- Creates the print_department table --
CREATE TABLE DP.Print_Department 
(

did                   INT                   NOT NULL,
numberOfMembers       INT                   NOT NULL,
CONSTRAINT FK_Print_Department FOREIGN KEY(did) REFERENCES DP.Department(did)

);

-- Creates the Human resource department table --
CREATE TABLE DP.Human_resource_Department
(  
did                  INT                    NOT NULL,
numberOfMembers      INT                    NOT NULL,

CONSTRAINT FK_Human_resourc_Department FOREIGN KEY(did) REFERENCES DP.Department(did)
);

-- Creates the maintenance system table --
CREATE TABLE MN.Maintenance_System 
(
companyname          NVARCHAR(50)           NOT NULL,
address              NVARCHAR(100)          NOT NULL,
phone                NVARCHAR(13)           NOT NULL

);

-- Creates the Kokomlemle branch table --
CREATE TABLE CP.Company_branch_Kokomlemle
(

brid                   INT                  NOT NULL,
numberOfEmployees      INT                  NOT NULL,
empid                  INT                  NOT NULL,

CONSTRAINT FK_Company_branch_Kokomlemle FOREIGN KEY(empid) REFERENCES HR.Employees(empid),
CONSTRAINT FK_Company_branch_Kokomlemle2 FOREIGN KEY(brid) REFERENCES CP.Company_Branch(brid)
);

-- Create the Newtown Branch table
CREATE TABLE CP.Company_branch_newtown
(
brid                  INT                   NOT NULL,
numberOfemployees     INT                   NOT NULL,
empid                 int                   NOT NULL,

CONSTRAINT FK_Company_branch_Kokomlemle4 FOREIGN KEY(empid) REFERENCES HR.Employees(empid),
CONSTRAINT FK_Company_branch_Kokomlemle3 FOREIGN KEY(brid) REFERENCES CP.Company_Branch(brid)

);

-- Creates the Job_Client table --
CREATE TABLE JB.Job_client
(

jid                  INT                    NOT NULL,
cid                  INT                    NOT NULL,
requestdate          DATETIME               NOT NULL,

CONSTRAINT FK_Job_client FOREIGN KEY(jid) REFERENCES JB.Job(jid),
CONSTRAINT FK_Job_client2 FOREIGN KEY(cid) REFERENCES CP.Company_Branch(brid)

);

-- Creates the Job_Machine table
CREATE TABLE JB.Job_machine
(

jid                 INT                     NOT NULL,
dateUsed            DATETIME                NOT NULL,
CONSTRAINT FK_Job_Machine FOREIGN KEY(jid) REFERENCES JB.Job(jid),

);

-- Create the Job_Inventory table -- 

CREATE TABLE JB.Job_Inventory
(

itemId              INT                    NOT NULL,
jid                 INT                    NOT NULL,
empid               INT                    NOT NULL,
dateUsed            DATETIME               NOT NULL,
CONSTRAINT FK_Job_Inventory1 FOREIGN KEY(itemid) REFERENCES INV.Inventory(itemid),
CONSTRAINT FK_Job_Inventory2 FOREIGN KEY(jid) REFERENCES JB.Job(jid)

);

-- Creates the Job_Employee table

CREATE TABLE JB.Job_employee
(

empid              INT                     NOT NULL,
jid                INT                     NOT NULL,
date_worked_ON     DATETIME                NOT NULL,
jobType            NVARCHAR(20)            NOT NULL,
CONSTRAINT FK_Job_employee FOREIGN KEY(jid) REFERENCES JB.Job(jid)

);


---------------------------------------------------------------------------------
-- Creating Views , triggers and stored procedure --
---------------------------------------------------------------------------------

CREATE VIEW JB.Clientele AS
SELECT
c.firstname, c.lastname, c.email, c.phone, c.cid
AS
ClinteleReceipt
FROM
JB.Client c GO
CREATE VIEW HR.EmployeeInfo AS
SELECT
empid,
firstname AS [FName], lastname AS [LName]
FROM
HR.Employees GO
CREATE VIEW HR.EmpInv AS
SELECT
e.firstname, e.lastname, i.unitPrice
FROM HR.Employees
INNER JOIN
INV.Inventory ON
e.firstname = i.unitPrice
WHERE
i.unitPrice >= 1; GO
CREATE VIEW JB.EmployeeDepartment
Views
 
AS SELECT
p.firstName, p.lastName,
d.did, d.departmentName
FROM JB.Client p
INNER JOIN
DP.Department d
ON
p.firstname = d.did
WHERE
d.departmentName = 'Finance' GO
Triggers
IF @Count >= (SELECT SUM(row_count)
FROM sys.dm_db_partition_stats
WHERE OBJECT_ID = OBJECT_ID('HR.Employees' ) AND index_id = 1)
BEGIN
RAISERROR('Not permitted for such operation. Contact Sheriff',16,1) ROLLBACK TRANSACTION
RETURN;
END END
GO

CREATE TRIGGER DP.department_Update ON DP.Department
FOR UPDATE AS
BEGIN
DECLARE @Count int
SET @Count = @@ROWCOUNT;
IF @Count >= (SELECT SUM(row_count)
FROM sys.dm_db_partition_stats
WHERE OBJECT_ID = OBJECT_ID('DP.Department' ) AND index_id = 1)
 CREATE TRIGGER HR.employee_update ON HR.Employees
FOR UPDATE AS
BEGIN
DECLARE @Count int
SET @Count = @@ROWCOUNT;
BEGIN
RAISERROR('Not permitted for such operation. Contact Sheriff',16,1) ROLLBACK TRANSACTION
RETURN;
END END
GO

CREATE TRIGGER JB.job_update ON JB.JOB
FOR UPDATE AS
BEGIN
DECLARE @Count int
SET @Count = @@ROWCOUNT;
IF @Count >= (SELECT SUM(row_count) FROM sys.dm_db_partition_stats
WHERE OBJECT_ID = OBJECT_ID('JB.JOB' ) AND index_id = 1)
BEGIN
RAISERROR('Not permitted for such operation. Contact Sheriff',16,1) ROLLBACK TRANSACTION
RETURN;
END END
GO

CREATE TRIGGER JB.Client_Update ON JB.Client
FOR UPDATE AS
BEGIN
DECLARE @Count int
SET @Count = @@ROWCOUNT;
IF @Count >= (SELECT SUM(row_count) FROM sys.dm_db_partition_stats
WHERE OBJECT_ID = OBJECT_ID('JB.Client' ) AND index_id = 1)
BEGIN
RAISERROR('Not permitted for such operation. Contact Sheriff',16,1) ROLLBACK TRANSACTION
RETURN;
END END
GO

CREATE TRIGGER JB.inv_Update
ON INV.Inventory FOR UPDATE AS BEGIN
DECLARE @Count int
SET @Count = @@ROWCOUNT;
IF @Count >= (SELECT SUM(row_count)
FROM sys.dm_db_partition_stats
WHERE OBJECT_ID = OBJECT_ID('INV.Inventory' ) AND index_id = 1)
BEGIN
RAISERROR('Not permitted for such operation. Contact Sheriff',16,1) ROLLBACK TRANSACTION
RETURN;
END END
GO

















































