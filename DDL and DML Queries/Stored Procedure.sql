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



 






