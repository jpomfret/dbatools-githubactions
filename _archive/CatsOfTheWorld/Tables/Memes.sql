-- Table: Memes (because the internet demands it)
CREATE TABLE dbo.Memes (
    MemeId INT IDENTITY PRIMARY KEY,
    CatId INT FOREIGN KEY REFERENCES dbo.Cats(CatId),
    MemeTitle NVARCHAR(200),
    MemeUrl NVARCHAR(255),
    Upvotes INT DEFAULT 0,
    DateCreated DATE DEFAULT GETDATE(),
    IsGrumpyCat BIT DEFAULT 0
);
GO
