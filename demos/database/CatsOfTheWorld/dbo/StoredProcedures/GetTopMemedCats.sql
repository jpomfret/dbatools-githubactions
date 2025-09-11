-- Stored Procedure: GetTopMemedCats
-- Returns cats with the most memes, including meme count and top meme title
CREATE PROCEDURE dbo.GetTopMemedCats
AS
BEGIN
    SELECT c.CatName, COUNT(m.MemeId) AS MemeCount, MAX(m.MemeTitle) AS TopMemeTitle
    FROM dbo.Cats c
    INNER JOIN dbo.Memes m ON c.CatId = m.CatId
    GROUP BY c.CatName
    ORDER BY MemeCount DESC;
END

GO

