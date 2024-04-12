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