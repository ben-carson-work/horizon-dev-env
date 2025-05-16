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

<v:widget caption="@Common.Configuration">
	<v:widget-block>
	  <v:form-field caption="Authorizer">
	    <v:lk-combobox field="cfg.InstallmentChargeSimulate" lookup="<%=LkSN.InstallmentChargeSimulate%>" allowNull="false"/>
	  </v:form-field>
	</v:widget-block>
</v:widget>	

<script>

function saveTaskConfig(reqDO) {
  var config ={
		  InstallmentChargeSimulate: $("#cfg\\.InstallmentChargeSimulate").val()
	}
	reqDO.TaskConfig = JSON.stringify(config); 
}

</script>

