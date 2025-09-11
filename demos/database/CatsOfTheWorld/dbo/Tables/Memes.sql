CREATE TABLE [dbo].[Memes] (
    [MemeId]      INT            IDENTITY (1, 1) NOT NULL,
    [CatId]       INT            NULL,
    [MemeTitle]   NVARCHAR (200) NULL,
    [MemeUrl]     NVARCHAR (255) NULL,
    [Upvotes]     INT            DEFAULT ((0)) NULL,
    [DateCreated] DATE           DEFAULT (getdate()) NULL,
    [IsGrumpyCat] BIT            DEFAULT ((0)) NULL,
    PRIMARY KEY CLUSTERED ([MemeId] ASC),
    FOREIGN KEY ([CatId]) REFERENCES [dbo].[Cats] ([CatId])
);


GO

