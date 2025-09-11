CREATE TABLE [dbo].[Cats] (
    [CatId]              INT            IDENTITY (1, 1) NOT NULL,
    [CatName]            NVARCHAR (100) NOT NULL,
    [BreedId]            INT            NULL,
    [FavoriteActivity]   NVARCHAR (100) DEFAULT ('Knocking things off tables') NULL,
    [FameReason]         NVARCHAR (255) NULL,
    [InstagramFollowers] INT            DEFAULT ((0)) NULL,
    [IsGoodKitty]        BIT            DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([CatId] ASC),
    FOREIGN KEY ([BreedId]) REFERENCES [dbo].[Breeds] ([BreedId])
);


GO

