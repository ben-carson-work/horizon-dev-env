<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.text.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>

<v:widget caption="@Common.Configuration">
	<v:widget-block>
	  <v:form-field caption="@Common.SendReportsAfterHours"><v:input-text field="cfg.SendReportsAfterHours"/></v:form-field>
	</v:widget-block>
</v:widget>	

<script>

function saveTaskConfig(reqDO) {
  var config={
      SendReportsAfterHours: $("#cfg\\.SendReportsAfterHours").val()
  };
  reqDO.TaskConfig = JSON.stringify(config); 
}

</script>

