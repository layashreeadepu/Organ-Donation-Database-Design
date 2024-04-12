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

