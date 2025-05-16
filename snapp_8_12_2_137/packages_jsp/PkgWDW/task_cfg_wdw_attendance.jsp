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
  String durationHint = 
      "Expressed in days, it indicates the number of days before the base date, for which an attendance event should be generated. (Default value is 1)" + JvString.CRLF + 
      "There will be one event generated for each day specified in the duration." + JvString.CRLF + 
      "If the duration is equal to 1, one attendance event will be generated for the base date." + JvString.CRLF +
      "If the duration is equal to 2, one attendance event will be generated for the base date and another attendance event will be generated for the day before the base date.";
%>

<v:widget caption="@Common.Configuration">
  <v:widget-block>
    <v:form-field caption="Base date" hint="This is the day from which the base attendance event will be generated. If left empty, the previous fiscal date (relative to the job execution) will be used">
      <v:input-text type="datepicker" field="cfg.BaseDate"/>
    </v:form-field>
    <v:form-field caption="Duration" hint="<%=durationHint%>">
      <v:input-text type="text" field="cfg.Duration" defaultValue="1" placeholder="1"/>
    </v:form-field>
	<v:form-field caption="Reconcile" hint="Reconcile attendance">
	  <v:db-checkbox field="cfg.Reconcile" caption="" value="true"/>
	</v:form-field>
    </v:widget-block>
  </v:widget>	
  
  
          
<script>
function saveTaskConfig(reqDO) {
  var baseDate = $("#cfg\\.BaseDate-picker").getXMLDate()
  var duration = $("#cfg\\.Duration").val();
  
  if (duration=="") {
    duration = 1;
  }
    
  if (duration < 1 || duration > 5)
    throw new Error("Duration value has to be between 1 and 5");
    
  var config = {
    BaseDate: baseDate!="" ? baseDate : null,
    Duration: duration,
    Reconcile: $("#cfg\\.Reconcile").isChecked(),
  }
  
  reqDO.TaskConfig = JSON.stringify(config); 
}
</script>

