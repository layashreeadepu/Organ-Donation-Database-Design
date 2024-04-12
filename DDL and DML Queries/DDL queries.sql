------------------------------Create Table Queries------------------------------

-- Person Table
CREATE TABLE Person 
(
Person_ID INT PRIMARY KEY IDENTITY(1,1),
First_Name VARCHAR(100) NOT NULL,
Last_Name VARCHAR(100) NOT NULL,
Contact_Number VARCHAR(50) UNIQUE,
Email VARCHAR(100) UNIQUE,
Street VARCHAR(100) NOT NULL,
City VARCHAR(100) NOT NULL,
State VARCHAR(100) NOT NULL,
Zip_Code VARCHAR(10) NOT NULL ,
Blood_Type VARCHAR(3) CHECK (Blood_Type IN ('A+','A-','B+','B-','O+','O-','AB+','AB-')) NOT NULL,
Date_of_Birth DATE NOT NULL,
Biological_Gender VARCHAR(1) CHECK (Biological_Gender IN ('F','M')) NOT NULL,
Person_Type VARCHAR(10) CHECK (Person_Type IN ('Donor','Recipient'))NOT NULL 
);


-- Medical Insurance Table
CREATE TABLE Medical_Insurance
( 
Insurance_ID INT PRIMARY KEY NOT NULL, 
Person_ID INT NOT NULL, 
Insurance_Company VARCHAR(255) NOT NULL, 
Insurance_Amount DECIMAL(18,2) NOT NULL, 
CONSTRAINT FK_Person_Medical_Insurance FOREIGN KEY (Person_ID) REFERENCES Person(Person_ID) 
);  
 
-- Helping Institutes Table
CREATE TABLE Helping_Institutes
(
Institute_ID INT PRIMARY KEY IDENTITY(1,1),
Institute_Name VARCHAR(255) NOT NULL,
Phone_Number VARCHAR(50) NOT NULL UNIQUE,
Registration_ID VARCHAR(100) NOT NULL UNIQUE
);
 
-- Person Helping Institutes Table
CREATE TABLE Person_Helping_Institutes
(
Institute_ID INT,
Person_ID INT NOT NULL,
PRIMARY KEY (Institute_ID, Person_ID),
FOREIGN KEY (Institute_ID) REFERENCES Helping_Institutes (Institute_ID),
FOREIGN KEY (Person_ID) REFERENCES Person(Person_ID)
);
 
-- Donor Table
CREATE TABLE Donor
( 
Donor_ID INT PRIMARY KEY,  
Donation_Date DATE,  
Organ_Donated VARCHAR(255) CHECK ( Organ_Donated IN ( 
        'Vascularized allograft (VCA)',  
        'Heart',  
        'Intestine',  
        'Liver',  
        'Kidney',  
        'Lung',  
        'Pancreas',  
        'Eyes' 
        )) NOT NULL ,
CONSTRAINT FK_Person_ID FOREIGN KEY (Donor_ID) REFERENCES Person(Person_ID)  
); 
 
-- Recipient Table
CREATE TABLE Recipient (
    Recipient_ID INT PRIMARY KEY FOREIGN KEY REFERENCES Person(Person_ID),
    Required_Organ VARCHAR(255) CHECK (
        Required_Organ IN (
            'Vascularized allograft (VCA)',
            'Heart',
            'Intestine',
            'Liver',
            'Kidney',
            'Lung',
            'Pancreas',
            'VCA inside circle'
        )
    ),
    Date_Registered DATE,
    Wait_List_No INT,
    CONSTRAINT CHK_Date_Registered CHECK (Date_Registered <= GETDATE())
    );

-- Organ List Table  
CREATE TABLE Organ_List  
(  
Organ_ID INT PRIMARY KEY,  
Organ_Name VARCHAR(255) CHECK (Organ_Name IN (  
        'Vascularized allograft (VCA)',  
        'Heart',  
        'Intestine',  
        'Liver',  
        'Kidney',  
        'Lung',  
        'Pancreas',  
        'Eyes'  
        )) NOT NULL ,  
Required_Specialist VARCHAR(255) CHECK (Required_Specialist IN (  
        'Microsurgery Specialist',  
        'Cardiologist',  
        'Gastroenterologist',  
        'Hepatologist',  
        'Nephrologist',  
        'Pulmonologist',  
        'Endocrinologist',  
        'Ophthalmologist'  
        )) NOT NULL 
);
 
-- Hospital Table  
CREATE TABLE Hospital  
(  
Hospital_ID INT PRIMARY KEY,  
Hospital_Name VARCHAR(255) NOT NULL,  
Street VARCHAR(255) NOT NULL,  
City VARCHAR(255) NOT NULL,  
State VARCHAR(255) NOT NULL,  
Zip_Code VARCHAR(10) NOT NULL,  
Hospital_Phone VARCHAR(50) NOT NULL, 
Lattitude DECIMAL(38,6), 
Longitude DECIMAL(38,6) 
); 
 
-- Doctors Table 
CREATE TABLE Doctors  
(  
Doctor_ID INT IDENTITY(1,1),  
Doctor_Name VARCHAR(255) NOT NULL,  
Doctor_Email VARCHAR(255) NOT NULL,  
Contact VARCHAR(50) NOT NULL,  
Specialist VARCHAR(255) CHECK (Specialist IN (  
        'Microsurgery Specialist',  
        'Cardiologist',  
        'Gastroenterologist',  
        'Hepatologist',  
        'Nephrologist',  
        'Pulmonologist',  
        'Endocrinologist',  
        'Ophthalmologist'  
         )) NOT NULL,  
Surgery_name VARCHAR(255) CHECK (Surgery_name IN (  
        'Plastic Surgery',  
        'Cardiothoracic Surgery',  
        'Transplant Surgery',  
        'Hepatobiliary Surgery',  
        'Urology',  
        'Thoracic Surgery',  
        'Transplant Surgery',  
        'Eye Surgery'  
        )) NOT NULL 
CONSTRAINT PK_HospDocID PRIMARY KEY (Doctor_ID),
);   
 
-- Hospital Doctors   
CREATE TABLE Hospital_Doctors  
(  
Hospital_ID INT,  
Doctor_ID INT,  
Schedule VARCHAR(255),  
CONSTRAINT PK_HospDocID1 PRIMARY KEY (Hospital_ID, Doctor_ID),  
CONSTRAINT FK_Hospital_ID FOREIGN KEY (Hospital_ID) REFERENCES Hospital(Hospital_ID),  
CONSTRAINT FK_Doctor_ID FOREIGN KEY (Doctor_ID) REFERENCES Doctors(Doctor_ID)  
); 
 
-- Donated Organ Table
CREATE TABLE Donated_Organ (
    Donated_Organ_ID INT PRIMARY KEY IDENTITY(1,1),
    Person_ID INT FOREIGN KEY REFERENCES Person(Person_ID),
    Hospital_ID INT FOREIGN KEY REFERENCES Hospital(Hospital_ID),
    Organ_ID INT FOREIGN KEY REFERENCES Organ_List(Organ_ID),
    Matching_Score INT
);
 
-- Transplantation Table   

CREATE TABLE Transplantation (
    Transplantation_ID INT IDENTITY(1,1) PRIMARY KEY,
    Person_ID INT,
    Hospital_ID INT,
    Donated_Organ_ID INT,
    Doctor_ID INT,
    Organ_Lifespan DECIMAL(36,8),
    Transplantation_Status VARCHAR(255) CHECK (Transplantation_Status IN (
        'Scheduled',
        'In Progress',
        'Completed',
        'Reschedule'
    )) NOT NULL,
    Transplantation_Date DATE,
    CONSTRAINT UK_Transplantation UNIQUE (Person_ID, Hospital_ID, Doctor_ID, Donated_Organ_ID),
    CONSTRAINT FK_Person_ID_5 FOREIGN KEY (Person_ID) REFERENCES Person(Person_ID),
    CONSTRAINT FK_Hospital_ID_2 FOREIGN KEY (Hospital_ID) REFERENCES Hospital(Hospital_ID),
    CONSTRAINT FK_Donated_Organ_ID_2 FOREIGN KEY (Donated_Organ_ID) REFERENCES Donated_Organ(Donated_Organ_ID),
    CONSTRAINT FK_Doctor_ID_1 FOREIGN KEY (Doctor_ID) REFERENCES Doctors(Doctor_ID),
    CONSTRAINT CK_Transplantation_Date CHECK (
        (Transplantation_Status = 'Scheduled' AND Transplantation_Date > GETDATE()) OR
        (Transplantation_Status = 'In Progress' AND Transplantation_Date <= GETDATE()) OR
        (Transplantation_Status = 'Completed' AND Transplantation_Date < GETDATE()) OR
        (Transplantation_Status = 'Reschedule' AND Transplantation_Date > GETDATE())
    )
);

------------------------------Stored Procedure------------------------------

--Procedure 1 
CREATE PROCEDURE GetRecipientPatientDetails
    @PersonID INT,
    @Patient_Name VARCHAR(255) OUTPUT,
    @DonationDate DATE OUTPUT,
    @OrganDonated VARCHAR(255) OUTPUT,
    @Hospital_Name VARCHAR(255) OUTPUT, 
    @Doctor_Name VARCHAR(255) OUTPUT
AS
BEGIN
    DECLARE @IsRecipient BIT = 0;

    -- Check if the person is a recipient
    SELECT @IsRecipient = COUNT(*)
    FROM Recipient
    WHERE Recipient_ID = @PersonID;

    -- If the person is not a recipient, display message
    IF @IsRecipient = 0
    BEGIN
        PRINT 'The person is not a recipient.';
        RETURN;
    END
    
select 
CONCAT(p.first_name,' ', p.Last_Name) as Transplantation_Patient, 
do.Organ_Donated, 
a.Hospital_Name, 
a.Doctor_Name, 
do.Donation_Date 
from Transplantation t

left join Person p
on p.Person_ID = t.Person_ID
left join Donor do
on do.Donor_ID = t.Person_ID
left join (select h.Hospital_ID, h.Hospital_Name, d.Doctor_Name from Hospital_Doctors hd 
            left join Hospital h on hd.Hospital_ID = h.Hospital_ID
            left join Doctors d on d.Doctor_ID = hd.Doctor_ID) a on a.Hospital_ID = t.Hospital_ID
where @PersonID = t.Person_ID;
Print @Patient_Name;
Print @DonationDate;
Print @OrganDonated;
Print @Hospital_Name; 
Print @Doctor_Name ;
end;

--Procedure 2
CREATE PROCEDURE GetDoctorsBySpecialization
    @Specialization varchar(40),
    @HospitalID INT output,
    @Hospitalname varchar (40) output,
    @Doctor_Name varchar(40) output
    
AS
BEGIN
    SELECT D.Doctor_ID, D.Doctor_Name, D.Specialist, HD.Hospital_ID, H.Hospital_name
    FROM Hospital_Doctors HD
    LEFT JOIN Doctors D ON D.Doctor_ID = HD.Doctor_ID
    LEFT JOIN Hospital H ON H.Hospital_ID = HD.Hospital_ID
    WHERE D.Specialist = @Specialization;
    Print   @Specialization
    Print   @HospitalID
    Print   @Hospitalname
    Print   @Doctor_Name
END;

--Procedure 3 
CREATE PROCEDURE TransplantationDetailsbyRecipientID
    @PersonID int, 
    @Transplantation_ID int output,
    @Recipient_Name varchar(40) output,
    @Transplantation_Status varchar(40) output,
    @Transplantation_Date date output,
    @Organ_name varchar(40) output,
    @Doctor_name varchar(40) output, 
    @Hospital varchar (40) output
AS
BEGIN
    DECLARE @Recipient_ID BIT = 0;

    SELECT @Recipient_ID = COUNT(*)
    FROM Transplantation T
    WHERE T.Person_ID = @PersonID;

    IF @Recipient_ID = 0
    BEGIN
        PRINT 'The person has not had a transplant';
        RETURN;
    END
    SELECT 
        T.Transplantation_ID,
        Recipient_Name = RP.First_Name + ' ' + RP.Last_Name,
        T.Transplantation_Status,
        T.Transplantation_Date,
        OL.Organ_Name,
        HD.Doctor_Name,
        HD.Hospital_Name
    FROM Transplantation T
    INNER JOIN Donated_Organ DO ON T.Donated_Organ_ID = DO.Donated_Organ_ID
    INNER JOIN Organ_List OL ON DO.Organ_ID = OL.Organ_ID
    LEFT JOIN Recipient R ON R.Recipient_ID = T.Person_ID
    LEFT JOIN Donor D ON D.Donor_ID = T.Person_ID
    LEFT JOIN Person RP ON RP.Person_ID = R.Recipient_ID
    LEFT JOIN Person DP ON DP.Person_ID = D.Donor_ID
    LEFT JOIN (
        SELECT HD.Hospital_ID, H.Hospital_Name, D.Doctor_Name, D.Specialist 
        FROM Hospital_Doctors HD 
        LEFT JOIN Hospital H ON HD.Hospital_ID = H.Hospital_ID
        LEFT JOIN Doctors D ON D.Doctor_ID = HD.Doctor_ID
    ) HD ON HD.Hospital_ID = T.Hospital_ID
    where r.Recipient_ID =@PersonID;

    print @Transplantation_ID
    print @PersonID
    print @Recipient_Name
    print @Transplantation_Status
    print @Transplantation_Date
    print @Organ_name
    print @Doctor_name
    print @Hospital
 END;

--Procedure 4 
CREATE PROCEDURE TransplantationDetailsbyDate
    @Transplantation_Date date,
    @Transplantation_ID int output,
    @Recipient_Name varchar(40) output,
    @Donor_Name varchar(40) output,
    @Transplantation_Status varchar(40) output,
    @Organ_name varchar(40) output,
    @Doctor_name varchar(40) output, 
    @Hospital varchar(40) output
AS
BEGIN
    DECLARE @TransplantationDate BIT = 0;

    SELECT @TransplantationDate = COUNT(*)
    FROM Transplantation T
    WHERE T.Transplantation_Date = @Transplantation_Date;

    IF @TransplantationDate = 0
    BEGIN
        PRINT 'There has been no transplantation on this day';
        RETURN;
    END

    SELECT 
        @Transplantation_ID = T.Transplantation_ID,
        @Recipient_Name = RP.First_Name + ' ' + RP.Last_Name,
        @Donor_Name = DP.First_Name + ' ' + DP.Last_Name,
        @Transplantation_Status = T.Transplantation_Status,
        @Organ_name = OL.Organ_Name,
        @Doctor_name = HD.Doctor_Name,
        @Hospital = HD.Hospital_Name
    FROM Transplantation T
    INNER JOIN Donated_Organ DO ON T.Donated_Organ_ID = DO.Donated_Organ_ID
    INNER JOIN Organ_List OL ON DO.Organ_ID = OL.Organ_ID
    LEFT JOIN Recipient R ON R.Recipient_ID = T.Person_ID
    LEFT JOIN Donor D ON D.Donor_ID = T.Person_ID
    LEFT JOIN Person RP ON RP.Person_ID = R.Recipient_ID
    LEFT JOIN Person DP ON DP.Person_ID = D.Donor_ID
    LEFT JOIN (
        SELECT HD.Hospital_ID, H.Hospital_Name, D.Doctor_Name, D.Specialist 
        FROM Hospital_Doctors HD 
        LEFT JOIN Hospital H ON HD.Hospital_ID = H.Hospital_ID
        LEFT JOIN Doctors D ON D.Doctor_ID = HD.Doctor_ID
    ) HD ON HD.Hospital_ID = T.Hospital_ID
    WHERE T.Transplantation_Date = @Transplantation_Date;
END;

--Procedure 5
CREATE PROCEDURE RescheduleTransplantation
    @Transplantation_ID INT,
    @RescheduleDate DATE
AS
BEGIN
    UPDATE Transplantation
    SET Transplantation_Status = 'Reschedule',
        Transplantation_Date = @RescheduleDate
    WHERE Transplantation_ID = @Transplantation_ID;
END;


------------------------------Views------------------------------

--View 1
CREATE VIEW PatientDetailsView AS
SELECT 
    p.Person_ID,
    p.First_Name,
    p.Last_Name,
    p.Contact_Number,
    p.Email,
    p.Street,
    p.City,
    p.State,
    p.Zip_Code,
    p.Blood_Type,
    p.Date_of_Birth,
    p.Person_Type,
    mi.Insurance_Company,
    r.Required_Organ AS Needed_Organ,
    t.Transplantation_Status,
    t.Transplantation_Date
FROM Person p
LEFT JOIN Medical_Insurance mi ON p.Person_ID = mi.Person_ID
LEFT JOIN Recipient r ON p.Person_ID = r.Recipient_ID
LEFT JOIN Transplantation t ON p.Person_ID = t.Person_ID;

--View 2
CREATE VIEW HospitalDoctorsView AS
SELECT 
    d.Doctor_ID,
    d.Doctor_Name,
    d.Specialist,
    h.Hospital_ID,
    h.Hospital_Name
FROM Doctors d
INNER JOIN Hospital_Doctors hd ON d.Doctor_ID = hd.Doctor_ID
INNER JOIN Hospital h ON hd.Hospital_ID = h.Hospital_ID;

--View 3
CREATE VIEW OrganDonorsView AS
SELECT 
    p.Person_ID,
    p.First_Name,
    p.Last_Name,
    p.Date_of_Birth,
    p.Blood_Type,
    p.City,
    p.State,
    p.Zip_Code,
    d.Donation_Date,
    d.Organ_Donated
FROM Person p
INNER JOIN Donor d ON p.Person_ID = d.Donor_ID;

------------------------------Triggers------------------------------

--Trigger 1
CREATE TRIGGER trg_CheckRecipientPersonID 
ON Donor 
AFTER INSERT, UPDATE 
AS 
BEGIN 
    -- Check if a donor is also a recipient 
    IF EXISTS (SELECT 1 FROM inserted i INNER JOIN Recipient r ON i.Donor_ID = r.Recipient_ID) 
    BEGIN 
        RAISERROR('A donor cannot also be a recipient.', 16, 1) 
        ROLLBACK TRANSACTION 
        RETURN;  -- Return to prevent further execution 
    END 
    -- Check if the person type for the donor is not 'Donor' 

    IF EXISTS (SELECT 1 FROM Person p 
        WHERE p.Person_ID IN (SELECT i.Donor_ID FROM inserted i) 
        AND p.Person_Type <> 'Donor' 
    ) 
    BEGIN 
        RAISERROR('A donor must have Person_Type as "Donor".', 16, 2) 
        ROLLBACK TRANSACTION 
        RETURN;  -- Return to prevent further execution 
    END 
END;

--Trigger 2
CREATE TRIGGER trg_CheckDonorPersonID
ON Recipient
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted i INNER JOIN Donor d ON i.Recipient_ID = d. Donor_ID)
    BEGIN
        RAISERROR('A recipient cannot also be a donor.', 16, 1)
        ROLLBACK TRANSACTION
		RETURN;  -- Return to prevent further execution 
    END
	    -- Check if the person type for the recipient is not 'Recipient' 

    IF EXISTS (SELECT 1 FROM Person p 
        WHERE p.Person_ID IN (SELECT i.Recipient_ID FROM inserted i) 
        AND p.Person_Type <> 'Recipient' 
    ) 
    BEGIN 
        RAISERROR('A recipient must have Person_Type as "Recipient".', 16, 2) 
        ROLLBACK TRANSACTION 
        RETURN;  -- Return to prevent further execution 
    END 
END;

--Trigger 3
CREATE TRIGGER trg_EnsureSpecialistSurgeryPair 
ON Doctors 
AFTER INSERT 
AS 
BEGIN 
DECLARE @Specialist VARCHAR(255), @SurgeryName VARCHAR(255); 

SELECT @Specialist = i.Specialist, @SurgeryName = i.Surgery_name 
FROM inserted i; 
  
IF NOT EXISTS ( 
    SELECT 1 
    FROM ( 
        VALUES 
            ('Cardiologist', 'Cardiothoracic Surgery'), 
            ('Microsurgery Specialist', 'Transplant Surgery'), 
            ('Gastroenterologist', 'Plastic Surgery'), 
            ('Hepatologist', 'Hepatobiliary Surgery'), 
            ('Nephrologist', 'Urology'), 
            ('Pulmonologist', 'Thoracic Surgery'), 
            ('Endocrinologist', 'Transplant Surgery'), 
            ('Ophthalmologist', 'Eye Surgery') 
    ) AS SpecialistSurgeryPair (Specialist, SurgeryName) 
    WHERE Specialist = @Specialist AND SurgeryName = @SurgeryName 
) 
BEGIN 
    RAISERROR('The specialist-surgery pair is invalid.', 16, 1); 
    ROLLBACK TRANSACTION; 
    RETURN; 
END 
END;

------------------------------------UDF-------------------------------------------
CREATE FUNCTION dbo.CalculateWaitlistTime (
    @RecipientID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @WaitlistTime INT;
    DECLARE @EntryDate DATE;

    SELECT @EntryDate = Date_Registered 
	FROM Recipient 
	WHERE Recipient_ID = @RecipientID;
    DECLARE @CurrentDate DATE = GETDATE();

    SET @WaitlistTime = DATEDIFF(DAY, @EntryDate, @CurrentDate);

    RETURN @WaitlistTime;
END;

-----------------------Column Computed UDF-----------------------------------
ALTER TABLE Recipient
ADD WaitlistTime AS dbo.CalculateWaitlistTime(Recipient_ID);
select * from Recipient

------------------------------------UDF-------------------------------------------
CREATE FUNCTION GetPotentialDonorsForOrgan (@RequiredOrgan VARCHAR(255)) 
RETURNS TABLE 
AS 
RETURN ( SELECT p.Person_ID, 
			p.First_Name, 
			p.Last_Name, 
			p.Contact_Number, 
			p.Email, 
			p.Street, 
			p.City, 
			p.State, 
			p.Zip_Code, 
			p.Blood_Type, 
			p.Date_of_Birth, 
			p.Biological_Gender, 
			p.Person_Type 
			FROM Person p JOIN Donor d 
			ON p.Person_ID = d.Donor_ID
			WHERE d.Organ_Donated = @RequiredOrgan ); 
			
SELECT * FROM GetPotentialDonorsForOrgan('Kidney'); 

------------------------------Column data encryption------------------------------
ALTER TABLE Person
ADD Encrypted_Contact_Number VARBINARY(MAX);

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'YourMasterKeyPassword';

CREATE SYMMETRIC KEY PhoneNumberEncryptionKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY PASSWORD = 'DMDD_Group11';

CREATE CERTIFICATE MyCertificate
    WITH SUBJECT = 'Certificate for Column Encryption';

OPEN SYMMETRIC KEY PhoneNumberEncryptionKey
    DECRYPTION BY PASSWORD = 'DMDD_Group11';

UPDATE Person
SET Encrypted_Contact_Number = ENCRYPTBYKEY(KEY_GUID('PhoneNumberEncryptionKey'), CONVERT(VARBINARY(MAX), Contact_Number));

------------------------------NON CLUSTERED INDEX------------------------------

--Index on Last name and first name of person

CREATE NONCLUSTERED INDEX IX_Person_LastName_FirstName
ON Person (Last_Name, First_Name);

-- Example query using the indexed columns
SELECT *
FROM Person
WHERE Last_Name = 'Smith' AND First_Name = 'Harry';

--Index to find Recipient waiting for specified organ within certain time
CREATE NONCLUSTERED INDEX IX_Recipient_RequiredOrgan_DateRegistered
ON Recipient (Required_Organ, Date_Registered);

-- Example query using the non-clustered index
SELECT *
FROM Recipient
WHERE Required_Organ = 'Kidney'
AND Date_Registered > '2023-01-01';

--Index to retrieve doctors of particular specialization
CREATE NONCLUSTERED INDEX IX_Doctors_Specialist
ON Doctors (Specialist);

-- Example query using the non-clustered index
SELECT *
FROM Doctors
WHERE Specialist = 'Cardiologist';

