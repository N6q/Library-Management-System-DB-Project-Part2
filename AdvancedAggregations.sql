---------------- HAVING for filtering aggregates---------------
SELECT 
    b.Genre,
    COUNT(b.BookID) AS BookCount,
    AVG(r.Rating) AS AvgRating
FROM Books b
	JOIN Reviews r 
		ON b.BookID = r.BookID
GROUP BY b.Genre
HAVING COUNT(b.BookID) > 8 AND AVG(r.Rating) >= 3; --Genres with more than 8 books and average rating ≥ 3


---------------- Subqueries for complex logic-------------------- 
 --Max priced book per genre
SELECT 
    Genre,
    Title,
    Price
FROM Books b
WHERE Price = (
    SELECT MAX(Price)
    FROM Books
    WHERE Genre = b.Genre
);

--Second highest priced book per genre
SELECT Genre, Title, Price
FROM Books b
WHERE 1 = (
    SELECT COUNT(DISTINCT Price)
    FROM Books
    WHERE Genre = b.Genre AND Price > b.Price
);

--Books with the highest average rating
SELECT b.BookID, b.Title, AVG(r.Rating) AS AvgRating
FROM Books b
JOIN Reviews r ON b.BookID = r.BookID
GROUP BY b.BookID, b.Title
HAVING AVG(r.Rating) = (
    SELECT MAX(AvgRating)
    FROM (
        SELECT AVG(Rating) AS AvgRating
        FROM Reviews
        GROUP BY BookID
    ) AS Ratings
);





------------- Occupancy rate calculations -----------------
--% of books issued per library
SELECT 
    b.LibraryID,
    COUNT(CASE WHEN l.ReturnDate IS NULL THEN 1 END) * 1.0 / COUNT(DISTINCT b.BookID) * 100 AS OccupancyRate
FROM Books b
	LEFT JOIN Loans l 
	ON b.BookID = l.BookID
GROUP BY b.LibraryID;

-- Issued vs. available book count per library
SELECT 
    LibraryID,
    SUM(CASE WHEN b.BookID IN (SELECT BookID FROM Loans WHERE ReturnDate IS NULL) THEN 1 ELSE 0 END) AS IssuedBooks,
    SUM(CASE WHEN b.BookID NOT IN (SELECT BookID FROM Loans WHERE ReturnDate IS NULL) THEN 1 ELSE 0 END) AS AvailableBooks
FROM Books b
GROUP BY LibraryID;

-- Occupancy rate + total books per library
SELECT 
    b.LibraryID,
    COUNT(b.BookID) AS TotalBooks,
    COUNT(CASE WHEN l.ReturnDate IS NULL THEN 1 END) AS CurrentlyLoaned,
    ROUND(COUNT(CASE WHEN l.ReturnDate IS NULL THEN 1 END) * 100.0 / COUNT(b.BookID), 2) AS OccupancyRate
FROM Books b
	LEFT JOIN Loans l 
		ON b.BookID = l.BookID
GROUP BY b.LibraryID;

-- Monthly occupancy rate per library
SELECT 
    b.LibraryID,
    FORMAT(l.LoanDate, 'yyyy-MM') AS LoanMonth,
    COUNT(CASE WHEN l.ReturnDate IS NULL THEN 1 END) * 100.0 / COUNT(DISTINCT b.BookID) AS MonthlyOccupancyRate
FROM Books b
	JOIN Loans l 
		ON b.BookID = l.BookID
GROUP BY b.LibraryID, 
		FORMAT(l.LoanDate, 'yyyy-MM');

-- ViewLibraryOccupancyDashboard → Shows total books, issued books, available books, and occupancy rate per library
GO
CREATE VIEW ViewLibraryOccupancyDashboard AS
SELECT 
    b.LibraryID,
    COUNT(b.BookID) AS TotalBooks,
    COUNT(CASE WHEN l.ReturnDate IS NULL THEN 1 END) AS IssuedBooks,
    COUNT(CASE WHEN l.ReturnDate IS NOT NULL OR l.LoanID IS NULL THEN 1 END) AS AvailableBooks,
    ROUND(
        COUNT(CASE WHEN l.ReturnDate IS NULL THEN 1 END) * 100.0 / NULLIF(COUNT(b.BookID), 0), 2
    ) AS OccupancyRate
FROM Books b
	LEFT JOIN Loans l 
		ON b.BookID = l.BookID
GROUP BY b.LibraryID;

GO

SELECT * FROM ViewLibraryOccupancyDashboard;
----------------- Members with loans but no fine-------------
SELECT 
    m.MemberID,
    m.FullName
FROM Members m
	JOIN Loans l 
		ON m.MemberID = l.MemberID
	LEFT JOIN Payments p 
		ON l.LoanID = p.LoanID
GROUP BY m.MemberID, m.FullName
HAVING SUM(ISNULL(p.Amount, 0)) = 0;


--------------- Genres with high average ratings (≥ 3.5)------------------
SELECT 
    b.Genre,
    AVG(r.Rating) AS AvgRating
FROM Books b
	JOIN Reviews r 
		ON b.BookID = r.BookID
GROUP BY b.Genre
HAVING AVG(r.Rating) >= 3.5;
