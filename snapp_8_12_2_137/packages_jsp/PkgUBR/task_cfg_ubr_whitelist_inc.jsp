<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>
<%
JvDocument cfg = (JvDocument)request.getAttribute("cfg");
%>

<v:widget caption="Settings">
  <v:widget-block>
    <v:form-field caption="API URL" hint="API end point - not including command part \"/library\"">
      <v:input-text field="cfg.ApiURL"/>
    </v:form-field>
    <v:form-field caption="BIZ ID">
      <v:input-text field="cfg.BizId"/>
    </v:form-field>
<%--     <v:form-field caption="SCENE">
      <v:input-text field="cfg.Scene"/>
    </v:form-field> --%>
    <v:form-field caption="Chuck size" hint="Maximum number of account per API call">
      <v:input-text field="cfg.ChunkSize" placeholder="1000"/>
    </v:form-field>
    <v:form-field caption="Enable Auth." hint="Enable API Gateway authentication for API calls, gateway authentication will be done using below parameters">
      <v:db-checkbox field="cfg.AuthRequired" caption="@Common.Enabled" value="true"/>
    </v:form-field>
	<v:form-field caption="Authentication URL">
      <v:input-text field="cfg.AuthenticationUrl"/>
    </v:form-field>
    <v:form-field caption="Client id" >
      <v:input-text field="cfg.ClientId"/>
    </v:form-field>
    <v:form-field caption="Client Secret">
      <v:input-text field="cfg.ClientSecret"/>
    </v:form-field>
  </v:widget-block>
</v:widget>	
  
<script>
	
function saveTaskConfig(reqDO) {
  var config = {
    "ApiURL": $("#cfg\\.ApiURL").val(),
    "BizId": $("#cfg\\.BizId").val(),
/*     "Scene": $("#cfg\\.Scene").val(), */
    "ChunkSize": $("#cfg\\.ChunkSize").val(),
    "AuthRequired": $("#cfg\\.AuthRequired").isChecked(),
    "AuthenticationUrl":$("#cfg\\.AuthenticationUrl").val(),
    "ClientId": $("#cfg\\.ClientId").val(),
    "ClientSecret": $("#cfg\\.ClientSecret").val()
  }
  
  reqDO.TaskConfig = JSON.stringify(config); 
}
</script>

