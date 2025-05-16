<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>
<% boolean canEdit = pageBase.isNewItem(); %>

<v:widget caption="@Common.Configuration">
	<v:widget-block>
    <v:form-field caption="@Common.FromDate">
      <v:input-text type="datepicker" field="cfg.DateFrom" enabled="<%=canEdit%>"/>
    </v:form-field>
    <v:form-field caption="@Common.ToDate">
      <v:input-text type="datepicker" field="cfg.DateTo" enabled="<%=canEdit%>"/>
    </v:form-field>
	</v:widget-block>
</v:widget>

<script>
function saveTaskConfig(reqDO) {
  var config ={
    DateFrom: getNull($("#cfg\\.DateFrom-picker").getXMLDate()),
    DateTo: getNull($("#cfg\\.DateTo-picker").getXMLDate())
	};
	reqDO.TaskConfig = JSON.stringify(config); 
}
</script>

