-------------- Transaction: Borrow a book-------------
BEGIN TRANSACTION;

-- Step 1: Insert new loan
INSERT INTO Loans (LoanID, MemberID, BookID, LoanDate, DueDate, Status)
VALUES (1001, 1, 101, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Active');

-- Step 2: Mark book as unavailable
UPDATE Books
SET IsAvailable = 0
WHERE BookID = 101;

COMMIT;


--------- Transaction: Return a book-------------
BEGIN TRANSACTION;

-- Step 1: Update return date and status
UPDATE Loans
SET ReturnDate = GETDATE(),
    Status = 'Returned'
WHERE LoanID = 1001;

-- Step 2: Mark book as available
UPDATE Books
SET IsAvailable = 1
WHERE BookID = (SELECT BookID FROM Loans WHERE LoanID = 1001);

COMMIT;


-------------- Transaction: Register payment only if loan exists--------------
BEGIN TRANSACTION;

-- Step 1: Check loan exists
IF EXISTS (SELECT 1 FROM Loans WHERE LoanID = 1001)
BEGIN
    INSERT INTO Payments (PaymentID, LoanID, Amount, PaymentDate)
    VALUES (501, 1001, 2.50, GETDATE());

    COMMIT;
END
ELSE
BEGIN
    ROLLBACK;
END


------------------- Transaction: Batch insert multiple loans safely------------
BEGIN TRANSACTION;

BEGIN TRY
    INSERT INTO Loans (LoanID, MemberID, BookID, LoanDate, DueDate, Status)
    VALUES 
        (1002, 2, 102, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Active'),
        (1003, 3, 103, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Active');

    -- Update books to unavailable
    UPDATE Books SET IsAvailable = 0 WHERE BookID IN (102, 103);

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
END CATCH;


