FUNCTION [dbo].[fnResourceScheduleTable]
/*
 * Returns list of resource linked to a ticket or a transaction
 */
(
  @typology varchar(8),         -- Entity typology (valid values are: TICKET, HANDOVER, RETURN) (MANDATORY)
  @entityId uniqueidentifier    -- Ticket or transaction identifier (MANDATORY)
)
RETURNS @result TABLE (
  DateTimeFrom datetime,
  DateTimeTo datetime,
  ResourceSerialId uniqueidentifier,
  ResourceSerialCode varchar(50),
  ResourceTypeId uniqueidentifier,
  ResourceTypeName varchar(50),
  SerialTrack smallint,
  EntityId uniqueidentifier,
  EntityType smallint,
  EntityName nvarchar(100),
  TicketId uniqueidentifier,
  TicketCode varchar(30),
  HandOverScheduleId uniqueidentifier,
  ExtResourceHold varchar(50),
  ExtResourceDesc nvarchar(100),
  ExtResourceData nvarchar(max),
  EntityProfilePictureId uniqueidentifier
)
AS

BEGIN
  declare @error varchar(max);
  declare @temp TABLE ([ResourceScheduleId] uniqueidentifier);

  IF (@typology='TICKET')
    insert into @temp (ResourceScheduleId) select ResourceScheduleId from tbResourceSchedule where TicketId=@entityId
  ELSE IF (@typology='HANDOVER')
    insert into @temp (ResourceScheduleId) select ResourceScheduleId from tbResourceSchedule where HandOverTransactionId=@entityId
  ELSE IF (@typology='RETURN')
    insert into @temp (ResourceScheduleId) select ResourceScheduleId from tbResourceSchedule where ReturnTransactionId=@entityId
  ELSE
	select @error=dbo.fnRaiseError('Unhandled typology: ' + @typology);

  insert into @result (
	  DateTimeFrom,
	  DateTimeTo,
	  ResourceSerialId,
	  ResourceSerialCode,
	  ResourceTypeId,
	  ResourceTypeName,
	  SerialTrack,
	  EntityId,
	  EntityType,
	  EntityName,
	  TicketId,
	  TicketCode,
	  HandOverScheduleId,
	  ExtResourceHold,
	  ExtResourceDesc,
	  ExtResourceData,
	  EntityProfilePictureId
  )
  		select
			RS.DateTimeFrom,
			RS.DateTimeTo,
			RR.ResourceSerialId,
			RR.ResourceSerialCode,
			RR.ResourceTypeId,
			RT.ResourceTypeName,
			RT.SerialTrack,
			RR.EntityId,
			RR.EntityType,
			A.DisplayName as EntityName,
			RS.TicketId,
			dbo.fnEntityDesc(22, RS.TicketId) as TicketCode,
			RR.HandOverScheduleId,
			RS.ExtResourceHold,
			RS.ExtResourceDesc,
			RS.ExtResourceData,
			(
				select RIDX.RepositoryId
				from tbRepositoryIndex RIDX
				where
				RIDX.EntityId=RR.EntityId and
				RIDX.RepositoryIndexType=1
			) as EntityProfilePictureId       
		from
			tbResourceSchedule RS left join
			tbResourceSerial RR on RR.ResourceSerialId=RS.ResourceSerialId left join
			tbResourceType RT on RT.ResourceTypeId=RR.ResourceTypeId left join
			tbAccount A on A.AccountId=RR.EntityId
		where
		  RS.ResourceScheduleId in (select ResourceScheduleId from @temp)


   RETURN;
END;