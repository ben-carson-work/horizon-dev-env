PROCEDURE vspConsAccess
/*
 * 1) Populate tbConsAccess table.
 * 2) Updates tbPerformance.QuantityRedeemed/QuantityInside
 * 
 * Returns as resultset of 1 row with 2 fields:
 *   - MaxSequence bigint   // Max TicketUsageSequence consolidated
 *   - Count int            // Total number of consolidated usages
 */
  @maxItems int     -- max records to be processed
AS

DECLARE @Table TABLE (
  ConsAccessType      int,
  ConsolidateType     int,
  FiscalDate          date,
  TimeSlot            datetime,
  LocationId          uniqueidentifier,
  OpAreaId            uniqueidentifier,
  AccessAreaId        uniqueidentifier,
  PerformanceId       uniqueidentifier,
  ProductId           uniqueidentifier,
  OptionSetId         uniqueidentifier,
  QtyFirstUsage       int,
  QtyEntry            int,
  QtyReentry          int,
  QtyExit             int,
  QtyCrossover        int,
  QtyOverride         int,
  QtyTransit          int,
  QtyOffEntry         int,
  QtyOffReentry       int,
  QtyOffCrossover     int
)

declare @dbInfoParamName varchar(50) = 'TicketUsageLastConsSequence';
declare @sequence bigint; -- consolidate all tbTicketUsage where TicketUsageSequence>@sequence
declare @minSequence bigint;
declare @maxSequence bigint;
declare @count int;
declare @UnknownProductId uniqueidentifier = (select ProductId from tbProduct where ProductCode='#MEDIANOTFOUND');

select @sequence = Coalesce(CAST (dbo.[fnReadDBParam](@dbInfoParamName) AS bigint), 0);

select 
  @minSequence=@sequence+1,
  @maxSequence=Max(TicketUsageSequence),
  @count=Count(*)
from (
  select top (@maxItems) TicketUsageSequence
  from tbTicketUsage WITH(INDEX(UQ_TicketUsage_TicketUsageSequence))
  where TicketUsageSequence>@sequence
  order by TicketUsageSequence
) X

IF (@maxSequence IS NOT NULL)
BEGIN

  with CTE_TicketUsage as 
    (
      select 
        TU.TicketUsageId,
        TU.TicketId,
        TU.UsageFiscalDate,
        TU.UsageLocalDateTime,
        TU.AccessAreaAccountId,
        TU.PerformanceId,
        Coalesce(TU.GroupQuantity, TCK.GroupQuantity) as [GroupQuantity],
        TU.ValidateDateTime,
        TU.UsageType,
        TCK.SaleItemDetailId,
        TU.AptWorkstationId
      from 
        tbTicketUsage TU  WITH(INDEX(UQ_TicketUsage_TicketUsageSequence)) left join
        tbTicket      TCK WITH(FORCESEEK) on TCK.TicketId=TU.TicketId left join
        tbProductFlag PF on PF.ProductId=TCK.ProductId and PF.ProductFlag=27/*IgnoreAdmissionStatistics*/  
      where 
        TU.TicketUsageSequence>=@minSequence and
        TU.TicketUsageSequence<=@maxSequence and
        TU.AccessAreaAccountId is not null and
        TU.PerformanceId is not null and
        TU.ValidateResult < 100 and
        Coalesce(TU.SimulatedRedemption, 0) = 0 and
        PF.ProductFlag is null
    ), 
  CTE_FirstUse as 
    (
      select
        TicketUsageId, 
        FirstUsageTicketUsageId
      from 
        (
          select 
            CTE.TicketUsageId, 
            TUX.TicketUsageId as FirstUsageTicketUsageId, 
            ROW_NUMBER() over (partition by CTE.TicketUsageId order by TUX.UsageDateTime) as Ordinal
          from 
            CTE_TicketUsage CTE inner join 
            tbTicketUsage TUX WITH(FORCESEEK) on TUX.TicketId = CTE.TicketId and 
              TUX.ValidateResult < 100 and
              Coalesce(TUX.SimulatedRedemption, 0) = 0
        ) X
      where X.Ordinal=1
    ) 

  /**** TIMESLOTS ****/
  insert into @Table (
    ConsAccessType,
    ConsolidateType,
    FiscalDate,
    TimeSlot,
    LocationId,
    OpAreaId,
    AccessAreaId,
    PerformanceId,
    ProductId,
    OptionSetId,
    QtyFirstUsage,
    QtyEntry,
    QtyReentry,
    QtyExit,
    QtyCrossover,
    QtyOverride,
    QtyTransit,
    QtyOffEntry,
    QtyOffReentry,
    QtyOffCrossover
  )
  select 
    1/*generic*/,
    2/*timeslot*/,
    TU.UsageFiscalDate,
    dbo.fnTimeSlot15(TU.UsageLocalDateTime),
    APT.LocationAccountId,
    APT.OpAreaAccountId,
    TU.AccessAreaAccountId,
    TU.PerformanceId,
    Coalesce(SI.ProductId, @UnknownProductId),
    Coalesce(SI.OptionSetId, '00000000-0000-0000-0000-000000000000'),
    Sum(case when (FTU.FirstUsageTicketUsageId is null) or TU.TicketUsageId=FTU.FirstUsageTicketUsageId then TU.GroupQuantity else 0 end) as QtyFirstUsage,
    Sum(case when TU.ValidateDateTime is null     and TU.UsageType = 1 then TU.GroupQuantity else 0 end) as QtyEntry,
    Sum(case when TU.ValidateDateTime is null     and TU.UsageType = 3 then TU.GroupQuantity else 0 end) as QtyReentry,
    Sum(case when TU.ValidateDateTime is null     and TU.UsageType = 2 then TU.GroupQuantity else 0 end) as QtyExit,
    Sum(case when TU.ValidateDateTime is null     and TU.UsageType = 4 then TU.GroupQuantity else 0 end) as QtyCrossover,
    Sum(case when TU.ValidateDateTime is null     and TU.UsageType = 6 then TU.GroupQuantity else 0 end) as QtyOverride,
    Sum(case when TU.ValidateDateTime is null     and TU.UsageType = 5 then TU.GroupQuantity else 0 end) as QtyTransit,
    Sum(case when TU.ValidateDateTime is not null and TU.UsageType = 1 then TU.GroupQuantity else 0 end) as QtyOffEntry,
    Sum(case when TU.ValidateDateTime is not null and TU.UsageType = 3 then TU.GroupQuantity else 0 end) as QtyOffReentry,
    Sum(case when TU.ValidateDateTime is not null and TU.UsageType = 4 then TU.GroupQuantity else 0 end) as QtyOffCrossover
  from
    CTE_TicketUsage  TU left join  
    CTE_FirstUse     FTU on FTU.TicketUsageId=TU.TicketUsageId left join
    tbSaleItemDetail SID WITH(FORCESEEK) on SID.SaleItemDetailId=TU.SaleItemDetailId left join
    tbSaleItem       SI WITH(FORCESEEK) on SI.SaleItemId=SID.SaleItemId left join
    tbWorkstation    APT on APT.WorkstationId=TU.AptWorkstationId
  group by
    TU.UsageFiscalDate,
    dbo.fnTimeSlot15(TU.UsageLocalDateTime),
    APT.LocationAccountId,
    APT.OpAreaAccountId,
    TU.AccessAreaAccountId,
    TU.PerformanceId,
    SI.ProductId,
    SI.OptionSetId
	

  /**** DATES ****/
  insert into @Table (
    ConsAccessType,
    ConsolidateType,
    FiscalDate,
    TimeSlot,
    LocationId,
    OpAreaId,
    AccessAreaId,
    PerformanceId,
    ProductId,
    OptionSetId,
    QtyFirstUsage,
    QtyEntry,
    QtyReentry,
    QtyExit,
    QtyCrossover,
    QtyOverride,
    QtyTransit,
    QtyOffEntry,
    QtyOffReentry,
    QtyOffCrossover
  )
  select
    ConsAccessType,
    1/*day*/,
    FiscalDate,
    FiscalDate,
    LocationId,
    OpAreaId,
    AccessAreaId,
    PerformanceId,
    ProductId,
    OptionSetId,
    Sum(QtyFirstUsage),
    Sum(QtyEntry),
    Sum(QtyReentry),
    Sum(QtyExit),
    Sum(QtyCrossover),
    Sum(QtyOverride),
    Sum(QtyTransit),
    Sum(QtyOffEntry),
    Sum(QtyOffReentry),
    Sum(QtyOffCrossover)
  from
    @Table
  where
    ConsolidateType=2
  group by
    ConsAccessType,
    FiscalDate,
    LocationId,
    OpAreaId,
    AccessAreaId,
    PerformanceId,
    ProductId,
    OptionSetId;
  
    
  /**** MERGE ****/
  merge into tbConsAccess as CA using @Table as CTE on (
    CA.ConsAccessType      = CTE.ConsAccessType and
    CA.ConsolidateType     = CTE.ConsolidateType and
    CA.FiscalDate          = CTE.FiscalDate and
    CA.DateTime            = CTE.TimeSlot and
    CA.LocationAccountId   = CTE.LocationId and
    CA.OpAreaAccountId     = CTE.OpAreaId and
    CA.AccessAreaAccountId = CTE.AccessAreaId and
    CA.PerformanceId       = CTE.PerformanceId and
    CA.ProductId           = CTE.ProductId and
    CA.OptionSetId         = CTE.OptionSetId
  )
  when matched then
    update set 
      CA.QtyFirstUsage     = CA.QtyFirstUsage + CTE.QtyFirstUsage,
      CA.QtyEntry          = CA.QtyEntry + CTE.QtyEntry,
      CA.QtyReentry        = CA.QtyReentry + CTE.QtyReentry,
      CA.QtyExit           = CA.QtyExit + CTE.QtyExit,
      CA.QtyCrossover      = CA.QtyCrossover + CTE.QtyCrossover,
      CA.QtyOverride       = CA.QtyOverride + CTE.QtyOverride,
      CA.QtyTransit        = CA.QtyTransit + CTE.QtyTransit,
      CA.QtyOffEntry       = CA.QtyOffEntry + CTE.QtyOffEntry,
      CA.QtyOffReentry     = CA.QtyOffReentry + CTE.QtyOffReentry,
      CA.QtyOffCrossover   = CA.QtyOffCrossover + CTE.QtyOffCrossover
  when not matched then
    insert (
      ConsAccessType,
      ConsolidateType,
      FiscalDate,
      DateTime,
      LocationAccountId,
      OpAreaAccountId,
      AccessAreaAccountId,
      PerformanceId,
      ProductId,
      OptionSetId,
      QtyFirstUsage,
      QtyEntry,
      QtyReentry,
      QtyExit,
      QtyCrossover,
      QtyOverride,
      QtyTransit,
      QtyOffEntry,
      QtyOffReentry,
      QtyOffCrossover,
      FirstUsageRevenue
    )
    values (
      CTE.ConsAccessType,
      CTE.ConsolidateType,
      CTE.FiscalDate,
      CTE.TimeSlot,
      CTE.LocationId,
      CTE.OpAreaId,
      CTE.AccessAreaId,
      CTE.PerformanceId,
      CTE.ProductId,
      CTE.OptionSetId,
      CTE.QtyFirstUsage,
      CTE.QtyEntry,
      CTE.QtyReentry,
      CTE.QtyExit,
      CTE.QtyCrossover,
      CTE.QtyOverride,
      CTE.QtyTransit,
      CTE.QtyOffEntry,
      CTE.QtyOffReentry,
      CTE.QtyOffCrossover,
      0
    );
  
    
  /**** tbPerformance: QuantityRedeemed / QuantityInside ****/
  with CTE_TicketUsage as 
    (
      select 
        TU.PerformanceId,
        Coalesce(TU.GroupQuantity, TCK.GroupQuantity) as [GroupQuantity],
        TU.UsageType
      from 
        tbTicketUsage TU  WITH(INDEX(UQ_TicketUsage_TicketUsageSequence)) left join
        tbTicket      TCK WITH(FORCESEEK) on TCK.TicketId=TU.TicketId left join
        tbProductFlag PF on PF.ProductId=TCK.ProductId and PF.ProductFlag=27/*IgnoreAdmissionStatistics*/  
      where 
        TU.TicketUsageSequence>=@minSequence and
        TU.TicketUsageSequence<=@maxSequence and
        TU.PerformanceId is not null and
        dbo.fnIsValidTicketUsage(TU.ValidateResult, TU.Invalidated, TU.SimulatedRedemption) = 1 and
        PF.ProductFlag is null
    ) 

  update tbPerformance
  set 
    QuantityRedeemed = QuantityRedeemed + X_RedeemDelta,
    QuantityInside = QuantityInside + X_InsideDelta
  from (
    select
      TU.PerformanceId as X_PerformanceId,
      Sum(case 
          when TU.UsageType in (1/*entry*/, 4/*xover*/) then TU.GroupQuantity 
          else 0 
        end) as X_RedeemDelta,
      Sum(case 
          when TU.UsageType in (1/*entry*/, 3/*reentry*/, 4/*xover*/) then TU.GroupQuantity 
          when TU.UsageType in (2/*exit*/, 7/*already-exit*/) then -TU.GroupQuantity
          /* TODO: Handle Transits*/
          else 0 
        end) as X_InsideDelta
    from
      CTE_TicketUsage TU
    group by
      TU.PerformanceId
  ) X
  where PerformanceId = X_PerformanceId

  /* save DBParam */
  exec vspSaveDBParam @dbInfoParamName, @maxSequence

END;


/**** RESULT ****/
select
  @maxSequence as [MaxSequence],
  @count as [Count]
  

