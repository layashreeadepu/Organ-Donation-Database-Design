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