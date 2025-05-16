<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_InvoiceList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="../../common/header.jsp"/>
<v:page-title-box/>

<%
  String defaultFromDate = (pageBase.getNullParameter("AccountId") == null) ? pageBase.getBrowserFiscalDate().getXMLDate() : null;
  String defaultToDate = (pageBase.getNullParameter("AccountId") == null) ? pageBase.getBrowserFiscalDate().addDays(1).getXMLDate() : null;
  
  pageBase.setDefaultParameter("FromIssueDate", defaultFromDate);
  pageBase.setDefaultParameter("ToIssueDate", defaultToDate);
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

    setGridUrlParam("#invoice-grid", "InvoiceStatus", $("[name='InvoiceStatus']").getCheckedValues());
    
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

</script>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
  
    <div class="tab-toolbar">
      <v:button id="search-btn" caption="@Common.Search" fa="search"/>

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
          </div>
        </div>
      </div>
      
      <div class="profile-cont-div">
        <v:async-grid id="invoice-grid" jsp="invoice/invoice_grid.jsp"/>
      </div>
    </div>

  </v:tab-item-embedded>
</v:tab-group>


<jsp:include page="../../common/footer.jsp"/>
