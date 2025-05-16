<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%
JvDocument settings = (JvDocument)request.getAttribute("settings"); 
%>

<%-- <v:widget caption="@Common.Settings">
  <v:widget-block>
     <v:form-field caption="@Common.PortName" mandatory="true">
       <select id="settings.PortName" class="form-control">
         <% for (int i=1;i<4;i++) { %>
           <% String desc = "USB " + i; %>
           <% String sel = JvString.isSameText(settings.getChildField("PortName").getString(), "100" + Integer.toString(i)) ? "selected" : ""; %>
           <option value="<%=1000+i%>" <%=sel%>><%=desc%></option>
         <% } %>
       </select>
     </v:form-field>
    <v:form-field caption="Timeout (secs)">
      <v:input-text field="settings.Timeout" placeholder="10"/>
    </v:form-field>
  </v:widget-block>    
</v:widget>

<script>

function getPluginSettings() {
  return {
	  PortName: $("#settings\\.PortName").val(),
	  Timeout: $("#settings\\.Timeout").val()
  };
}

</script> --%>