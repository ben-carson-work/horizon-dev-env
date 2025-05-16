<%@page import="com.vgs.snapp.query.QryBO_Account"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:widget id="usj-nec-exp-pass-settings" caption="Plugin settings" >
  <v:widget-block>
    <v:form-field caption="Server URL">
      <v:input-text field="ServerURL" placeholder="ie: https://exp3-st.usj.co.jp/app/interface" />
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="Login userNo">
      <v:input-text field="LoginUserNo"/>
    </v:form-field>
    <v:form-field caption="Login password">
      <v:input-text field="LoginPassword" type="password"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="NEC encryption key">
      <v:input-text field="NECEncryptionKey" type="password"/>
    </v:form-field>
    <v:form-field caption="NEC product type"  hint="Product type used by the system to generate the ticket associated with the scanned barcode"> 
      <snp:dyncombo id="NECProductId" entityType="<%=LkSNEntityType.ProductType%>"/>
    </v:form-field>
    <v:form-field caption="Lawson encryption key">
      <v:input-text field="LawsonEncryptionKey" type="password"/>
    </v:form-field>
    <v:form-field caption="Lawson product type"  hint="Product type used by the system to generate the ticket associated with the scanned barcode"> 
      <snp:dyncombo id="LawsonProductId" entityType="<%=LkSNEntityType.ProductType%>"/>
    </v:form-field>
    <v:form-field caption="@Account.AccessAreas">
      <% JvDataSet dsArea = pageBase.getBL(BLBO_Account.class).getAccessAreaDS(null); %>
      <v:multibox field="AccessAreaIDs" lookupDataSet="<%=dsArea%>" idFieldName="AccountId" captionFieldName="DisplayName" linkEntityType="<%=LkSNEntityType.AccessArea%>"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var $cfg = $("#usj-nec-exp-pass-settings");
  
  $(document).von($cfg, "plugin-settings-load", function(event, params) {
    $cfg.find("#ServerURL").val(params.settings.ServerURL);
    $cfg.find("#LoginUserNo").val(params.settings.LoginUserNo);
    $cfg.find("#LoginPassword").val(params.settings.LoginPassword);
    $cfg.find("#NECEncryptionKey").val(params.settings.NECEncryptionKey);
    $cfg.find("#NECProductId").val(params.settings.NECProductId);
    $cfg.find("#LawsonEncryptionKey").val(params.settings.LawsonEncryptionKey);
    $cfg.find("#LawsonProductId").val(params.settings.LawsonProductId);
    setMultibxoVal($("#AccessAreaIDs"), params.settings.AccessAreaIDs);
  });
  
  $(document).von($cfg, "plugin-settings-save", function(event, params) {
    params.settings = {
    	ServerURL: $cfg.find("#ServerURL").val(),  
    	LoginUserNo: $cfg.find("#LoginUserNo").val(),  
    	LoginPassword: $cfg.find("#LoginPassword").val(),
    	NECEncryptionKey: $cfg.find("#NECEncryptionKey").val(),
    	NECProductId: $cfg.find("#NECProductId").val(),
    	LawsonEncryptionKey: $cfg.find("#LawsonEncryptionKey").val(),
    	LawsonProductId: $cfg.find("#LawsonProductId").val(),
    	AccessAreaIDs: $cfg.find("#AccessAreaIDs").val()
    };
  });

  function setMultibxoVal($sel, value){
    $sel.attr('data-html', $sel.html());
    $sel.selectize({
      dropdownParent:"body",
      plugins: ['remove_button','drag_drop']
    })[0].selectize.setValue(value, true);
  }
});
</script>