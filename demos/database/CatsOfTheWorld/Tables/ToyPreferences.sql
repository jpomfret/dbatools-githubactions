-- Table: ToyPreferences (because every cat is unique)
CREATE TABLE dbo.ToyPreferences (
    CatId INT FOREIGN KEY REFERENCES dbo.Cats(CatId),
    ToyId INT FOREIGN KEY REFERENCES dbo.Toys(ToyId),
    PreferenceLevel INT CHECK (PreferenceLevel BETWEEN 1 AND 5),
    PRIMARY KEY (CatId, ToyId)
);
GO
