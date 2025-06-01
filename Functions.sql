

-- Returns average rating of a book
CREATE FUNCTION GetBookAverageRating (@BookID INT)
RETURNS DECIMAL(4,2)
AS
BEGIN
    DECLARE @AvgRating DECIMAL(4,2);

    SELECT @AvgRating = AVG(Rating)
    FROM Reviews
    WHERE BookID = @BookID;

    RETURN ISNULL(@AvgRating, 0);
END;

GO
-- Fetches the next available book of a certain title/genre in a library
CREATE FUNCTION GetNextAvailableBook (
    @Genre NVARCHAR(50),
    @Title NVARCHAR(100),
    @LibraryID INT
)
RETURNS TABLE
AS
RETURN
    SELECT TOP 1 *
    FROM Books
    WHERE 
        Genre = @Genre AND 
        Title = @Title AND 
        LibraryID = @LibraryID AND 
        IsAvailable = 1
    ORDER BY BookID;

	GO

-- Returns % of books currently issued in a library
CREATE FUNCTION CalculateLibraryOccupancyRate (@LibraryID INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @Total INT, @Issued INT;

    SELECT @Total = COUNT(*) 
	FROM Books 
	WHERE LibraryID = @LibraryID;

    SELECT @Issued = COUNT(*) 
    FROM Books b
    JOIN Loans l 
		ON b.BookID = l.BookID
    WHERE b.LibraryID = @LibraryID AND l.ReturnDate IS NULL;

    RETURN CASE WHEN @Total = 0 THEN 0 ELSE CAST(@Issued * 100.0 / @Total AS DECIMAL(5,2)) END;
END;


GO

-- Returns the total number of loans made by a given member
CREATE FUNCTION fn_GetMemberLoanCount (@MemberID INT)
RETURNS INT
AS
BEGIN
    DECLARE @LoanCount INT;
    SELECT @LoanCount = COUNT(*) FROM Loans WHERE MemberID = @MemberID;
    RETURN @LoanCount;
END;

GO

-- Returns the number of late days for a loan (0 if not late)
CREATE FUNCTION fn_GetLateReturnDays (@LoanID INT)
RETURNS INT
AS
BEGIN
    DECLARE @DueDate DATE, @ReturnDate DATE;
    SELECT @DueDate = DueDate, @ReturnDate = ReturnDate FROM Loans WHERE LoanID = @LoanID;

    RETURN CASE 
        WHEN @ReturnDate IS NULL OR @ReturnDate <= @DueDate THEN 0
        ELSE DATEDIFF(DAY, @DueDate, @ReturnDate)
    END;
END;

GO

-- Returns a table of available books from a specific library
CREATE FUNCTION fn_ListAvailableBooksByLibrary (@LibraryID INT)
RETURNS TABLE
AS
RETURN
    SELECT BookID, Title, Genre, Price
    FROM Books
    WHERE IsAvailable = 1 AND LibraryID = @LibraryID;

GO

-- Returns books with average rating ≥ 4.5
CREATE FUNCTION fn_GetTopRatedBooks()
RETURNS TABLE
AS
RETURN
    SELECT b.BookID, b.Title, AVG(r.Rating) AS AverageRating
    FROM Books b
    JOIN Reviews r 
		ON b.BookID = r.BookID
    GROUP BY b.BookID, b.Title
    HAVING AVG(r.Rating) >= 4.5;


GO

-- Returns the full name formatted as "LastName, FirstName"
CREATE FUNCTION fn_FormatMemberName (
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50)
)
RETURNS NVARCHAR(101)
AS
BEGIN
    RETURN @LastName + ', ' + @FirstName;
END;

