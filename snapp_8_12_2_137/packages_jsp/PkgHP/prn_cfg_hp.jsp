<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<v:widget caption="@Common.Settings" icon="settings.png">
  <v:widget-block>
    <v:form-field caption="@Common.Name">
       <select id="settings.PrinterLogicName" class="form-control">
        <option value="A799" <%=JvString.isSameText("A799", settings.getChildField("PrinterLogicName").getString()) ? "selected" : ""%>>A799</option>
        <option value="H300S" <%=JvString.isSameText("H300S", settings.getChildField("PrinterLogicName").getString()) ? "selected" : ""%>>H300S</option>
        <option value="H300C" <%=JvString.isSameText("H300C", settings.getChildField("PrinterLogicName").getString()) ? "selected" : ""%>>H300C</option>
      </select>
    </v:form-field>
		<v:form-field caption="Timeout" hint="Define the timeout(in seconds) for the printer commands, if printer doesn't compleate execution of the command in this time an error is raised. Default value is 3 sec.">
			<v:input-text field="settings.CommandTimeout" type="number"  placeholder="3"/>
    </v:form-field>
<%--     <v:form-field caption="@Common.Language">
      <select id="settings.CharSet" class="form-control">
        <% String sel = ""; %>
        <% sel = (settings.CharSet.isSameString("1256")) ? "selected" : ""; %>
        <option value="1256" <%=sel%>>Standard</option>
        <% sel = (settings.CharSet.isSameString("864")) ? "selected" : ""; %>
        <option value="864" <%=sel %>>Arabic</option>
         <% sel = (settings.CharSet.isSameString("936")) ? "selected" : ""; %>
        <option value="936" <%=sel%>>Chinese</option>
      </select>
    </v:form-field> --%>
  </v:widget-block>
</v:widget>
 
 
<script>

function getPluginSettings() {
  return {
    CommandTimeout: $("#settings\\.CommandTimeout").val(),
    PrinterLogicName: $("#settings\\.PrinterLogicName").val()/* ,
    CharSet: $("#settings\\.CharSet").val() */
  };
}

</script>
 