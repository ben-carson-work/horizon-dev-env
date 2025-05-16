/*
Created   12/03/2012
Modified    07/01/2013
Project   TixKiosk
Model     
Company   VGS Srl
Author    Ugo Galbiati
Version   1.0
Database    MS SQL 2005 
*/


Create type [VGS_PrimaryKey] from Uniqueidentifier NOT NULL
go

Create type [VGS_Code10] from Varchar(10) NOT NULL
go

Create type [VGS_Name30] from Nvarchar(30) NOT NULL
go

Create type [VGS_Name50] from Nvarchar(50) NOT NULL
go

Create type [VGS_Code15] from Varchar(15) NOT NULL
go

Create type [VGS_LookupItemCode] from Smallint NOT NULL
go

Create type [VGS_Currency] from Float NOT NULL
go

Create type [VGS_Boolean] from Bit NOT NULL
go

Create type [VGS_Date] from Datetime NOT NULL
go

Create type [VGS_DateTime] from Datetime NOT NULL
go

Create type [VGS_CodeAuto] from Varchar(20) NOT NULL
go

Create type [VGS_LID] from Smallint NOT NULL
go

Create type [VGS_DateTimeGMT] from Smalldatetime NOT NULL
go


Create table [tbAccount]
(
  [AccountId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [EntityType] Smallint NOT NULL,
  [AccountStatus] Smallint NOT NULL,
  [AccountCode] Varchar(15) NOT NULL, UNIQUE ([AccountCode]),
  [DisplayName] Nvarchar(50) NOT NULL,
  [LangISO] Varchar(3) NULL,
Primary Key ([AccountId])
) 
go

Create table [tbAccountTree]
(
  [AccountTreeId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [AccountId] Uniqueidentifier NOT NULL,
  [RootAccountId] Uniqueidentifier NOT NULL,
  [ParentAccountId] Uniqueidentifier NULL,
  [CategoryId] Uniqueidentifier NOT NULL,
Primary Key ([AccountTreeId])
) 
go

Create table [tbLookupTable]
(
  [TableCode] Smallint NOT NULL,
  [TableName] Nvarchar(50) NOT NULL,
Primary Key ([TableCode])
) 
go

Create table [tbLookupItem]
(
  [TableCode] Smallint NOT NULL,
  [ItemCode] Smallint NOT NULL,
  [ItemName] Nvarchar(50) NOT NULL
) 
go

Create table [tbAccountFinance]
(
  [AccountFinanceId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [AccountId] Uniqueidentifier NOT NULL,
  [Active] Bit NOT NULL,
  [SaleChannelId] Uniqueidentifier NULL,
  [TotalCredit] Float NULL,
  [CreditDays] Integer NULL,
  [CreditPerTransaction] Float NULL,
  [ItemsPerTransaction] Integer NULL,
  [AutoPayCredits] Bit NOT NULL,
  [TotalOpen] Float NOT NULL,
  [TotalPaid] Float NOT NULL,
  [AdvancedPayment] Float NOT NULL,
Primary Key ([AccountFinanceId])
) 
go

Create table [tbLogin]
(
  [AccountId] Uniqueidentifier NOT NULL,
  [UserName] Nvarchar(30) NOT NULL,
  [Password] Varchar(100) NOT NULL,
  [LoginStatus] Smallint NOT NULL,
  [ValidFrom] Datetime NULL,
  [ValidTo] Datetime NULL,
Primary Key ([AccountId])
) 
go

Create table [tbMetaData]
(
  [MetaDataId] Uniqueidentifier NOT NULL,
  [EntityType] Smallint NOT NULL,
  [EntityId] Uniqueidentifier NOT NULL,
  [MetaFieldId] Uniqueidentifier NOT NULL,
  [ShortValue] Nvarchar(100) NULL,
  [LongValue] Ntext NULL,
Primary Key ([MetaDataId])
) 
go

Create table [tbMetaField]
(
  [MetaFieldId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [MetaFieldCode] Varchar(10) NOT NULL,
  [MetaFieldName] Nvarchar(50) NOT NULL,
  [FieldType] Smallint NULL,
Primary Key ([MetaFieldId])
) 
go

Create table [tbWorkstation]
(
  [WorkstationId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [CategoryId] Uniqueidentifier NOT NULL,
  [LocationAccountId] Uniqueidentifier NOT NULL,
  [OpAreaAccountId] Uniqueidentifier NOT NULL,
  [WorkstationType] Smallint NOT NULL,
  [WorkstationCode] Varchar(15) NOT NULL,
  [WorkstationName] Nvarchar(50) NOT NULL,
  [ActivationKey] Varchar(25) NULL,
  [StationSerial] Smallint NULL,
  [LicenseParams] Ntext NULL,
Primary Key ([WorkstationId])
) 
go

Create table [tbEvent]
(
  [EventId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [AccountId] Uniqueidentifier NULL,
  [EventType] Smallint NOT NULL,
  [CategoryId] Uniqueidentifier NOT NULL,
  [EventCode] Varchar(10) NOT NULL,
  [EventName] Nvarchar(50) NOT NULL,
  [EventStatus] Smallint NOT NULL,
  [OnSaleFrom] Datetime NULL,
  [OnSaleTo] Datetime NULL,
  [ProducerAccountId] Uniqueidentifier NULL,
  [LastUpdate] Datetime NOT NULL,
Primary Key ([EventId])
) 
go

Create table [tbProduct]
(
  [ProductId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [CategoryId] Uniqueidentifier NOT NULL,
  [ProductType] Smallint NOT NULL,
  [ProductCode] Varchar(10) NOT NULL,
  [ProductName] Nvarchar(50) NOT NULL,
  [ParentEntityType] Smallint NULL,
  [ParentEntityId] Uniqueidentifier NULL,
Primary Key ([ProductId])
) 
go

Create table [tbAttribute]
(
  [AttributeId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [ParentEntityType] Smallint NULL,
  [ParentEntityId] Uniqueidentifier NULL,
  [AttributeCode] Varchar(10) NOT NULL,
  [AttributeName] Nvarchar(30) NOT NULL,
  [AttributeWeight] Integer NULL,
  [SeatCategory] Bit NOT NULL,
Primary Key ([AttributeId])
) 
go

Create table [tbAttributeItem]
(
  [AttributeItemId] Uniqueidentifier NOT NULL,
  [AttributeId] Uniqueidentifier NOT NULL,
  [AttributeItemCode] Varchar(10) NOT NULL,
  [AttributeItemName] Nvarchar(30) NOT NULL,
  [PriorityOrder] Integer NOT NULL,
  [OptionalPrice] Float NULL,
  [SeatCategoryCode] Varchar(10) NULL,
  [SeatCategoryColor] Varchar(7) NULL,
  [SeatAlgorithmType] Smallint NULL,
Primary Key ([AttributeItemId])
) 
go

Create table [tbProductPrice]
(
  [ProductPriceId] Uniqueidentifier NOT NULL,
  [ProductId] Uniqueidentifier NOT NULL,
  [SaleChannelId] Uniqueidentifier NULL,
  [PerformanceTypeId] Uniqueidentifier NULL,
  [PriceActionType] Smallint NOT NULL,
  [PriceValueType] Smallint NOT NULL,
  [PriceValue] Float NOT NULL,
Primary Key ([ProductPriceId])
) 
go

Create table [tbPerformanceType]
(
  [PerformanceTypeId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [PerformanceTypeCode] Varchar(10) NOT NULL,
  [PerformanceTypeName] Nvarchar(50) NOT NULL,
  [ParentEntityType] Smallint NULL,
  [ParentEntityId] Uniqueidentifier NULL,
  [ValidFrom] Datetime NULL,
  [ValidTo] Datetime NULL,
  [PriceActionType] Smallint NOT NULL,
  [PriceValueType] Smallint NOT NULL,
  [PriceValue] Float NULL,
Primary Key ([PerformanceTypeId])
) 
go

Create table [tbSaleChannel]
(
  [SaleChannelId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [SaleChannelType] Smallint NOT NULL,
  [SaleChannelCode] Varchar(10) NOT NULL,
  [SaleChannelName] Nvarchar(50) NOT NULL,
  [ValidFrom] Datetime NULL,
  [ValidTo] Datetime NULL,
  [PriceActionType] Smallint NOT NULL,
  [PriceValueType] Smallint NOT NULL,
  [PriceValue] Float NULL,
Primary Key ([SaleChannelId])
) 
go

Create table [tbPerformance]
(
  [PerformanceId] Uniqueidentifier NOT NULL,
  [EventId] Uniqueidentifier NOT NULL,
  [PerformanceTypeId] Uniqueidentifier NOT NULL,
  [LocationAccountId] Uniqueidentifier NULL,
  [AccessAreaAccountId] Uniqueidentifier NULL,
  [AllocateResourcesOnCreate] Bit NOT NULL,
  [DateTimeFrom] Datetime NOT NULL,
  [DateTimeTo] Datetime NOT NULL,
  [PerformanceStatus] Smallint NOT NULL,
  [OnSaleFrom] Datetime NULL,
  [OnSaleTo] Datetime NULL,
Primary Key ([PerformanceId])
) 
go


Create table [tbDBInfo]
(
  [ParamName] Varchar(50) NOT NULL,
  [ParamValue] Ntext NOT NULL,
  [LastUpdate] Datetime NOT NULL,
Primary Key ([ParamName])
) 
go

Create table [tbAccountLink]
(
  [AccountId] Uniqueidentifier NOT NULL,
  [SystemURL] Varchar(1000) NOT NULL,
Primary Key ([AccountId])
) 
go

Create table [tbRole]
(
  [RoleId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [RoleCode] Varchar(10) NOT NULL,
  [RoleName] Nvarchar(50) NOT NULL,
Primary Key ([RoleId])
) 
go

Create table [tbAccount2Role]
(
  [Account2RoleId] Uniqueidentifier NOT NULL,
  [RoleId] Uniqueidentifier NOT NULL,
  [AccountId] Uniqueidentifier NOT NULL,
Primary Key ([Account2RoleId])
) 
go

Create table [tbSale]
(
  [SaleId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [UserAccountId] Uniqueidentifier NOT NULL,
  [WorkstationId] Uniqueidentifier NOT NULL,
  [AccountId] Uniqueidentifier NULL,
  [SaleStatus] Smallint NOT NULL,
  [SaleDateTime] Datetime NOT NULL,
  [SaleFiscalDate] Datetime NOT NULL,
  [SaleCode] Varchar(20) NOT NULL,
  [SaleCodeExt] Varchar(20) NULL,
  [Approved] Bit NOT NULL,
  [Paid] Bit NOT NULL,
  [Encoded] Bit NOT NULL,
  [Printed] Bit NOT NULL,
  [Validated] Bit NOT NULL,
  [Completed] Bit NOT NULL,
  [TotalAmount] Float NOT NULL,
  [PaidAmount] Float NOT NULL,
  [SaleAmount] Float NOT NULL,
  [ItemCount] Integer NOT NULL,
  [HoldId] Uniqueidentifier NULL,
Primary Key ([SaleId])
) 
go

Create table [tbTransaction]
(
  [TransactionId] Uniqueidentifier NOT NULL,
  [SaleId] Uniqueidentifier NOT NULL,
  [WorkstationId] Uniqueidentifier NOT NULL,
  [UserAccountId] Uniqueidentifier NOT NULL,
  [TransactionType] Smallint NOT NULL,
  [TransactionDateTime] Smalldatetime NOT NULL,
  [TransactionFiscalDate] Datetime NOT NULL,
  [TransactionSerial] Integer NOT NULL,
  [ItemCount] Integer NOT NULL,
  [TotalAmount] Float NOT NULL,
  [TotalTax] Float NOT NULL,
  [PaidAmount] Float NOT NULL,
  [PaidTax] Float NOT NULL,
  [Approved] Bit NOT NULL,
  [Paid] Bit NOT NULL,
  [Encoded] Bit NOT NULL,
  [Printed] Bit NOT NULL,
  [Validated] Bit NOT NULL,
Primary Key ([TransactionId])
) 
go

Create table [tbTransactionItem]
(
  [TransactionItemId] Uniqueidentifier NOT NULL,
  [TransactionId] Uniqueidentifier NOT NULL,
  [SaleItemId] Uniqueidentifier NOT NULL,
  [Quantity] Smallint NOT NULL,
Primary Key ([TransactionItemId])
) 
go

Create table [tbTicketMediaMatch]
(
  [TicketMediaMatchId] Uniqueidentifier NOT NULL,
  [AccountId] Uniqueidentifier NULL,
  [WalletBalance] Float NOT NULL,
Primary Key ([TicketMediaMatchId])
) 
go

Create table [tbTicket]
(
  [TicketId] Uniqueidentifier NOT NULL,
  [TicketMediaMatchId] Uniqueidentifier NULL,
  [SaleItemDetailId] Uniqueidentifier NOT NULL,
  [ProductId] Uniqueidentifier NULL,
  [SaleChannelId] Uniqueidentifier NULL,
  [PerformanceTypeId] Uniqueidentifier NULL,
  [PerformanceSetId] Uniqueidentifier NULL,
  [LicenseId] Smallint NOT NULL,
  [TicketStatus] Smallint NOT NULL,
  [StationSerial] Smallint NOT NULL,
  [TicketSerial] Smallint NOT NULL,
  [EncodeDateTime] Datetime NOT NULL,
  [EncodeFiscalDate] Datetime NOT NULL,
  [ValidateDateTime] Datetime NULL,
  [FirstUsageDateTime] Datetime NULL,
  [EntitlementData] Ntext NULL,
  [SeatHoldId] Uniqueidentifier NULL,
Primary Key ([TicketId])
) 
go

Create table [tbMedia]
(
  [MediaId] Uniqueidentifier NOT NULL,
  [TicketMediaMatchId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [MediaType] Smallint NOT NULL,
  [MediaStatus] Smallint NOT NULL,
  [EncodeFiscalDate] Datetime NOT NULL,
  [StationSerial] Smallint NOT NULL,
  [MediaSerial] Smallint NOT NULL,
  [TransactionSerial] Smallint NOT NULL,
  [PrintDateTime] Datetime NULL,
Primary Key ([MediaId])
) 
go

Create table [tbMediaCode]
(
  [MediaCodeId] Uniqueidentifier NOT NULL,
  [MediaId] Uniqueidentifier NOT NULL,
  [MediaCode] Varchar(50) NOT NULL,
  [MediaCodeType] Smallint NOT NULL,
Primary Key ([MediaCodeId])
) 
go

Create table [tbTranslate]
(
  [TranslateId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [LangISO] Varchar(3) NOT NULL,
  [LabelKey] Varchar(50) NOT NULL,
  [LabelValue] Nvarchar(4000) NOT NULL,
Primary Key ([TranslateId])
) 
go

Create table [tbCategory]
(
  [CategoryId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [EntityType] Smallint NOT NULL,
  [ParentCategoryId] Uniqueidentifier NULL,
  [CategoryCode] Varchar(10) NOT NULL,
  [CategoryName] Nvarchar(30) NOT NULL,
  [RecursiveName] Nvarchar(200) NULL,
  [MaskNames] Nvarchar(200) NULL,
Primary Key ([CategoryId])
) 
go

Create table [tbMask]
(
  [MaskId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [EntityType] Smallint NOT NULL,
  [MaskCode] Varchar(10) NOT NULL,
  [MaskName] Nvarchar(50) NOT NULL,
Primary Key ([MaskId])
) 
go

Create table [tbCategory2Mask]
(
  [Category2MaskId] Uniqueidentifier NOT NULL,
  [MaskId] Uniqueidentifier NOT NULL,
  [CategoryId] Uniqueidentifier NOT NULL,
  [PriorityOrder] Integer NOT NULL,
Primary Key ([Category2MaskId])
) 
go

Create table [tbAccountDetail]
(
  [AccountId] Uniqueidentifier NOT NULL,
  [AllowDistribution] Bit NOT NULL,
  [AllowAdmission] Bit NOT NULL,
  [AllowGeneralAdmission] Bit NOT NULL,
  [AllowCapacityAllocation] Bit NOT NULL,
  [AllowSeatAllocation] Bit NOT NULL,
  [FirstName] Nvarchar(30) NULL,
  [LastName] Nvarchar(30) NULL,
  [CompanyName] Nvarchar(30) NULL,
  [Address] Nvarchar(50) NULL,
  [ZipCode] Nvarchar(30) NULL,
  [City] Nvarchar(30) NULL,
  [Province] Nvarchar(30) NULL,
  [State] Nvarchar(30) NULL,
  [Country] Nvarchar(30) NULL,
  [HomePhone] Nvarchar(30) NULL,
  [BusinessPhone] Nvarchar(30) NULL,
  [MobilePhone] Nvarchar(30) NULL,
  [Fax] Nvarchar(30) NULL,
  [EmailAddress] Nvarchar(30) NULL,
  [ExternalCode] Nvarchar(30) NULL,
Primary Key ([AccountId])
) 
go

Create table [tbMaskItem]
(
  [MaskItemId] Uniqueidentifier NOT NULL,
  [MaskId] Uniqueidentifier NOT NULL,
  [MetaFieldId] Uniqueidentifier NOT NULL,
  [Caption] Nvarchar(50) NULL,
  [Hint] Nvarchar(50) NULL,
  [PosX] Integer NOT NULL,
  [PosY] Integer NOT NULL,
  [Required] Bit NOT NULL,
Primary Key ([MaskItemId])
) 
go

Create table [tbResource]
(
  [ResourceId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [ResourceType] Smallint NOT NULL,
  [CategoryId] Uniqueidentifier NOT NULL,
  [ResourceCode] Varchar(10) NULL,
  [ResourceName] Nvarchar(30) NULL,
  [EntityType] Smallint NULL,
  [EntityId] Uniqueidentifier NULL,
Primary Key ([ResourceId])
) 
go

Create table [tbResourceSchedule]
(
  [ResourceScheduleId] Uniqueidentifier NOT NULL,
  [ResourceId] Uniqueidentifier NOT NULL,
  [Quantity] Char(1) NOT NULL,
  [PerformanceId] Uniqueidentifier NOT NULL,
Primary Key ([ResourceScheduleId])
) 
go

Create table [tbLabel]
(
  [LabelId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [LabelType] Smallint NOT NULL,
  [LabelCode] Varchar(10) NOT NULL,
  [LabelName] Nvarchar(30) NOT NULL,
Primary Key ([LabelId])
) 
go

Create table [tbResourceProperty]
(
  [ResourcePropertyId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [ResourcePropertyCode] Varchar(10) NOT NULL,
  [ResourcePropertyName] Nvarchar(30) NOT NULL,
Primary Key ([ResourcePropertyId])
) 
go

Create table [tbEvent2ResourceProperty]
(
  [Event2ResourcePropertyId] Uniqueidentifier NOT NULL,
  [CategoryId] Uniqueidentifier NOT NULL,
  [EventId] Uniqueidentifier NOT NULL,
  [Quantity] Integer NOT NULL,
  [AddAttendees] Bit NOT NULL,
  [Mandatory] Bit NOT NULL,
Primary Key ([Event2ResourcePropertyId])
) 
go

Create table [tbResource2ResourceProperty]
(
  [Resource2ResourcePropertyId] Uniqueidentifier NOT NULL,
  [ResourceId] Uniqueidentifier NOT NULL,
  [ResourcePropertyId] Uniqueidentifier NOT NULL,
Primary Key ([Resource2ResourcePropertyId])
) 
go

Create table [tbCurrency]
(
  [CurrencyId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [CurrencyType] Smallint NOT NULL,
  [ISOCode] Varchar(3) NOT NULL,
  [ISOCodeNumeric] Integer NOT NULL,
  [Symbol] Nvarchar(10) NOT NULL,
  [CurrencyName] Nvarchar(30) NOT NULL,
  [DisplayFormat] Varchar(30) NULL,
  [ExchangeRate] Float NOT NULL,
  [RoundDecimals] Smallint NOT NULL,
Primary Key ([CurrencyId])
) 
go

Create table [tbLoginLog]
(
  [LoginLogId] Uniqueidentifier NOT NULL,
  [UserAccountId] Uniqueidentifier NOT NULL,
  [WorkstationId] Uniqueidentifier NOT NULL,
  [LoginDateTime] Datetime NOT NULL,
  [LogType] Smallint NOT NULL,
  [IPAddress] Varchar(15) NULL,
Primary Key ([LoginLogId])
) 
go

Create table [tbRepository]
(
  [RepositoryId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [EntityType] Smallint NOT NULL,
  [EntityId] Uniqueidentifier NOT NULL,
  [FileName] Nvarchar(50) NOT NULL,
  [Description] Nvarchar(50) NULL,
  [Version] Integer NOT NULL,
  [DocData] Image NOT NULL,
  [LastUpdate] Datetime NOT NULL,
  [Thumb] Image NULL,
  [Small] Image NULL,
  [Large] Image NULL,
Primary Key ([RepositoryId])
) 
go

Create table [tbHistoryLog]
(
  [HistoryLogId] Uniqueidentifier NOT NULL,
  [EntityType] Smallint NOT NULL,
  [EntityId] Uniqueidentifier NOT NULL,
  [LogDateTime] Datetime NOT NULL,
  [UserAccountId] Uniqueidentifier NOT NULL,
  [WorkstationId] Uniqueidentifier NOT NULL,
  [DataXML] Ntext NULL,
  [LogNote] Nvarchar(100) NULL,
Primary Key ([HistoryLogId])
) 
go

Create table [tbSerial]
(
  [SerialId] Uniqueidentifier NOT NULL,
  [EntityType] Smallint NULL,
  [IdentifierAK] Varchar(32) NOT NULL,
  [ReferenceTime] Varchar(32) NOT NULL,
  [Serial] Integer NOT NULL,
  [LastUpdateGuid] Uniqueidentifier NULL,
Primary Key ([SerialId])
) 
go

Create table [tbNote]
(
  [NoteId] Uniqueidentifier NOT NULL,
  [EntityType] Smallint NOT NULL,
  [EntityId] Uniqueidentifier NOT NULL,
  [NoteDateTime] Datetime NOT NULL,
  [UserAccountId] Uniqueidentifier NOT NULL,
  [WorkstationId] Uniqueidentifier NOT NULL,
  [Note] Ntext NOT NULL,
Primary Key ([NoteId])
) 
go

Create table [tbRepositoryIndex]
(
  [RepositoryIndexId] Uniqueidentifier NOT NULL,
  [EntityType] Smallint NOT NULL,
  [EntityId] Uniqueidentifier NOT NULL,
  [RepositoryId] Uniqueidentifier NOT NULL,
  [RepositoryIndexType] Smallint NOT NULL,
Primary Key ([RepositoryIndexId])
) 
go

Create table [tbRichDesc]
(
  [RichDescId] Uniqueidentifier NOT NULL,
  [EntityType] Smallint NOT NULL,
  [EntityId] Uniqueidentifier NOT NULL,
  [LangISO] Varchar(3) NOT NULL,
  [Description] Ntext NOT NULL,
Primary Key ([RichDescId])
) 
go

Create table [tbProduct2AttributeItem]
(
  [Product2AttributeItemId] Uniqueidentifier NOT NULL,
  [ProductId] Uniqueidentifier NOT NULL,
  [AttributeItemId] Uniqueidentifier NOT NULL,
  [SelectionType] Smallint NOT NULL,
Primary Key ([Product2AttributeItemId])
) 
go

Create table [tbEntitlement]
(
  [EntitlementId] Uniqueidentifier NOT NULL,
  [EntityType] Smallint NOT NULL,
  [EntityId] Uniqueidentifier NOT NULL,
  [EntitlementData] Ntext NOT NULL,
Primary Key ([EntitlementId])
) 
go

Create table [tbLicense]
(
  [LicenseId] Smallint NOT NULL,
  [AccountId] Uniqueidentifier NULL,
  [LicenseParams] Ntext NULL,
  [LastUpdate] Datetime NULL,
Primary Key ([LicenseId])
) 
go

Create table [tbCache]
(
  [CacheId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [EntityType] Smallint NOT NULL,
  [EntityId] Uniqueidentifier NULL,
  [CacheData] Ntext NULL,
  [LastUpdate] Datetime NOT NULL,
  [InsertUpdate] Bit NOT NULL,
Primary Key ([CacheId])
) 
go

Create table [tbEntitlement2Event]
(
  [Entitlement2EventId] Uniqueidentifier NOT NULL,
  [EntitlementId] Uniqueidentifier NOT NULL,
  [EventId] Uniqueidentifier NOT NULL,
Primary Key ([Entitlement2EventId])
) 
go

Create table [tbUpload]
(
  [UploadId] Uniqueidentifier NOT NULL,
  [WorkstationId] Uniqueidentifier NOT NULL,
  [UploadStatus] Smallint NOT NULL,
  [RequestDateTime] Datetime NOT NULL,
  [StartDateTime] Datetime NULL,
  [EndDateTime] Datetime NULL,
  [MsgRequest] Ntext NOT NULL,
Primary Key ([UploadId])
) 
go

Create table [tbUploadLog]
(
  [UploadLogId] Uniqueidentifier NOT NULL,
  [UploadId] Uniqueidentifier NOT NULL,
  [LogDateTime] Datetime NOT NULL,
  [LogMessage] Ntext NOT NULL,
Primary Key ([UploadLogId])
) 
go

Create table [tbPayment]
(
  [PaymentId] Uniqueidentifier NOT NULL,
  [TransactionId] Uniqueidentifier NOT NULL,
  [PaymentFiscalDate] Datetime NOT NULL,
  [PaymentDateTime] Datetime NOT NULL,
  [PaymentStatus] Smallint NOT NULL,
  [PaymentType] Smallint NOT NULL,
  [PaymentAmount] Float NOT NULL,
  [CurrencyAmount] Float NOT NULL,
  [ExchangeRate] Float NOT NULL,
Primary Key ([PaymentId])
) 
go

Create table [tbSaleItem]
(
  [SaleItemId] Uniqueidentifier NOT NULL,
  [SaleId] Uniqueidentifier NOT NULL,
  [ProductId] Uniqueidentifier NOT NULL,
  [SaleChannelId] Uniqueidentifier NULL,
  [PerformanceTypeId] Uniqueidentifier NULL,
  [PerformanceSetId] Uniqueidentifier NULL,
  [UnitRawPrice] Float NOT NULL,
  [TaxCalcType] Smallint NOT NULL,
  [UnitAmount] Float NOT NULL,
  [UnitTax] Float NOT NULL,
  [Quantity] Smallint NOT NULL,
  [TotalAmount] Float NOT NULL,
  [TotalTax] Float NOT NULL,
Primary Key ([SaleItemId])
) 
go

Create table [tbPerformanceSet]
(
  [PerformanceSetId] Uniqueidentifier NOT NULL,
  [PerformanceId] Uniqueidentifier NOT NULL,
Primary Key ([PerformanceSetId])
) 
go

Create table [tbSaleItemDetail]
(
  [SaleItemDetailId] Uniqueidentifier NOT NULL,
  [SaleItemId] Uniqueidentifier NOT NULL,
  [TicketMediaMatchId] Uniqueidentifier NULL,
  [SeatHoldId] Uniqueidentifier NULL,
Primary Key ([SaleItemDetailId])
) 
go

Create table [tbTransactionLink]
(
  [TransactionLinkId] Uniqueidentifier NOT NULL,
  [TransactionId] Uniqueidentifier NOT NULL,
  [EntityType] Smallint NOT NULL,
  [EntityId] Uniqueidentifier NOT NULL,
Primary Key ([TransactionLinkId])
) 
go

Create table [tbAccessPoint]
(
  [AptWorkstationId] Uniqueidentifier NOT NULL,
  [ControllerWorkstationId] Uniqueidentifier NULL,
  [EntryControl] Smallint NOT NULL,
  [ExitControl] Smallint NOT NULL,
  [ReentryControl] Smallint NOT NULL,
  [CounterMode] Smallint NOT NULL,
  [EntryCount] Integer NOT NULL,
  [ExitCount] Integer NOT NULL,
  [HardwareCode] Varchar(10) NULL,
  [DriverId] Uniqueidentifier NULL,
  [Settings] Ntext NULL,
Primary Key ([AptWorkstationId])
) 
go

Create table [tbTicketUsage]
(
  [TicketUsageId] Uniqueidentifier NOT NULL,
  [UsageDateTime] Datetime NOT NULL,
  [UsageType] Smallint NOT NULL,
  [ValidateResult] Smallint NOT NULL,
  [MediaCodeId] Uniqueidentifier NOT NULL,
  [AptWorkstationId] Uniqueidentifier NOT NULL,
  [TicketId] Uniqueidentifier NULL,
  [AccessAreaAccountId] Uniqueidentifier NULL,
  [PerformanceId] Uniqueidentifier NULL,
Primary Key ([TicketUsageId])
) 
go

Create table [tbAccessPoint2Area]
(
  [AccessPoint2AreaId] Uniqueidentifier NOT NULL,
  [AptWorkstationId] Uniqueidentifier NOT NULL,
  [AccessAreaAccountId] Uniqueidentifier NOT NULL,
Primary Key ([AccessPoint2AreaId])
) 
go

Create table [tbPaymentCard]
(
  [PaymentId] Uniqueidentifier NOT NULL,
  [AuthId] Uniqueidentifier NOT NULL,
Primary Key ([PaymentId])
) 
go

Create table [tbPaymentCredit]
(
  [PaymentId] Uniqueidentifier NOT NULL,
  [CreditStatus] Smallint NOT NULL,
  [AccountId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [DueDate] Datetime NULL,
  [SettleTransactionId] Uniqueidentifier NULL,
  [VoucherId] Uniqueidentifier NULL,
Primary Key ([PaymentId])
) 
go

Create table [tbVoucher]
(
  [VoucherId] Uniqueidentifier NOT NULL,
  [TemplateVoucherId] Uniqueidentifier NULL,
  [AccountId] Uniqueidentifier NOT NULL,
  [VoucherType] Smallint NOT NULL,
  [VoucherStatus] Smallint NOT NULL,
  [VoucherCode] Varchar(10) NOT NULL,
  [VoucherName] Nvarchar(50) NULL,
  [CreateDate] Datetime NOT NULL,
  [StartDate] Datetime NULL,
  [EndDate] Datetime NULL,
  [MaxItems] Smallint NULL,
Primary Key ([VoucherId])
) 
go

Create table [tbVoucherItem]
(
  [VoucherItemId] Uniqueidentifier NOT NULL,
  [VoucherId] Uniqueidentifier NOT NULL,
  [MinQuantity] Smallint NOT NULL,
  [MaxQuantity] Smallint NULL,
  [ProductId] Uniqueidentifier NOT NULL,
Primary Key ([VoucherItemId])
) 
go

Create table [tbDriver]
(
  [DriverId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [DriverType] Smallint NOT NULL,
  [DriverName] Nvarchar(50) NOT NULL,
  [LibraryName] Varchar(100) NOT NULL,
  [ClassAlias] Varchar(25) NOT NULL,
Primary Key ([DriverId])
) 
go

Create table [tbPlugin]
(
  [PluginId] Uniqueidentifier NOT NULL,
  [DriverId] Uniqueidentifier NOT NULL,
  [WorkstationId] Uniqueidentifier NULL,
  [PluginName] Nvarchar(50) NULL,
  [PluginEnabled] Bit NOT NULL,
  [PluginSettings] Ntext NULL,
  [PriorityOrder] Smallint NULL,
Primary Key ([PluginId])
) 
go

Create table [tbPortfolioShare]
(
  [PortfolioShareId] Uniqueidentifier NOT NULL,
  [TicketMediaMatchId] Uniqueidentifier NOT NULL,
  [EntityType] Smallint NOT NULL,
  [EntityId] Uniqueidentifier NOT NULL,
Primary Key ([PortfolioShareId])
) 
go

Create table [tbPaymentWallet]
(
  [PaymentId] Uniqueidentifier NOT NULL,
  [TicketMediaMatchId] Uniqueidentifier NOT NULL,
  [MediaCodeId] Uniqueidentifier NOT NULL,
Primary Key ([PaymentId])
) 
go

Create table [tbPortfolioLedger]
(
  [PortfolioLedgerId] Uniqueidentifier NOT NULL,
  [TransactionId] Uniqueidentifier NOT NULL,
  [TicketMediaMatchId] Uniqueidentifier NOT NULL,
  [PaymentId] Uniqueidentifier NULL,
  [MediaCodeId] Uniqueidentifier NULL,
  [Amount] Float NOT NULL,
Primary Key ([PortfolioLedgerId])
) 
go

Create table [tbSeatSector]
(
  [SeatSectorId] Uniqueidentifier NOT NULL,
  [AcAreaAccountId] Uniqueidentifier NOT NULL,
  [ParentSectorId] Uniqueidentifier NULL,
  [SeatSectorType] Smallint NOT NULL,
  [SeatSectorCode] Varchar(10) NULL,
  [SeatSectorName] Nvarchar(30) NOT NULL,
Primary Key ([SeatSectorId])
) 
go

Create table [tbAuth]
(
  [AuthId] Uniqueidentifier NOT NULL,
  [LicenseId] Smallint NOT NULL,
  [StationSerial] Smallint NOT NULL,
  [WorkstationId] Uniqueidentifier NULL,
  [UserAccountId] Uniqueidentifier NULL,
  [AuthProcessorType] Smallint NOT NULL,
  [ExternalAuth] Bit NOT NULL,
  [AuthType] Smallint NOT NULL,
  [AuthStatus] Smallint NOT NULL,
  [AuthAmount] Float NOT NULL,
  [RequestDateTime] Datetime NOT NULL,
  [StartDateTime] Datetime NULL,
  [EndDateTime] Datetime NULL,
  [CardNumber] Varchar(40) NULL,
  [CardExpDate] Varchar(4) NULL,
  [CardHolderName] Varchar(30) NULL,
  [InputType] Smallint NOT NULL,
  [AuthorizationMode] Smallint NOT NULL,
  [AuthorizationCode] Varchar(20) NULL,
  [CustomData] Ntext NULL,
Primary Key ([AuthId])
) 
go

Create table [tbSeatTemplate]
(
  [SeatTemplateId] Uniqueidentifier NOT NULL,
  [PerformanceId] Uniqueidentifier NULL,
  [SeatSectorId] Uniqueidentifier NOT NULL,
  [AttributeItemId] Uniqueidentifier NOT NULL,
  [SeatStatus] Smallint NOT NULL,
  [QuantityMin] Integer NOT NULL,
  [QuantityMax] Integer NOT NULL,
  [Weight] Integer NOT NULL,
  [SeqNumber] Integer NOT NULL,
  [BreakAfter] Bit NOT NULL,
  [AisleLeft] Bit NOT NULL,
  [AisleRight] Bit NOT NULL,
  [SeatCol] Nvarchar(15) NULL,
  [SeatRow] Nvarchar(15) NULL,
  [GraphicId] Uniqueidentifier NULL,
Primary Key ([SeatTemplateId])
) 
go

Create table [tbSeat]
(
  [SeatId] Uniqueidentifier NOT NULL,
  [SeatTemplateId] Uniqueidentifier NOT NULL,
  [PerformanceId] Uniqueidentifier NOT NULL,
  [QuantityHeld] Integer NOT NULL,
  [QuantityReserved] Integer NOT NULL,
  [QuantityPaid] Integer NOT NULL,
Primary Key ([SeatId])
) 
go

Create table [tbSeatHold]
(
  [SeatHoldId] Uniqueidentifier NOT NULL,
  [HoldId] Uniqueidentifier NOT NULL,
  [WorkstationId] Uniqueidentifier NOT NULL,
  [UserAccountId] Uniqueidentifier NOT NULL,
  [HoldStatus] Smallint NOT NULL,
  [HoldDateTime] Datetime NOT NULL,
  [ExpireDateTime] Datetime NULL,
  [PerformanceSetId] Uniqueidentifier NOT NULL,
  [SeatSectorId] Uniqueidentifier NOT NULL,
  [AttributeItemId] Uniqueidentifier NOT NULL,
  [NumSeats] Integer NOT NULL,
  [SaleCode] Varchar(20) NULL,
  [Paid] Bit NOT NULL,
Primary Key ([SeatHoldId])
) 
go

Create table [tbSeatLink]
(
  [SeatLinkId] Uniqueidentifier NOT NULL,
  [SeatId] Uniqueidentifier NOT NULL,
  [EntityType] Smallint NOT NULL,
  [EntityId] Uniqueidentifier NOT NULL,
Primary Key ([SeatLinkId])
) 
go


Create UNIQUE Index [UQ_AccountTree] ON [tbAccountTree] ([LicenseId] ,[AccountId] ) 
go
Create Index [IDX_LookupItem] ON [tbLookupItem] ([TableCode] ,[ItemCode] ) 
go
Create UNIQUE Index [UQ_AccountFinance] ON [tbAccountFinance] ([LicenseId] ,[AccountId] ) 
go
Create UNIQUE Index [UQ_MetaData] ON [tbMetaData] ([EntityType] ,[EntityId] ,[MetaFieldId] ) 
go
Create UNIQUE Index [UQ_MetaField_Code] ON [tbMetaField] ([LicenseId] ,[MetaFieldCode] ) 
go
Create UNIQUE Index [UQ_Workstation_Code] ON [tbWorkstation] ([LicenseId] ,[WorkstationCode] ) 
go
Create UNIQUE Index [UQ_Workstation_StationSerial] ON [tbWorkstation] ([LicenseId] ,[StationSerial] ) 
where StationSerial is not null and StationSerial <> 0

go
Create UNIQUE Index [UQ_Workstation_ActivationKey] ON [tbWorkstation] ([ActivationKey] ) 
where ActivationKey is not null

go
Create UNIQUE Index [UQ_Event_EventCode] ON [tbEvent] ([LicenseId] ,[EventCode] ) 
go
Create UNIQUE Index [UQ_Product_ProductCode] ON [tbProduct] ([LicenseId] ,[ProductCode] ) 
go
Create Index [IDX_Product_ParentEntity] ON [tbProduct] ([ParentEntityType] ,[ParentEntityId] ) 
go
Create Index [IDX_Product_ParentEntityId] ON [tbProduct] ([ParentEntityId] ) 
go
Create Index [IDX_Attribute_ParentEntity] ON [tbAttribute] ([ParentEntityType] ,[ParentEntityId] ) 
go
Create Index [IDX_Attribute_ParentEntityId] ON [tbAttribute] ([ParentEntityId] ) 
go
Create UNIQUE Index [UQ_Attribute_Code] ON [tbAttribute] ([LicenseId] ,[AttributeCode] ) 
go
Create UNIQUE Index [UQ_ProductPrice] ON [tbProductPrice] ([ProductId] ,[SaleChannelId] ,[PerformanceTypeId] ) 
go
Create Index [IDX_PerformanceType_ParentEntity] ON [tbPerformanceType] ([ParentEntityType] ,[ParentEntityId] ) 
go
Create Index [IDX_PerformanceType_ParentEntityId] ON [tbPerformanceType] ([ParentEntityId] ) 
go
Create UNIQUE Index [UQ_PerformanceType_Code] ON [tbPerformanceType] ([LicenseId] ,[PerformanceTypeCode] ) 
go
Create UNIQUE Index [UQ_SaleChannelCode] ON [tbSaleChannel] ([LicenseId] ,[SaleChannelCode] ) 
go
Create Index [IDX_Performance_EventDateTime] ON [tbPerformance] ([EventId] ,[DateTimeFrom] ) 
go
Create UNIQUE Index [UQ_Role_Code] ON [tbRole] ([LicenseId] ,[RoleCode] ) 
go
Create Index [IDX_Sale_HoldId] ON [tbSale] ([HoldId] ) 
go
Create Index [UQ_Media] ON [tbMedia] ([LicenseId] ,[EncodeFiscalDate] ,[StationSerial] ,[MediaSerial] ) 
go
Create UNIQUE Index [UQ_MediaCode] ON [tbMediaCode] ([MediaCode] ) 
go
Create UNIQUE Index [UQ_Translate] ON [tbTranslate] ([LicenseId] ,[LangISO] ,[LabelKey] ) 
go
Create UNIQUE Index [UQ_Category_Code] ON [tbCategory] ([LicenseId] ,[CategoryCode] ) 
go
Create UNIQUE Index [UQ_Mask_Code] ON [tbMask] ([LicenseId] ,[MaskCode] ) 
go
Create UNIQUE Index [UQ_Category2Mask] ON [tbCategory2Mask] ([MaskId] ,[CategoryId] ) 
go
Create UNIQUE Index [UQ_MaskItem] ON [tbMaskItem] ([MaskId] ,[MetaFieldId] ) 
go
Create Index [IDX_Repository] ON [tbRepository] ([LicenseId] ,[EntityType] ,[EntityId] ) 
go
Create Index [IDX_HistoryLog_Entity] ON [tbHistoryLog] ([EntityType] ,[EntityId] ,[LogDateTime] ) 
go
Create Index [IDX_Note_Entity] ON [tbNote] ([EntityType] ,[EntityId] ,[NoteDateTime] ) 
go
Create Index [IDX_RepositoryIndex_EntityId] ON [tbRepositoryIndex] ([EntityId] ) 
go
Create Index [IDX_RichDesc_EntityLang] ON [tbRichDesc] ([EntityId] ,[LangISO] ) 
go
Create Index [IDX_Entitlement_Entity] ON [tbEntitlement] ([EntityType] ,[EntityId] ) 
go
Create UNIQUE Index [UQ_Entitlement_EntityId] ON [tbEntitlement] ([EntityId] ) 
go
Create UNIQUE Index [UQ_License_AccountId] ON [tbLicense] ([AccountId] ) 
go
Create UNIQUE Index [UQ_Cache_Entity] ON [tbCache] ([LicenseId] ,[EntityType] ,[EntityId] ) 
go
Create Index [IDX_Upload_StatusAndTime] ON [tbUpload] ([UploadStatus] ,[RequestDateTime] ) 
go
Create Index [IDX_TransactionLink_Entity] ON [tbTransactionLink] ([EntityType] ,[EntityId] ) 
go
Create Index [IDX_TransactionLink_EntityId] ON [tbTransactionLink] ([EntityId] ) 
go
Create Index [IDX_TicketUsage_TicketDateTime] ON [tbTicketUsage] ([TicketId] ,[UsageDateTime] ) 
go
Create Index [IDX_TicketUsage_MediaDateTime] ON [tbTicketUsage] ([MediaCodeId] ,[UsageDateTime] ) 
go
Create Index [IDX_PortfolioShare_Entity] ON [tbPortfolioShare] ([EntityType] ,[EntityId] ) 
go
Create Index [IDX_PortfolioShare_EntityId] ON [tbPortfolioShare] ([EntityId] ) 
go
Create Index [IX_SeatHold_HoldId] ON [tbSeatHold] ([HoldId] ) 
go
Create Index [IX_SeatLink_EntityId] ON [tbSeatLink] ([EntityId] ) 
go
Create Index [IX_DBInfo_LastUpdate] ON [tbDBInfo] ([LastUpdate] Desc) 
go

Alter table [tbAccountTree] add  foreign key([AccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbAccountTree] add  foreign key([RootAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbAccountTree] add  foreign key([ParentAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbAccountLink] add  foreign key([AccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbLogin] add  foreign key([AccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbAccount2Role] add  foreign key([AccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbSale] add  foreign key([AccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbTicketMediaMatch] add  foreign key([AccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbAccountDetail] add  foreign key([AccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbAccountFinance] add  foreign key([AccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbSale] add  foreign key([UserAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbTransaction] add  foreign key([UserAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbLoginLog] add  foreign key([UserAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbHistoryLog] add  foreign key([UserAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbNote] add  foreign key([UserAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbEvent] add  foreign key([ProducerAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbPerformance] add  foreign key([LocationAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbPerformance] add  foreign key([AccessAreaAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbEvent] add  foreign key([AccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbWorkstation] add  foreign key([LocationAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbWorkstation] add  foreign key([OpAreaAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbLicense] add  foreign key([AccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbTicketUsage] add  foreign key([AccessAreaAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbAccessPoint2Area] add  foreign key([AccessAreaAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbPaymentCredit] add  foreign key([AccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbVoucher] add  foreign key([AccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbSeatSector] add  foreign key([AcAreaAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbAuth] add  foreign key([UserAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbSeatHold] add  foreign key([UserAccountId]) references [tbAccount] ([AccountId])  on update no action on delete no action 
go
Alter table [tbLookupItem] add  foreign key([TableCode]) references [tbLookupTable] ([TableCode])  on update no action on delete no action 
go
Alter table [tbMetaData] add  foreign key([MetaFieldId]) references [tbMetaField] ([MetaFieldId])  on update no action on delete no action 
go
Alter table [tbMaskItem] add  foreign key([MetaFieldId]) references [tbMetaField] ([MetaFieldId])  on update no action on delete no action 
go
Alter table [tbSale] add  foreign key([WorkstationId]) references [tbWorkstation] ([WorkstationId])  on update no action on delete no action 
go
Alter table [tbTransaction] add  foreign key([WorkstationId]) references [tbWorkstation] ([WorkstationId])  on update no action on delete no action 
go
Alter table [tbLoginLog] add  foreign key([WorkstationId]) references [tbWorkstation] ([WorkstationId])  on update no action on delete no action 
go
Alter table [tbHistoryLog] add  foreign key([WorkstationId]) references [tbWorkstation] ([WorkstationId])  on update no action on delete no action 
go
Alter table [tbNote] add  foreign key([WorkstationId]) references [tbWorkstation] ([WorkstationId])  on update no action on delete no action 
go
Alter table [tbUpload] add  foreign key([WorkstationId]) references [tbWorkstation] ([WorkstationId])  on update no action on delete no action 
go
Alter table [tbAccessPoint] add  foreign key([AptWorkstationId]) references [tbWorkstation] ([WorkstationId])  on update no action on delete no action 
go
Alter table [tbAccessPoint] add  foreign key([ControllerWorkstationId]) references [tbWorkstation] ([WorkstationId])  on update no action on delete no action 
go
Alter table [tbPlugin] add  foreign key([WorkstationId]) references [tbWorkstation] ([WorkstationId])  on update no action on delete no action 
go
Alter table [tbAuth] add  foreign key([WorkstationId]) references [tbWorkstation] ([WorkstationId])  on update no action on delete no action 
go
Alter table [tbSeatHold] add  foreign key([WorkstationId]) references [tbWorkstation] ([WorkstationId])  on update no action on delete no action 
go
Alter table [tbPerformance] add  foreign key([EventId]) references [tbEvent] ([EventId])  on update no action on delete no action 
go
Alter table [tbEvent2ResourceProperty] add  foreign key([EventId]) references [tbEvent] ([EventId])  on update no action on delete no action 
go
Alter table [tbEntitlement2Event] add  foreign key([EventId]) references [tbEvent] ([EventId])  on update no action on delete no action 
go
Alter table [tbProductPrice] add  foreign key([ProductId]) references [tbProduct] ([ProductId])  on update no action on delete no action 
go
Alter table [tbProduct2AttributeItem] add  foreign key([ProductId]) references [tbProduct] ([ProductId])  on update no action on delete no action 
go
Alter table [tbSaleItem] add  foreign key([ProductId]) references [tbProduct] ([ProductId])  on update no action on delete no action 
go
Alter table [tbTicket] add  foreign key([ProductId]) references [tbProduct] ([ProductId])  on update no action on delete no action 
go
Alter table [tbVoucherItem] add  foreign key([ProductId]) references [tbProduct] ([ProductId])  on update no action on delete no action 
go
Alter table [tbAttributeItem] add  foreign key([AttributeId]) references [tbAttribute] ([AttributeId])  on update no action on delete no action 
go
Alter table [tbProduct2AttributeItem] add  foreign key([AttributeItemId]) references [tbAttributeItem] ([AttributeItemId])  on update no action on delete no action 
go
Alter table [tbSeatTemplate] add  foreign key([AttributeItemId]) references [tbAttributeItem] ([AttributeItemId])  on update no action on delete no action 
go
Alter table [tbSeatHold] add  foreign key([AttributeItemId]) references [tbAttributeItem] ([AttributeItemId])  on update no action on delete no action 
go
Alter table [tbProductPrice] add  foreign key([PerformanceTypeId]) references [tbPerformanceType] ([PerformanceTypeId])  on update no action on delete no action 
go
Alter table [tbPerformance] add  foreign key([PerformanceTypeId]) references [tbPerformanceType] ([PerformanceTypeId])  on update no action on delete no action 
go
Alter table [tbSaleItem] add  foreign key([PerformanceTypeId]) references [tbPerformanceType] ([PerformanceTypeId])  on update no action on delete no action 
go
Alter table [tbTicket] add  foreign key([PerformanceTypeId]) references [tbPerformanceType] ([PerformanceTypeId])  on update no action on delete no action 
go
Alter table [tbProductPrice] add  foreign key([SaleChannelId]) references [tbSaleChannel] ([SaleChannelId])  on update no action on delete no action 
go
Alter table [tbAccountFinance] add  foreign key([SaleChannelId]) references [tbSaleChannel] ([SaleChannelId])  on update no action on delete no action 
go
Alter table [tbSaleItem] add  foreign key([SaleChannelId]) references [tbSaleChannel] ([SaleChannelId])  on update no action on delete no action 
go
Alter table [tbTicket] add  foreign key([SaleChannelId]) references [tbSaleChannel] ([SaleChannelId])  on update no action on delete no action 
go
Alter table [tbResourceSchedule] add  foreign key([PerformanceId]) references [tbPerformance] ([PerformanceId])  on update no action on delete no action 
go
Alter table [tbPerformanceSet] add  foreign key([PerformanceId]) references [tbPerformance] ([PerformanceId])  on update no action on delete no action 
go
Alter table [tbTicketUsage] add  foreign key([PerformanceId]) references [tbPerformance] ([PerformanceId])  on update no action on delete no action 
go
Alter table [tbSeatTemplate] add  foreign key([PerformanceId]) references [tbPerformance] ([PerformanceId])  on update no action on delete no action 
go
Alter table [tbSeat] add  foreign key([PerformanceId]) references [tbPerformance] ([PerformanceId])  on update no action on delete no action 
go
Alter table [tbAccount2Role] add  foreign key([RoleId]) references [tbRole] ([RoleId])  on update no action on delete no action 
go
Alter table [tbTransaction] add  foreign key([SaleId]) references [tbSale] ([SaleId])  on update no action on delete no action 
go
Alter table [tbSaleItem] add  foreign key([SaleId]) references [tbSale] ([SaleId])  on update no action on delete no action 
go
Alter table [tbTransactionItem] add  foreign key([TransactionId]) references [tbTransaction] ([TransactionId])  on update no action on delete no action 
go
Alter table [tbPayment] add  foreign key([TransactionId]) references [tbTransaction] ([TransactionId])  on update no action on delete no action 
go
Alter table [tbTransactionLink] add  foreign key([TransactionId]) references [tbTransaction] ([TransactionId])  on update no action on delete no action 
go
Alter table [tbPaymentCredit] add  foreign key([SettleTransactionId]) references [tbTransaction] ([TransactionId])  on update no action on delete no action 
go
Alter table [tbPortfolioLedger] add  foreign key([TransactionId]) references [tbTransaction] ([TransactionId])  on update no action on delete no action 
go
Alter table [tbTicket] add  foreign key([TicketMediaMatchId]) references [tbTicketMediaMatch] ([TicketMediaMatchId])  on update no action on delete no action 
go
Alter table [tbMedia] add  foreign key([TicketMediaMatchId]) references [tbTicketMediaMatch] ([TicketMediaMatchId])  on update no action on delete no action 
go
Alter table [tbSaleItemDetail] add  foreign key([TicketMediaMatchId]) references [tbTicketMediaMatch] ([TicketMediaMatchId])  on update no action on delete no action 
go
Alter table [tbPortfolioShare] add  foreign key([TicketMediaMatchId]) references [tbTicketMediaMatch] ([TicketMediaMatchId])  on update no action on delete no action 
go
Alter table [tbPaymentWallet] add  foreign key([TicketMediaMatchId]) references [tbTicketMediaMatch] ([TicketMediaMatchId])  on update no action on delete no action 
go
Alter table [tbPortfolioLedger] add  foreign key([TicketMediaMatchId]) references [tbTicketMediaMatch] ([TicketMediaMatchId])  on update no action on delete no action 
go
Alter table [tbTicketUsage] add  foreign key([TicketId]) references [tbTicket] ([TicketId])  on update no action on delete no action 
go
Alter table [tbMediaCode] add  foreign key([MediaId]) references [tbMedia] ([MediaId])  on update no action on delete no action 
go
Alter table [tbTicketUsage] add  foreign key([MediaCodeId]) references [tbMediaCode] ([MediaCodeId])  on update no action on delete no action 
go
Alter table [tbPaymentWallet] add  foreign key([MediaCodeId]) references [tbMediaCode] ([MediaCodeId])  on update no action on delete no action 
go
Alter table [tbPortfolioLedger] add  foreign key([MediaCodeId]) references [tbMediaCode] ([MediaCodeId])  on update no action on delete no action 
go
Alter table [tbCategory] add  foreign key([ParentCategoryId]) references [tbCategory] ([CategoryId])  on update no action on delete no action 
go
Alter table [tbCategory2Mask] add  foreign key([CategoryId]) references [tbCategory] ([CategoryId])  on update no action on delete no action 
go
Alter table [tbResource] add  foreign key([CategoryId]) references [tbCategory] ([CategoryId])  on update no action on delete no action 
go
Alter table [tbEvent2ResourceProperty] add  foreign key([CategoryId]) references [tbCategory] ([CategoryId])  on update no action on delete no action 
go
Alter table [tbAccountTree] add  foreign key([CategoryId]) references [tbCategory] ([CategoryId])  on update no action on delete no action 
go
Alter table [tbEvent] add  foreign key([CategoryId]) references [tbCategory] ([CategoryId])  on update no action on delete no action 
go
Alter table [tbProduct] add  foreign key([CategoryId]) references [tbCategory] ([CategoryId])  on update no action on delete no action 
go
Alter table [tbWorkstation] add  foreign key([CategoryId]) references [tbCategory] ([CategoryId])  on update no action on delete no action 
go
Alter table [tbCategory2Mask] add  foreign key([MaskId]) references [tbMask] ([MaskId])  on update no action on delete no action 
go
Alter table [tbMaskItem] add  foreign key([MaskId]) references [tbMask] ([MaskId])  on update no action on delete no action 
go
Alter table [tbResourceSchedule] add  foreign key([ResourceId]) references [tbResource] ([ResourceId])  on update no action on delete no action 
go
Alter table [tbResource2ResourceProperty] add  foreign key([ResourceId]) references [tbResource] ([ResourceId])  on update no action on delete no action 
go
Alter table [tbResource2ResourceProperty] add  foreign key([ResourcePropertyId]) references [tbResourceProperty] ([ResourcePropertyId])  on update no action on delete no action 
go
Alter table [tbRepositoryIndex] add  foreign key([RepositoryId]) references [tbRepository] ([RepositoryId])  on update no action on delete no action 
go
Alter table [tbEntitlement2Event] add  foreign key([EntitlementId]) references [tbEntitlement] ([EntitlementId])  on update no action on delete no action 
go
Alter table [tbAccount] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbAccountTree] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbRole] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbAccountFinance] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbSale] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbWorkstation] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbCurrency] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbMetaField] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbMask] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbCategory] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbRepository] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbLabel] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbProduct] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbSaleChannel] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbEvent] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbAttribute] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbPerformanceType] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbResource] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbResourceProperty] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbCache] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbTicket] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbMedia] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbPaymentCredit] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbDriver] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbTranslate] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbAuth] add  foreign key([LicenseId]) references [tbLicense] ([LicenseId])  on update no action on delete no action 
go
Alter table [tbUploadLog] add  foreign key([UploadId]) references [tbUpload] ([UploadId])  on update no action on delete no action 
go
Alter table [tbPaymentCard] add  foreign key([PaymentId]) references [tbPayment] ([PaymentId])  on update no action on delete no action 
go
Alter table [tbPaymentCredit] add  foreign key([PaymentId]) references [tbPayment] ([PaymentId])  on update no action on delete no action 
go
Alter table [tbPaymentWallet] add  foreign key([PaymentId]) references [tbPayment] ([PaymentId])  on update no action on delete no action 
go
Alter table [tbPortfolioLedger] add  foreign key([PaymentId]) references [tbPayment] ([PaymentId])  on update no action on delete no action 
go
Alter table [tbTransactionItem] add  foreign key([SaleItemId]) references [tbSaleItem] ([SaleItemId])  on update no action on delete no action 
go
Alter table [tbSaleItemDetail] add  foreign key([SaleItemId]) references [tbSaleItem] ([SaleItemId])  on update no action on delete no action 
go
Alter table [tbSeatHold] add  foreign key([PerformanceSetId]) references [tbPerformanceSet] ([PerformanceSetId])  on update no action on delete no action 
go
Alter table [tbTicket] add  foreign key([SaleItemDetailId]) references [tbSaleItemDetail] ([SaleItemDetailId])  on update no action on delete no action 
go
Alter table [tbTicketUsage] add  foreign key([AptWorkstationId]) references [tbAccessPoint] ([AptWorkstationId])  on update no action on delete no action 
go
Alter table [tbAccessPoint2Area] add  foreign key([AptWorkstationId]) references [tbAccessPoint] ([AptWorkstationId])  on update no action on delete no action 
go
Alter table [tbVoucher] add  foreign key([TemplateVoucherId]) references [tbVoucher] ([VoucherId])  on update no action on delete no action 
go
Alter table [tbPaymentCredit] add  foreign key([VoucherId]) references [tbVoucher] ([VoucherId])  on update no action on delete no action 
go
Alter table [tbVoucherItem] add  foreign key([VoucherId]) references [tbVoucher] ([VoucherId])  on update no action on delete no action 
go
Alter table [tbPlugin] add  foreign key([DriverId]) references [tbDriver] ([DriverId])  on update no action on delete no action 
go
Alter table [tbAccessPoint] add  foreign key([DriverId]) references [tbDriver] ([DriverId])  on update no action on delete no action 
go
Alter table [tbSeatSector] add  foreign key([ParentSectorId]) references [tbSeatSector] ([SeatSectorId])  on update no action on delete no action 
go
Alter table [tbSeatTemplate] add  foreign key([SeatSectorId]) references [tbSeatSector] ([SeatSectorId])  on update no action on delete no action 
go
Alter table [tbSeatHold] add  foreign key([SeatSectorId]) references [tbSeatSector] ([SeatSectorId])  on update no action on delete no action 
go
Alter table [tbPaymentCard] add  foreign key([AuthId]) references [tbAuth] ([AuthId])  on update no action on delete no action 
go
Alter table [tbSeat] add  foreign key([SeatTemplateId]) references [tbSeatTemplate] ([SeatTemplateId])  on update no action on delete no action 
go
Alter table [tbSeatLink] add  foreign key([SeatId]) references [tbSeat] ([SeatId])  on update no action on delete no action 
go
Alter table [tbTicket] add  foreign key([SeatHoldId]) references [tbSeatHold] ([SeatHoldId])  on update no action on delete no action 
go
Alter table [tbSaleItemDetail] add  foreign key([SeatHoldId]) references [tbSeatHold] ([SeatHoldId])  on update no action on delete no action 
go


Set quoted_identifier on
go


Set quoted_identifier off
go


