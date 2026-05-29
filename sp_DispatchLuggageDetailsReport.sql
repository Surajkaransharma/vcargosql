    
  
  
alter PROCEDURE [dbo].[sp_DispatchLuggageDetailsReport]      
    @CompanyId INT,      
    @BranchId INT = -1,      
    @BusNo nvarchar(100) = 'AllCargo',      
    @Destination INT = -1,     
    @paidtype nvarchar(100) = 'All',  
    @FromDate DATE,      
    @ToDate DATE          
AS      
BEGIN      
    SET NOCOUNT ON;      
      
    SELECT       
    c.ChallanId,  
    c.BusNo,      
    c.challantime,
    c.Destination,  
    c.DestinationId,  
    c.id,  
    c.ChallanDate,  
    lb.BookingId ,      
   lb.Descriptions,      
   lb.FName,      
   lb.FMobile,      
   lb.Fgst,      
   lb.TName,      
   lb.TMobile,      
   lb.Tgst,      
   lb.PaidType,      
   lb.TotalParcel,      
   lb.ToDestination,        
   lb.ToDestId,      
   lb.FromDestination,      
   lb.BookingDate,      
   lb.PackingType,      
   lb.PackingType,      
   lb.FrightAmount,      
   lb.FrightPerUnit,      


   lb.Weight,      
   lb.TotalAmt,      
   lb.DeliveryCartage, 
   lb.OtherCharge,      
   
   lb.LabourCharge      
    FROM Challan AS c WITH(NOLOCK)     
    INNER JOIN ChallanDetail AS cd WITH(NOLOCK) ON c.id = cd.challanSr      
    INNER JOIN LuggageBooking AS lb  WITH(NOLOCK) ON lb.id = cd.BookingSr      
    WHERE       
        c.CompanyId = @CompanyId      
        AND ( @BranchId = -1 or  c.Branchid = @BranchId  )    
        AND ( @BusNo = 'AllCargo' or  c.BusNo = @BusNo  )    
        AND ( @paidtype = 'All' or  lb.PaidType = @paidtype  )    
        AND (@Destination = -1 OR lb.ToDestId = @Destination)       
        AND c.ChallanDate >= @FromDate      
        AND c.ChallanDate <= @ToDate      
        AND lb.cancel = 0 order by lb.ToDestination asc;      
END 