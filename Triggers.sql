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

-- trg_CalculateLibraryRevenue: After new payment → update library revenue
CREATE TRIGGER trg_CalculateLibraryRevenue
ON Payments
AFTER INSERT
AS
BEGIN
    UPDATE l
    SET Revenue = ISNULL(Revenue, 0) + i.Amount
    FROM Libraries l
    JOIN Books b 
		ON l.LibraryID = b.LibraryID
    JOIN Loans lo 
		ON b.BookID = lo.BookID
    JOIN INSERTED i 
		ON lo.LoanID = i.LoanID;
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
