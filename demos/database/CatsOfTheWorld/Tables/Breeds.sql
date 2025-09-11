-- Table: Breeds (for all the floofs and chonks)
CREATE TABLE dbo.Breeds (
    BreedId INT IDENTITY PRIMARY KEY,
    BreedName NVARCHAR(100) NOT NULL,
    CountryOfOrigin NVARCHAR(100),
    FluffinessLevel INT CHECK (FluffinessLevel BETWEEN 1 AND 10),
    IsHypoallergenic BIT DEFAULT 0,
    AverageNapHoursPerDay INT DEFAULT 16 -- because cats are professional nappers
);
GO
