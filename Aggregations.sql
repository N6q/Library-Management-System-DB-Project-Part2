
-- Total fines per member
SELECT 
    m.MemberID,
    m.FullName,
    ISNULL(SUM(p.Amount), 0) AS TotalFines
FROM 
	Members m
	LEFT JOIN Loans l 
		ON m.MemberID = l.MemberID
	LEFT JOIN Payments p 
		ON l.LoanID = p.LoanID
GROUP BY 
	m.MemberID, m.FullName;


-- Most active libraries (by loan count)
SELECT 
    b.LibraryID,
    COUNT(l.LoanID) AS TotalLoans
FROM Loans l
	JOIN Books b 
		ON l.BookID = b.BookID
GROUP BY b.LibraryID
ORDER BY TotalLoans DESC;


-- Avg book price per genre
SELECT 
    Genre,
    AVG(Price) AS AvgPrice
FROM Books
GROUP BY Genre;


-- Top 3 most reviewed books
SELECT TOP 3 
    b.BookID,
    b.Title,
    COUNT(r.ReviewID) AS ReviewCount
FROM Reviews r
	 JOIN Books b 
		ON r.BookID = b.BookID
GROUP BY b.BookID, b.Title
ORDER BY ReviewCount DESC;


-- Library revenue report
SELECT 
    b.LibraryID,
    SUM(p.Amount) AS Revenue

FROM Payments p
	JOIN Loans l 
		ON p.LoanID = l.LoanID
	JOIN Books b 
		ON l.BookID = b.BookID

GROUP BY b.LibraryID;


-- Member activity summary (loan + fines)
SELECT 
    m.MemberID,
    m.FullName,
    COUNT(l.LoanID) AS TotalLoans,
    ISNULL(SUM(p.Amount), 0) AS TotalFines
FROM Members m
	LEFT JOIN Loans l 
		ON m.MemberID = l.MemberID
	LEFT JOIN Payments p 
		ON l.LoanID = p.LoanID
GROUP BY m.MemberID, m.FullName;
