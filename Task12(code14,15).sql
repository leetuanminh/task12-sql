-- SS 14
USE AdventureWorks2019
GO
--VD1
Declare @TranName varchar(30);
Select @TranName = 'FirstTransaction';
Begin Transaction @TranName ;
Delete From HumanResources.JobCandidate Where JobCandidateID = 13;
GO
--VD2
Begin Transaction ;
GO
Delete From HumanResources.JobCandidate Where JobCandidateID = 11;
GO
Commit Transaction;
GO
--VD3
Begin Transaction DeleteCandidate
With Mark N'Deleting a Job Candidate';
GO
Delete From HumanResources.JobCandidate Where JobCandidateID = 11;
GO
COMMIT Transaction DeleteCandidate;
GO
--VD4
USE Sterling;
GO
Create  Table ValueTable ([value] char)
GO
--VD5
Begin Transaction 
Insert Into ValueTable Values('A');Insert Into ValueTable Values('B');
GO
Rollback Transaction 
Insert Into ValueTable Values('C');
Select [value] From ValueTable;
GO

--VD6
Create procedure SaveTranExample @InputCandidateID INT
AS
Declare @Trancounter int;
Set @Trancounter = @@TRANCOUNT; IF @Trancounter > 0
Save Transaction ProcedureSave;
ELSE
Begin Transaction ;
Delete HumanResources.JobCandidate
Where JobCandidateID = @InputCandidateID; IF @Trancounter = 0
COMMIT Transaction ;
IF @Trancounter = 1
RollBack Transaction ProcedureSave;
GO
--VD7
PRINT @@TRANCOUNT BEGIN TRAN
PRINT @@TRANCOUNT BEGIN TRAN
PRINT @@TRANCOUNT COMMIT
PRINT @@TRANCOUNT COMMIT
PRINT @@TRANCOUNT
GO
--VD8
PRINT @@TRANCOUNT BEGIN TRAN
PRINT @@TRANCOUNT BEGIN TRAN
PRINT @@TRANCOUNT
ROLLBACK
PRINT @@TRANCOUNT
GO
--VD9
Begin Transaction ListPriceUpdate
With Mark 'UPDATE Product list prices';
GO
UPDATE Production.Product
SET ListPrice = ListPrice * 1.20 Where ProductNumber LIKE 'BK-%';
GO
COMMIT Transaction ListPriceUpdate;
GO



-- SS 15
--VD1
Begin Try 
Declare @num int ;
Select @num = 217/0;
END Try 
Begin CATCH
Print 'Error occurred, unable to divide by 0'
END CATCH;
GO
--VD2
Begin Try 
Select 217/0;
END Try 
Begin CATCH
Select 
ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_LINE()
AS ErrorLine , ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO
--VD3
IF OBJECT_ID ( 'sp_ErrorInfo', 'P' ) IS NOT NULL
DROP PROCEDURE sp_ErrorInfo;
GO
CREATE PROCEDURE sp_ErrorInfo
AS
SELECT
ERROR_NUMBER () AS ErrorNumber,
ERROR_SEVERITY () AS ErrorSeverity,
ERROR_STATE () AS ErrorState,
ERROR_PROCEDURE () AS ErrorProcedure,
ERROR_LINE () AS ErrorLine,
ERROR_MESSAGE () AS ErrorMessage;
GO
BEGIN TRY SELECT 217/0;
END TRY
BEGIN CATCH
EXECUTE sp_ErrorInfo;
END CATCH 
GO
--VD4
BEGIN TRANSACTION;
BEGIN TRY
DELETE FROM Production.Product WHERE ProductID = 980;
END TRY
BEGIN CATCH
SELECT
 ERROR_SEVERITY () AS ErrorSeverity
,ERROR_NUMBER () AS ErrorNumber
,ERROR_PROCEDURE () AS ErrorProcedure
,ERROR_STATE () AS ErrorState
,ERROR_MESSAGE () AS ErrorMessage
,ERROR_LINE () AS ErrorLine; IF @@TRANCOUNT > 0
ROLLBACK TRANSACTION;
END CATCH;
IF @@TRANCOUNT > 0 COMMIT TRANSACTION;
GO
--VD5
BEGIN TRY
UPDATE HumanResources.EmployeePayHistory SET PayFrequency = 4
WHERE BusinessEntityID = 1;
END TRY
BEGIN CATCH
IF @@ERROR = 547
PRINT N'Check constraint violation has occurred. ';
END CATCH
GO
--VD6
RAISERROR (N'This is an error message $s d.', 10, 1, N'serial number', 23);
GO
--VD7
RAISERROR (N'S*. *s', 10, 1, 7, 3, N'Hello world');
GO
RAISERROR (N'87.3s', 10, 1, N'Helloworld');
GO
--VD8
BEGIN TRY
RAISERROR ('Raises Error in the TRY block.', 16, 1);
END TRY
BEGIN CATCH
DECLARE @ErrorMessage NVARCHAR (4000); DECLARE @ErrorSeverity INT;
DECLARE @ErrorState INT; SELECT
@ErrorMessage = ERROR_MESSAGE (), @ErrorSeverity = ERROR_SEVERITY(),
@ErrorState = ERROR_STATE();
RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
                 
GO
--VD9
BEGIN TRY
SELECT 217/0;
END TRY
BEGIN CATCH
SELECT ERROR_STATE() AS ErrorState;
END CATCH;
GO
--VD10
BEGIN TRY
SELECT 217/0;
END TRY
BEGIN CATCH
SELECT ERROR_SEVERITY() AS ErrorSeverity;
END CATCH;
GO
--VD11
IF OBJECT_ID ( 'usp_Example', 'P') IS NOT NULL
DROP PROCEDURE usp_Example;
GO
CREATE PROCEDURE usp_Example AS
SELECT 217/0;
GO
BEGIN TRY
EXECUTE usp_Example;
END TRY
BEGIN CATCH
SELECT ERROR_PROCEDURE () AS ErrorProcedure;
END CATCH;
GO
--VD12
IF OBJECT_ID ('usp Example', 'P') IS NOT NULL
DROP PROCEDURE usp_Example;
GO
CREATE PROCEDURE usp_Example AS
SELECT 217/0;
GO
BEGIN TRY
EXECUTE usp_Example;
END TRY
BEGIN CATCH SELECT
ERROR_NUMBER() AS ErrorNumber, ERROR_SEVERITY() AS ErrorSeverity, ERROR_STATE()
AS ErrorState, ERROR_PROCEDURE() AS ErrorProcedure, ERROR_MESSAGE () AS
ErrorMessage, ERROR_LINE() AS ErrorLine;
END CATCH;
GO
--VD13
BEGIN TRY
SELECT 217/0;
END TRY
BEGIN CATCH
SELECT ERROR_NUMBER() AS ErrorNumber;
END CATCH;
GO
--VD14
BEGIN TRY
SELECT 217/0;
END TRY
BEGIN CATCH
SELECT ERROR_MESSAGE () AS ErrorMessage;
END CATCH;
GO
--VD15
BEGIN TRY
SELECT 217/0;
END TRY
BEGIN CATCH
SELECT ERROR_LINE () AS ErrorLine;
END CATCH;
GO
--VD16
BEGIN TRY
SELECT * FROM Nonexistent;
END TRY
BEGIN CATCH
SELECT
ERROR_NUMBER() AS ErrorNumber,
ERROR_MESSAGE() AS ErrorMessage;
END CATCH
GO
--VD17
IF OBJECT_ID (N'sp Example', N'P') IS NOT NULL
DROP PROCEDURE sp_Example;
GO
CREATE PROCEDURE sp_Example AS
SELECT * FROM Nonexistent;
GO
BEGIN TRY
EXECUTE sp_Example;
END TRY
BEGIN CATCH SELECT
ERROR_NUMBER() AS ErrorNumber,
ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO
--VD18
USE tempdb;
GO
CREATE TABLE dbo.TestRethrow
(ID INT PRIMARY KEY ) ;
BEGIN TRY
INSERT dbo.TestRethrow (ID) VALUES (1) ;
INSERT dbo.TestRethrow (ID) VALUES (1) ;
END TRY
BEGIN CATCH
PRINT 'In catch block.';
THROW;
END CATCH;
GO