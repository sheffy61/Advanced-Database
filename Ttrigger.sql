----------------------------------------------------------------------------
-- This is a script that creates a database for Imani Impressionz
-- Author of Script ®Sheriff Ayew--
--
-- All rights reserved ©Sheriff Ayew
--
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--Create Empty database "™SA67032016"
-----------------------------------------------------------------------------
--Steps to follow when creating the daabase using MSSQL server
-----------------------------------------------------------------------------
--1. Connecting to MSSQL Server

USE master; 

--To Drop the Database

IF DB_ID('SA67032016LOG') IS NOT NULL DROP DATABASE SA67032016;

--If database could not be open due to open connections, abort

IF @@ERROR = 3702

   RAISERROR('Open connections not allowing database to be dropped.',127,127) WITH NOWAIT,LOG;

--Syntax to create the database

CREATE DATABASE SA67032016LOG;
GO

USE SA67032016LOG;
GO
------------------------------------------------------------------------------
--Creating Schemas --

--Schemas in this database are deployed for the sole purpose of categorizing the tables in the database--

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
CREATE TABLE DP.Department_log
(
did                    INT               ,
departmentName         NVARCHAR(10)      ,
numberOfMembers        INT               
);


--Ceate table CP.Company_branch
CREATE TABLE CP.Company_Branch_log
(
brid                   INT                  ,
nameOfBranch           NVARCHAR(10)         ,
location               NVARCHAR(10)         ,
NumberOfEmployees      INT                   
);


CREATE TABLE HR.Employees_log
(
empid                   INT               , 
firstname               NVARCHAR(15)      ,  
lastname                NVARCHAR(15)      ,
gender                  CHAR(1)           ,  
initials                CHAR(2)           ,  
address                 NVARCHAR(20)      ,  
dob                     DATETIME          ,
Salary                  MONEY             ,
dateEmployed            DATETIME          ,
employment_Status       NVARCHAR(4)       ,
email                   NVARCHAR(20)      ,
did                     INT               ,
phone                   NVARCHAR(10)      , 
brid                    INT               
);


CREATE TABLE JB.JOB_log
(

nameOfjob                 NVARCHAR(10)          , 
jid                       INT                   ,
jobdescription            NVARCHAR(20)          ,
price                     INT                   ,
dateOrdered               DATETIME              ,
dateSubmitted             DATETIME              ,
jobType                   NVARCHAR(20)          ,
brid                      INT                   ,
empid                     INT                   
);

CREATE TABLE JB.Client_log
(
cid                     INT                    ,
firstname               NVARCHAR(10)           ,
lastname                NVARCHAR(10)           ,
gender                  CHAR(1)                ,
address                 NVARCHAR(20)           ,
email                   NVARCHAR(15)           ,
phone                   NVARCHAR(13)           ,
jid                     INT               

);


CREATE TABLE INV.Inventory_log
(
itemId                 INT                   ,
nameOfItem             NVARCHAR(10)          ,
datePurchased          DATETIME              ,
supplier               NVARCHAR(10)          ,
Saddress               NVARCHAR(20)          ,
unitPrice              INT                   ,
quantity               INT                   ,

);


CREATE TABLE MN.Machine_log
(

nameOfMachine           NVARCHAR(20)        ,
mid                     INT                 ,
ServiceName             NVARCHAR(20)        ,
DateServiced            DATETIME            ,    
);



CREATE TABLE DP.Finance_Department_log
(
did                         INT              ,
brid                        INT              ,
empid                       INT                  
);



-- creates the Graphic_Department table --
CREATE TABLE DP.Graphic_Department_log

(
did                        INT                ,
brid                       INT                ,
empid                      INT                   

);


CREATE TABLE DP.Print_Department_log 
(
did                        INT                   ,
brid                       INT                   ,
empid                      INT                   
);


CREATE TABLE DP.Human_resource_Department_log
(  
did                        INT                    ,
brid                       INT                    ,
empid                      INT                    
);

CREATE TABLE MN.Maintenance_System_log 
(

companyname              NVARCHAR(15)           ,
address                  NVARCHAR(20)           ,
phone                    INT          

);

CREATE TABLE JB.Job_client_log
(

jid                      INT                    ,
cid                      INT                    

);

CREATE TABLE JB.Job_machine_log
(

jid                     INT                     ,
mid                     INT                     ,
dateUsed                DATETIME               

);

-- Create the Job_Inventory table -- 
CREATE TABLE JB.Job_Employee_log
(

empid                     INT                   ,
jid                       INT

);


CREATE TRIGGER HR.Employees_log 
ON HR.Employees
FOR UPDATE AS
BEGIN
DECLARE @Count int
SET @Count = @@ROWCOUNT;

        IF @Count >= (SELECT SUM(row_count)
            FROM sys.dm_db_partition_stats
            WHERE OBJECT_ID = OBJECT_ID('HR.Employees' ) 
            AND index_id = 1)
        BEGIN
           RAISERROR('Not permitted for such operation. Contact Sheriff',16,1) 
           ROLLBACK TRANSACTION
           RETURN;
          END

     END
GO


CREATE TRIGGER DP.department_log 
ON DP.Department
FOR UPDATE AS
BEGIN
DECLARE @Count int
SET @Count = @@ROWCOUNT;

        IF @Count >= (SELECT SUM(row_count)
           FROM sys.dm_db_partition_stats
           WHERE OBJECT_ID = OBJECT_ID('DP.Department' ) 
           AND index_id = 1)
        BEGIN
          RAISERROR('Not permitted for such operation. Contact Sheriff',16,1) 
          ROLLBACK TRANSACTION
          RETURN;
        END 
    END
GO


CREATE TRIGGER JB.JOB_log 
ON JB.JOB
FOR UPDATE AS
BEGIN
DECLARE @Count int
SET @Count = @@ROWCOUNT;

          IF @Count >= (SELECT SUM(row_count) 
             FROM sys.dm_db_partition_stats
             WHERE OBJECT_ID = OBJECT_ID('JB.JOB' ) 
             AND index_id = 1)
           BEGIN
              RAISERROR('Not permitted for such operation. Contact Sheriff',16,1) 
              ROLLBACK TRANSACTION
              RETURN;
            END 
    END
GO


CREATE TRIGGER JB.Job_client_log 
ON JB.Client
FOR UPDATE AS
BEGIN
DECLARE @Count int
SET @Count = @@ROWCOUNT;

             IF @Count >= (SELECT SUM(row_count) 
                FROM sys.dm_db_partition_stats
                WHERE OBJECT_ID = OBJECT_ID('JB.Client' ) 
                AND index_id = 1)
             BEGIN
                RAISERROR('Not permitted for such operation. Contact Sheriff',16,1) 
                ROLLBACK TRANSACTION
                RETURN;
                END 
       END
GO

CREATE TRIGGER INV.Inventory_log
ON INV.Inventory 
FOR UPDATE AS BEGIN
DECLARE @Count int
SET @Count = @@ROWCOUNT;

          IF @Count >= (SELECT SUM(row_count)
             FROM sys.dm_db_partition_stats
             WHERE OBJECT_ID = OBJECT_ID('INV.Inventory' )
             AND index_id = 1)
          BEGIN
             RAISERROR('Not permitted for such operation. Contact Sheriff',16,1) 
             ROLLBACK TRANSACTION
             RETURN;
          END 
END
GO


















