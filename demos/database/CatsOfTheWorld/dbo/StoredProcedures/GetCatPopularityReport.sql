-- Stored Procedure: GetCatPopularityReport
-- Returns a list of cats, their breed, Instagram followers, and fame reason, ordered by most followers
CREATE PROCEDURE dbo.GetCatPopularityReport
AS
BEGIN
    SELECT c.CatName, b.BreedName, c.InstagramFollowers, c.FameReason
    FROM dbo.Cats c
    INNER JOIN dbo.Breeds b ON c.BreedId = b.BreedId
    ORDER BY c.InstagramFollowers DESC;
END

GO

