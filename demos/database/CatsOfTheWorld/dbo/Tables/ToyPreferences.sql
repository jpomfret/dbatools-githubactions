CREATE TABLE [dbo].[ToyPreferences] (
    [CatId]           INT NOT NULL,
    [ToyId]           INT NOT NULL,
    [PreferenceLevel] INT NULL,
    PRIMARY KEY CLUSTERED ([CatId] ASC, [ToyId] ASC),
    CHECK ([PreferenceLevel]>=(1) AND [PreferenceLevel]<=(5)),
    FOREIGN KEY ([CatId]) REFERENCES [dbo].[Cats] ([CatId]),
    FOREIGN KEY ([ToyId]) REFERENCES [dbo].[Toys] ([ToyId])
);


GO

