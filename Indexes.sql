
-----------------Library Table-----------------------

-- Non-clustered index on Name (for searching by name)
CREATE NONCLUSTERED INDEX IX_Library_Name
ON Libraries(Name);

-- Non-clustered index on Location (for filtering by location)
CREATE NONCLUSTERED INDEX IX_Library_Location
ON Libraries(Location);


-----------------Book Table-----------------------

-- Non-clustered index on (LibraryID, ISBN)
CREATE NONCLUSTERED INDEX IX_Book_LibraryID_ISBN
ON Books(LibraryID, ISBN);

-- Non-clustered index on Genre (for filtering by genre)
CREATE NONCLUSTERED INDEX IX_Book_Genre
ON Books(Genre);


-----------------Loan Table-----------------------
-- Non-clustered index on MemberID (for retrieving loan history)
CREATE NONCLUSTERED INDEX IX_Loan_MemberID
ON Loans(MemberID);

-- Non-clustered index on Status (for filtering returned/active loans)
CREATE NONCLUSTERED INDEX IX_Loan_Status
ON Loans(Status);

-- Composite non-clustered index on BookID, LoanDate, ReturnDate (for overdue checks)
CREATE NONCLUSTERED INDEX IX_Loan_Book_LoanDate_ReturnDate
ON Loans(BookID, LoanDate, ReturnDate);