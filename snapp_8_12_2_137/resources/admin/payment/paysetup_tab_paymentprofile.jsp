<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePaymentSetup" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% boolean canEdit = rights.SettingsPayments.getBoolean(); %>

<div class="tab-toolbar">
  <v:button caption="@Common.New" title="@Payment.PaymentProfiles" fa="plus" href="admin?page=paymentprofile&id=new" enabled="<%=canEdit%>" />
  <v:button caption="@Common.Delete" fa="trash" href="javascript:deletePaymentProfiles()" enabled="<%=canEdit%>"/>
  <span class="divider"></span>
  <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="paymentprofile-grid"  onclick="exportPaymentProfile()"/>
  <span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.PaymentProfile.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/> 
  <v:pagebox gridId="paymentprofile-grid"/>
</div>
    
<v:last-error/>

<div class="tab-content">
  <v:async-grid id="paymentprofile-grid" jsp="payment/paymentprofile_grid.jsp" />
</div>

<script>
  function deletePaymentProfiles() {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeletePaymentProfile",
        DeletePaymentProfile: {
          PaymentProfileIDs: $("[name='PaymentProfileId']").getCheckedValues()
        }
      };
      
      vgsService("PayMethod", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.PaymentProfile.getCode()%>);      
      });
    });
  }
  
  function showImportDialog() {
	  asyncDialogEasy("payment/paymentprofile_snapp_import_dialog", "");
	}
	      
	function exportPaymentProfile() {
	  var bean = getGridSelectionBean("#paymentprofile-grid-table", "[name='PaymentProfileId']");
	  if (bean) 
	    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.PaymentProfile.getCode()%> + &QueryBase64=" + bean.queryBase64;
	}
	
</script>
