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

	





