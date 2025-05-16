<%@page import="com.vgs.snapp.web.gencache.SrvBO_Cache_LocationTimezone"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String ledgerManualId = pageBase.getNullParameter("ledgerManualId");
DOLedgerManualEntry manualEntry = pageBase.getBL(BLBO_LedgerManual.class).loadLedgerManualEntry(ledgerManualId);
JvDateTime ledgerDateTime = SrvBO_Cache_LocationTimezone.instance().getServerDateTime(manualEntry.LocationId.getString(), manualEntry.LedgerLocalDateTime.getDateTime());  
%>

<v:dialog id="ledgermanual_entry_recap_dialog" width="1300" height="900" title="@Ledger.ManualEntry">
  <v:tab-content>
    <div id="maskedit-container"></div>
 
    <table class="recap-table" style="width:100%">
      <tr>
        <td>
          <v:widget caption="@Common.General">
            <v:widget-block>
              <div class="recap-value-item">
                <v:itl key="@Account.Location"/>
                <span class="recap-value"> <%=manualEntry.LocationName.getHtmlString()%> </span>
              </div>
              <div class="recap-value-item">
                <v:itl key="@Common.DateTime"/>
                <span class="recap-value">
                  <span class="recap-value"><snp:datetime timestamp="<%=ledgerDateTime%>" format="shortdatetime" timezone="location" location="<%=manualEntry.LocationId%>"/></span>
                </span>
              </div>
            </v:widget-block>
            <% if (!manualEntry.LedgerManualDescription.isNull() && !manualEntry.LedgerManualDescription.isSameString("")) { %>
	          <v:widget-block>
	            <div class="recap-value-item">
                  <v:itl key="@Common.Description"/>
                  <span class="recap-value"> <%=manualEntry.LedgerManualDescription.getHtmlString()%> </span>
                </div>
	          </v:widget-block>
            <% } %>
            <% if (manualEntry.AffectClearingLimit.getBoolean()) { %>
              <v:widget-block>
                <div class="recap-value-item">
                  <v:itl key="@Ledger.AffectClearingLimit"/>
                  <span class="recap-value"><snp:entity-link entityId="<%=manualEntry.GateCategoryId%>" entityType="<%=LkSNEntityType.GateCategory%>"><%=manualEntry.GateCategoryName.getHtmlString()%></snp:entity-link></span>
                </div>
              </v:widget-block>
            <% } %>
          </v:widget>
        </td>
        <td>
          <v:widget caption="@Common.Creation">
            <v:widget-block style="overflow:hidden">
              <div class="recap-value-item">
                <v:itl key="@Common.DateTime"/>
                <span class="recap-value">
                  <span class="recap-value"><snp:datetime timestamp="<%=manualEntry.LedgerManualDateTime%>" format="shortdatetime" timezone="local" location="<%=manualEntry.LocationId%>"/></span>
                </span>
              </div>
              <div class="recap-value-item">
                <v:itl key="@Account.Location"/>
                <span class="recap-value">
                  <snp:entity-link entityId="<%=manualEntry.LocationId%>" entityType="<%=LkSNEntityType.Location%>"><%=manualEntry.LocationName.getHtmlString()%></snp:entity-link><br/>
                </span>
              </div>
              <div class="recap-value-item">
                <v:itl key="@Account.OpArea"/>
                <span class="recap-value">
                  <snp:entity-link entityId="<%=manualEntry.OpAreaId%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=manualEntry.OpAreaName.getHtmlString()%></snp:entity-link>
                </span>
              </div>
              <div class="recap-value-item">
                <v:itl key="@Common.Workstation"/>
                <span class="recap-value">
                  <snp:entity-link entityId="<%=manualEntry.WorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>"><%=manualEntry.WorkstationName.getHtmlString()%></snp:entity-link>
                </span>
              </div>
            </v:widget-block>
          </v:widget>
        </td>
      </tr>
      <tr>
      </tr>
    </table>

    <% if (!manualEntry.TicketId.isNull()) { %>
      <% String params = "TicketId=" + manualEntry.TicketId.getString(); %>
      <v:async-grid id="ticket-grid" jsp="portfolio/ticket_grid.jsp" params="<%=params%>" />
	<% } %>

    <table style="width:100%">
      <v:grid id="rule-detail-grid">
        <thead>
          <v:grid-title caption="@Common.Entries"/>
          <tr>
            <td width="40%">
              <v:itl key="@Account.Account"/>
            </td>
            <td width="40%">
              <v:itl key="@Account.Location"/>
            </td>
            <td width="10%" align="right">
              <v:itl key="@Ledger.LedgerDebit"/>
            </td>
            <td width="10%" align="right">
              <v:itl key="@Ledger.LedgerCredit"/><br/>
            </td>
          </tr>
        </thead>
        <tbody>
           <% for (DOLedgerManualEntry.DOLedgerManualEntryItem entryItem : manualEntry.ManualEntryItemList) { %>
             <tr>
               <td>
                 <% String ledgerAccountDisplay = "[" + entryItem.LedgerAccountCode.getString() + "] " + entryItem.LedgerAccountName.getString(); %>
                 <div class="recap-value-item"> <%=JvString.escapeHtml(ledgerAccountDisplay)%></div>
               </td>
               <td>
                 <div class="recap-value-item"> <%=entryItem.LocationName.getHtmlString()%></div>
               </td>
               <td align="right">
                 <%
                   String ledgerDebitAmount = "";
                   if (!entryItem.LedgerDebitAmount.isNull())
                     ledgerDebitAmount = JvString.escapeHtml(entryItem.LedgerDebitAmount.getString().replace("-", ""));
                 %>
                 <div class="recap-value-item"><%=ledgerDebitAmount%></div>
               </td>
               <td align="right">
                <div class="recap-value-item"> <%=entryItem.LedgerCreditAmount.getHtmlString()%></div>
               </td>
             </tr>
           <% } %>              
        </tbody>
      </v:grid>
    </table>
  </v:tab-content>
    
  <script>

  $(document).ready(function() {
    $dlg = $("#ledgermanual_entry_recap_dialog");
    
    $dlg.on("snapp-dialog", function(event, params) {
      params.buttons = [
        {
          text: itl("@Common.Close"),
          click: doCloseDialog
        }
      ]; 
    });
    
    <% String params = "&LoadData=true&readOnly=true&id=" + manualEntry.TransactionId.getEmptyString() + "&EntityType=" + LkSNEntityType.LedgerManual.getCode(); %>
    asyncLoad("#maskedit-container", addTrailingSlash(BASE_URL) + "admin?page=maskedit_widget<%=params%>");
  });
  
  </script>
</v:dialog>

