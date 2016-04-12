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
firstname               NVARCHAR(15)      NOT NULL,  
lastname                NVARCHAR(15)      ,
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

EXEC HR.EmployT 111,'Juluis','Kofigah','M','JK','Lapaz-Accra','1982-01-03',2000,'2006-01-03','Full','kofi@imani.com',01,0244111222,111;
GO
EXEC HR.EmployT 112,'Berikisu','Ibrahim','F','BI','Newtown-Accra','1981-01-03',1500,'2006-01-03','Full','kissu@imani.com',01,0244223229,111;
GO
EXEC HR.EmployT 113,'Ebo','White','M','JK','Alajo-Accra','1983-01-03',1500,'2006-01-03','Full','ebo@imani.com',01,0244333444,111;
GO
EXEC HR.EmployT 114,'Kweku','Agyemang','M','KA','Eastlegon-Accra','1987-01-03',500,'2006-01-03','Part','kweku@imani.com',01,0244211322,111;
GO
EXEC HR.EmployT 115,'Kwame','Cudjoe','M','JK','Westlegon-Accra','1989-01-03',1500,'2006-01-03','Full','kofi2@imani.com',01,0241213222,111;
GO
EXEC HR.EmployT 116,'Alice','Wonder','F','AW','Lashibi-Accra','1990-01-03',1500,'2006-01-03','Full','Alice@imani.com',01,0044111222,111;
GO
EXEC HR.EmployT 117,'Bat','Man','M','BA','Klagon-Accra','1983-01-03',1500,'2006-01-03','Full','Bat@imani.com',01,0244131222,111;
GO
EXEC HR.EmployT 118,'Super','Woman','F','SW','Tema-Accra','1984-01-03',1500,'2006-01-03','Part','Super@imani.com',02,0244111342,111;
GO
EXEC HR.EmployT 119,'Nana','Ama','F','JK','Osu-Accra','1986-01-03',1500,'2006-01-03','Full','nana@imani.com',02,0244011282,111;
GO
EXEC HR.EmployT 110,'Sama','Kofi','F','SA','Koforidua-Accra','1989-01-03',1100,'2006-01-03','Full','Jama@imani.com',02,023131722,111;
GO
EXEC HR.EmployT 120,'Kweku','Ansah','F','SA','Tamale-Accra','1989-01-03',1300,'2006-01-03','Full','Mama@imani.com',02,024131722,111;
GO
EXEC HR.EmployT 121,'kojo','Larbi','F','SA','Achimota-Accra','1989-01-03',100,'2006-01-03','Full','Xama@imani.com',02,02431317,111;
GO
EXEC HR.EmployT 122,'Adjoa','Kwakye','F','SA','Japan','1989-01-03',200,'2006-01-03','Full','Cama@imani.com',02,024313122,111;
GO
EXEC HR.EmployT 123,'David','Tandoh','M','SA','England','1989-01-03',300,'2006-01-03','Full','Vama@imani.com',02,02131722,111;
GO
EXEC HR.EmployT 124,'Chuma','Amazigo','CA','SA','VAenezuela','1989-01-03',400,'2006-01-03','Full','Aama@imani.com',02,0231722,111;
GO
EXEC HR.EmployT 125,'Kenneth','Mensah','M','KM','Dubai','1989-01-03',500,'2006-01-03','Full','Lama@imani.com',02,111999222,111;
GO
EXEC HR.EmployT 126,'Isaac','Amoafo','F','IA','Cambodia','1989-01-03' ,500,'2006-01-03','Full','Qama@imani.com',02,222111999,111;
GO
EXEC HR.EmployT 127,'James','Graham','M','JG','Mallata','1989-01-03',500,'2006-01-03','Full','Rama@imani.com',02,333111999,111;
GO
EXEC HR.EmployT 128,'Priscilla','Owusuah','F','SA','Takoradi','1989-01-03',600,'2006-01-03','Part','Oama@imani.com',02,444111999,111;
GO
EXEC HR.EmployT 129,'Kweku','Owusu','F','SA','Kumasi','1989-01-03',700,'2006-01-03','Part','Eama@imani.com',02,555111999,111;
GO
EXEC HR.EmployT 130,'Christian','odonkor','F','SA','Koforidua','1989-01-03',800,'2006-01-03','Part','Pama@imani.com',02,666111999,111;
GO
EXEC HR.EmployT 131,'Jennifer','Jackson','F','SA','Abeka','1989-01-03',900,'2006-01-03','Part','Kama@imani.com',02,777111999,111;
GO
EXEC HR.EmployT 132,'I','Miss','F','SA','Lapaz','1989-01-03',5000,'2006-01-03','Part','Wama@imani.com',03,888111999,111;
GO
EXEC HR.EmployT 133,'Tackie','Nii','F','SA','Lagos-town','1989-01-03',100,'2006-01-03','Part','LOma@imani.com',03,999111222,111;
GO
EXEC HR.EmployT 134,'Adjoa','Tackie','F','SA','Kojokrom','1989-01-03',200,'2006-01-03','Part','SOma@imani.com',03,999111333,111;
GO
EXEC HR.EmployT 135,'Prince','Kwame','F','SA','Newbady','1989-01-03',300,'2006-01-03','Part','ma@imani.com',03,999111444,111;
GO
EXEC HR.EmployT 136,'Majoub','Nadine','F','SA','Labadi','1989-01-03',400,'2006-01-03','Part','aa@imani.com',03,999111555,111;
GO
EXEC HR.EmployT 137,'Ian','Iane','F','SA','Tema','1989-01-03',500,'2006-01-03','Part','VP@imani.com',03,999222666,111;
GO
EXEC HR.EmployT 138,'Grace','Frimpong','F','SA','Achimota-Accra','1989-01-03',600,'2006-01-03','Part','MI@imani.com',03,111222333,111;
GO
EXEC HR.EmployT 139,'Whitney','Ofori','F','SA','Achimota-Accra','1989-01-03',700,'2006-01-03','Part','BI@imani.com',03,999000888,111;
GO
EXEC HR.EmployT 140,'Norbert','Tackie','F','SA','Achimota-Accra','1989-01-03',800,'2006-01-03','Part','sd@imani.com',03,333444555,112;
GO
EXEC HR.EmployT 141,'Manso','Hanck','F','SA','Achimota-Accra','1989-01-03',900,'2006-01-03','Part','bo@imani.com',03,666777888,112;
GO
EXEC HR.EmployT 142,'Michael','Essien','F','SA','Achimota-Accra','1989-01-03',1000,'2006-01-03','Part','bro@imani.com',03,222000888,112;
GO
EXEC HR.EmployT 143,'Jeff','Essien','F','SA','Achimota-Accra','1989-01-03',100,'2006-01-03','Full','sis@imani.com',03,777222111,112;
GO
EXEC HR.EmployT 144,'Victor','Kafui','F','SA','Achimota-Accra','1989-01-03',200,'2006-01-03','Full','uncle@imani.com',03,000333222,112;
GO
EXEC HR.EmployT 145,'Salma','Dubrie','F','SA','Achimota-Accra','1989-01-03',300,'2006-01-03','Full','lop@imani.com',03,888777333,112;
GO
EXEC HR.EmployT 146,'Kuukua','Bartels','F','SA','Achimota-Accra','1989-01-03',400,'2006-01-03','Full','lol@imani.com',03,999444111,112;
GO
EXEC HR.EmployT 147,'','Ansah','Fm','SA','Achimota-Accra','1989-01-03',500,'2006-01-03','Full','lmao@imani.com',03,002233,112;
GO
EXEC HR.EmployT 148,'Gideon','Baah','F','SA','Achimota-Accra','1989-01-03',600,'2006-01-03','Full','lolz@imani.com',03,119988,112;
GO
EXEC HR.EmployT 149,'Nana','Aba','F','SA','Achimota-Accra','1989-01-03',700,'2006-01-03','Full','vbo@imani.com',03,334499,112;
GO
EXEC HR.EmployT 150,'Joshua','Muntari','F','SA','Achimota-Accra','1989-01-03',800,'2006-01-03','Full','mmm@imani.com',03,889900,112;
GO
EXEC HR.EmployT 151,'Sheriff','Captan','F','SA','Achimota-Accra','1989-01-03',900,'2006-01-03','Full','tol@imani.com',03,112233,112;
GO
EXEC HR.EmployT 152,'Kindness','Aprontie','F','SA','Achimota-Accra','1989-01-03',1000,'2006-01-03','Full','chri@imani.com',04,223344,112;
GO
EXEC HR.EmployT 153,'Bismack','Ansah','F','SA','Achimota-Accra','1989-01-03',100,'2006-01-03','Full','mko@imani.com',04,567483,112;
GO
EXEC HR.EmployT 154,'Moko','Ansah','F','SA','Achimota-Accra','1989-01-03',200,'2006-01-03','Full','goog@imani.com',04,8646829,112;
GO
EXEC HR.EmployT 155,'Dennis','Danso','F','SA','Achimota-Accra','1989-01-03',300,'2006-01-03','Full','bing@imani.com',04,9847463,112;
GO
EXEC HR.EmployT 156,'Samir','Adam','F','SA','Achimota-Accra','1989-01-03',400,'2006-01-03','Full','mic@imani.com',04,9384749,112;
GO
EXEC HR.EmployT 157,'Nina','Ayew','F','SA','Achimota-Accra','1989-01-03',500,'2006-01-03','Full','jic@imani.com',04,84746829,112;
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

EXEC JB.JOB_T 'Poster',1001,'MTNjob',100,'2015-03-01','2015-04-01','Poster',111,111;
GO
EXEC JB.JOB_T 'Banner',1002,'Airteljob',500,'2015-03-01','2015-04-01','Banner',112,112;
GO
EXEC JB.JOB_T 'CallCard',1003,'Vodafone',100,'2015-03-01','2015-04-01','A6',111,113;
GO
EXEC JB.JOB_T 'Card',1004,'TigoJob',100,'2015-03-01','2015-04-01','A5 Card',111,114;
GO
EXEC JB.JOB_T 'Banner',1005,'Logo',1000,'2015-03-01','2015-04-01','Banner',111,115;
GO
EXEC JB.JOB_T 'Design',1006,'Career',123000,'2015-03-01','2015-04-01','Trifold',112,116;
GO
EXEC JB.JOB_T 'Cert',1007,'Football',5,'2015-03-01','2015-04-01','Certificate',112,117;
GO
EXEC JB.JOB_T 'Branding',1008,'MustCargo',20000,'2015-03-01','2015-04-01','ArtWork',112,118;
GO
EXEC JB.JOB_T 'Jersey',1009,'Jersey',10,'2015-03-01','2015-04-01','Poster',112,119;
GO
EXEC JB.JOB_T 'Photocopy',1101,'job',1,'2015-03-01','2015-04-01','Poster',111,110;
GO

--Create table JB.Client
CREATE TABLE JB.Client
(
cid                     INT                 ,
firstname               NVARCHAR(10)        ,
lastname                NVARCHAR(10)        ,
gender                  CHAR(1)             ,
address                 NVARCHAR(20)        ,
email                   NVARCHAR(15)        ,
phone                   NVARCHAR(13)        NOT NULL,
jid                     INT                 ,
CONSTRAINT PK_Client PRIMARY KEY(cid),
CONSTRAINT FK_Job3 FOREIGN KEY(jid) REFERENCES JB.Job(jid),


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

CREATE NONCLUSTERED INDEX idx_nc_nadNdmeOfItem ON INV.Inventory(nameOfItem);



IF ( OBJECT_ID('INV.Inventory_T') IS NOT NULL ) 
   DROP PROCEDURE INV.Inventory_T
GO

CREATE PROCEDURE INV.Inventory_T
       @itemId                    INT                , 
       @nameOfItem                NVARCHAR(10)       , 
       @datePurchased             DATETIME           , 
       @supplier                  NVARCHAR(20)       ,  
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

nameOfMachine           NVARCHAR(20)        ,
mid                     INT                 ,
ServiceName             NVARCHAR(20)        ,
DateServiced            DATETIME            ,
CONSTRAINT PK_Machine PRIMARY KEY(mid)     
);

IF ( OBJECT_ID('MN.Machine_T') IS NOT NULL ) 
   DROP PROCEDURE MN.Machine_T
GO

CREATE PROCEDURE MN.Machine_T
       @nameOfMachine         NVARCHAR(20)      , 
       @mid                   INT               , 
       @serviceName           NVARCHAR(20)          , 
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
empid                       INT                  ,


CONSTRAINT FK_Finance_Department FOREIGN KEY(did) REFERENCES DP.Department(did),
CONSTRAINT FK_Finance_Department1 FOREIGN KEY(brid) REFERENCES CP.Company_Branch(brid),
CONSTRAINT FK_Finance_Department2 FOREIGN KEY(empid) REFERENCES HR.Employees(empid)
);



IF ( OBJECT_ID('DP.FD_T') IS NOT NULL ) 
   DROP PROCEDURE DP.FD_T
GO

CREATE PROCEDURE DP.FD_T
       @did                   INT           , 
       @brid                  INT           ,
	   @empid                 INT               

AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO DP.Finance_Department
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

EXEC DP.FD_T 01,111,111;
GO
EXEC DP.FD_T 01,112,112;
GO
EXEC DP.FD_T 01,112,113;
GO
EXEC DP.FD_T 01,111,114;
GO
EXEC DP.FD_T 01,112,115;
GO
EXEC DP.FD_T 01,111,116;
GO
EXEC DP.FD_T 01,112,117;
GO


-- creates the Graphic_Department table --
CREATE TABLE DP.Graphic_Department

(
did                        INT                   ,
brid                       INT                   ,
empid                      INT                   ,

CONSTRAINT FK_Graphic_department FOREIGN KEY(did) REFERENCES DP.Department(did),
CONSTRAINT FK_Graphic_department1 FOREIGN KEY(brid) REFERENCES CP.Company_Branch(brid),
CONSTRAINT FK_Graphic_department2 FOREIGN KEY(empid) REFERENCES HR.Employees(empid)

);


IF ( OBJECT_ID('DP.GD_T') IS NOT NULL ) 
   DROP PROCEDURE DP.GD_T
GO

CREATE PROCEDURE DP.GD_T
       @did                   INT           , 
       @brid                  INT           ,
	   @empid                 INT

AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO DP.Graphic_Department
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

EXEC DP.GD_T 02,111,118;
GO
EXEC DP.GD_T 02,111,119;
GO
EXEC DP.GD_T 02,111,110;
GO
EXEC DP.GD_T 02,111,120;
GO
EXEC DP.GD_T 02,111,121;
GO
EXEC DP.GD_T 02,111,122;
GO
EXEC DP.GD_T 02,111,123;
GO
EXEC DP.GD_T 02,111,124;
GO
EXEC DP.GD_T 02,111,125;
GO
EXEC DP.GD_T 02,111,126;
GO
EXEC DP.GD_T 02,111,127;
GO
EXEC DP.GD_T 02,111,128;
GO
EXEC DP.GD_T 02,111,129;
GO
EXEC DP.GD_T 02,111,130;
GO
EXEC DP.GD_T 02,111,131;
GO



-- Creates the print_department table --
CREATE TABLE DP.Print_Department 
(
did                        INT                   ,
brid                       INT                   ,
empid                      INT                   ,

CONSTRAINT FK_Print_Department FOREIGN KEY(did) REFERENCES DP.Department(did),
CONSTRAINT FK_Print_Department1 FOREIGN KEY(brid) REFERENCES CP.Company_Branch(brid),
CONSTRAINT FK_Print_Department2 FOREIGN KEY(empid) REFERENCES HR.Employees(empid)
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

EXEC DP.PD_T 03,111,132;
GO
EXEC DP.PD_T 03,111,133;
GO
EXEC DP.PD_T 03,111,134;
GO
EXEC DP.PD_T 03,111,135;
GO
EXEC DP.PD_T 03,111,136;
GO
EXEC DP.PD_T 03,111,137;
GO
EXEC DP.PD_T 03,111,138;
GO
EXEC DP.PD_T 03,111,139;
GO
EXEC DP.PD_T 03,112,140;
GO
EXEC DP.PD_T 03,112,141;
GO
EXEC DP.PD_T 03,112,142;
GO
EXEC DP.PD_T 03,112,143;
GO
EXEC DP.PD_T 03,112,144;
GO
EXEC DP.PD_T 03,112,145;
GO
EXEC DP.PD_T 03,112,146;
GO
EXEC DP.PD_T 03,112,147;
GO
EXEC DP.PD_T 03,112,148;
GO
EXEC DP.PD_T 03,112,149;
GO
EXEC DP.PD_T 03,112,150;
GO
EXEC DP.PD_T 03,112,151;
GO


-- Creates the Human resource department table --
CREATE TABLE DP.Human_resource_Department
(  
did                        INT                    ,
brid                       INT                    ,
empid                      INT                    ,            

CONSTRAINT FK_Human_resourc_Department FOREIGN KEY(did) REFERENCES DP.Department(did),
CONSTRAINT FK_Human_resourc_Department1 FOREIGN KEY(brid) REFERENCES CP.Company_Branch(brid),
CONSTRAINT FK_Human_resourc_Department2 FOREIGN KEY(empid) REFERENCES HR.Employees(empid)
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

EXEC DP.HRD_T 04,112,151;
GO
EXEC DP.HRD_T 04,112,152;
GO
EXEC DP.HRD_T 04,112,153;
GO
EXEC DP.HRD_T 04,112,154;
GO
EXEC DP.HRD_T 04,112,155;
GO
EXEC DP.HRD_T 04,112,156;
GO

-- Creates the maintenance system table --
CREATE TABLE MN.Maintenance_System 
(
companyname              NVARCHAR(15)           ,
address                  NVARCHAR(20)           ,
phone                    INT          

);

IF ( OBJECT_ID('MN.MS_T') IS NOT NULL ) 
   DROP PROCEDURE MN.MS_T
GO

CREATE PROCEDURE MN.MS_T
       @companyname                   NVARCHAR(15)           , 
       @address                       NVARCHAR(20)           ,
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
mid                   INT                     ,
dateUsed              DATETIME                NOT NULL,

CONSTRAINT FK_Job_Machine FOREIGN KEY(jid) REFERENCES JB.Job(jid),
CONSTRAINT FK_Job_Machine2 FOREIGN KEY(mid) REFERENCES MN.Machine(mid)

);

IF ( OBJECT_ID('JB.JBM_T') IS NOT NULL ) 
   DROP PROCEDURE JB.JBM_T
GO

CREATE PROCEDURE JB.JBM_T
       @jid                  INT           , 
       @dateUsed             DATETIME      ,
	     @mid                  INT

AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO JB.Job_machine
          ( 
          	jid                            ,
            dateUsed                       ,
			mid                                                          
          ) 
     VALUES 
          ( 
           @jid                            , 
           @dateUsed                       ,
		   @mid                 
          ) 
END
GO 

EXEC JB.JBM_T 1001,'2016-01-01',5501;
GO
EXEC JB.JBM_T 1002,'2015-01-01',5502;
GO
EXEC JB.JBM_T 1003,'2014-01-01',5503;
GO
EXEC JB.JBM_T 1004,'2013-01-01',5504;
GO
EXEC JB.JBM_T 1005,'2012-01-01',5505;
GO
EXEC JB.JBM_T 1006,'2011-01-01',5506;
GO
EXEC JB.JBM_T 1007,'2010-01-01',5507;
GO
EXEC JB.JBM_T 1008,'2009-01-01',5508;
GO


-- Create the Job_Inventory table -- 
CREATE TABLE JB.Job_Employee
(

empid                                  INT,
jid                                    INT

CONSTRAINT FK_Job_employee FOREIGN KEY(jid) REFERENCES JB.Job(jid),
CONSTRAINT FK_Job_employee2 FOREIGN KEY(empid) REFERENCES HR.Employees(empid)
);


IF ( OBJECT_ID('JB.EM_T') IS NOT NULL ) 
   DROP PROCEDURE JB.EM_T
GO

CREATE PROCEDURE JB.EM_T
       @empid                          INT          , 
       @jid                            INT       

AS
BEGIN
     SET NOCOUNT ON 

     INSERT INTO JB.Job_Employee
          ( 
            empid                                  ,
            jid                                                                             
          ) 
     VALUES 
          ( 
           @empid                                   , 
           @jid                                                    
          ) 
END
GO 

EXEC JB.EM_T 111, 1001;
GO
EXEC JB.EM_T 112, 1002;
GO
EXEC JB.EM_T 113, 1003;
GO
EXEC JB.EM_T 114, 1004;
GO
EXEC JB.EM_T 115, 1005;
GO
EXEC JB.EM_T 116, 1006;
GO
EXEC JB.EM_T 117, 1007;
GO
EXEC JB.EM_T 118, 1008;
GO
EXEC JB.EM_T 119, 1009;
GO
EXEC JB.EM_T 119, 1101;
GO







