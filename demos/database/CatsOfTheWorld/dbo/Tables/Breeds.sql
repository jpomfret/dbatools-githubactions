CREATE TABLE [dbo].[Breeds] (
    [BreedId]               INT            IDENTITY (1, 1) NOT NULL,
    [BreedName]             NVARCHAR (100) NOT NULL,
    [CountryOfOrigin]       NVARCHAR (100) NULL,
    [FluffinessLevel]       INT            NULL,
    [IsHypoallergenic]      BIT            DEFAULT ((0)) NULL,
    [AverageNapHoursPerDay] INT            DEFAULT ((16)) NULL,
    PRIMARY KEY CLUSTERED ([BreedId] ASC),
    CHECK ([FluffinessLevel]>=(1) AND [FluffinessLevel]<=(10))
);


GO

