CREATE TABLE [dbo].[CatOwners] (
    [OwnerId]                INT            IDENTITY (1, 1) NOT NULL,
    [CatId]                  INT            NOT NULL,
    [OwnerName]              NVARCHAR (100) NOT NULL,
    [OwnerEmail]             NVARCHAR (150) NULL,
    [YearsOwningCats]        INT            DEFAULT ((1)) NULL,
    [FavoriteTimeToFeedCat]  TIME           DEFAULT ('07:00:00') NULL,
    [NumberOfCatPhotosDaily] INT            DEFAULT ((15)) NULL,
    [HasCatTattoo]           BIT            DEFAULT ((0)) NULL,
    [SpeaksCatLanguage]      BIT            DEFAULT ((0)) NULL,
    [TreatsDispensedDaily]   INT            DEFAULT ((5)) NULL,
    [OwnershipStartDate]     DATE           DEFAULT (getdate()) NULL,
    [IsTrainedByCat]         BIT            DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([OwnerId] ASC),
    FOREIGN KEY ([CatId]) REFERENCES [dbo].[Cats] ([CatId]),
    CHECK ([YearsOwningCats]>=(0) AND [YearsOwningCats]<=(50)),
    CHECK ([NumberOfCatPhotosDaily]>=(0) AND [NumberOfCatPhotosDaily]<=(500)),
    CHECK ([TreatsDispensedDaily]>=(0) AND [TreatsDispensedDaily]<=(100))
);