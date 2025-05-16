<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageInvoiceList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
  String defaultFromDate = (pageBase.getNullParameter("AccountId") == null) ? pageBase.getBrowserFiscalDate().getXMLDate() : null;
  String defaultToDate = (pageBase.getNullParameter("AccountId") == null) ? pageBase.getBrowserFiscalDate().addDays(1).getXMLDate() : null;
  
  pageBase.setDefaultParameter("FromIssueDate", defaultFromDate);
  pageBase.setDefaultParameter("ToIssueDate", defaultToDate);
  boolean bko = pageBase.isVgsContext("BKO");
  boolean voidButtonEnabled = 
      bko && 
      pageBase.getRights().InvoiceVoid.getBoolean();
  boolean writeOffButtonEnabled = 
      bko && 
      pageBase.getRights().InvoiceWriteOff.getBoolean();
  boolean restoreButtonEnabled = 
      bko && 
      pageBase.getRights().InvoiceRestore.getBoolean();
  boolean changeDueDateButtonEnabled = 
      bko && 
      pageBase.getRights().InvoiceChangeDueDate.getBoolean();
%>

<script>
//# sourceURL=invoice_list.jsp

$(document).ready(function(){
  $("#search-btn").click(search);
});

function search() {
  try {
    setGridUrlParam("#invoice-grid", "InvoiceCode", $("#InvoiceCode").val());
    
    setGridUrlParam("#invoice-grid", "FromIssueDate", "");
    setGridUrlParam("#invoice-grid", "ToIssueDate", "");
  
    setGridUrlParam("#invoice-grid", "FromDueDate", "");
    setGridUrlParam("#invoice-grid", "ToDueDate", "");
  
    setGridUrlParam("#invoice-grid", "FromIssueDateTime", "");
    setGridUrlParam("#invoice-grid", "ToIssueDateTime", "");
  
    if ($("#filter-issue-date").is(':checked')) {
      setGridUrlParam("#invoice-grid", "FromIssueDate", $("#FromIssueDate-picker").getXMLDate());
      setGridUrlParam("#invoice-grid", "ToIssueDate", $("#ToIssueDate-picker").getXMLDate(true));
    }
    
    if ($("#filter-due-date").is(':checked')) {
      setGridUrlParam("#invoice-grid", "FromDueDate", $("#FromDueDate-picker").getXMLDate());
      setGridUrlParam("#invoice-grid", "ToDueDate", $("#ToDueDate-picker").getXMLDate(true));
    }
    
    if ($("#filter-issue-date-time").is(':checked')) {
      setGridUrlParam("#invoice-grid", "FromIssueDateTime", $("#FromIssueDateTime-picker").getXMLDateTime());
      setGridUrlParam("#invoice-grid", "ToIssueDateTime", $("#ToIssueDateTime-picker").getXMLDateTime(true));
    }
    
    <% if (pageBase.getParameter("AccountId") == null) { %>
    setGridUrlParam("#invoice-grid", "AccountId", $("#AccountId").val());
    <% }%>
    setGridUrlParam("#invoice-grid", "InvoiceStatus", $("[name='InvoiceStatus']").getCheckedValues());
    
    setGridUrlParam("#invoice-grid", "LocationId", $("#LocationId").val());
    setGridUrlParam("#invoice-grid", "OpAreaId", $("#OpAreaId").val());
    setGridUrlParam("#invoice-grid", "WorkstationId", $("#WorkstationId").val(), true);
    
    changeGridPage("#invoice-grid", "first");
  }
  catch (err) {
    showMessage(err);
  }
}

function dateFilterChanged(radio) {
  $("#issue-date-rage").addClass("hidden");
  $("#issue-date-time-rage").addClass("hidden");
  $("#due-date-rage").addClass("hidden");
  
  if (radio.value == "issue-date")
    $("#issue-date-rage").removeClass("hidden");
  else if (radio.value == "due-date")
    $("#due-date-rage").removeClass("hidden");
  else if (radio.value == "issue-date-time")
    $("#issue-date-time-rage").removeClass("hidden");
}

function showInvoiceTransactionDialog(transactionType, invoiceIDs) {
  var invoiceIDs = $("[name='InvoiceId']").getCheckedValues();
  if (invoiceIDs == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    var params = "invoiceIDs=" + invoiceIDs + "&transactionType=" + transactionType;
    asyncDialogEasy("invoice/invoice_action_dialog", params);
  }
}

</script>

<div class="tab-toolbar">
  <v:button id="search-btn" caption="@Common.Search" fa="search"/>
  <span class="divider"></span>
  <div class="btn-group">
    <v:button caption="@Common.Actions" dropdown="true" fa="flag" bindGrid="invoice-grid"/>
    <v:popup-menu bootstrap="true" >
      <% String hrefWriteOff = "javascript:showInvoiceTransactionDialog(" + LkSNTransactionType.InvoiceWriteOff.getCode() + ")";%>     
      <v:popup-item caption="@Invoice.InvoiceWriteOff" fa="handshake-slash" onclick="<%=hrefWriteOff%>" enabled="<%=writeOffButtonEnabled%>"/>
      <% String hrefRestore = "javascript:showInvoiceTransactionDialog(" + LkSNTransactionType.InvoiceRestore.getCode() + ")";%>     
      <v:popup-item caption="@Invoice.InvoiceRestore" fa="history" onclick="<%=hrefRestore%>" enabled="<%=restoreButtonEnabled%>"/>
      <% String hrefVoid = "javascript:showInvoiceTransactionDialog(" + LkSNTransactionType.InvoiceVoid.getCode() + ")";%>     
      <v:popup-item caption="@Common.Void" fa="times" onclick="<%=hrefVoid%>" enabled="<%=voidButtonEnabled%>"/>
      <% String hrefDueDate = "javascript:showInvoiceTransactionDialog(" + LkSNTransactionType.InvoiceDueDateChange.getCode() + ")";%>     
      <v:popup-item caption="@Invoice.DueDate" fa="calendar" onclick="<%=hrefDueDate%>" enabled="<%=changeDueDateButtonEnabled%>"/>
    </v:popup-menu>
  </div>
  <v:pagebox gridId="invoice-grid"/>
</div>

<div class="tab-content">
  <div class="profile-pic-div">
    <div class="v-filter-container">
      <div class="form-toolbar">
        <input type="text" id="InvoiceCode" class="form-control default-focus v-filter-code" placeholder="<v:itl key="@Common.Code"/>" onkeypress="if (event.keyCode == KEY_ENTER) {search();return false;}"/>     
      </div>

      <div class="v-filter-all-condition">
        <v:widget caption="@Common.DateRange">
          <v:widget-block>
            <div>
              <label><input type="radio" id="filter-issue-date" name="date-filter" value="issue-date" onChange="dateFilterChanged(this);" checked>&nbsp;<v:itl key="@Invoice.IssueDate"/></label><br/>
              <label><input type="radio" id="filter-due-date" name="date-filter" value="due-date" onChange="dateFilterChanged(this);">&nbsp;<v:itl key="@Invoice.DueDate"/></label><br/>
              <label><input type="radio" id="filter-issue-date-time" name="date-filter" value="issue-date-time" onChange="dateFilterChanged(this);">&nbsp;<v:itl key="@Invoice.IssueDateTime"/></label>
            </div>
            <br/>
            <table id="issue-date-rage" style="width:100%">
              <tr>
                <td>
                  &nbsp;<v:itl key="@Common.FromDate"/><br/>
                  <v:input-text type="datepicker" field="FromIssueDate"/>
                </td>
                <td>&nbsp;</td>
                <td>
                  &nbsp;<v:itl key="@Common.ToDate"/><br/>
                  <v:input-text type="datepicker" field="ToIssueDate"/>
                </td>
              </tr>
            </table>
            <table id="due-date-rage" class="hidden" style="width:100%">
              <tr>
                <td>
                  &nbsp;<v:itl key="@Common.FromDate"/><br/>
                  <v:input-text type="datepicker" field="FromDueDate"/>
                </td>
                <td>&nbsp;</td>
                <td>
                  &nbsp;<v:itl key="@Common.ToDate"/><br/>
                  <v:input-text type="datepicker" field="ToDueDate"/>
                </td>
              </tr>
            </table>
            <div id="issue-date-time-rage" class="hidden">
              <v:itl key="@Common.FromDate"/><br/>
              <v:input-text type="datetimepicker" field="FromIssueDateTime" style="width:120px"/>
              <br/>
              <v:itl key="@Common.ToDate"/><br/>
              <v:input-text type="datetimepicker" field="ToIssueDateTime" style="width:120px"/>
            </div>
          </v:widget-block>
        </v:widget>
    
        <v:widget caption="@Common.Status">
          <v:widget-block>
          <% for (LookupItem item : LkSN.InvoiceStatus.getItems()) { %>
            <label><input type="checkbox" name="InvoiceStatus" value="<%=item.getCode()%>"/> <%=item.getDescription(pageBase.getLang())%></label><br/>
          <% } %>
          </v:widget-block>
        </v:widget>
    
        <v:widget caption="@Common.Filter">
        <%  if (pageBase.getParameter("AccountId") == null) { %>
          <v:widget-block>
            <v:itl key="@Account.Account"/><br/>
            <snp:dyncombo id="AccountId" entityType="<%=LkSNEntityType.Organization%>"/>
          </v:widget-block>
        <%} %>
          <v:widget-block>
            <v:itl key="@Account.Location"/><br/>
            <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>" auditLocationFilter="true"/>
            <div class="filter-divider"></div>
            <v:itl key="@Account.OpArea"/><br/>
            <snp:dyncombo  id="OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" auditLocationFilter="true" parentComboId="LocationId"/>
            <div class="filter-divider"></div>
            <v:itl key="@Common.Workstation"/><br/>
            <snp:dyncombo id="WorkstationId" entityType="<%=LkSNEntityType.Workstation%>" auditLocationFilter="true" parentComboId="OpAreaId"/>    
          </v:widget-block>
        </v:widget>
      </div>
    </div>
  </div>
  
  <div class="profile-cont-div">
    <% 
      String params ="";
      if (pageBase.getParameter("AccountId") != null)
        params = "AccountId=" + pageBase.getParameter("AccountId") + "&";      
      else
        params = "FromIssueDate=" + defaultFromDate + "&ToIssueDate=" + defaultToDate; 
    %>
    <v:async-grid id="invoice-grid" jsp="invoice/invoice_grid.jsp" params="<%=params%>"/>
  </div>
</div>
