

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

GO
-- ViewAvailableBooks: Available books grouped by genre, ordered by price
CREATE VIEW ViewAvailableBooks AS
SELECT 
    Genre,
    Title,
    Price,
    LibraryID
FROM 
    Books
WHERE 
    IsAvailable = 1
ORDER BY 
    Genre, 
	Price ASC;

	GO
-- ViewLoanStatusSummary: Loan stats (issued, returned, overdue) per library
CREATE VIEW ViewLoanStatusSummary AS
SELECT 
    b.LibraryID,
    l.Status,
    COUNT(*) AS LoanCount
FROM 
    Loans l
    JOIN Books b 
	ON l.BookID = b.BookID
GROUP BY 
    b.LibraryID, 
	l.Status;


GO

-- ViewPaymentOverview → Payment info with member, book, and status
CREATE VIEW ViewPaymentOverview AS
SELECT 
    p.PaymentID,
    m.FullName AS MemberName,
    b.Title AS BookTitle,
    p.Amount,
    p.PaymentDate,
    l.Status
FROM 
    Payments p
    JOIN Loans l 
		ON p.LoanID = l.LoanID
    JOIN Members m 
		ON l.MemberID = m.MemberID
    JOIN Books b 
		ON l.BookID = b.BookID;
