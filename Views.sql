

-- ViewPopularBooks: Books with average rating > 4.5 + total loans
CREATE VIEW ViewPopularBooks AS
SELECT 
    b.BookID,
    b.Title,
    AVG(r.Rating) AS AverageRating,
    COUNT(l.LoanID) AS TotalLoans
FROM 
    Books b
    LEFT JOIN Reviews r 
		ON b.BookID = r.BookID
    LEFT JOIN Loans l 
		ON b.BookID = l.BookID
GROUP BY 
    b.BookID, b.Title
HAVING 
    AVG(r.Rating) > 4.5;
	
GO
-- ViewMemberLoanSummary: Member loan count + total fines paid
CREATE VIEW ViewMemberLoanSummary AS
SELECT 
    m.MemberID,
    m.FullName,
    COUNT(l.LoanID) AS LoanCount,
    ISNULL(SUM(p.Amount), 0) AS TotalFinesPaid
FROM 
    Members m
    LEFT JOIN Loans l ON m.MemberID = l.MemberID
    LEFT JOIN Payments p ON l.LoanID = p.LoanID
GROUP BY 
    m.MemberID, m.FullName;

