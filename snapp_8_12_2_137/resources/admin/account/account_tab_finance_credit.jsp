<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>
<% 
boolean canEditFinance = rights.CreditLine.canUpdate();
int[] defaultStatusFilter = new int[] {LkSNCreditStatus.Opened.getCode()}; 
boolean invoiceIssue = rights.InvoiceIssue.getBoolean(); 
%>


<script>

function search() {
  setGridUrlParam("#credit-grid-container", "CreditStatus", $("input[name='CreditStatus']:checked").map(function () {return this.value;}).get().join(","), false);
  setGridUrlParam("#credit-grid-container", "FromDate", $("#FromDate-picker").getXMLDate(), false);
  setGridUrlParam("#credit-grid-container", "ToDate", $("#ToDate-picker").getXMLDate(), false);
  setGridUrlParam("#credit-grid-container", "FromDueDate", $("#FromDueDate-picker").getXMLDate(), false);
  setGridUrlParam("#credit-grid-container", "ToDueDate", $("#ToDueDate-picker").getXMLDate(), false);
  changeGridPage("#credit-grid-container", "first");
}

</script>

<div id="duedate-dialog" class="v-hidden" title="<v:itl key="@Account.Credit.ChangeDueDate"/>">
  <v:input-text type="datepicker" field="NewDueDatePicker" style="width:120px"/>
</div>


<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" href="javascript:search()" />
  <span class="divider"></span>
  <v:button-group>
    <v:button caption="@Account.Credit.DueDate" fa="calendar" id="duedate-btn" title="@Account.Credit.ChangeDueDate" bindGrid="credit-grid-container" enabled="<%=canEditFinance%>"/>
    <v:button caption="@Invoice.InvoiceIssue" fa="file-alt" id="invoice-issue-btn" onclick="showInvoiceIssueDialog()" bindGrid="credit-grid-container" enabled="<%=invoiceIssue%>"/>
  </v:button-group>
  
  <v:pagebox gridId="credit-grid-container"/>
</div>

<script>
  $("#duedate-btn").click(function(event) {
	  var ids = $("[name='PaymentId']").getCheckedValues();
	  if (ids == "")
	    showMessage(itl("@Common.NoElementWasSelected"));
	  else {
	    $("#duedate-dialog").dialog({
	      modal: true,
	      width: 300,
	      height: 350,
	      buttons: [
	        dialogButton("@Common.Close", doCloseDialog),
	        dialogButton("@Common.Ok", function() {
	          if ($("#NewDueDatePicker").val() == "")
	            showMessage(itl("@Common.PleaseSelectADate"));
	          else {
	            $(this).dialog("close");
	            
	            var reqDO = {
	              Command: "ChangeCreditDueDate",
	              ChangeCreditDueDate: {
	                PaymentIDs: $("[name='PaymentId']").getCheckedValues(),
	                Date: $("#NewDueDatePicker").val()
	              }
	            };
	            
	            if ($("#credit-grid").hasClass("multipage-selected")) {
	            	reqDO.ChangeCreditDueDate.PaymentIDs = "";            
	            	reqDO.ChangeCreditDueDate.QueryBase64 = $("#credit-grid").attr("data-QueryBase64");
	            }
	            
	            vgsService("Account", reqDO, false, function(ansDO) {
	              triggerEntityChange(<%=LkSNEntityType.Payment.getCode()%>);
	            });
	          }
	        })
	      ]
	    });
	  }
  });
  
  function showInvoiceIssueDialog() {
    var ids = $("[name='PaymentId']").getCheckedValues();
    if (ids == "")
      showMessage(itl("@Common.NoElementWasSelected"));
    else {
      var queryBase64 = null;
      if ($("#credit-grid").hasClass("multipage-selected")) {
        ids = "";            
        queryBase64 = $("#credit-grid").attr("data-QueryBase64");
      }
      
      var params = "AccountId=" + <%=JvString.jsString(pageBase.getId())%>;
      if (ids != "")
        params += "&PaymentIDs=" + ids;
      
      asyncDialogEasy("invoice/invoice_issue_dialog", params, {"QueryBase64":queryBase64});
    }
  }

</script>

<v:page-form page="account_tab_finance_credit">

<div class="tab-content">
  <v:last-error/>
  
  <div id="main-container">
    <div id="filter-column" class="profile-pic-div">
      <v:widget caption="@Common.Status">
        <v:widget-block>
        <% for (LookupItem status : LkSN.CreditStatus.getItems()) { %>
          <v:db-checkbox field="CreditStatus" caption="<%=status.getRawDescription()%>" value="<%=String.valueOf(status.getCode())%>" hint="<%=status.getRawHint()%>" checked="<%=JvArray.contains(status.getCode(), defaultStatusFilter)%>" /><br/>
        <% } %>
        </v:widget-block>
      </v:widget>
  
      <v:widget caption="@Common.CreationDate">
        <v:widget-block>
          <table style="width:100%">
            <tr>
              <td>
                &nbsp;<v:itl key="@Common.From"/><br/>
                <v:input-text type="datepicker" field="FromDate"/>
              </td>
              <td>&nbsp;</td>
              <td>
                &nbsp;<v:itl key="@Common.To"/><br/>
                <v:input-text type="datepicker" field="ToDate"/>
              </td>
            </tr>
          </table>
        </v:widget-block>
      </v:widget>

      <v:widget caption="@Account.Credit.DueDate">
        <v:widget-block>
          <table style="width:100%">
            <tr>
              <td>
                &nbsp;<v:itl key="@Common.From"/><br/>
                <v:input-text type="datepicker" field="FromDueDate"/>
              </td>
              <td>&nbsp;</td>
              <td>
                &nbsp;<v:itl key="@Common.To"/><br/>
                <v:input-text type="datepicker" field="ToDueDate"/>
              </td>
            </tr>
          </table>
        </v:widget-block>
      </v:widget>
    </div>

    <div class="profile-cont-div">
      <% String params = "AccountId=" + pageBase.getId() + "&CreditStatus=" + JvArray.arrayToString(defaultStatusFilter, ","); %>
      <v:async-grid id="credit-grid-container" jsp="account/credit_grid.jsp" params="<%=params%>" />
    </div>
  </div>

</div>

</v:page-form>