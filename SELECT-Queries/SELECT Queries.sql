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
DECLARE @LibraryID INT = 1; -- i wanr to check in muscat branch library 

SELECT 
    Genre,
    COUNT(*) AS BookCount
FROM 
	Books
WHERE 
	LibraryID = @LibraryID
GROUP BY 
	Genre;

 



	





