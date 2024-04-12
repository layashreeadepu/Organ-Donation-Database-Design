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

