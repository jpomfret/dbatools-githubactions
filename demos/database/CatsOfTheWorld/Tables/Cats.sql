-- Table: Cats (the real stars of the show)
CREATE TABLE dbo.Cats (
    CatId INT IDENTITY PRIMARY KEY,
    CatName NVARCHAR(100) NOT NULL,
    BreedId INT FOREIGN KEY REFERENCES dbo.Breeds(BreedId),
    FavoriteActivity NVARCHAR(100) DEFAULT 'Knocking things off tables',
    FameReason NVARCHAR(255),
    InstagramFollowers INT DEFAULT 0,
    IsGoodKitty BIT DEFAULT 1 -- all cats are good kitties
);
GO
