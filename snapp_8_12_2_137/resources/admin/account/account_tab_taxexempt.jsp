<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>
<%
boolean canEdit = true;
%>

<v:tab-toolbar>
  <v:button id="btn-account-taxexempt-save" caption="@Common.Save" fa="save" enabled="<%=canEdit%>"/>
</v:tab-toolbar>

<v:tab-content>
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Account.TaxExemptCertificateCode">
        <v:input-text field="account.TaxExemptCertificateCode" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Common.Expiration">
        <v:input-text type="datepicker" field="account.TaxExemptCertificateExpiration" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Account.ExemptibleTaxes" hint="@Account.ExemptibleTaxesHint">
        <v:multibox field="account.TaxExemptTaxIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Tax.class).getExemptibleExplicitDS()%>" idFieldName="TaxId" captionFieldName="TaxName" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    
    <v:widget-block>
      <v:form-field>
        <v:db-checkbox field="account.TaxExemptCertificateApproved" caption="@Common.Approved" value="true" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
</v:tab-content>

<script>

$(document).ready(function() {
  $("#btn-account-taxexempt-save").click(_save);
  
  function _save() {
    var reqDO = {
      AccountId                     : <%=account.AccountId.getJsString()%>,
      EntityType                    : <%=account.EntityType.getJsString()%>,
      TaxExemptCertificateCode      : $("#account\\.TaxExemptCertificateCode").val(),
      TaxExemptCertificateExpiration: $("#account\\.TaxExemptCertificateExpiration-picker").getXMLDate(),
      TaxExemptCertificateApproved  : $("#account\\.TaxExemptCertificateApproved").isChecked(),
      TaxExemptTaxIDs               : $("#account\\.TaxExemptTaxIDs").val(),
    };
    
    snpAPI.cmd("Account", "SaveAccount", reqDO).then(ansDO => entitySaveNotification(<%=account.EntityType.getJsString()%>, ansDO.AccountId, "tab=taxexempt"));
  }
});

</script>
