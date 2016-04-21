----------------------------------------------------------------------------
-- This is a script that creates a database for Imani Impressionz
-- Author of Script ®Sheriff AyeW
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

CREATE DATABASE SA67032016_LOG;
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
did                    INT               IDENTITY(1,1)       ,
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
       @departmentName                 VARCHAR(10)              , 
       @numberOfmembers                INT                                      
AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO DP.Department
          ( 
            departmentName              ,
            numberOfmembers                                                      
          ) 
     VALUES 
          ( 
            @departmentName             ,
            @numberOfmembers                                                 
          ) 
END 
GO

EXEC DP.depT 'Finance',7;
GO
EXEC DP.depT 'Graphics',15;
GO
EXEC DP.depT 'Printing',20;
GO
EXEC DP.depT 'Human',6;
GO


--Ceate table CP.Company_branch
CREATE TABLE CP.Company_Branch
(
brid                   INT              IDENTITY(1,1)              ,
nameOfBranch           NVARCHAR(10)                                ,
location               NVARCHAR(10)                                ,
NumberOfEmployees      INT                                         ,
CONSTRAINT PK_COMPANYBR PRIMARY KEY(brid),
);

CREATE NONCLUSTERED INDEX idx_nc_nameOfBranch ON CP.Company_Branch(nameOfBranch);



IF ( OBJECT_ID('CP.Company_Branch_T') IS NOT NULL ) 
   DROP PROCEDURE CP.Company_Branch_T
GO

CREATE PROCEDURE CP.Company_Branch_T 
       @nameOfBranch                  NVARCHAR(10)       , 
       @location                      NVARCHAR(20)       , 
       @NumberOfEmployees             INT
  
AS 

BEGIN 
     SET NOCOUNT ON 

     INSERT INTO CP.Company_Branch
          (  
             nameOfBranch              , 
             location                  , 
             numberOfEmployees        
          ) 
     VALUES 
          ( 
           @nameOfBranch               , 
           @location                   , 
           @numberOfEmployees                                          
          ) 
END 
GO


EXEC CP.Company_Branch_T 'Imani1','Kokomlemle',30;
GO
EXEC CP.Company_Branch_T 'Imani2','Newtown',18;
GO



--Create tabe HR.Employees
CREATE TABLE HR.Employees
(
empid                   INT                IDENTITY(1,1)      , 
firstname               NVARCHAR(15)       NOT NULL           ,  
lastname                NVARCHAR(15)                          ,
gender                  CHAR(1)            NOT NULL           ,  
initials                CHAR(2)                               ,  
address                 NVARCHAR(20)                          ,  
dob                     DATETIME                              ,
Salary                  MONEY                                 ,
dateEmployed            DATETIME                              ,
employment_Status       NVARCHAR(4)       NOT NULL CHECK (employment_status IN('Full' , 'Part')),
email                   NVARCHAR(20)                          ,
did                     INT                                   ,
phone                   NVARCHAR(10)                          , 
brid                    INT                                   ,
CONSTRAINT PK_Employees PRIMARY KEY(empid)                    ,
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

EXEC HR.EmployT 'Juluis','Kofigah','M','JK','Lapaz-Accra','1982-01-03',2000,'2006-01-03','Full','kofi@imani.com',1,0244111222,1;
GO
EXEC HR.EmployT 'Berikisu','Ibrahim','F','BI','Newtown-Accra','1981-01-03',1500,'2006-01-03','Full','kissu@imani.com',1,0244223229,1;
GO
EXEC HR.EmployT 'Ebo','White','M','JK','Alajo-Accra','1983-01-03',1500,'2006-01-03','Full','ebo@imani.com',1,0244333444,1;
GO
EXEC HR.EmployT 'Kweku','Agyemang','M','KA','Eastlegon-Accra','1987-01-03',500,'2006-01-03','Part','kweku@imani.com',1,0244211322,1;
GO
EXEC HR.EmployT 'Kwame','Cudjoe','M','JK','Westlegon-Accra','1989-01-03',1500,'2006-01-03','Full','kofi2@imani.com',1,0241213222,1;
GO
EXEC HR.EmployT 'Alice','Wonder','F','AW','Lashibi-Accra','1990-01-03',1500,'2006-01-03','Full','Alice@imani.com',1,0044111222,1;
GO
EXEC HR.EmployT 'Bat','Man','M','BA','Klagon-Accra','1983-01-03',1500,'2006-01-03','Full','Bat@imani.com',1,0244131222,1;
GO
EXEC HR.EmployT 'Super','Woman','F','SW','Tema-Accra','1984-01-03',1500,'2006-01-03','Part','Super@imani.com',1,0244111342,1;
GO
EXEC HR.EmployT 'Nana','Ama','F','JK','Osu-Accra','1986-01-03',1500,'2006-01-03','Full','nana@imani.com',2,0244011282,1;
GO
EXEC HR.EmployT 'Sama','Kofi','F','SA','Koforidua-Accra','1989-01-03',1100,'2006-01-03','Full','Jama@imani.com',2,023131722,1;
GO
EXEC HR.EmployT 'Kweku','Ansah','F','SA','Tamale-Accra','1989-01-03',1300,'2006-01-03','Full','Mama@imani.com',2,024131722,1;
GO
EXEC HR.EmployT 'kojo','Larbi','F','SA','Achimota-Accra','1989-01-03',100,'2006-01-03','Full','Xama@imani.com',2,02431317,1;
GO
EXEC HR.EmployT 'Adjoa','Kwakye','F','SA','Japan','1989-01-03',200,'2006-01-03','Full','Cama@imani.com',2,024313122,1;
GO
EXEC HR.EmployT 'David','Tandoh','M','SA','England','1989-01-03',300,'2006-01-03','Full','Vama@imani.com',2,02131722,1;
GO
EXEC HR.EmployT 'Chuma','Amazigo','CA','SA','VAenezuela','1989-01-03',400,'2006-01-03','Full','Aama@imani.com',2,0231722,1;
GO
EXEC HR.EmployT 'Kenneth','Mensah','M','KM','Dubai','1989-01-03',500,'2006-01-03','Full','Lama@imani.com',2,111999222,1;
GO
EXEC HR.EmployT 'Isaac','Amoafo','F','IA','Cambodia','1989-01-03' ,500,'2006-01-03','Full','Qama@imani.com',2,222111999,1;
GO
EXEC HR.EmployT 'James','Graham','M','JG','Mallata','1989-01-03',500,'2006-01-03','Full','Rama@imani.com',2,333111999,1;
GO
EXEC HR.EmployT 'Priscilla','Owusuah','F','SA','Takoradi','1989-01-03',600,'2006-01-03','Part','Oama@imani.com',2,444111999,1;
GO
EXEC HR.EmployT 'Kweku','Owusu','F','SA','Kumasi','1989-01-03',700,'2006-01-03','Part','Eama@imani.com',2,555111999,1;
GO
EXEC HR.EmployT 'Christian','odonkor','F','SA','Koforidua','1989-01-03',800,'2006-01-03','Part','Pama@imani.com',2,666111999,1;
GO
EXEC HR.EmployT 'Jennifer','Jackson','F','SA','Abeka','1989-01-03',900,'2006-01-03','Part','Kama@imani.com',2,777111999,1;
GO
EXEC HR.EmployT 'I','Miss','F','SA','Lapaz','1989-01-03',5000,'2006-01-03','Part','Wama@imani.com',3,888111999,1;
GO
EXEC HR.EmployT 'Tackie','Nii','F','SA','Lagos-town','1989-01-03',100,'2006-01-03','Part','LOma@imani.com',3,999111222,1;
GO
EXEC HR.EmployT 'Adjoa','Tackie','F','SA','Kojokrom','1989-01-03',200,'2006-01-03','Part','SOma@imani.com',3,999111333,1;
GO
EXEC HR.EmployT 'Prince','Kwame','F','SA','Newbady','1989-01-03',300,'2006-01-03','Part','ma@imani.com',3,999111444,1;
GO
EXEC HR.EmployT 'Majoub','Nadine','F','SA','Labadi','1989-01-03',400,'2006-01-03','Part','aa@imani.com',3,999111555,1;
GO
EXEC HR.EmployT 'Ian','Iane','F','SA','Tema','1989-01-03',500,'2006-01-03','Part','VP@imani.com',3,999222666,1;
GO
EXEC HR.EmployT 'Grace','Frimpong','F','SA','Achimota-Accra','1989-01-03',600,'2006-01-03','Part','MI@imani.com',3,111222333,1;
GO
EXEC HR.EmployT 'Whitney','Ofori','F','SA','Achimota-Accra','1989-01-03',700,'2006-01-03','Part','BI@imani.com',3,999000888,1;
GO
EXEC HR.EmployT 'Norbert','Tackie','F','SA','Achimota-Accra','1989-01-03',800,'2006-01-03','Part','sd@imani.com',3,333444555,2;
GO
EXEC HR.EmployT 'Manso','Hanck','F','SA','Achimota-Accra','1989-01-03',900,'2006-01-03','Part','bo@imani.com',3,666777888,2;
GO
EXEC HR.EmployT 'Michael','Essien','F','SA','Achimota-Accra','1989-01-03',1000,'2006-01-03','Part','bro@imani.com',3,222000888,2;
GO
EXEC HR.EmployT 'Jeff','Essien','F','SA','Achimota-Accra','1989-01-03',100,'2006-01-03','Full','sis@imani.com',3,777222111,2;
GO
EXEC HR.EmployT 'Victor','Kafui','F','SA','Achimota-Accra','1989-01-03',200,'2006-01-03','Full','uncle@imani.com',3,000333222,2;
GO
EXEC HR.EmployT 'Salma','Dubrie','F','SA','Achimota-Accra','1989-01-03',300,'2006-01-03','Full','lop@imani.com',3,888777333,2;
GO
EXEC HR.EmployT 'Kuukua','Bartels','F','SA','Achimota-Accra','1989-01-03',400,'2006-01-03','Full','lol@imani.com',3,999444111,2;
GO
EXEC HR.EmployT 'Mmma','Ansah','Fm','SA','Achimota-Accra','1989-01-03',500,'2006-01-03','Full','lmao@imani.com',3,002233,2;
GO
EXEC HR.EmployT 'Gideon','Baah','F','SA','Achimota-Accra','1989-01-03',600,'2006-01-03','Full','lolz@imani.com',3,119988,2;
GO
EXEC HR.EmployT 'Nana','Aba','F','SA','Achimota-Accra','1989-01-03',700,'2006-01-03','Full','vbo@imani.com',3,334499,2;
GO
EXEC HR.EmployT 'Joshua','Muntari','F','SA','Achimota-Accra','1989-01-03',800,'2006-01-03','Full','mmm@imani.com',3,889900,2;
GO
EXEC HR.EmployT 'Sheriff','Captan','F','SA','Achimota-Accra','1989-01-03',900,'2006-01-03','Full','tol@imani.com',3,112233,2;
GO
EXEC HR.EmployT 'Kindness','Aprontie','F','SA','Achimota-Accra','1989-01-03',1000,'2006-01-03','Full','chri@imani.com',4,223344,2;
GO
EXEC HR.EmployT 'Bismack','Ansah','F','SA','Achimota-Accra','1989-01-03',100,'2006-01-03','Full','mko@imani.com',4,567483,2;
GO
EXEC HR.EmployT 'Moko','Ansah','F','SA','Achimota-Accra','1989-01-03',200,'2006-01-03','Full','goog@imani.com',4,8646829,2;
GO
EXEC HR.EmployT 'Dennis','Danso','F','SA','Achimota-Accra','1989-01-03',300,'2006-01-03','Full','bing@imani.com',4,9847463,2;
GO
EXEC HR.EmployT 'Samir','Adam','F','SA','Achimota-Accra','1989-01-03',400,'2006-01-03','Full','mic@imani.com',4,9384749,2;
GO
EXEC HR.EmployT 'Nina','Ayew','F','SA','Achimota-Accra','1989-01-03',500,'2006-01-03','Full','jic@imani.com',4,84746829,2;
GO
EXEC HR.EmployT 'Vanessa','Ayew','F','SA','Achimota-Accra','1989-01-03',500,'2006-01-03','Full','va@imani.com',4,20746829,2;
GO
EXEC HR.EmployT 'Van','Ay','F','SA','Achimota-Accra','1989-01-03',500,'2006-01-03','Full','lo@imani.com',4,90746829,2;
GO

select * from HR.Employees



-- Creates the Job table --
CREATE TABLE JB.JOB
(

nameOfjob                 NVARCHAR(10)          , 
jid                       INT                   IDENTITY(1,1) ,
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
CONSTRAINT CHK_dateOrdered CHECK(dateOrdered <= CURRENT_TIMESTAMP) 
);


CREATE NONCLUSTERED INDEX idx_nc_price ON JB.JOB(price);

IF ( OBJECT_ID('JB.Job_T') IS NOT NULL ) 
   DROP PROCEDURE JB.JOB_T
GO

CREATE PROCEDURE JB.JOB_T  
       @nameOfjob                    NVARCHAR(20)             , 
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

EXEC JB.JOB_T 'Poster','MTNjob',100,'2015-03-01','2015-04-01','Poster',1,1;
GO
EXEC JB.JOB_T 'Banner','Airteljob',500,'2015-03-01','2015-04-01','Banner',2,2;
GO
EXEC JB.JOB_T 'CallCard','Vodafone',100,'2015-03-01','2015-04-01','A6',1,3;
GO
EXEC JB.JOB_T 'Card','TigoJob',100,'2015-03-01','2015-04-01','A5 Card',1,4;
GO
EXEC JB.JOB_T 'Banner','Logo',1000,'2015-03-01','2015-04-01','Banner',1,5;
GO
EXEC JB.JOB_T 'Design','Career',123000,'2015-03-01','2015-04-01','Trifold',2,6;
GO
EXEC JB.JOB_T 'Cert','Football',5,'2015-03-01','2015-04-01','Certificate',2,7;
GO
EXEC JB.JOB_T 'Branding','MustCargo',20000,'2015-03-01','2015-04-01','ArtWork',2,8;
GO
EXEC JB.JOB_T 'Jersey','Jersey',10,'2015-03-01','2015-04-01','Poster',2,9;
GO
EXEC JB.JOB_T 'Photocopy','job',1,'2015-03-01','2015-04-01','Poster',1,10;
GO

--Create table JB.Client
CREATE TABLE JB.Client
(
cid                     INT                 IDENTITY(1,1)       ,
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

EXEC JB.Client_T 'kwame','Cudjoe','M','Klagon','k12@yahoo.com',0235765434,1;
GO
EXEC JB.Client_T 'Kofi','Draku','M','KokomlemlE','kofi@gmail.com',0245768434,2;
GO
EXEC JB.Client_T 'Ama','Imani','F','Ashaiman','ama@face.com',0265765434,3;
GO
EXEC JB.Client_T 'Maame','Yaa','F','London','maa@yahoo.com',0265965435,4;
GO
EXEC JB.Client_T 'Alexa','Boye','F','Lashibi','ab@yahoo.com',0295765434,5;
GO
EXEC JB.Client_T 'kofi','Cudjoe','M','Nungua','kA@yahoo.com',0365765434,6;
GO

--Create table INV.Inventory
CREATE TABLE INV.Inventory
(
itemId                 INT                   IDENTITY(1,1)     ,
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
             nameOfItem                , 
             datePurchased             , 
             supplier                  , 
             Saddress                  ,  
             unitPrice                 ,
             quantity                    
                      
          ) 
     VALUES 
          ( 
           @nameOfItem                , 
           @datePurchased             , 
           @supplier                  , 
           @Saddress                  ,  
           @unitPrice                 ,
           @quantity                                  
          ) 
END 
GO


EXEC INV.Inventory_T 'Ink','2016-01-02','Araba','Circle',50.00,100;
GO
EXEC INV.Inventory_T 'plate','2016-01-04','Kweku','Accra',5000.00,100;
GO
EXEC INV.Inventory_T 'Paper','2016-01-03','Kofi','Ridge',100.00,5000;
GO
EXEC INV.Inventory_T 'shirt','2016-02-03','Rorbert','Taifa',10.0,100000;
GO
EXEC INV.Inventory_T 'Roller','2016-01-05','Moses','Dzorwulu',20.00,100;
GO


-- Creates the Machine table --
CREATE TABLE MN.Machine
(

nameOfMachine           NVARCHAR(20)        ,
mid                     INT                 IDENTITY(1,1)           ,
ServiceName             NVARCHAR(20)        ,
DateServiced            DATETIME            ,
CONSTRAINT PK_Machine PRIMARY KEY(mid)     
);

IF ( OBJECT_ID('MN.Machine_T') IS NOT NULL ) 
   DROP PROCEDURE MN.Machine_T
GO

CREATE PROCEDURE MN.Machine_T
       @nameOfMachine         NVARCHAR(20)          , 
       @serviceName           NVARCHAR(20)          , 
       @DateServiced          DATETIME      

AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO MN.Machine
          ( 
             nameOfMachine                    , 
             serviceName                      , 
             DateServiced                              
          ) 
     VALUES 
          ( 
           @nameOfMachine                   , 
           @serviceName                     , 
           @DateServiced                                                
          ) 
END 
GO

EXEC MN.Machine_T 'HP_Printer','Jonny','2015-02-01';
GO
EXEC MN.Machine_T 'Xerox_Printer','Carl','2016-02-01';
GO
EXEC MN.Machine_T 'Le_Printer','Christian','2015-01-01';
GO
EXEC MN.Machine_T 'Mac_Printer','Bravo','2002-01-03';
GO
EXEC MN.Machine_T 'Windows_Printer','Carly','2015-04-03';
GO
EXEC MN.Machine_T 'Bag_Printer','Damian','2014-02-01';
GO
EXEC MN.Machine_T 'Dusty_Printer','Hudson','2013-02-01';
GO
EXEC MN.Machine_T 'Moto_Printer','Bat','2011-02-01';
GO
EXEC MN.Machine_T 'Car_Printer','Welbeck','2006-02-01';
GO
EXEC MN.Machine_T 'Apple_Printer','Wilshire','2010-02-01';
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

EXEC DP.FD_T 1,1,1;
GO
EXEC DP.FD_T 1,2,2;
GO
EXEC DP.FD_T 1,2,3;
GO
EXEC DP.FD_T 1,1,4;
GO
EXEC DP.FD_T 1,2,5;
GO
EXEC DP.FD_T 1,1,6;
GO
EXEC DP.FD_T 1,2,7;
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

EXEC DP.GD_T 2,1,8;
GO
EXEC DP.GD_T 2,1,9;
GO
EXEC DP.GD_T 2,1,10;
GO
EXEC DP.GD_T 2,1,11;
GO
EXEC DP.GD_T 2,1,12;
GO
EXEC DP.GD_T 2,1,13;
GO
EXEC DP.GD_T 2,1,14;
GO
EXEC DP.GD_T 2,1,15;
GO
EXEC DP.GD_T 2,1,16;
GO
EXEC DP.GD_T 2,1,17;
GO
EXEC DP.GD_T 2,1,18;
GO
EXEC DP.GD_T 2,1,19;
GO
EXEC DP.GD_T 2,1,20;
GO
EXEC DP.GD_T 2,1,21;
GO
EXEC DP.GD_T 2,1,22;
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

EXEC DP.PD_T 3,1,23;
GO
EXEC DP.PD_T 3,1,24;
GO
EXEC DP.PD_T 3,1,25;
GO
EXEC DP.PD_T 3,1,26;
GO
EXEC DP.PD_T 3,1,27;
GO
EXEC DP.PD_T 3,1,28;
GO
EXEC DP.PD_T 3,1,29;
GO
EXEC DP.PD_T 3,1,30;
GO
EXEC DP.PD_T 3,2,31;
GO
EXEC DP.PD_T 3,2,32;
GO
EXEC DP.PD_T 3,2,33;
GO
EXEC DP.PD_T 3,2,34;
GO
EXEC DP.PD_T 3,2,35;
GO
EXEC DP.PD_T 3,2,36;
GO
EXEC DP.PD_T 3,2,37;
GO
EXEC DP.PD_T 3,2,38;
GO
EXEC DP.PD_T 3,2,39;
GO
EXEC DP.PD_T 3,2,40;
GO
EXEC DP.PD_T 3,2,41;
GO
EXEC DP.PD_T 3,2,42;
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

EXEC DP.HRD_T 4,2,43;
GO
EXEC DP.HRD_T 4,2,44;
GO
EXEC DP.HRD_T 4,2,45;
GO
EXEC DP.HRD_T 4,2,46;
GO
EXEC DP.HRD_T 4,2,47;
GO
EXEC DP.HRD_T 4,2,48;
GO


-- Creates the maintenance system table --
CREATE TABLE MN.Maintenance_System 
(
mid                      INT                    ,
companyname              NVARCHAR(15)           ,
address                  NVARCHAR(20)           ,
phone                    INT                    ,

CONSTRAINT FK_Machine FOREIGN KEY(mid) REFERENCES MN.Machine(mid)

);

IF ( OBJECT_ID('MN.MS_T') IS NOT NULL ) 
   DROP PROCEDURE MN.MS_T
GO

CREATE PROCEDURE MN.MS_T
       @mid                           INT                    ,
       @companyname                   NVARCHAR(15)           , 
       @address                       NVARCHAR(20)           ,
       @phone                         INT

AS 
BEGIN 
     SET NOCOUNT ON 

     INSERT INTO MN.Maintenance_System
          ( 
		    mid                                ,
          	companyname                        ,
            address                            ,
            phone                                                   
          ) 
     VALUES 
          ( 

		   @mid                               ,
           @companyname                       , 
           @address                           ,     
           @phone         

          ) 
END
GO 


EXEC MN.MS_T 1,'ttbrothers','k-accra',0244525508;
GO
EXEC MN.MS_T 2,'rdbrothers','n-accra',0245525508;
GO
EXEC MN.MS_T 3,'mnbrothers','a-accra',0246525508;
GO
EXEC MN.MS_T 4,'kkbrothers','b-accra',0247525508;
GO
EXEC MN.MS_T 5,'sssisters','l-accra',0248525508;
GO
EXEC MN.MS_T 6,'ttsisers','b-accra',0249525508;
GO
EXEC MN.MS_T 7,'llsisters','a-accra',0241525508;
GO
EXEC MN.MS_T 8,'rrbrothers','g-accra',0244125508;
GO
EXEC MN.MS_T 9,'ddbrothers','l-accra',0244225508;
GO
EXEC MN.MS_T 10,'ccbrothers','k-accra',0244325508;
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

EXEC JB.JC_T 1,1;
GO
EXEC JB.JC_T 2,2;
GO
EXEC JB.JC_T 3,3;
GO
EXEC JB.JC_T 4,4;
GO
EXEC JB.JC_T 5,5;
GO
EXEC JB.JC_T 6,6;
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

EXEC JB.JBM_T 1,'2016-01-01',1;
GO
EXEC JB.JBM_T 2,'2015-01-01',2;
GO
EXEC JB.JBM_T 3,'2014-01-01',3;
GO
EXEC JB.JBM_T 4,'2013-01-01',4;
GO
EXEC JB.JBM_T 5,'2012-01-01',5;
GO
EXEC JB.JBM_T 6,'2011-01-01',6;
GO
EXEC JB.JBM_T 7,'2010-01-01',7;
GO
EXEC JB.JBM_T 8,'2009-01-01',8;
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

EXEC JB.EM_T 1, 1;
GO
EXEC JB.EM_T 2, 2;
GO
EXEC JB.EM_T 3, 3;
GO
EXEC JB.EM_T 4, 4;
GO
EXEC JB.EM_T 5, 5;
GO
EXEC JB.EM_T 6, 6;
GO
EXEC JB.EM_T 7, 7;
GO
EXEC JB.EM_T 8, 8;
GO
EXEC JB.EM_T 9, 9;
GO
EXEC JB.EM_T 10, 10;

GO

-----------------------------------------------------------
                     --LOG TABLES FOR TRIGGERS--
------------------------------------------------------------ 
CREATE TABLE SA67032016_LOG.dbo.Department_log
(
did                    INT               ,
departmentName         NVARCHAR(10)      ,
numberOfMembers        INT               
);

CREATE TABLE SA67032016_LOG.dbo.Company_Branch_log
(
brid                   INT                  ,
nameOfBranch           NVARCHAR(10)         ,
location               NVARCHAR(10)         ,
NumberOfEmployees      INT                   
);
CREATE TABLE SA67032016_LOG.dbo.Employees_log
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
brid                    INT               ,
What_Happened           NVARCHAR(50)      ,
who_did_it              NVARCHAR(20)      , 
Date_Executed           DATETIME                 
);
CREATE TABLE SA67032016_LOG.dbo.JOB_log
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
What_Happened             NVARCHAR(50)          ,
who_did_it                NVARCHAR(20)          , 
Date_Executed             DATETIME                                 
);
CREATE TABLE SA67032016_LOG.dbo.Client_log
(
cid                     INT                 ,
firstname               NVARCHAR(10)        ,
lastname                NVARCHAR(10)        ,
gender                  CHAR(1)             ,
address                 NVARCHAR(20)        ,
email                   NVARCHAR(15)        ,
phone                   NVARCHAR(13)        ,
jid                     INT                 ,      
What_Happened           NVARCHAR(50)        ,
who_did_it              NVARCHAR(20)        , 
Date_Executed           DATETIME                  
);
CREATE TABLE SA67032016_LOG.dbo.Inventory_log
(
itemId                 INT                   ,
nameOfItem             NVARCHAR(10)          ,
datePurchased          DATETIME              ,
supplier               NVARCHAR(10)          ,
Saddress               NVARCHAR(20)          ,
unitPrice              INT                   ,
quantity               INT                   ,
What_Happened          NVARCHAR(50)          ,
who_did_it             NVARCHAR(20)          , 
Date_Executed          DATETIME                  
);
CREATE TABLE SA67032016_LOG.dbo.Machine_log
(
nameOfMachine           NVARCHAR(20)        ,
mid                     INT                 ,
ServiceName             NVARCHAR(20)        ,
DateServiced            DATETIME            ,    
);
CREATE TABLE SA67032016_LOG.dbo.Finance_Department_log
(
did                         INT              ,
brid                        INT              ,
empid                       INT                  
);
CREATE TABLE SA67032016_LOG.dbo.Graphic_Department_log
(
did                        INT                ,
brid                       INT                ,
empid                      INT                   
);
CREATE TABLE SA67032016_LOG.dbo.Print_Department_log 
(
did                        INT                   ,
brid                       INT                   ,
empid                      INT                   
);
CREATE TABLE SA67032016_LOG.dbo.Human_resource_Department_log
(  
did                        INT                    ,
brid                       INT                    ,
empid                      INT                    
);
CREATE TABLE SA67032016_LOG.dbo.Maintenance_System_log 
(
companyname              NVARCHAR(15)           ,
address                  NVARCHAR(20)           ,
phone                    INT          
);

CREATE TABLE SA67032016_LOG.dbo.Job_client_log
(
jid                      INT                    ,
cid                      INT                    
);

CREATE TABLE SA67032016_LOG.dbo.Job_machine_log
(
jid                     INT                     ,
mid                     INT                     ,
dateUsed                DATETIME               
);
 
CREATE TABLE SA67032016_LOG.dbo.Job_Employee_log
(

empid                     INT                   ,
jid                       INT
);
GO

---------------------------------------------------------------------------------
                             --Triggers-
--This section of the Code creates on four entities in the database sa67032016--
----------------------------------------------------------------------------------

CREATE TRIGGER Employee_trigger_log
ON HR.Employees
AFTER UPDATE, INSERT, DELETE
AS 

DECLARE @empid                   INT               ; 
DECLARE @firstname               NVARCHAR(15)      ;  
DECLARE @lastname                NVARCHAR(15)      ;
DECLARE @gender                  CHAR(1)           ; 
DECLARE @initials                CHAR(2)           ;  
DECLARE @address                 NVARCHAR(20)      ;  
DECLARE @dob                     DATETIME          ;
DECLARE @Salary                  MONEY             ;
DECLARE @dateEmployed            DATETIME          ;
DECLARE @employment_Status       NVARCHAR(4)       ;
DECLARE @email                   NVARCHAR(20)      ;
DECLARE @did                     INT               ;
DECLARE @phone                   NVARCHAR(10)      ; 
DECLARE @brid                    INT               ;
DECLARE @What_Happened           NVARCHAR(50)      ;
DECLARE @who_did_it              NVARCHAR(20)      ;
DECLARE @Date_Executed           DATETIME          ;

BEGIN
    SET @What_Happened = 'UPDATE';
    SET @who_did_it = SYSTEM_USER;
	SET @Date_Executed = GETDATE()

    INSERT into SA67032016_LOG.dbo.Employees_log(empid,firstname,lastname,gender,
	initials,address,dob,Salary,dateEmployed,employment_Status,email,
	did,phone,brid,What_Happened,who_did_it,Date_Executed) 

    SELECT empid,firstname,lastname,gender,
	initials,address,dob,Salary,dateEmployed,employment_Status,email,
	did,phone,brid,@What_Happened, @who_did_it, @Date_Executed

	FROM DELETED
END
BEGIN
    SET @What_Happened = 'INSERT';
    SET @who_did_it = SYSTEM_USER;
	SET @Date_Executed = GETDATE()

    INSERT into SA67032016_LOG.dbo.Employees_log(empid,firstname,lastname,gender,
	initials,address,dob,Salary,dateEmployed,employment_Status,email,
	did,phone,brid,What_Happened,who_did_it,Date_Executed) 

	  SELECT empid,firstname,lastname,gender,
	initials,address,dob,Salary,dateEmployed,employment_Status,email,
	did,phone,brid,@What_Happened, @who_did_it, @Date_Executed

	FROM INSERTED
END
BEGIN
    SET @What_Happened = 'DELETE';
    SET @who_did_it = SYSTEM_USER;
	SET @Date_Executed = GETDATE()

    INSERT into SA67032016_LOG.dbo.Employees_log(empid,firstname,lastname,gender,
	initials,address,dob,Salary,dateEmployed,employment_Status,email,
	did,phone,brid,What_Happened,who_did_it,Date_Executed) 

	SELECT empid,firstname,lastname,gender,
	initials,address,dob,Salary,dateEmployed,employment_Status,email,
	did,phone,brid,@What_Happened, @who_did_it, @Date_Executed

	FROM DELETED
END
GO


CREATE TRIGGER Job_trigger_log
ON JB.JOB
AFTER UPDATE, INSERT, DELETE
AS 
DECLARE @nameOfjob                 NVARCHAR(10)          ; 
DECLARE @jid                       INT                   ;
DECLARE @jobdescription            NVARCHAR(20)          ; 
DECLARE @price                     INT                   ;
DECLARE @dateOrdered               DATETIME              ;
DECLARE @dateSubmitted             DATETIME              ;
DECLARE @jobType                   NVARCHAR(20)          ;
DECLARE @brid                      INT                   ;
DECLARE @empid                     INT                   ;
DECLARE @What_Happened             NVARCHAR(50)          ;
DECLARE @who_did_it                NVARCHAR(20)          ; 
DECLARE @Date_Executed             DATETIME              ;

BEGIN
    SET @What_Happened = 'UPDATE';
    SET @who_did_it = SYSTEM_USER;
	SET @Date_Executed = GETDATE()

    INSERT into SA67032016_LOG.dbo.JOB_log(nameOfjob,jid,jobdescription,
	price,dateOrdered,dateSubmitted,jobType,
	brid,empid,What_Happened,who_did_it,Date_Executed) 

    SELECT nameOfjob,jid,jobdescription,price,dateOrdered,dateSubmitted,jobType,
	brid,empid,@What_Happened,@who_did_it,@Date_Executed

	FROM DELETED
END
BEGIN
    SET @What_Happened = 'INSERT';
    SET @who_did_it = SYSTEM_USER;
	SET @Date_Executed = GETDATE()

  INSERT into SA67032016_LOG.dbo.JOB_log(nameOfjob,jid,jobdescription,
	price,dateOrdered,dateSubmitted,jobType,
	brid,empid,What_Happened,who_did_it,Date_Executed) 

    SELECT nameOfjob,jid,jobdescription,price,dateOrdered,dateSubmitted,jobType,
	brid,empid,@What_Happened,@who_did_it,@Date_Executed

	FROM INSERTED
END
BEGIN 
    SET @What_Happened = 'DELETE';
    SET @who_did_it = SYSTEM_USER;
	SET @Date_Executed = GETDATE()

    INSERT into SA67032016_LOG.dbo.JOB_log(nameOfjob,jid,jobdescription,
	price,dateOrdered,dateSubmitted,jobType,
	brid,empid,What_Happened,who_did_it,Date_Executed) 

    SELECT nameOfjob,jid,jobdescription,price,dateOrdered,dateSubmitted,jobType,
	brid,empid,@What_Happened,@who_did_it,@Date_Executed

	FROM DELETED
END
GO

CREATE TRIGGER Client_trigger_log
ON JB.Client
AFTER UPDATE, INSERT, DELETE
AS 

DECLARE @cid                     INT                ;
DECLARE @firstname               NVARCHAR(10)       ;
DECLARE @lastname                NVARCHAR(10)       ;
DECLARE @gender                  CHAR(1)            ;
DECLARE @address                 NVARCHAR(20)       ;
DECLARE @email                   NVARCHAR(15)       ;
DECLARE @phone                   NVARCHAR(13)       ;
DECLARE @jid                     INT                ;     
DECLARE @What_Happened           NVARCHAR(50)       ;
DECLARE @who_did_it              NVARCHAR(20)       ; 
DECLARE @Date_Executed           DATETIME           ;

BEGIN
    SET @What_Happened = 'UPDATE';
    SET @who_did_it = SYSTEM_USER;
	SET @Date_Executed = GETDATE()

    INSERT into SA67032016_LOG.dbo.Client_log(cid,firstname,lastname,gender,address,email  
	 ,phone,jid,What_Happened,who_did_it,Date_Executed) 

    SELECT cid,firstname,lastname,gender,address,email,
	phone,jid,@What_Happened,@who_did_it,@Date_Executed

	FROM DELETED
END

BEGIN
    SET @What_Happened = 'INSERT';
    SET @who_did_it = SYSTEM_USER;
	SET @Date_Executed = GETDATE()

  INSERT into SA67032016_LOG.dbo.Client_log(cid,firstname,lastname,gender,address,email  
	 ,phone,jid,What_Happened,who_did_it,Date_Executed) 

    SELECT cid,firstname,lastname,gender,address,email,
	phone,jid,@What_Happened,@who_did_it,@Date_Executed

	FROM INSERTED
END

BEGIN 
    SET @What_Happened = 'DELETE';
    SET @who_did_it = SYSTEM_USER;
	SET @Date_Executed = GETDATE()

     INSERT into SA67032016_LOG.dbo.Client_log(cid,firstname,lastname,gender,address,email  
	 ,phone,jid,What_Happened,who_did_it,Date_Executed) 

    SELECT cid,firstname,lastname,gender,address,email,
	phone,jid,@What_Happened,@who_did_it,@Date_Executed

	FROM DELETED
END
GO


CREATE TRIGGER Inventory_trigger_log
ON INV.Inventory
AFTER UPDATE, INSERT, DELETE
AS 

DECLARE @itemId                 INT                   ;
DECLARE @nameOfItem             NVARCHAR(10)          ;
DECLARE @datePurchased          DATETIME              ;
DECLARE @supplier               NVARCHAR(10)          ;
DECLARE @Saddress               NVARCHAR(20)          ;
DECLARE @unitPrice              INT                   ;
DECLARE @quantity               INT                   ;
DECLARE @What_Happened          NVARCHAR(50)          ;
DECLARE @who_did_it             NVARCHAR(20)          ; 
DECLARE @Date_Executed          DATETIME              ;

BEGIN
    SET @What_Happened = 'UPDATE';
    SET @who_did_it = SYSTEM_USER;
	SET @Date_Executed = GETDATE()

    INSERT into SA67032016_LOG.dbo.Inventory_log(itemId,nameOfItem,datePurchased,supplier,Saddress,
	unitPrice,quantity,What_Happened,who_did_it,Date_Executed) 

    SELECT itemId,nameOfItem,datePurchased,supplier,Saddress,
	unitPrice,quantity,@What_Happened,@who_did_it,@Date_Executed

	FROM DELETED
END

BEGIN
    SET @What_Happened = 'INSERT';
    SET @who_did_it = SYSTEM_USER;
	SET @Date_Executed = GETDATE()

INSERT into SA67032016_LOG.dbo.Inventory_log(itemId,nameOfItem,datePurchased,supplier,Saddress,
	unitPrice,quantity,What_Happened,who_did_it,Date_Executed) 

    SELECT itemId,nameOfItem,datePurchased,supplier,Saddress,
	unitPrice,quantity,@What_Happened,@who_did_it,@Date_Executed

	FROM INSERTED
END

BEGIN 
    SET @What_Happened = 'DELETE';
    SET @who_did_it = SYSTEM_USER;
	SET @Date_Executed = GETDATE()

    INSERT into SA67032016_LOG.dbo.Inventory_log(itemId,nameOfItem,datePurchased,supplier,Saddress,
	unitPrice,quantity,What_Happened,who_did_it,Date_Executed) 

    SELECT itemId,nameOfItem,datePurchased,supplier,Saddress,
	unitPrice,quantity,@What_Happened,@who_did_it,@Date_Executed

	FROM DELETED
END
GO

---------------------------------------------------------------------------------
-- Views Created in the Database
----------------------------------------------------------------------------------
IF ( OBJECT_ID('HR.Emp_v') IS NOT NULL ) 
   DROP VIEW HR.Emp_v 
GO

CREATE VIEW HR.Emp_v
AS
  SELECT 
    lastname    , 
    firstname   , 
    (firstname + ' ' + lastname) as "Fullname_fl",
    (lastname + ', ' + firstname) as "Fullname_lf",
    dob,  
    DATEDIFF(yy, dob, GETDATE()) - 
    CASE 
       WHEN MONTH(dob) > MONTH(GETDATE()) 
            OR 
            (MONTH(dob) = MONTH(GETDATE()) 
             AND DAY(dob) > DAY(GETDATE())
            ) 
    THEN 1 ELSE 0 
    END as "Age"  
    FROM   HR.Employees       
GO  

IF ( OBJECT_ID('HR.EmployeeInfo') IS NOT NULL ) 
   DROP VIEW HR.EmployeeInfo
GO

CREATE VIEW HR.EmployeeInfo 
AS
SELECT
        empid,
        firstname
 AS [FName], 
        lastname 
AS [LName]
FROM
HR.Employees 
GO


CREATE VIEW receipt
AS
SELECT C.firstname
      ,C.lastname
      ,j.nameOfjob
      ,j.price
      ,(10 *j.Price) AS TotalAmountPayable
FROM JB.Client C
INNER JOIN JB.JOB J
ON C.jid=j.jid
INNER JOIN HR.Employees y
ON y.empid =C.jid;
GO




IF ( OBJECT_ID('JB.Clientele') IS NOT NULL ) 
   DROP VIEW JB.Clientele 
GO

CREATE VIEW JB.Clientele
AS
SELECT
      c.firstname, 
	  c.lastname, 
	  c.email, 
	  c.phone, 
	  c.cid
AS
      ClinteleReceipt
FROM
JB.Client c
 
GO

---------------------------------------------------------------------------------
-- Queries --
----------------------------------------------------------------------------------

SELECT empid, firstname, LastName, dateEmployed, employment_Status, Salary 
FROM HR.Employees
WHERE employment_Status = 'Full'
AND (FirstName NOT LIKE 'A%')


-- Want to know the price range of inventory items -- 
SELECT   itemId, nameOfItem, "Unit Price Range" = 
      CASE 
         WHEN unitPrice =  0 THEN 'Invalid Item'
         WHEN unitPrice < 50 THEN  'Under GHS 50'
         WHEN unitPrice >= 50 and unitPrice < 100 THEN 'Under GHS100'
         WHEN unitPrice >= 250 and unitPrice < 1000 THEN 'Under GHS1000'
         ELSE 'Over GHS 1000'
      END
FROM INV.Inventory
ORDER BY itemId ;
GO

-- Want to know the Items in the inventory that needs restocking --
SELECT   itemId, nameOfItem, unitPrice,quantity, "Quantity Left" = 
      CASE 
         WHEN quantity =  0 THEN 'No Item Available'
         WHEN quantity < 200 THEN  'Restock Immediately'
         WHEN quantity >= 100 AND quantity <= 150  THEN 'Warning'
         WHEN quantity > 700 THEN 'Safe Zone'
         ELSE 'Safe Zone'
      END
FROM INV.Inventory
ORDER BY itemId ;
GO

-- The job that yield the most amount of profit to the firm -- 
SELECT jid, nameOfJob, price
FROM JB.JOB
WHERE price > 500
ORDER BY price ASC


SELECT firstname, lastname, dateEmployed, employment_Status, address
FROM HR.Employees AS e1
UNION
SELECT firstname, lastname, dateEmployed, employment_Status, address
FROM HR.Employees AS e2
OPTION (MERGE UNION);
GO

-- 
SELECT jid, nameOfJob, price
FROM JB.JOB
WHERE price > 500
ORDER BY price ASC


