

-- sp_MarkBookUnavailable(BookID): Updates availability after issuing
CREATE PROCEDURE sp_MarkBookUnavailable
    @BookID INT
AS
BEGIN
    UPDATE Books
    SET IsAvailable = 0
    WHERE BookID = @BookID;
END;

GO
-- sp_UpdateLoanStatus(): Checks dates and updates loan statuses
CREATE PROCEDURE sp_UpdateLoanStatus
AS
BEGIN
    -- Mark overdue loans
    UPDATE Loans
    SET Status = 'Overdue'
    WHERE ReturnDate IS NULL AND DueDate < GETDATE();

    -- Mark active loans
    UPDATE Loans
    SET Status = 'Active'
    WHERE ReturnDate IS NULL AND DueDate >= GETDATE();

    -- Mark returned loans
    UPDATE Loans
    SET Status = 'Returned'
    WHERE ReturnDate IS NOT NULL;
END;

GO
-- sp_RankMembersByFines(): Ranks members by total fines paid
-- Returns a list of members sorted by total fines in descending order
CREATE PROCEDURE sp_RankMembersByFines
AS
BEGIN
    SELECT 
        m.MemberID,
        m.FullName,
        ISNULL(SUM(p.Amount), 0) AS TotalFinesPaid
    FROM 
        Members m
        LEFT JOIN Loans l 
			ON m.MemberID = l.MemberID
        LEFT JOIN Payments p 
			ON l.LoanID = p.LoanID
    GROUP BY 
        m.MemberID, m.FullName
    ORDER BY 
        TotalFinesPaid DESC;
END;


