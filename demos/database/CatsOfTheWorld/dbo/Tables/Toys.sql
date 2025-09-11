CREATE TABLE [dbo].[Toys] (
    [ToyId]            INT            IDENTITY (1, 1) NOT NULL,
    [ToyName]          NVARCHAR (100) NOT NULL,
    [IsLaserPointer]   BIT            DEFAULT ((0)) NULL,
    [SqueakinessLevel] INT            NULL,
    [ContainsCatnip]   BIT            DEFAULT ((1)) NULL,
    PRIMARY KEY CLUSTERED ([ToyId] ASC),
    CHECK ([SqueakinessLevel]>=(0) AND [SqueakinessLevel]<=(10))
);


GO

