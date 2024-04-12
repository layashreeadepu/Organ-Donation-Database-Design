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
CONSTRAINT PK_HospDocID PRIMARY KEY (Doctor_Name, Doctor_ID),
);   
 
-- Hospital Doctors   
CREATE TABLE Hospital_Doctors  
(  
Hospital_ID INT,  
Doctor_ID INT,  
Schedule VARCHAR(255),  
CONSTRAINT PK_HospDocID PRIMARY KEY (Hospital_ID, Doctor_ID),  
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