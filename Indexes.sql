
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