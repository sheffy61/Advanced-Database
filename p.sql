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
CREATE TABLE DP.Department
(
did                    INT               ,
departmentName         NVARCHAR(10)      CHECK (departmentName IN('Finance','Graphics','Printing','Human')),
numberOfMembers        INT               ,
CONSTRAINT PK_Department PRIMARY KEY(did)
);

CREATE NONCLUSTERED INDEX idx_nc_numberOfMembers ON DP.Department(numberOfMembers);
CREATE NONCLUSTERED INDEX idx_nc_did ON DP.Department(did);


IF ( OBJECT_ID('DP.depT') IS NOT NULL ) 
   DROP PROCEDURE DP.depT
GO

CREATE PROCEDURE DP.depT
       @did                            INT                      , 
       @departmentName                 VARCHAR(10)              , 
       @numberOfmembers                INT                                      
AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO DP.Department
          ( 
            did                         ,
            departmentName              ,
            numberOfmembers                                                      
          ) 
     VALUES 
          ( 
            @did                        ,
            @departmentName             ,
            @numberOfmembers                                                 
          ) 
END 
GO

EXEC DP.depT 01,'Finance',7;
GO
EXEC DP.depT 02,'Graphics',15;
GO
EXEC DP.depT 03,'Printing',20;
GO
EXEC DP.depT 04,'Human',6;
GO


--Ceate table CP.Company_branch
CREATE TABLE CP.Company_Branch
(
brid                   INT                  ,
nameOfBranch           NVARCHAR(10)         ,
location               NVARCHAR(10)         ,
NumberOfEmployees      INT                  ,
CONSTRAINT PK_COMPANYBR PRIMARY KEY(brid),
--CONSTRAINT CHK_NumberOfEmployees CHECK(NumberOfEmployees > 10) -- 
);

CREATE NONCLUSTERED INDEX idx_nc_nameOfBranch ON CP.Company_Branch(nameOfBranch);



IF ( OBJECT_ID('CP.Company_Branch_T') IS NOT NULL ) 
   DROP PROCEDURE CP.Company_Branch_T
GO

CREATE PROCEDURE CP.Company_Branch_T
       @brid                          INT                , 
       @nameOfBranch                  NVARCHAR(10)       , 
       @location                      NVARCHAR(20)       , 
       @NumberOfEmployees             INT
  
AS 

BEGIN 
     SET NOCOUNT ON 

     INSERT INTO CP.Company_Branch
          ( 
             brid                     , 
             nameOfBranch             , 
             location                 , 
             numberOfEmployees        
          ) 
     VALUES 
          ( 
           @brid                       , 
           @nameOfBranch               , 
           @location                   , 
           @numberOfEmployees                                          
          ) 
END 
GO


EXEC CP.Company_Branch_T 111,'Imani1','Kokomlemle',30;
GO
EXEC CP.Company_Branch_T 112,'Imani2','Newtown',18;
GO



--Create tabe HR.Employees
CREATE TABLE HR.Employees
(
empid                   INT               , 
firstname               NVARCHAR(10)      NOT NULL,  
lastname                NVARCHAR(10)      ,
gender                  CHAR(1)           NOT NULL,  
initials                CHAR(2)           ,  
address                 NVARCHAR(20)      ,  
dob                     DATETIME          ,
Salary                  MONEY             ,
dateEmployed            DATETIME          ,
employment_Status       NVARCHAR(4)       NOT NULL CHECK (employment_status IN('Full' , 'Part')),
email                   NVARCHAR(20)      ,
did                     INT               ,
phone                   NVARCHAR(10)      , 
brid                    INT               ,
CONSTRAINT PK_Employees PRIMARY KEY(empid),
CONSTRAINT FK_Employees FOREIGN KEY(did) REFERENCES DP.Department(did),
CONSTRAINT FK_Branch    FOREIGN KEY(brid) REFERENCES CP.Company_Branch(brid),
CONSTRAINT CHK_dob CHECK(dob <= CURRENT_TIMESTAMP),
CONSTRAINT CHK_dateEmployed CHECK(dateEmployed <= CURRENT_TIMESTAMP)

);

CREATE UNIQUE INDEX idx_nc_email ON HR.Employees(email);
CREATE UNIQUE INDEX idx_nc_phone ON HR.Employees(phone);




IF ( OBJECT_ID('HR.EmployT') IS NOT NULL ) 
   DROP PROCEDURE HR.EmployT
GO

CREATE PROCEDURE HR.EmployT  
       @empid                          INT                , 
       @firstname                      NVARCHAR(10)       , 
       @lastname                       NVARCHAR(10)       , 
       @gender                         CHAR(1)            , 
       @initials                       CHAR(2)            , 
       @address                        NVARCHAR(20)       , 
       @dob                            DATETIME           , 
       @Salary                         MONEY              ,
       @dateEmployed                   DATETIME           ,       
       @employment_status              NVARCHAR(4)        ,
       @email                          NVARCHAR(20)       ,
       @did                            INT                ,
       @phone                          INT                ,
       @brid                           INT   

AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO HR.Employees
          ( 
            empid                    ,
            firstname                ,
            lastname                 ,
            gender                   ,
            initials                 ,
            address                  ,
            dob                      ,
            Salary                   ,
            dateEmployed             ,
            employment_status        ,
            email                    ,
            did                      ,
            phone                    ,
            brid         
          ) 
     VALUES 
          ( 
            
            @empid                    ,
            @firstname                ,
            @lastname                 ,
            @gender                   ,
            @initials                 ,
            @address                  ,
            @dob                      ,
            @Salary                   ,
            @dateEmployed             ,
            @employment_status        ,
            @email                    ,
            @did                      ,
            @phone                    ,
            @brid

          ) 
END 
GO

EXEC HR.EmployT 111231,'Juluis','Kofigah','M','JK','Lapaz-Accra','1982-01-03','1500','2006-01-03','Full','kofi@imani.com',03,0244111222,111;
GO
EXEC HR.EmployT 111232,'Berikisu','Ibrahim','F','BI','Newtown-Accra','1981-01-03',1500,'2006-01-03','Full','kissu@imani.com',03,0244223229,112;
GO
EXEC HR.EmployT 111233,'Ebo','White','M','JK','Alajo-Accra','1983-01-03',1500,'2006-01-03','Full','ebo@imani.com',01,0244333444,111;
GO
EXEC HR.EmployT 111234,'Kweku','Agyemang','M','KA','Eastlegon-Accra','1987-01-03',500,'2006-01-03','Part','kweku@imani.com',03,0244211322,111;
GO
EXEC HR.EmployT 111235,'Kwame','Cudjoe','M','JK','Westlegon-Accra','1989-01-03',1500,'2006-01-03','Full','kofi2@imani.com',01,0241213222,112;
GO
EXEC HR.EmployT 111236,'Alice','Wonder','F','AW','Lashibi-Accra','1990-01-03',1500,'2006-01-03','Full','Alice@imani.com',03,0044111222,111;
GO
EXEC HR.EmployT 111237,'Bat','Man','M','BA','Klagon-Accra','1983-01-03',1500,'2006-01-03','Full','Bat@imani.com',03,0244131222,112;
GO
EXEC HR.EmployT 111238,'Super','Woman','F','SW','Tema-Accra','1984-01-03',1500,'2006-01-03','Part','Super@imani.com',03,0244111342,111;
GO
EXEC HR.EmployT 111239,'Nana','Ama','F','JK','Osu-Accra','1986-01-03',1500,'2006-01-03','Full','nana@imani.com',02,0244011282,111;
GO
EXEC HR.EmployT 1112311,'Sama','Ansah','F','SA','Achimota-Accra','1989-01-03',1500,'2006-01-03','Part','Sama@imani.com',02,0243131722,112;
GO


-- Creates the Job table --
CREATE TABLE JB.JOB
(

nameOfjob                 NVARCHAR(10)          , 
jid                       INT                   ,
jobdescription            NVARCHAR(20)          ,
price                     INT                   ,
dateOrdered               DATETIME              ,
dateSubmitted             DATETIME              ,
jobType                   NVARCHAR(20)          ,
brid                      INT                   ,
empid                     INT                   ,
CONSTRAINT PK_JOB PRIMARY KEY(jid), 
CONSTRAINT FK_JOB FOREIGN KEY(brid) REFERENCES CP.Company_Branch(brid),
CONSTRAINT FK_JOB2 FOREIGN KEY(empid) REFERENCES HR.Employees(empid),
CONSTRAINT CHK_dateOrdered CHECK(dateOrdered <= CURRENT_TIMESTAMP), -- This 

);

CREATE NONCLUSTERED INDEX idx_nc_price ON JB.JOB(price);

IF ( OBJECT_ID('JB.Job_T') IS NOT NULL ) 
   DROP PROCEDURE JB.JOB_T
GO

CREATE PROCEDURE JB.JOB_T  
       @nameOfjob                    NVARCHAR(20)             , 
       @jid                          INT                      , 
       @jobdescription               NVARCHAR(20)             , 
       @price                        INT                      , 
       @dateOrdered                  DATETIME                 , 
       @dateSubmitted                DATETIME                 ,  
       @jobType                      NVARCHAR(20)             ,
       @brid                         INT                      ,
       @empid                        INT                            
AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO JB.JOB
          ( 
            nameOfjob                    ,
            jid                          ,
            jobdescription               ,
            price                        ,
            dateOrdered                  ,
            dateSubmitted                ,
            jobType                      ,
            brid                         ,
            empid             
          ) 
     VALUES 
          ( 
            @nameOfjob                    ,
            @jid                          ,
            @jobdescription               ,
            @price                        ,
            @dateOrdered                  ,
            @dateSubmitted                ,
            @jobType                      ,
            @brid                         ,
            @empid                
          ) 
END 
GO

EXEC JB.JOB_T 'Poster',1001,'MTNjob',100,'2015-03-01','2015-04-01','Poster',111,111231;
GO
EXEC JB.JOB_T 'Banner',1002,'Airteljob',500,'2015-03-01','2015-04-01','Banner',112,111232;
GO
EXEC JB.JOB_T 'CallCard',1003,'Vodafone',100,'2015-03-01','2015-04-01','A6',111,111231;
GO
EXEC JB.JOB_T 'Card',1004,'TigoJob',100,'2015-03-01','2015-04-01','A5 Card',111,111232;
GO
EXEC JB.JOB_T 'Banner',1005,'Logo',1000,'2015-03-01','2015-04-01','Banner',111,111233;
GO
EXEC JB.JOB_T 'Design',1006,'Career',123000,'2015-03-01','2015-04-01','Trifold',112,111234;
GO
EXEC JB.JOB_T 'Cert',1007,'Football',5,'2015-03-01','2015-04-01','Certificate',112,111235;
GO
EXEC JB.JOB_T 'Branding',1008,'MustCargo',20000,'2015-03-01','2015-04-01','ArtWork',112,111236;
GO
EXEC JB.JOB_T 'Jersey',1009,'Jersey',10,'2015-03-01','2015-04-01','Poster',112,111237;
GO
EXEC JB.JOB_T 'Photocopy',10011,'job',1,'2015-03-01','2015-04-01','Poster',111,111238;
GO

--Create table JB.Client
CREATE TABLE JB.Client
(
cid                     INT                 ,
firstname               NVARCHAR(10)        ,
lastname                NVARCHAR(10)        ,
gender                  CHAR(1)             ,
dob                     DATETIME            ,
initials                NVARCHAR(2)         ,
address                 NVARCHAR(20)        ,
email                   NVARCHAR(15)        ,
phone                   NVARCHAR(13)        NOT NULL,
jid                     INT                 ,
CONSTRAINT PK_Client PRIMARY KEY(cid),
CONSTRAINT FK_Job3 FOREIGN KEY(jid) REFERENCES JB.Job(jid),
CONSTRAINT CHK_dob CHECK(dob <= CURRENT_TIMESTAMP)

);

CREATE UNIQUE INDEX idx_nc_email2 ON HR.Employees(email);
CREATE UNIQUE INDEX idx_nc_phone2 ON HR.Employees(phone);



IF ( OBJECT_ID('JB.Client_T') IS NOT NULL ) 
   DROP PROCEDURE JB.Client_T
GO

CREATE PROCEDURE JB.Client_T 
       @cid                    INT                , 
       @firstname              NVARCHAR(10)       , 
       @lastname               NVARCHAR(10)       , 
       @gender                 CHAR(1)            ,  
       @address                NVARCHAR(20)       ,  
       @email                  NVARCHAR(20)       ,
       @phone                  INT                ,
       @jid                    INT                
AS 

BEGIN 
     SET NOCOUNT ON 

     INSERT INTO JB.Client
          ( 
             cid                    , 
             firstname              , 
             lastname               , 
             gender                 , 
             address                ,  
             email                  ,
             phone                  ,  
             jid          
          ) 
     VALUES 
          ( 
           @cid                    , 
           @firstname              , 
           @lastname               , 
           @gender                 , 
           @address                ,  
           @email                  ,
           @phone                  ,  
           @jid               
          ) 
END 
GO

EXEC JB.Client_T 0011,'kwame','Cudjoe','M','Klagon','k12@yahoo.com',0235765434,1001;
GO
EXEC JB.Client_T 0012,'Kofi','Draku','M','KokomlemlE','kofi@gmail.com',0245768434,1002;
GO
EXEC JB.Client_T 0013,'Ama','Imani','F','Ashaiman','ama@face.com',0265765434,1003;
GO
EXEC JB.Client_T 0014,'Maame','Yaa','F','London','maa@yahoo.com',0265965435,1004;
GO
EXEC JB.Client_T 0015,'Alexa','Boye','F','Lashibi','ab@yahoo.com',0295765434,1005;
GO
EXEC JB.Client_T 0016,'kofi','Cudjoe','M','Nungua','kA@yahoo.com',0365765434,1006;
GO

--Create table INV.Inventory
CREATE TABLE INV.Inventory
(
itemId                 INT                   ,
nameOfItem             NVARCHAR(10)          ,
datePurchased          DATETIME              NOT NULL,
supplier               NVARCHAR(10)          ,
Saddress               NVARCHAR(20)          ,
unitPrice              INT                   NOT NULL,
quantity               INT                   ,
CONSTRAINT PK_Iventory PRIMARY KEY(itemId),
CONSTRAINT CHK_datePurchased CHECK(datePurchased <= CURRENT_TIMESTAMP)
);

CREATE NONCLUSTERED INDEX idx_nc_nameOfItem ON INV.Inventory(nameOfItem);



IF ( OBJECT_ID('INV.Inventory_T') IS NOT NULL ) 
   DROP PROCEDURE INV.Inventory_T
GO

CREATE PROCEDURE INV.Inventory_T
       @itemId                    INT                , 
       @nameOfItem                NVARCHAR(10)       , 
       @datePurchased             DATETIME           , 
       @supplier                  NVARCHAR           ,  
       @Saddress                  NVARCHAR(20)       ,  
       @unitPrice                 INT                ,
       @quantity                  INT                
  
AS 

BEGIN 
     SET NOCOUNT ON 

     INSERT INTO INV.Inventory
          ( 
             itemId                    , 
             nameOfItem                , 
             datePurchased             , 
             supplier                  , 
             Saddress                  ,  
             unitPrice                 ,
             quantity                    
                      
          ) 
     VALUES 
          ( 
           @itemId                    , 
           @nameOfItem                , 
           @datePurchased             , 
           @supplier                  , 
           @Saddress                  ,  
           @unitPrice                 ,
           @quantity                                  
          ) 
END 
GO


EXEC INV.Inventory_T 1,'Ink','2016-01-02','Araba','Circle',50.00,100;
GO
EXEC INV.Inventory_T 2,'plate','2016-01-04','Kweku','Accra',5000.00,100;
GO
EXEC INV.Inventory_T 3,'Paper','2016-01-03','Kofi','Ridge',100.00,5000;
GO
EXEC INV.Inventory_T 4,'shirt','2016-02-03','Rorbert','Taifa',10.0,100000;
GO
EXEC INV.Inventory_T 5,'Roller','2016-01-05','Moses','Dzorwulu',20.00,100;
GO


-- Creates the Machine table --
CREATE TABLE MN.Machine
(

nameOfMachine           NVARCHAR(10)        ,
mid                     INT                 ,
ServiceName             NVARCHAR(10)        ,
DateServiced            DATETIME            
);

IF ( OBJECT_ID('MN.Machine_T') IS NOT NULL ) 
   DROP PROCEDURE MN.Machine_T
GO

CREATE PROCEDURE MN.Machine_T
       @nameOfMachine         NVARCHAR(20)  , 
       @mid                   INT           , 
       @serviceName           NVARCHAR(20)      , 
       @DateServiced          DATETIME      

AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO MN.Machine
          ( 
             nameOfMachine                    , 
             mid                              , 
             serviceName                      , 
             DateServiced                              
          ) 
     VALUES 
          ( 
           @nameOfMachine                   , 
           @mid                             , 
           @serviceName                     , 
           @DateServiced                                                
          ) 
END 
GO

EXEC MN.Machine_T 'HP_Printer',5501,'Jonny','2015-02-01';
GO
EXEC MN.Machine_T 'Xerox_Printer',5502,'Carl','2016-02-01';
GO
EXEC MN.Machine_T 'Le_Printer',5503,'Christian','2015-01-01';
GO
EXEC MN.Machine_T 'Mac_Printer',5504,'Bravo','2002-01-03';
GO
EXEC MN.Machine_T 'Windows_Printer',5505,'Carly','2015-04-03';
GO
EXEC MN.Machine_T 'Bag_Printer',5506,'Damian','2014-02-01';
GO
EXEC MN.Machine_T 'Dusty_Printer',5507,'Hudson','2013-02-01';
GO
EXEC MN.Machine_T 'Moto_Printer',5508,'Bat','2011-02-01';
GO
EXEC MN.Machine_T 'Car_Printer',5509,'Welbeck','2006-02-01';
GO
EXEC MN.Machine_T 'Apple_Printer',5511,'Wilshire','2010-02-01';
GO


--Creates the Finance_Department
CREATE TABLE DP.Finance_Department
(
did                         INT                  ,
brid                        INT                  ,

CONSTRAINT FK_Finance_Department FOREIGN KEY(did) REFERENCES DP.Department(did),
CONSTRAINT FK_Finance_Department1 FOREIGN KEY(brid) REFERENCES CP.Company_Branch(brid)
);

IF ( OBJECT_ID('DP.FD_T') IS NOT NULL ) 
   DROP PROCEDURE DP.FD_T
GO

CREATE PROCEDURE DP.FD_T
       @did                   INT           , 
       @brid                  INT               

AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO DP.Finance_Department
          ( 
          	did                             ,
            brid                                                                            
          ) 
     VALUES 
          ( 
           @did                             , 
           @brid                                      

          ) 
END 
GO

EXEC DP.FD_T 01,111;
GO
EXEC DP.FD_T 01,112;
GO
EXEC DP.FD_T 01,112;
GO
EXEC DP.FD_T 01,111;
GO
EXEC DP.FD_T 01,112;
GO
EXEC DP.FD_T 01,111;
GO
EXEC DP.FD_T 01,112;
GO


-- creates the Graphic_Department table --
CREATE TABLE DP.Graphic_Department

(
did                        INT                   ,
brid                       INT                   ,

CONSTRAINT FK_Graphic_department FOREIGN KEY(did) REFERENCES DP.Department(did),
CONSTRAINT FK_Graphic_department1 FOREIGN KEY(brid) REFERENCES CP.Company_Branch(brid)

);


IF ( OBJECT_ID('DP.GD_T') IS NOT NULL ) 
   DROP PROCEDURE DP.GD_T
GO

CREATE PROCEDURE DP.GD_T
       @did                   INT           , 
       @brid                  INT           

AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO DP.Graphic_Department
          ( 
          	did                             ,
            brid                                                                           
          ) 
     VALUES 
          ( 
           @did                             , 
           @brid                           

          ) 
END 
GO

EXEC DP.GD_T 02,111;
GO
EXEC DP.GD_T 02,112;
GO
EXEC DP.GD_T 02,111;
GO
EXEC DP.GD_T 02,111;
GO
EXEC DP.GD_T 02,112;
GO
EXEC DP.GD_T 02,111;
GO
EXEC DP.GD_T 02,112;
GO
EXEC DP.GD_T 02,111;
GO
EXEC DP.GD_T 02,111;
GO
EXEC DP.GD_T 02,112;
GO


-- Creates the print_department table --
CREATE TABLE DP.Print_Department 
(
did                        INT                   ,
brid                       INT                   ,
empid                      INT                   ,

CONSTRAINT FK_Print_Department FOREIGN KEY(did) REFERENCES DP.Department(did),
CONSTRAINT FK_Print_Department1 FOREIGN KEY(brid) REFERENCES CP.Company_Branch(brid),

);


IF ( OBJECT_ID('DP.PD_T') IS NOT NULL ) 
   DROP PROCEDURE DP.PD_T
GO

CREATE PROCEDURE DP.PD_T
       @did                   INT           , 
       @brid                  INT           ,
       @empid                 INT

AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO DP.Print_Department
          ( 
          	did                             ,
            brid                            ,
            empid                                                   
          ) 
     VALUES 
          ( 
           @did                             , 
           @brid                            ,     
           @empid         

          ) 
END 
GO

EXEC DP.PD_T 03,111,111231;
GO
EXEC DP.PD_T 03,112,111232;
GO
EXEC DP.PD_T 03,111,11123331;
GO
EXEC DP.PD_T 03,111,111234;
GO
EXEC DP.PD_T 03,112,11123532;
GO
EXEC DP.PD_T 03,111,11123633;
GO
EXEC DP.PD_T 03,112,111237;
GO
EXEC DP.PD_T 03,111,111238;
GO
EXEC DP.PD_T 03,111,11123933;
GO
EXEC DP.PD_T 03,112,11123113;
GO



-- Creates the Human resource department table --
CREATE TABLE DP.Human_resource_Department
(  
did                        INT                    ,
brid                       INT                    ,
empid                      INT                    ,            

CONSTRAINT FK_Human_resourc_Department FOREIGN KEY(did) REFERENCES DP.Department(did),
CONSTRAINT FK_Human_resourc_Department1 FOREIGN KEY(brid) REFERENCES CP.Company_Branch(brid),
);


IF ( OBJECT_ID('DP.HRD_T') IS NOT NULL ) 
   DROP PROCEDURE DP.HRD_T
GO

CREATE PROCEDURE DP.HRD_T
       @did                   INT           , 
       @brid                  INT           ,
       @empid                 int 

AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO DP.Human_resource_Department
          ( 
          	did                             ,
            brid                            ,
            empid                                                   
          ) 
     VALUES 
          ( 
           @did                             , 
           @brid                            ,     
           @empid         
          ) 
END 
GO

EXEC DP.HRD_T 04,111,121231;
GO
EXEC DP.HRD_T 04,112,121232;
GO
EXEC DP.HRD_T 04,111,121233;
GO
EXEC DP.HRD_T 04,111,121234;
GO
EXEC DP.HRD_T 04,112,121235;
GO
EXEC DP.HRD_T 04,111,121236;
GO

-- Creates the maintenance system table --
CREATE TABLE MN.Maintenance_System 
(
companyname              NVARCHAR(10)           ,
address                  NVARCHAR(20)           ,
phone                    NVARCHAR(13)           

);

IF ( OBJECT_ID('MN.MS_T') IS NOT NULL ) 
   DROP PROCEDURE MN.MS_T
GO

CREATE PROCEDURE MN.MS_T
       @companyname                   NVARCHAR(15)           , 
       @address                       NVARCHAR(15)           ,
       @phone                         INT

AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO MN.Maintenance_System
          ( 
          	companyname                        ,
            address                            ,
            phone                                                   
          ) 
     VALUES 
          ( 
           @companyname                       , 
           @address                           ,     
           @phone         
          ) 
END
GO 

EXEC MN.MS_T 'ttbrothers','k-accra',0244525508;
GO
EXEC MN.MS_T 'rdbrothers','n-accra',0245525508;
GO
EXEC MN.MS_T 'mnbrothers','a-accra',0246525508;
GO
EXEC MN.MS_T 'kkbrothers','b-accra',0247525508;
GO
EXEC MN.MS_T 'sssisters','l-accra',0248525508;
GO
EXEC MN.MS_T 'ttsisers','b-accra',0249525508;
GO
EXEC MN.MS_T 'llsisters','a-accra',0241525508;
GO
EXEC MN.MS_T 'rrbrothers','g-accra',0244125508;
GO
EXEC MN.MS_T 'ddbrothers','l-accra',0244225508;
GO
EXEC MN.MS_T 'ccbrothers','k-accra',0244325508;
GO


-- Creates the Job_Client table --
CREATE TABLE JB.Job_client
(

jid                      INT                    ,
cid                      INT                    ,

CONSTRAINT FK_Job_client FOREIGN KEY(jid) REFERENCES JB.Job(jid),
CONSTRAINT FK_Job_client2 FOREIGN KEY(cid) REFERENCES JB.Client(cid)

);


IF ( OBJECT_ID('JB.JC_T') IS NOT NULL ) 
   DROP PROCEDURE JB.JC_T
GO

CREATE PROCEDURE JB.JC_T
       @jid                  INT           , 
       @cid                  INT     

AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO JB.Job_client
          ( 
          	jid                        ,
            cid                                                                    
          ) 
     VALUES 
          ( 
           @jid                      , 
           @cid                                
          ) 
END
GO 

EXEC JB.JC_T 1001,0011;
GO
EXEC JB.JC_T 1002,0012;
GO
EXEC JB.JC_T 1003,0013;
GO
EXEC JB.JC_T 1004,0014;
GO
EXEC JB.JC_T 1005,0015;
GO
EXEC JB.JC_T 1006,0016;
GO


-- Creates the Job_Machine table
CREATE TABLE JB.Job_machine
(

jid                   INT                     ,
dateUsed              DATETIME                NOT NULL,
CONSTRAINT FK_Job_Machine FOREIGN KEY(jid) REFERENCES JB.Job(jid),

);

IF ( OBJECT_ID('JB.JBM_T') IS NOT NULL ) 
   DROP PROCEDURE JB.JBM_T
GO

CREATE PROCEDURE JB.JBM_T
       @jid                  INT           , 
       @dateUsed             DATETIME     

AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO JB.Job_machine
          ( 
          	jid                            ,
            dateUsed                                                               
          ) 
     VALUES 
          ( 
           @jid                            , 
           @dateUsed                              
          ) 
END
GO 

EXEC JB.JBM_T 1001,'2016-01-01';
GO
EXEC JB.JBM_T 1002,'2015-01-01';
GO
EXEC JB.JBM_T 1003,'2014-01-01';
GO
EXEC JB.JBM_T 1004,'2013-01-01';
GO
EXEC JB.JBM_T 1005,'2012-01-01';
GO
EXEC JB.JBM_T 1006,'2011-01-01';
GO
EXEC JB.JBM_T 1007,'2010-01-01';
GO
EXEC JB.JBM_T 1008,'2009-01-01';
GO


-- Create the Job_Inventory table -- 
CREATE TABLE JB.Job_Inventory
(

itemId                INT                    ,
jid                   INT                    ,
empid                 INT                    ,
dateUsed              DATETIME               NOT NULL,
CONSTRAINT FK_Job_Inventory1 FOREIGN KEY(itemid) REFERENCES INV.Inventory(itemid),
CONSTRAINT FK_Job_Inventory2 FOREIGN KEY(jid) REFERENCES JB.Job(jid)

);


IF ( OBJECT_ID('JB.INV_T') IS NOT NULL ) 
   DROP PROCEDURE JB.INV_T
GO

CREATE PROCEDURE JB.INV_T
       @itemId                INT          , 
       @jid                   INT          ,
       @empid                 INT          ,
       @dateUsed              DATETIME
AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO JB.Job_Inventory
          ( 
          	itemId                         ,
            jid                            ,
            empid                          ,
            dateUsed                                                         
          ) 
     VALUES 
          ( 
           @itemId                           , 
           @jid                              ,
           @empid                            ,
           @dateUsed                              
          ) 
END
GO 

EXEC JB.INV_T 1,1001,111231,'2015-01-02';
GO
EXEC JB.INV_T 2,1002,111232,'2016-01-02';
GO
EXEC JB.INV_T 3,1003,111233,'2014-01-02';
GO
EXEC JB.INV_T 4,1004,111234,'2013-01-02';
GO
EXEC JB.INV_T 5,1005,111235,'2012-01-02';
GO

select * from HR.Employees
SELECT * FROM MN.Machine

