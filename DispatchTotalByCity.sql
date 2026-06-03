  

 --Exec [dbo].[DispatchTotalByCity]   27, 78, -1, '2026-05-01', '2026-05-29'  
alter PROCEDURE [dbo].[DispatchTotalByCity]  
  @CompanyId INT,      
    @BranchId INT,      
    @Destination INT = -1,      
    @FromDate DATE,      
    @ToDate DATE  
AS  
 BEGIN   
 SET NOCOUNT ON;  
  WITH TotalByCity AS (  
  
    SELECT lb.ToDestination,  
  
    SUM(CASE WHEN lb.PaidType = 'PaidCash' THEN lb.TotalAmt ELSE 0 END) AS TotalPaidCashAmt,  
    SUM(CASE WHEN lb.PaidType = 'PaidCash' THEN lb.TotalParcel ELSE 0 END) AS TotalPaidCashNug, 
    SUM(CASE WHEN lb.PaidType = 'PaidDue' THEN lb.TotalAmt ELSE 0 END) AS TotalPaidDueAmt,
    SUM(CASE WHEN lb.PaidType = 'PaidDue' THEN lb.TotalParcel ELSE 0 END) AS TotalPaidDueNug,  
    SUM(CASE WHEN lb.PaidType = 'UPI' THEN lb.TotalAmt ELSE 0 END) AS TotalUpiAmt,   
SUM(CASE WHEN lb.PaidType = 'UPI' THEN lb.TotalParcel ELSE 0 END) AS TotalUpiNug,   
SUM(CASE WHEN lb.PaidType = 'FOC' THEN lb.TotalAmt ELSE 0 END) AS TotalFocAmt,    
SUM(CASE WHEN lb.PaidType = 'FOC' THEN lb.TotalParcel ELSE 0 END) AS TotalFocNug,  
SUM(CASE WHEN lb.PaidType = 'ToPay' THEN lb.TotalAmt ELSE 0 END) AS TotalToPayAmt, 
SUM(CASE WHEN lb.PaidType = 'ToPay' THEN lb.TotalParcel ELSE 0 END) AS TotalToPayNug, 
SUM(CASE WHEN lb.PaidType = 'Debit' THEN lb.TotalAmt ELSE 0 END) AS TotalDebitAmt,  
SUM(CASE WHEN lb.PaidType = 'Debit' THEN lb.TotalParcel ELSE 0 END) AS TotalDebitNug, 
SUM(CASE WHEN lb.PaidType = 'Paid' THEN lb.TotalAmt ELSE 0 END) AS TotalPaidtAmt, 
 SUM(CASE WHEN lb.PaidType = 'Paid' THEN lb.TotalParcel ELSE 0 END) AS TotalPaidNug,  
 SUM(CASE WHEN lb.PaidType = 'PaidUPI' THEN lb.TotalAmt ELSE 0 END) AS TotalPaidUPIAmt,     
 SUM(CASE WHEN lb.PaidType = 'PaidUPI' THEN lb.TotalParcel ELSE 0 END) AS TotalPaidUPINug,   
 ISNULL(SUM(lb.TotalAmt), 0) AS TotalAmount,   
 ISNULL(SUM(lb.TotalParcel), 0) AS TotalNug  
  

FROM Challan ch   
  INNER JOIN  ChallanDetail cd ON ch.id = cd.challanSr  
  INNER JOIN LuggageBooking lb ON cd.BookingSr = lb.id  
WHERE  
  ch.CompanyId = @CompanyId AND ch.Branchid = @BranchId AND lb.cancel = 0 AND lb.Dispatch = 1  
  AND ch.ChallanDate >= @FromDate AND ch.ChallanDate <= @ToDate  
  AND (@Destination = -1 OR ch.DestinationId = @Destination)   
  AND (lb.PaidType = 'Topay')   
  
GROUP BY lb.ToDestination  
)  
SELECT * FROM TotalByCity bc  
  
END  
   
  