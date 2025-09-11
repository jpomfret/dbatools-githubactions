-- Table: Toys (for maximum chaos)
CREATE TABLE dbo.Toys (
    ToyId INT IDENTITY PRIMARY KEY,
    ToyName NVARCHAR(100) NOT NULL,
    IsLaserPointer BIT DEFAULT 0,
    SqueakinessLevel INT CHECK (SqueakinessLevel BETWEEN 0 AND 10),
    ContainsCatnip BIT DEFAULT 1
);
GO
