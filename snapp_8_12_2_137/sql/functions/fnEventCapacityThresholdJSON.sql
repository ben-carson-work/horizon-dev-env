FUNCTION [dbo].[fnEventCapacityThresholdJSON]
/*
 * Returns a json containing a list of event capacity thresholds configuration
 * Map to com.vgs.snapp.dataobject.event.DOEventCapacityThreshold 
 */
(
  @EventId uniqueidentifier    -- Event ID
)
RETURNS nvarchar(max)
AS
BEGIN

  return (
    select
      ECT.EventCapacityThresholdId,
      ECT.ThresholdValueType,
      ECT.ThresholdValue,
      ECT.ThresholdDefault,
      (select
        ECTD.AttributeItemId as SeatCategoryId,
        AI.AttributeItemCode as SeatCategoryCode,
        AI.AttributeItemName as SeatCategoryName,
        ECTD.SeatEnvelopeId,
        SE.SeatEnvelopeCode,
        SE.SeatEnvelopeName,
        ECTD.ValueType,
        ECTD.Value
      from
        tbEventCapacityThresholdDetail ECTD inner join
        tbAttributeItem AI on AI.AttributeItemId=ECTD.AttributeItemId inner join
        tbSeatEnvelope SE on SE.SeatEnvelopeId=ECTD.SeatEnvelopeId
      where
        ECTD.EventCapacityThresholdId=ECT.EventCapacityThresholdId
      FOR JSON PATH
      ) as DetailList
    from
      tbEventCapacityThreshold ECT
    where
      ECT.EventId=@EventId
    FOR JSON PATH
  )
  
END