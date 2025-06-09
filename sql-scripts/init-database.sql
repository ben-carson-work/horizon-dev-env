-- Create SNP_WIP database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'SNP_WIP')
BEGIN
    CREATE DATABASE [SNP_WIP];
    PRINT 'Database SNP_WIP created successfully.';
END
ELSE
BEGIN
    PRINT 'Database SNP_WIP already exists.';
END

-- Use the SNP_WIP database
USE [SNP_WIP];

-- Create any additional tables or initial data here if needed
-- Example:
-- CREATE TABLE IF NOT EXISTS sample_table (
--     id INT IDENTITY(1,1) PRIMARY KEY,
--     name NVARCHAR(255) NOT NULL,
--     created_date DATETIME2 DEFAULT GETDATE()
-- );

PRINT 'Database initialization completed.';