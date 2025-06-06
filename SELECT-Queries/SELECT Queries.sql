Use LibraryManagementSystemDB;

--List all overdue loans with member name, book title, due date  
SELECT 
    m.FullName AS MemberName,
    b.Title AS BookTitle,
    l.DueDate
FROM 
    Loans l
	JOIN Members m
		ON l.MemberID = m.MemberID
	JOIN Books b 
		ON l.BookID = b.BookID
WHERE 
    l.ReturnDate IS NULL 
    AND l.DueDate < GETDATE();


-- List books not available
SELECT 
	Title, 
	Genre
FROM 
	Books
WHERE 
	IsAvailable = 'False';

--Members who borrowed >2 books 
SELECT 
    m.FullName AS MemberName,
    COUNT(*) AS TotalBookBorrow    
FROM 
    Members m
	JOIN Loans l
		ON m.MemberID = l.MemberID
GROUP BY 
	m.FullName
HAVING 
	COUNT(*) > 2;

--Show average rating per book
SELECT 
    b.Title,
    AVG(r.Rating) AS AverageRating
FROM 
	Reviews r
	JOIN Books b 
		ON r.BookID = b.BookID
WHERE 
	b.BookID = 1 --average for the first book Remove this to make it for all books
GROUP BY 
	b.Title;

--Count books by genre 
DECLARE @LibraryID INT = 1; -- i want to check muscat branch library 

SELECT 
    Genre,
    COUNT(*) AS BookCount
FROM 
	Books
WHERE 
	LibraryID = @LibraryID
GROUP BY 
	Genre;

 
 -- List members with no loans 
SELECT 
	m.MemberID, 
	m.FullName
FROM 
	Members m
	LEFT JOIN Loans l 
		ON m.MemberID = l.MemberID
WHERE 
	l.LoanID IS NULL;

--Total fine paid per member
SELECT 
    m.MemberID,
    m.FullName,
    SUM(p.Amount) AS TotalFinePaid
FROM 
	Payments p
	JOIN Loans l 
		ON p.LoanID = l.LoanID
	JOIN Members m 
		ON l.MemberID = m.MemberID
GROUP BY 
	m.MemberID, m.FullName;


--Reviews with member and book info  
SELECT 
    m.FullName AS MemberName,
    b.Title AS BookTitle,
    r.Rating,
    r.Comments
FROM 
	Reviews r
	JOIN Members m 
		ON r.MemberID = m.MemberID
	JOIN Books b 
		ON r.BookID = b.BookID;


--List top 3 books by number of times they were loaned 
SELECT TOP 3 
    b.Title,
    COUNT(*) AS LoanCount
FROM 
	Loans l
	JOIN Books b ON l.BookID = b.BookID
GROUP BY 
	b.Title
ORDER BY 
	LoanCount DESC;

--Retrieve full loan history of a specific member including book title, loan & return dates 
DECLARE @MemberID INT = 1;

SELECT 
    b.Title,
    l.LoanDate,
    l.ReturnDate
FROM 
	Loans l
	JOIN Books b 
		ON l.BookID = b.BookID
WHERE l.MemberID = @MemberID;


--Show all reviews for a book with member name and comments
DECLARE @BookID INT = 1;

SELECT 
    m.FullName AS MemberName,
    r.Rating,
    r.Comments
FROM 
	Reviews r
	JOIN Members m 
		ON r.MemberID = m.MemberID
WHERE 
	r.BookID = @BookID;


--List all staff working in a given library
SELECT 
    s.StaffID,
    s.FullName,
    s.Position,
    s.ContactNumber
FROM 
    Staff s
WHERE 
    s.LibraryID = @LibraryID; --already decleared 


--Show books whose prices fall within a given range
DECLARE @MinPrice DECIMAL(10,2) = 5;
DECLARE @MaxPrice DECIMAL(10,2) = 15;

SELECT 
    BookID,
    Title,
    Price
FROM 
    Books
WHERE 
    Price BETWEEN @MinPrice AND @MaxPrice;


--List all currently active loans (not yet returned) with member and book info
SELECT 
    m.FullName AS MemberName,
    b.Title AS BookTitle,
    l.LoanDate,
    l.DueDate
FROM 
    Loans l
    JOIN Members m ON l.MemberID = m.MemberID
    JOIN Books b ON l.BookID = b.BookID
WHERE 
    l.ReturnDate IS NULL;


--List members who have paid any fine
SELECT DISTINCT 
    m.MemberID,
    m.FullName
FROM 
    Payments p
    JOIN Loans l 
		ON p.LoanID = l.LoanID
    JOIN Members m 
		ON l.MemberID = m.MemberID
WHERE 
    p.Amount > 0;


--List books that have never been reviewed
SELECT 
    b.BookID,
    b.Title
FROM 
    Books b
	LEFT JOIN Reviews r 
		ON b.BookID = r.BookID
WHERE 
    r.ReviewID IS NULL;


--Show a member�s loan history with book titles and loan status
DECLARE @MemberID2 INT = 1;

SELECT 
    b.Title,
    l.LoanDate,
    l.ReturnDate,
    CASE 
        WHEN l.ReturnDate IS NULL 
		THEN 'Active'
        ELSE 'Returned'
    END AS LoanStatus
FROM 
    Loans l
    JOIN Books b 
		ON l.BookID = b.BookID
WHERE 
    l.MemberID = @MemberID2;

--List all members who have never borrowed any book
SELECT 
    m.MemberID,
    m.FullName
FROM 
    Members m
	LEFT JOIN Loans l 
		ON m.MemberID = l.MemberID
WHERE 
    l.LoanID IS NULL;
	

--List books that were never loaned
SELECT 
    b.BookID,
    b.Title
FROM 
    Books b
	LEFT JOIN Loans l 
		ON b.BookID = l.BookID
WHERE 
    l.LoanID IS NULL;


--List all payments with member name and book title
SELECT 
    m.FullName AS MemberName,
    b.Title AS BookTitle,
    p.PaymentDate,
    p.Amount
FROM 
    Payments p
    JOIN Loans l 
		ON p.LoanID = l.LoanID
    JOIN Members m 
		ON l.MemberID = m.MemberID
    JOIN Books b 
		ON l.BookID = b.BookID;


--List all overdue loans with member and book details
SELECT 
    m.FullName AS MemberName,
    b.Title AS BookTitle,
    l.LoanDate,
    l.DueDate
FROM 
    Loans l
    JOIN Members m 
		ON l.MemberID = m.MemberID
    JOIN Books b 
		ON l.BookID = b.BookID
WHERE 
    l.ReturnDate IS NULL
    AND l.DueDate < GETDATE();


--Show how many times a book has been loaned
DECLARE @BookID2 INT = 1;

SELECT 
    b.Title,
    COUNT(l.LoanID) AS LoanCount
FROM 
    Books b
LEFT JOIN Loans l ON b.BookID = l.BookID
WHERE 
    b.BookID = @BookID2
GROUP BY 
    b.Title;


--Get total fines paid by a member across all loans
DECLARE @MemberID3 INT = 1;

SELECT 
    m.FullName,
    SUM(p.Amount) AS TotalFinesPaid
FROM 
    Payments p
    JOIN Loans l
		ON p.LoanID = l.LoanID
    JOIN Members m 
		ON l.MemberID = m.MemberID
WHERE 
    m.MemberID = @MemberID3
GROUP BY 
    m.FullName;


--Show count of available and unavailable books in a library
DECLARE @LibraryID2 INT = 1;

SELECT 
    b.IsAvailable,
    COUNT(*) AS BookCount
FROM 
    Books b
WHERE 
    b.LibraryID = @LibraryID2
GROUP BY 
    b.IsAvailable;


--Return books with more than 5 reviews and average rating > 4.5
SELECT 
    b.Title,
    COUNT(r.ReviewID) AS ReviewCount,
    AVG(r.Rating) AS AverageRating
FROM 
    Reviews r
    JOIN Books b
		ON r.BookID = b.BookID
GROUP BY 
    b.Title
HAVING 
    COUNT(r.ReviewID) > 5
    AND AVG(r.Rating) > 4.5;





