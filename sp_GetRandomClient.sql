CREATE PROCEDURE [vcargo3].[sp_GetRandomClient]  
    @Search NVARCHAR(255),  
    @BranchId INT,  
 @Type NVARCHAR(50)  
AS  
BEGIN  
IF @Type = '0'  
    WITH LatestEntries AS (  
        SELECT TOP (10)  FName,  MAX(ID) AS LatestID  
        FROM LuggageBooking WITH(NOLOCK) WHERE branchid = @BranchId AND FName LIKE @Search + '%'  
        GROUP BY FName  
    )  
    SELECT   
        l.FName AS label,  
        l.FName AS value,  
        l.FMobile AS Mobile,  
        l.Fgst AS GstNo  
    FROM LuggageBooking l WITH(NOLOCK) JOIN LatestEntries le ON l.ID = le.LatestID  
    --ORDER BY l.FName;  
ELSE IF @Type = '2'  
 WITH LatestEntries AS (  
        SELECT TOP (10)  Fgst,  MAX(ID) AS LatestID  
        FROM LuggageBooking WITH(NOLOCK) WHERE branchid = @BranchId AND Fgst LIKE '%' + @Search + '%'  
        GROUP BY Fgst  
    )  
    SELECT   
        l.Fgst AS label,  
        l.Fgst AS value,  
        l.FMobile AS Mobile,  
        l.FName AS Fname  
    FROM LuggageBooking l WITH(NOLOCK) JOIN LatestEntries le ON l.ID = le.LatestID  
ELSE IF @Type = '3'   
 WITH LatestEntries AS (  
        SELECT TOP (10)  Tgst,  MAX(ID) AS LatestID  
        FROM LuggageBooking WITH(NOLOCK) WHERE branchid = @BranchId AND Tgst LIKE '%' + @Search + '%'  
        GROUP BY Tgst  
    )  
    SELECT   
        l.Tgst AS label,  
        l.Tgst AS value,  
        l.TMobile AS Mobile,  
        l.TName AS TName,  
  l.id AS ClientId  
    FROM LuggageBooking l WITH(NOLOCK) JOIN LatestEntries le ON l.ID = le.LatestID  
ELSE IF @Type = '4'  
 WITH LatestEntries AS (  
  SELECT TOP (10) FMobile, MAX(ID) AS LatestID  
  FROM LuggageBooking WITH(NOLOCK) WHERE branchid = @BranchId AND FMobile LIKE '%' + @Search + '%'  
  GROUP BY FMobile  
 )  
 SELECT   
  l.FMobile AS label,  
        l.FMobile AS value,  
  l.FName AS Fname,  
  l.Fgst AS GstNo  
 FROM LuggageBooking l WITH(NOLOCK) JOIN LatestEntries le ON l.ID = le.LatestID  
ELSE IF @Type = '5'  
 WITH LatestEntries AS (  
  SELECT TOP (10) TMobile, MAX(ID) AS LatestID  
  FROM LuggageBooking WITH(NOLOCK) WHERE branchid = @BranchId AND TMobile LIKE '%' + @Search + '%'  
  GROUP BY TMobile  
 )  
 SELECT   
  l.TMobile AS label,  
        l.TMobile AS value,  
  l.TName AS TName,  
  l.Tgst AS GstNo  
 FROM LuggageBooking l WITH(NOLOCK) JOIN LatestEntries le ON l.ID = le.LatestID  
ELSE  
WITH Combined AS   
    (  
        SELECT TName AS Name  
        FROM LuggageBooking WITH(NOLOCK) WHERE branchid = @BranchId  AND TName LIKE @Search + '%'  
  
        UNION  
  
        SELECT Name  
        FROM ClientInformation WITH(NOLOCK)  
        WHERE Name LIKE @Search + '%' AND UserBranch = @BranchId  
    ),  
  
    DistinctNames AS   
    (  
        SELECT TOP (10) Name  
        FROM Combined  
        GROUP BY Name  
        ORDER BY Name  
    ),  
  
    LatestLB AS   
    (  
        SELECT   
            n.Name,  
            lb.ID,  
            lb.TMobile,  
            lb.Tgst  
        FROM DistinctNames n  
        OUTER APPLY   
        (  
            SELECT TOP 1 ID, TMobile, Tgst  
            FROM LuggageBooking WITH(NOLOCK)  
            WHERE TName = n.Name AND branchid = @BranchId  
            ORDER BY ID DESC  
        ) lb  
    )  
  
    SELECT   
        l.Name AS label,  
        l.Name AS value,  
        ISNULL(l.TMobile, '') AS Mobile,  
        ISNULL(l.Tgst, '') AS GstNo,  
        ISNULL(ci.Id, 0) AS ClientId  
    FROM LatestLB l WITH(NOLOCK) LEFT JOIN ClientInformation ci WITH(NOLOCK) ON l.Name = ci.Name AND ci.UserBranch = @BranchId  
END  