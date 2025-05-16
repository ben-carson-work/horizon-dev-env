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
QueryDef qdef = new QueryDef(QryBO_DocTemplate.class);
qdef.addSelect(QryBO_DocTemplate.Sel.DocTemplateId);
qdef.addSelect(QryBO_DocTemplate.Sel.DocTemplateName);
qdef.addFilter(QryBO_DocTemplate.Fil.DocTemplateType, LookupManager.getIntArray(LkSNDocTemplateType.OrderConfirmation));
qdef.addSort(QryBO_DocTemplate.Sel.DocTemplateName);
JvDataSet dsDocTemplate = pageBase.execQuery(qdef);
request.setAttribute("dsDocTemplate", dsDocTemplate);
%>
<v:widget caption="@Task.ResMaintenance_ResPayment" hint="@Task.ResMaintenance_ResPayment_Hint">
  <v:widget-block>
    <div><v:db-checkbox field="cfg.AutopayOpenRes" caption="@Task.ResMaintenance_AutopayOpenRes" value="true"/></div>
  </v:widget-block>
</v:widget>

<v:widget caption="@Task.ResMaintenance_Encoding" hint="@Task.ResMaintenance_Encoding_Hint">
	<v:widget-block>
	  <v:form-field caption="@Task.ResMaintenance_EncodeExpiredOrders" hint="@Task.ResMaintenance_EncodeExpiredOrdersHint"><v:input-text field="cfg.EncodeExpiredOrdersDays" placeholder="@Common.Never"/></v:form-field>
	</v:widget-block>
</v:widget>	

<v:widget caption="@Task.ResMaintenance_ResPurge" hint="@Task.ResMaintenance_ResPurge_Hint">
	<v:widget-block>
	  <v:form-field caption="@Task.ResMaintenance_DaysFromPerformance" hint="@Task.ResMaintenance_DaysFromPerformanceHint">
	    <v:input-text field="cfg.DaysFromPerformance" placeholder="@Common.Unlimited"/>
	  </v:form-field>
	  <v:form-field caption="@Task.ResMaintenance_DaysFromReservation" hint="@Task.ResMaintenance_DaysFromReservationHint">
	    <v:input-text field="cfg.DaysFromReservation" placeholder="@Common.Unlimited"/>
	  </v:form-field>
	</v:widget-block>
	<v:widget-block>
	  <div><v:db-checkbox field="cfg.VoidReservation" caption="@Task.ResMaintenance_VoidReservation" value="true" hint="@Task.ResMaintenance_VoidReservationHint"/></div>
	</v:widget-block>
</v:widget>		
<script>


$(document).ready(enableDisable);

function saveTaskConfig(reqDO) {
	var config ={
		  DaysFromPerformance: $("#cfg\\.DaysFromPerformance").val(),
		  DaysFromReservation: $("#cfg\\.DaysFromReservation").val(),
		  VoidReservation: $("#cfg\\.VoidReservation").isChecked(),
		  EncodeExpiredOrdersDays:  $("#cfg\\.EncodeExpiredOrdersDays").val(),
		  AutopayOpenRes: $("#cfg\\.AutopayOpenRes").isChecked()
	}
	reqDO.TaskConfig = JSON.stringify(config); 
}

</script>

