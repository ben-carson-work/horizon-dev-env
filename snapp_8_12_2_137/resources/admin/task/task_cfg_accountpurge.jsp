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
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>

<%
  String never = pageBase.getLang().Common.Never.getText();
  String SnpMaxDays = rights.SnpLoginMaxInactivityDays.getInt() != 0 ? rights.SnpLoginMaxInactivityDays.getInt()+"" : never;  
  String B2BMaxDays = rights.B2BLoginMaxInactivityDays.getInt() != 0 ? rights.B2BLoginMaxInactivityDays.getInt()+"" : never;  
  String B2CMaxDays = rights.B2CLoginMaxInactivityDays.getInt() != 0 ? rights.B2CLoginMaxInactivityDays.getInt()+"" : never;  
%>

<v:widget caption="@Task.AccountPurge_Demographic" hint="@Task.AccountPurge_DemographicHint">
	<v:widget-block>
    <v:form-field caption="@Task.AccountPurge_DemographicExpirationDays" hint="@Task.AccountPurge_DemographicExpirationDaysHint"><v:input-text field="cfg.DemographicExpirationDays" placeholder="@Common.Never"/></v:form-field>
  </v:widget-block>
</v:widget>	
<v:widget caption="@Task.BlockInactiveUsers" hint="@Task.BlockInactiveUsersHint">
	<v:widget-block>
    <v:form-field caption="@Task.SnpLoginMaxInactivityDays"><v:input-text placeholder="<%=SnpMaxDays%>" enabled="false"/></v:form-field>
    <v:form-field caption="@Task.B2BLoginMaxInactivityDays"><v:input-text placeholder="<%=B2BMaxDays%>" enabled="false"/></v:form-field>
    <v:form-field caption="@Task.B2CLoginMaxInactivityDays"><v:input-text placeholder="<%=B2CMaxDays%>" enabled="false"/></v:form-field>
  </v:widget-block>
</v:widget>	

<script>

function saveTaskConfig(reqDO) {
  var config = {
    DemographicExpirationDays: _getIntValue("#cfg\\.DemographicExpirationDays")
	}
	reqDO.TaskConfig = JSON.stringify(config); 


  function _getIntValue(selector) {
    var value = $(selector).val();
    if (getNull(value) == null)
      return  null;
    else {
      var result = parseInt(value);
      if (isNaN(result))
        throw(itl("@Common.InvalidValue") + ": " + value);
      
      return result;
    }
  }
}

</script>

