-- trg_UpdateBookAvailability: After new loan → set book to unavailable
CREATE TRIGGER trg_UpdateBookAvailability
ON Loans
AFTER INSERT
AS
BEGIN
    UPDATE Books
    SET IsAvailable = 0
    WHERE BookID IN (SELECT BookID FROM INSERTED);
END;
GO

--Make a new table to calculate the total revenur
CREATE TABLE LibraryRevenue (
    LibraryID INT PRIMARY KEY,
    TotalRevenue DECIMAL(10, 2) DEFAULT 0
);

--Initialize with existing library IDs
INSERT INTO LibraryRevenue (LibraryID, TotalRevenue)
SELECT LibraryID, 0 FROM Libraries;

GO
-- trg_CalculateLibraryRevenue: After new payment → update total revenue in separate table
CREATE TRIGGER trg_CalculateLibraryRevenue
ON Payments
AFTER INSERT
AS
BEGIN
    -- Update the total revenue for each affected library
    UPDATE lr
    SET lr.TotalRevenue = (
        SELECT SUM(p.Amount)
        FROM Payments p
        JOIN Loans l ON p.LoanID = l.LoanID
        JOIN Books b ON l.BookID = b.BookID
        WHERE b.LibraryID = lr.LibraryID
    )
    FROM LibraryRevenue lr
    WHERE lr.LibraryID IN (
        SELECT DISTINCT b.LibraryID
        FROM inserted i
        JOIN Loans l ON i.LoanID = l.LoanID
        JOIN Books b ON l.BookID = b.BookID
    );
END;

GO

-- trg_LoanDateValidation: Prevents invalid return dates on insert
CREATE TRIGGER trg_LoanDateValidation
ON Loans
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM INSERTED
        WHERE ReturnDate IS NOT NULL AND ReturnDate < LoanDate
    )
    BEGIN
        RAISERROR('Return date cannot be earlier than loan date.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Proceed with valid insert
    INSERT INTO Loans (LoanID, MemberID, BookID, LoanDate, DueDate, ReturnDate, Status)
    SELECT LoanID, MemberID, BookID, LoanDate, DueDate, ReturnDate, Status
    FROM INSERTED;
END;
GO
