<%@page import="com.vgs.web.tag.ImageCacheLinkTag"%>
<%@page import="com.vgs.vcl.JvImageCache"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
	boolean canEdit = rights.SettingsLedgerAccounts.canUpdate();
  boolean isNewItem = pageBase.isNewItem(); 

	String[] maskIDs = rights.LedgerAccountMaskIDs.getArray();
	String maskEditURL = pageBase.getContextURL() + "?page=maskedit_widget&id=" + pageBase.getId()  + "&EntityType=" + LkSNEntityType.LedgerAccount.getCode() + "&MaskIDs=" + JvArray.arrayToString(maskIDs, ",") + "&LoadData=true&readonly=" + !canEdit;
 
  BLBO_Ledger bl = pageBase.getBL(BLBO_Ledger.class);
  DOLedgerAccount ledgerAccount = isNewItem ? bl.prepareNewLedgerAccount() : bl.loadLedgerAccount(pageBase.getId());
  request.setAttribute("ledgerAccount", ledgerAccount);
  
  String title = isNewItem ? pageBase.getLang().Common.New.getText() : ledgerAccount.LedgerAccountCode.getString() + " - " + ledgerAccount.LedgerAccountName.getString();
  
  JvDateTime fromDate = null;
  if (pageBase.getNullParameter("FromDate") != null)
    fromDate = JvDateTime.createByXML(pageBase.getParameter("FromDate"));
  
  JvDateTime toDate = null;
  if (pageBase.getNullParameter("ToDate") != null)
    toDate = JvDateTime.createByXML(pageBase.getParameter("ToDate"));
  
  String serialNumber = null;
  if (pageBase.getNullParameter("SerialNumber") != null) {
    serialNumber = pageBase.getParameter("SerialNumber");
    title = "#" + serialNumber + " - " + title; 
  }

  JvDataSet dsTotal = pageBase.getBL(BLBO_Ledger.class).getLedgerAccountBalanceDS(pageBase.getId(), fromDate, toDate);
%>

<div id="ledgeraccount_dialog">
  <div>
		<div id="ledgeraccount_dialog_profile" class="col-lg-7" style="padding-left:0; padding-right:10px">
			<v:widget caption="@Common.Profile">
			  <v:widget-block>
			    <v:form-field caption="@Common.Code" mandatory="true">
			      <v:input-text field="ledgerAccount.LedgerAccountCode" placeholder="000.000.000.000" enabled="<%=canEdit%>"/>
			    </v:form-field>
			    <v:form-field caption="@Common.Name">
			      <v:input-text field="ledgerAccount.LedgerAccountName" enabled="<%=canEdit%>"/>
			    </v:form-field>
			    <v:form-field caption="@Common.Level">
			      <v:lk-combobox field="ledgerAccount.LedgerAccountLevel" lookup="<%=LkSN.LedgerAccountLevel%>" allowNull="false" enabled="<%=canEdit%>"/>
			    </v:form-field>
			    <v:form-field id="ledger-account-type-container" caption="@Common.Type">
			      <v:lk-combobox field="ledgerAccount.LedgerAccountType" lookup="<%=LkSN.LedgerAccountType%>" allowNull="false" enabled="<%=canEdit%>"/>
			    </v:form-field>
			    <% if (ledgerAccount.LedgerAccountType.isLookup(LkSNLedgerAccountType.Liability, LkSNLedgerAccountType.Revenue) && ledgerAccount.LedgerAccountLevel.isLookup(LkSNLedgerAccountLevel.SubAccount)) { %>
			      <v:db-checkbox field="ledgerAccount.AffectClearing" value="true" caption="@Ledger.AffectClearing" hint="@Ledger.AffectClearingHint" enabled="<%=canEdit%>"/>
			    <% } %>
			  </v:widget-block>
        <v:widget-block>
          <v:db-checkbox field="ledgerAccount.LedgerAccountStatus" value="<%=LkSNLedgerAccountStatus.Active.getCode()%>" caption="@Common.Active" enabled="<%=canEdit%>"/>
        </v:widget-block>
			</v:widget>
			
			<div id="maskedit-container"></div>
		</div>
	
		<div class="col-lg-5" id="ledgeraccount_dialog_balance" style="padding:0">
		<% if ((dsTotal != null) && !dsTotal.isEmpty()) { %>
			<v:widget caption="@Common.Balance">
			  <% long total = 0; %>
			  <v:widget-block>
			    <v:ds-loop dataset="<%=dsTotal%>"> 
			      <%
			      long accountTotal = dsTotal.getField("LedgerTotalBalance").getMoney();
			      if (LkSNLedgerAccountType.isDebit(ledgerAccount.LedgerAccountType.getLkValue()))
			        accountTotal *= -1;
			      total += accountTotal;
			      %>
			      <%=dsTotal.getField("AccountName").getHtmlString()%><span class="recap-value"><%=pageBase.formatCurrHtml(accountTotal)%></span><br/>
			    </v:ds-loop>
			  </v:widget-block>
			  <v:widget-block>
			    <b><v:itl key="@Common.Total"/></b><span class="recap-value"><%=pageBase.formatCurrHtml(total)%></span>
			  </v:widget-block>
			</v:widget>
		<% } %>
		</div>
  </div>

<script>

$(document).ready(function() {
  $("#tabs").tabs();
  
  var dlg = $("#ledgeraccount_dialog");
  dlg.dialog({
    title: <%=JvString.jsString(title)%>,
    modal: true,
    width: 1024,
    height: 768,
    close: function() {
      dlg.remove();
    },
    buttons: [
    	<% if (canEdit) { %>
    	  dialogButton("@Common.Save", doSaveLedgerAccount),
        dialogButton("@Common.Cancel", doCloseDialog)
      <% } else { %>
        dialogButton("@Common.Close", doCloseDialog)
      <% } %>
    ]
  });
  
  asyncLoad("#maskedit-container", <%=JvString.jsString(maskEditURL)%>);
  
  <% if (canEdit) { %>
    refreshLedgerAccountVisibility();
    $("#ledgerAccount\\.LedgerAccountLevel").change(refreshLedgerAccountVisibility);
    
	  dlg.keypress(function() {
	    if (event.keyCode == KEY_ENTER)
	      doSaveLedgerAccount();
	  });

	  function doSaveLedgerAccount() {
		 var metaDataList = prepareMetaDataArray("#maskedit-container");
	    checkRequired(dlg, function() {
	      var reqDO = {
					Command: "SaveLedgerAccount",
					SaveLedgerAccount: {
					  LedgerAccount: {
							LedgerAccountId: <%=ledgerAccount.LedgerAccountId.isNull() ? "null" : "\"" + ledgerAccount.LedgerAccountId.getHtmlString() + "\""%>,
				      LedgerAccountCode: $("#ledgerAccount\\.LedgerAccountCode").val(),
				      LedgerAccountName: $("#ledgerAccount\\.LedgerAccountName").val(),
				      LedgerAccountLevel: $("#ledgerAccount\\.LedgerAccountLevel").val(),
              LedgerAccountType: $("#ledgerAccount\\.LedgerAccountType").val(),
              LedgerAccountStatus: ($("#ledgerAccount\\.LedgerAccountStatus").isChecked() ? <%=LkSNLedgerAccountStatus.Active.getCode()%> : <%=LkSNLedgerAccountStatus.Disabled.getCode()%>),
              AffectClearing: $("#ledgerAccount\\.AffectClearing").isChecked(),
			        MetaDataList: metaDataList
				    }
				  }
				};
		
				showWaitGlass();
				vgsService("Ledger", reqDO, false, function(ansDO) {
				  hideWaitGlass();
				  changeGridPage("#ledgeraccount-grid", 1);
				  $("#ledgeraccount_dialog").dialog("close");
				});
	    });  
	  }
	  
	  function refreshLedgerAccountVisibility() {
	    var level = parseInt($("#ledgerAccount\\.LedgerAccountLevel").val());
	    $("#ledger-account-type-container").setClass("v-hidden", level != <%=LkSNLedgerAccountLevel.Master.getCode()%>);
	  }
	<% } %>
});


</script>

</div>


