
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
