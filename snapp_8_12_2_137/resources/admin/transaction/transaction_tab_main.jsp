<%@page import="com.vgs.snapp.web.bko.library.BLBO_Installment"%>
<%@page import="com.vgs.snapp.api.installment.APIDef_InstallmentContract_Search"%>
<%@page import="com.vgs.web.library.product.NSystemProduct"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="com.vgs.snapp.web.queue.outbound.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.transaction.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTransaction" scope="request"/>
<jsp:useBean id="transaction" class="com.vgs.snapp.dataobject.transaction.DOTransaction" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String clickReceipt = null;
String trnRcpt_DocTemplateId = rights.TrnReceipt_DocTemplateId.getString(); 
if (trnRcpt_DocTemplateId != null) { 
  LookupItem docEditorType = pageBase.getBL(BLBO_DocTemplate.class).getDocEditorType(trnRcpt_DocTemplateId);
  if (docEditorType.isLookup(LkSNDocEditorType.Report)) 
    clickReceipt = "window.open('" + ConfigTag.getValue("site_url") + "/docproc?DocTemplateId=" + trnRcpt_DocTemplateId + "&p_TransactionId=" + transaction.TransactionId.getHtmlString() + "')";
}

String[] groupEntityIDs = new String[] {pageBase.getId()};
if ((transaction.LedgerCount.getInt() > 0) && transaction.TransactionType.isLookup(LkSNTransactionType.PayPerUse))  
  groupEntityIDs = JvArray.add(pageBase.getBL(BLBO_Transaction.class).findTicketUsageIDs(pageBase.getId()), groupEntityIDs);
String groupEntityIDsString = JvArray.arrayToString(groupEntityIDs, ",");
%>

<v:tab-toolbar>
  <snp:notes-btn entityId="<%=transaction.SaleId.getString()%>" entityType="<%=LkSNEntityType.Sale%>"/>
  
  <v:button-group>
    <v:button caption="@Receipt.Receipt" fa="file-pdf" onclick="<%=clickReceipt%>" include="<%=clickReceipt != null%>"/>
    <snp:btn-report docContext="<%=LkSNContextType.Sale_Transaction%>" caption="@DocTemplate.Reports"/>
  </v:button-group>
  
  <div style="float:right">
    <% String priorTransactionId = transaction.PriorTransactionId.getString(); %>
    <% String hrefPrior = pageBase.getContextURL() + "?page=transaction&id=" + priorTransactionId; %>
    <v:button id="prior-btn" fa="chevron-left" title="@Common.Prior" href="<%=hrefPrior%>" enabled="<%=priorTransactionId != null%>" />
    
    <% String nextTransactionId = transaction.NextTransactionId.getString(); %>
    <% String hrefNext = pageBase.getContextURL() + "?page=transaction&id=" + nextTransactionId; %>
    <v:button id="next-btn" fa="chevron-right" title="@Common.Next" href="<%=hrefNext%>" enabled="<%=nextTransactionId != null%>" />
  </div>
</v:tab-toolbar>

<v:tab-content>

  <table class="recap-table" style="width:100%">
    <tr>      
      <% // Status %>
      <td width="33%" valign="top">
        <v:widget caption="@Common.Info">
          <v:widget-block>
            <v:recap-item caption="@Sale.PNR">
              <snp:entity-link entityId="<%=transaction.SaleId%>" entityType="<%=LkSNEntityType.Sale%>"><%=transaction.SaleCodeDisplay.getHtmlString()%></snp:entity-link>
            </v:recap-item>
            <v:recap-item caption="@Common.Type">
              <%=transaction.TransactionType.getHtmlLookupDesc(pageBase.getLang())%>
            </v:recap-item>
            <v:recap-item caption="@Reservation.Flags">
              <%=transaction.Flags.getHtmlString()%>
            </v:recap-item>
            <v:recap-item valueColor="orange" include="<%=transaction.SaleTaxExempt.getBoolean()%>">
              <v:itl key="@Sale.TaxExempt"/>
            </v:recap-item>
            <v:recap-item caption="@Common.ArchivedOn" valueColor="red" include="<%=!transaction.ArchivedOnDateTime.isNull()%>"><snp:datetime timestamp="<%=transaction.ArchivedOnDateTime%>" format="shortdatetime" timezone="local"/></v:recap-item>
            <v:recap-item caption="@Common.Archivable" valueColor="orange" include="<%=!transaction.ArchivableOnDateTime.isNull()%>"><snp:datetime timestamp="<%=transaction.ArchivableOnDateTime%>" format="shortdatetime" timezone="local"/></v:recap-item>
            <% for (DOTransaction.DOTransactionWarn warn : transaction.TransactionWarnList) { %>
              <v:recap-item valueColor="red">
                <% String warnHint = LkSNTransactionWarn.findHint(warn.TransactionWarn.getLkValue()); %>
                <% if (warnHint != null) { %><v:hint-handle hint="<%=warnHint%>"/><% } %>
                <%=warn.TransactionWarnDesc.getHtmlString()%>
              </v:recap-item>
            <% } %>
          </v:widget-block>

          <v:widget-block include="<%=!transaction.TicketUpdateFieldList.isEmpty()%>">
            <v:recap-item caption="@Common.Fields">
              <% for (DOTransaction.DOTransactionTicketUpdateField ticketUpdateField : transaction.TicketUpdateFieldList) { %>
                <div><%=ticketUpdateField.TicketUpdateFieldDesc.getHtmlString()%></div>
              <% } %>
            </v:recap-item> 
          </v:widget-block>
          
          <v:widget-block>
            <v:recap-item caption="@Common.DateTime">
              <div><snp:datetime timestamp="<%=transaction.SerialDateTime%>" format="shortdatelongtime" timezone="local"/></div>
              <div><snp:datetime timestamp="<%=transaction.SerialDateTime%>" format="shortdatelongtime" timezone="location" location="<%=transaction.LocationId%>"/></div>
            </v:recap-item>
            
            <% JvDateTime fiscalDateTime = transaction.TransactionDateTime.getDateTime(); %>
            <v:recap-item caption="@Common.ServerDateTime" valueColor="red" include="<%=transaction.DateTimeWarn.getBoolean()%>">
              <snp:datetime timestamp="<%=fiscalDateTime%>" format="shortdatetime" timezone="location" location="<%=transaction.LocationId%>"/>
            </v:recap-item>
            
            <% JvDateTime fiscalDate = transaction.TransactionFiscalDate.getDateTime(); %>
            <v:recap-item caption="@Common.FiscalDate">
              <%=JvString.htmlEncode(pageBase.format(transaction.SerialFiscalDate, pageBase.getShortDateFormat()))%>
            </v:recap-item>
            <v:recap-item caption="@Common.ServerFiscalDate" valueColor="red" include="<%=!JvDateTime.isSameDay(fiscalDate, transaction.SerialFiscalDate.getDateTime())%>">
              <%=pageBase.format(fiscalDate, pageBase.getShortDateFormat())%>
            </v:recap-item>
            
            <v:recap-item caption="@Common.Serial">
              <%=transaction.TransactionSerial.getHtmlString()%>
            </v:recap-item>
            <v:recap-item caption="@Box.Box" include="<%=!transaction.BoxId.isNull()%>">
              <snp:entity-link entityId="<%=transaction.BoxId%>" entityType="<%=LkSNEntityType.Box%>"><%=transaction.BoxCode.getHtmlString()%></snp:entity-link>
            </v:recap-item>
          </v:widget-block>
           
          <v:widget-block include="<%=!transaction.JobList.isEmpty()%>">
            <v:recap-item caption="@Task.Task">
              <% for (DOTransactionJob job : transaction.JobList) { %>
                <div><snp:entity-link entityId="<%=job.TaskId%>" entityType="<%=LkSNEntityType.Task%>"><v:label field="<%=job.TaskName%>" translate="true"/></snp:entity-link> &mdash; <snp:entity-link entityId="<%=job.JobId%>" entityType="<%=LkSNEntityType.Job%>"><snp:datetime timezone="local" timestamp="<%=job.JobDateTime%>" format="shortdatetime"/> </snp:entity-link></div>
              <% } %>
            </v:recap-item>
          </v:widget-block>
           
          <v:widget-block include="<%=!transaction.LinkedTransactionList.isEmpty()%>">
            <v:recap-item caption="@Sale.LinkedTransactions">
              <% for (DOTransactionRef link : transaction.LinkedTransactionList) { %>
                <div><snp:entity-link entityId="<%=link.TransactionId%>" entityType="<%=LkSNEntityType.Transaction%>"><%=link.TransactionCode.getHtmlString()%></snp:entity-link></div>
              <% } %>
              <% if (transaction.LinkedTransactionCount.getInt() > transaction.LinkedTransactionList.getSize()) { %>
              <div>
                <a href="javascript:asyncDialogEasy('transaction/linked_transactions_dialog' , 'LinkedTransactionId=<%=transaction.TransactionId.getHtmlString()%>');">
                  <v:itl key="@Common.ShowMore" param1="<%=transaction.LinkedTransactionCount.getString()%>"/>
                </a>
              </div>
              <% } %>
            </v:recap-item>
          </v:widget-block>

          <v:widget-block include="<%=pageBase.isVgsContext(\"BKO\")%>">
            <v:recap-item caption="@Common.Logs" include="<%=!transaction.UploadId.isNull()%>">
              <snp:entity-link entityId="<%=transaction.UploadId%>" entityType="<%=LkSNEntityType.Upload%>">Upload Process</snp:entity-link>
            </v:recap-item>

            <v:recap-item caption="@System.ApiTracing" include="<%=!transaction.ApiLogId.isNull()%>">
              <snp:entity-link entityId="<%=transaction.ApiLogId%>" entityType="<%=LkSNEntityType.ApiLog%>">Trace</snp:entity-link>
            </v:recap-item>
          
            <v:recap-item caption="@Stats.PostProcess" include="<%=!transaction.AsyncFinalize.isEmpty()%>">
              <% String color = LkCommonStatus.findColorHex(LkSN.CommonStatus.findItemByCode(transaction.AsyncFinalize.CommonStatus)); %>
              <i class="fa fa-circle" style="font-size:0.9em;color:<%=color%>"></i>
              <%=transaction.AsyncFinalize.AsyncFinalizeStatus.getHtmlLookupDesc(pageBase.getLang())%>
              
              <% if (transaction.AsyncFinalize.QueueMS.getLong() != 0) { %>
                &mdash; <v:itl key="@System.AsyncFinalize_QueueTimeShort"/> <%=JvString.htmlEncode(JvDateUtils.getSmoothTime(transaction.AsyncFinalize.QueueMS.getLong()))%>
              <% } %>
              <% if (!transaction.AsyncFinalize.ProcMS.isNull()) { %>
                &mdash; <v:itl key="@System.AsyncFinalize_ExecTimeShort"/> <%=JvString.htmlEncode(JvDateUtils.getSmoothTime(transaction.AsyncFinalize.ProcMS.getLong()))%>
              <% } %>
            </v:recap-item>
          </v:widget-block>
          
          <v:widget-block style="overflow:hidden" include="<%=!transaction.OutboundQueueList.isEmpty()%>">
            <%
            boolean externalQueue = rights.ExternalQueue.getBoolean();
            String queueContextURL = pageBase.getBL(BLBO_Outbound.class).calcExternalContextURL();
            %>
            <v:recap-item caption="@Outbound.OutboundQueue" valueStyle="text-align:right">
              <% for (DOOutboundQueueRef obq : transaction.OutboundQueueList) { %>
                <div>
                  <i class="fa fa-circle" style="font-size:0.9em;color:<%=LkCommonStatus.findColorHex(LkSN.CommonStatus.findItemByCode(obq.CommonStatus))%>"></i>
                  <snp:entity-link entityId="<%=obq.OutboundQueueId%>" entityType="<%=LkSNEntityType.OutboundQueue%>" contextURL="<%=queueContextURL%>" openOnNewTab="<%=externalQueue%>">
                    <%=obq.OutboundMessageName.getHtmlString()%>
                  </snp:entity-link>
                </div> 
              <% } %>
            </v:recap-item>
          </v:widget-block>
          
          <% String ledgerManualId = pageBase.getDB().getString("select LedgerManualId from tbLedgerManual where TransactionId=" + JvString.sqlStr(pageBase.getId())); %>
          <v:widget-block style="overflow:hidden" include="<%=ledgerManualId != null%>">
            <v:recap-item caption="@Ledger.LedgerManualEntry" valueStyle="text-align:right">
              <a href="javascript:showManualLedgerDetails('<%=ledgerManualId%>')" class="v-tooltip"><v:itl key="@Ledger.ManualEntry"/></a>
            </v:recap-item>
          </v:widget-block>
        </v:widget>
      </td>
          
      <% // Workstation %>
      <td width="33%">
        <v:widget caption="@Common.Workstation">
          <v:widget-block style="overflow:hidden">
            <v:recap-item caption="@Common.Workstation" valueStyle="text-align:right">
              <div><snp:entity-link entityId="<%=transaction.LocationId%>" entityType="<%=LkSNEntityType.Location%>"><%=transaction.LocationName.getHtmlString()%></snp:entity-link></div>
              <div><snp:entity-link entityId="<%=transaction.OpAreaId%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=transaction.OpAreaName.getHtmlString()%></snp:entity-link></div>
              <div><snp:entity-link entityId="<%=transaction.WorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>"><%=transaction.WorkstationName.getHtmlString()%></snp:entity-link></div>
            </v:recap-item>
          </v:widget-block>
          
          <v:widget-block include="<%=!transaction.AccountList.isEmpty()%>">
            <% for (DOSaleAccountRef account : transaction.AccountList) { %>
              <v:recap-item caption="<%=account.SaleAccountType.getHtmlLookupDesc(pageBase.getLang())%>">
                <snp:entity-link entityId="<%=account.AccountId%>" entityType="<%=account.EntityType.getLkValue()%>">
                  <%=JvString.escapeHtml(JvString.coalesce(account.AccountName.getNullString(true), pageBase.getLang().Account.AnonymousAccount.getText()))%>
                </snp:entity-link>
              </v:recap-item>
            <% } %>
          </v:widget-block>
          
          <v:widget-block>
            <v:recap-item caption="@Common.User">
              <snp:entity-link entityId="<%=transaction.UserAccountId%>" entityType="<%=LkSNEntityType.Person%>"><%=transaction.UserAccountName.getHtmlString()%></snp:entity-link>
            </v:recap-item>
            <v:recap-item caption="@Common.Supervisor" include="<%=!transaction.SupAccountId.isNull()%>">
              <snp:entity-link entityId="<%=transaction.SupAccountId%>" entityType="<%=LkSNEntityType.Person%>"><%=transaction.SupAccountName.getHtmlString()%></snp:entity-link>
            </v:recap-item>
          </v:widget-block>
          
          <v:widget-block>
            <v:recap-item caption="@Common.DurationSelection">
              <%= JvDateUtils.getSmoothTime(transaction.DurationSelection.getInt()*100) %>
            </v:recap-item>
            <v:recap-item caption="@Common.DurationPayment">
              <%= JvDateUtils.getSmoothTime(transaction.DurationPayment.getInt()*100) %>
            </v:recap-item>
            <v:recap-item caption="@Common.DurationPrint">
              <%= JvDateUtils.getSmoothTime(transaction.DurationPrint.getInt()*100) %>
            </v:recap-item>
          </v:widget-block>
        </v:widget>

        <v:widget caption="@Resource.Resources" include="<%=!transaction.ResourceScheduleList.isEmpty()%>">  
          <% request.setAttribute("ResourceList", transaction.ResourceScheduleList.getItems()); %>
          <jsp:include page="../resource/resource_list_widget.jsp">
            <jsp:param name="ParentEntityType" value="<%=LkSNEntityType.Transaction.getCode()%>" />
          </jsp:include>
        </v:widget>
      </td>
      
      <% // Amounts %>
      <td width="33%">
        <v:widget caption="@Common.Amounts">
          <v:widget-block>
            <v:recap-item caption="@Common.Quantity">
              <%=transaction.ItemCount.getHtmlString()%>
            </v:recap-item>
            <% if (transaction.TransactionType.isLookup(LkSNTransactionType.Normal)) { %>
              <% String ticketsText = pageBase.getLang().Ticket.Tickets.getText() + "(" + pageBase.getLang().Common.Used.getText().toLowerCase() + " / " + pageBase.getLang().Common.Total.getText().toLowerCase() + ")";%>
              <v:recap-item caption="<%=ticketsText%>">
                <%=transaction.UsedTicketCount.getInt()%> / <%=transaction.TicketCount.getInt()%>
              </v:recap-item>
              <v:recap-item caption="@Common.SerialRange" include="<%=!transaction.TicketSerialMin.isNull()%>">
                <%=transaction.TicketSerialMin.getHtmlString()%> &ndash; <%=transaction.TicketSerialMax.getHtmlString()%>
              </v:recap-item>
            <% } %>
          </v:widget-block>

          <v:widget-block>
            <v:recap-item caption="@Reservation.TotalAmount"><%=pageBase.formatCurrHtml(transaction.TotalAmount)%></v:recap-item>
            <v:recap-item caption="@Reservation.TotalTax"><%=pageBase.formatCurrHtml(transaction.TotalTax)%></v:recap-item>
          </v:widget-block>

          <v:widget-block>
            <v:recap-item caption="@Reservation.PaidAmount"><%=pageBase.formatCurrHtml(transaction.PaidAmount)%></v:recap-item>
            <v:recap-item caption="@Reservation.PaidTax"><%=pageBase.formatCurrHtml(transaction.PaidTax)%></v:recap-item>
          </v:widget-block>

          <v:widget-block include="<%=transaction.CommissionRecap.CommissionQuantity.getInt() > 0%>">
            <v:recap-item caption="@Commission.CommissionTotalAmount"><%=pageBase.formatCurrHtml(transaction.CommissionRecap.CommissionAmount)%></v:recap-item>
          </v:widget-block>
          
          <v:widget-block style="overflow:hidden" include="<%=(transaction.LedgerCount.getInt() > 0) && rights.AuditLedger.getBoolean()%>">
            <v:recap-item><snp:entity-link entityType="<%=LkSNEntityType.LedgerGroup%>" entityId="<%=transaction.TransactionId%>"><v:itl key="@Ledger.Ledger"/></snp:entity-link></v:recap-item>
          </v:widget-block>
          </v:widget>
      </td>
    </tr>
  </table>
  
  <% if (!transaction.TransactionType.isLookup(LkSNTransactionType.SaleBulkPay, LkSNTransactionType.InstallmentContractManualExport, LkSNTransactionType.InstallmentContractManualUnexport) || (transaction.ItemCount.getInt() > 0)) { %>
    <v:grid>
      <thead>
        <v:grid-title caption="@Common.Items"/>
        <tr>
          <td><v:grid-checkbox header="true"/></td>
          <td>&nbsp;</td>
          <% if (transaction.TransactionType.isLookup(LkSNTransactionType.UpgradeDowngrade)) { %>
          <td width="30%">
            <v:itl key="@Product.ProductType"/> &mdash; <v:itl key="@Common.Options"/><br/>
            <v:itl key="@Performance.Performance"/>
          </td>
          <td width="20%">
            <v:itl key="@Product.SourceProduct"/>
          </td>
          <% } else { %>
          <td width="50%">
            <v:itl key="@Product.ProductType"/> &mdash; <v:itl key="@Common.Options"/><br/>
            <v:itl key="@Performance.Performance"/>
          </td>
          <% } %>
          <td width="20%">
            <v:itl key="@Reservation.Discount"/><br/>
            <v:itl key="@Common.SerialRange"/>
          </td>
          <td width="10%" align="right">
            <v:itl key="@Reservation.UnitAmount"/><br/>
            <v:itl key="@Reservation.UnitTax"/>
          </td>
          <td width="10%" align="right">
            <v:itl key="@Common.Quantity"/><br/>
            <v:itl key="@Reservation.Flag_Paid"/>
          </td>
          <td width="10%" align="right">
            <v:itl key="@Reservation.TotalAmount"/><br/>
            <v:itl key="@Reservation.TotalTax"/>
          </td>
        </tr>
      </thead>
      <tbody>
        <% for (DOTransaction.DOTransactionItemRecap item : transaction.TransactionItemList.filter(item -> item.MainSaleItemId.isNull())) { %>
	        <tr class="grid-row">
	          <td><v:grid-checkbox/></td>
	          <td><v:grid-icon name="<%=item.IconName.getString()%>" repositoryId="<%=item.ProductProfilePictureId.getString()%>"/></td>
	          <td valign="top">
	            <snp:entity-link entityId="<%=item.ProductId%>" entityType="<%=item.ProductEntityType%>">
	              [<%=item.ProductCode.getHtmlString()%>] <%=item.ProductName.getHtmlString()%>
	            </snp:entity-link>
	            <% if (item.OptionsDesc.getEmptyString().length() > 0) { %>
	              &mdash; <%=item.OptionsDesc.getHtmlString()%>
	            <% } %>
	            <% if (item.GiftCardNumber.getEmptyString().length() > 0) { %>
	              &mdash; <%=item.GiftCardNumber.getHtmlString()%>
	            <% } %>
	            <% if (!item.SettleInstallmentContractId.isNull()) { %>
	              &mdash; 
	              <snp:entity-link entityId="<%=item.SettleInstallmentContractId%>" entityType="<%=LkSNEntityType.InstallmentContract%>">
	                <%=item.SettleInstallmentContractCode.getHtmlString()%> #<%=item.SettleInstallmentNumber.getHtmlString()%>
	              </snp:entity-link>
	            <% } %>
	            <% if (item.SlaveItemCount.getInt() != 0) { %>
	              <% String jspTrnItemStat = "transaction/trnitem_stat_tooltip&TransactionId=" + pageBase.getId() + "&SaleItemId=" + item.SaleItemId.getHtmlString(); %>
	              &mdash; <span class="infoicon-stats v-tooltip" data-jsp="<%=jspTrnItemStat%>"></span>
	            <% } %>
	            <br/>
	            <span class="list-subtitle">
	            <% if (!item.DepositAccountId.isNull()) { %>
	              <snp:entity-link entityId="<%=item.DepositAccountId.getString()%>" entityType="<%=LkSNEntityType.Organization%>">
	                <%=item.DepositAccountName.getHtmlString()%>
	              </snp:entity-link>
	            <% } else if (item.PerformanceId.isNull()) { %>
	              <v:itl key="@Common.None"/>
	            <% } else { %>
	              <snp:entity-link entityId="<%=item.EventId%>" entityType="<%=LkSNEntityType.Event%>"><%=item.EventName.getHtmlString()%></snp:entity-link> &raquo;
	              <% if (!item.AdmLocationId.isNull()) { %>
	                <snp:entity-link entityId="<%=item.AdmLocationId%>" entityType="<%=LkSNEntityType.Location%>"><%=item.AdmLocationName.getHtmlString()%></snp:entity-link> &raquo;
	              <% } %>
	              <snp:entity-link entityId="<%=item.PerformanceId%>" entityType="<%=LkSNEntityType.Performance%>"><%=JvString.escapeHtml(pageBase.format(item.PerformanceDateTime, pageBase.getShortDateTimeFormat()))%></snp:entity-link>
	            <% } %>
	            </span>
	          </td>
	          <% if (transaction.TransactionType.isLookup(LkSNTransactionType.UpgradeDowngrade)) { %>
	          <td>
	            <% if (!item.UpgradeTicketId.isNull()) { %>
	              <snp:entity-link entityId="<%=item.UpgradeTicketId.getString()%>" entityType="<%=LkSNEntityType.Ticket%>" clazz="list-title" entityTooltip="false">
	                <%=item.UpgradeTicketCode.getHtmlString()%>
	              </snp:entity-link><br/>
	            <% } %>
	          </td>
	          <% } %>
	          <td>
	            <% if (item.DiscountCount.getInt() > 0) { %>
	              <a href="javascript:showDiscounts('<%=item.SaleItemId.getEmptyString()%>')"><%=pageBase.formatCurrHtml(item.TotalDiscount)%></a>
	            <% } %>
	            <br/>
	            <div class="list-subtitle"><%=item.TicketSerialDesc.getHtmlString()%></div>
	          </td>
	          <td align="right">
	            <%=pageBase.formatCurrHtml(item.UnitAmount)%><br/>
	            <%
	            boolean hasTax = (item.TaxCount.getInt() != 0);
	            String taxTooltipClass = hasTax ? " v-tooltip" : "";
	            String dataJsp = "data-jsp=\"sale/saleitem_tax_tooltip&SaleItemId=" + item.SaleItemId.getHtmlString() + "\"";
	            %>
	            <span class="list-subtitle <%=taxTooltipClass%>" <%=dataJsp%>><%=pageBase.formatCurrHtml(item.UnitTax)%></span>
	          </td>
	          <td align="right">
	            <%=item.Quantity.getHtmlString()%><br/>
	            <span class="list-subtitle"><%=item.PaidQuantity.getHtmlString()%></span>
	          </td>
	          <% boolean isExtraTime = (item.ProductCode.isSameString(NSystemProduct.ExtraTime.getProductCode())); %>
	          <td align="right">
	            <% if (isExtraTime) { %>
	              <% String jspTimeTicket = "product/timedticket/timedticketstatement_tooltip&SaleItemId=" + item.SaleItemId.getHtmlString(); %>
	              <span class="v-tooltip" data-jsp="<%=jspTimeTicket%>">
	                <%=pageBase.formatCurrHtml(item.TotalAmount)%><br/>
	              </span>
	            <% } else {%>
	              <%=pageBase.formatCurrHtml(item.TotalAmount)%><br/>
	            <% }%>          
	            <span class="list-subtitle"><%=pageBase.formatCurrHtml(item.TotalTax)%></span>
	          </td>        
	        </tr>
        <% } %>
      </tbody>
    </v:grid>
  <% } %>

  <% if (transaction.TransactionType.isLookup(LkSNTransactionType.SaleBulkPay)) { %>
    <div style="margin-top:10px">
      <% String params = "show-title=true&BulkSalePayTransactionId=" + pageBase.getId(); %>
      <v:async-grid id="bulkpaidsale-grid" jsp="sale/sale_grid.jsp" params="<%=params%>"></v:async-grid>
    </div>
  <% } %>
  
  <% if (transaction.TransactionType.isLookup(LkSNTransactionType.LedgerBalanceRecalc)) { %>
    <jsp:include page="transaction_tab_main_ledgerbalance_widget.jsp"></jsp:include>
  <% } %>
  
  <% if (!transaction.InstallmentContractList.isEmpty()) { %>
    <% request.setAttribute("searchContract", pageBase.getBL(BLBO_Installment.class).getInstallmentContractSearchResponse(transaction.InstallmentContractList.getItems())); %>
    <jsp:include page="../installment/contract_grid_static.jsp">
      <jsp:param name="title" value="@Installment.InstallmentContracts"/>
    </jsp:include>
  <% } %>
</v:tab-content>

<script>
function showDiscounts(saleItemId) {
  asyncDialogEasy("product/discount_list_dialog", "SaleItemId=" + saleItemId);
}

function showManualLedgerDetails(ledgerManualId) {
  asyncDialogEasy("ledger/ledgermanualentryrecap_dialog", "ledgerManualId=" + ledgerManualId);
}

function getDocExecParams() {
  return "lock_in_params=true&p_TransactionId=<%=pageBase.getId()%>";
}
</script>