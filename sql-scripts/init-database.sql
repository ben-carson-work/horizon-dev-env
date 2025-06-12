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

PRINT 'Database initialization completed.';