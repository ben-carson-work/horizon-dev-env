<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.cl.database.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pkg" class="com.vgs.snapp.dataobject.DOExtensionPackage" scope="request"/>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<v:widget caption="API gateway">
  <v:widget-block>
    <v:form-field caption="Enable authentication">
      <v:db-checkbox field="ubr-config-AuthRequired" caption="@Common.Enabled" value="true"/>
    </v:form-field>
    <div id="authentication" class="v-hidden">
      <v:form-field caption="Authentication URL">
        <v:input-text field="ubr-config-AuthenticationUrl"/>
      </v:form-field>
      <v:form-field caption="Client ID" >
        <v:input-text field="ubr-config-ClientId"/>
      </v:form-field>
      <v:form-field caption="Client Secret">
        <v:input-text field="ubr-config-ClientSecret" type="password"/>
      </v:form-field>
    </div>
  </v:widget-block>
</v:widget>

<v:widget caption="Fapiao settings">
  <v:widget-block>
    <v:form-field caption="System code" hint="Request system code identification" mandatory="true">
      <v:input-text field="ubr-config-SystemCode" placeholder="Ex. VGS"/>
    </v:form-field>
    <v:form-field caption="System channel" hint="Request system channel identification" mandatory="true">
      <v:input-text field="ubr-config-SystemChannel" placeholder="Ex. TKTPOS"/>
    </v:form-field>
    <v:form-field caption="Product tag" hint="Tag used to identify the products that require Fapiao" mandatory="true">
       <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
       <v:combobox field="ubr-config-ProductTagId" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var doc = <%=pkg.ConfigDoc.getString()%>;
  doc = (doc) ? doc : {};
  $("#ubr-config-ProductTagId").val(doc.ProductTagId);
  $("#ubr-config-SystemChannel").val(doc.SystemChannel);
  $("#ubr-config-SystemCode").val(doc.SystemCode);
  
  $("#ubr-config-AuthRequired").prop('checked', doc.AuthRequired);
  $("#ubr-config-AuthenticationUrl").val(doc.AuthenticationUrl);
  $("#ubr-config-ClientId").val(doc.ClientId);
  $("#ubr-config-ClientSecret").val(doc.ClientSecret);
  enableDisbaleAuthorization();
});

$("#ubr-config-AuthRequired").change(enableDisbaleAuthorization);

function enableDisbaleAuthorization() {
  var enabled = $("#ubr-config-AuthRequired").isChecked();
  $("#authentication").setClass("v-hidden", !enabled); 
}

function getExtensionPackageConfigDoc() {
  return {
    AuthRequired: $("#ubr-config-AuthRequired").isChecked(),
    AuthenticationUrl: $("#ubr-config-AuthenticationUrl").val(),
    ClientId: $("#ubr-config-ClientId").val(),
    ClientSecret: $("#ubr-config-ClientSecret").val(),
    SystemChannel: $("#ubr-config-SystemChannel").val(),
    SystemCode: $("#ubr-config-SystemCode").val(),
    ProductTagId: $("#ubr-config-ProductTagId").val()
  };
}

</script>