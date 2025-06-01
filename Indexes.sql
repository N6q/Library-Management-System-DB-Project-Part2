-- Non-clustered index on Name (for searching by name)
CREATE NONCLUSTERED INDEX IX_Library_Name
ON Libraries(Name);

-- Non-clustered index on Location (for filtering by location)
CREATE NONCLUSTERED INDEX IX_Library_Location
ON Libraries(Location);
