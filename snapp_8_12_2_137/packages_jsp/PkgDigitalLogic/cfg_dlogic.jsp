<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pkg" class="com.vgs.snapp.dataobject.DOExtensionPackage" scope="request"/>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="QUUPPA DocTemplate"  mandatory="true" hint="DocTemplate to be associated to the QUUPPA Media codes"> 
      <snp:dyncombo id="dlogc-config-quuppaDocTemplateId" entityType="<%=LkSNEntityType.DocTemplate%>"/>
    </v:form-field>
    <v:form-field caption="Souvenir DocTemplate"  mandatory="true" hint="DocTemplate to be associated to the Souvenir Media codes"> 
      <snp:dyncombo id="dlogc-config-souvenirDocTemplateId" entityType="<%=LkSNEntityType.DocTemplate%>"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  var doc = <%=pkg.ConfigDoc.getString()%>;
  doc = (doc) ? doc : {};
  $("#dlogc-config-quuppaDocTemplateId").val(doc.QuuppaDocTemplateId);
  $("#dlogc-config-souvenirDocTemplateId").val(doc.SouvenirDocTemplateId);
});

function getExtensionPackageConfigDoc() {
  return {
    QuuppaDocTemplateId: $("#dlogc-config-quuppaDocTemplateId").val(),
    SouvenirDocTemplateId: $("#dlogc-config-souvenirDocTemplateId").val()
  };
}

</script>