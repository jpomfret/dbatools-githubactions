CREATE TABLE [dbo].[CatVideos] (
    [VideoId]          INT            IDENTITY (1, 1) NOT NULL,
    [CatId]            INT            NULL,
    [VideoTitle]       NVARCHAR (200) NOT NULL,
    [VideoUrl]         NVARCHAR (500) NULL,
    [Platform]         NVARCHAR (50)  DEFAULT ('YouTube') NULL,
    [ViewCount]        BIGINT         DEFAULT ((0)) NULL,
    [LikeCount]        INT            DEFAULT ((0)) NULL,
    [Duration]         INT            NULL,
    [DateUploaded]     DATE           DEFAULT (getdate()) NULL,
    [IsViral]          BIT            DEFAULT ((0)) NULL,
    [ThumbnailUrl]     NVARCHAR (500) NULL,
    [Description]      NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([VideoId] ASC),
    FOREIGN KEY ([CatId]) REFERENCES [dbo].[Cats] ([CatId])
);