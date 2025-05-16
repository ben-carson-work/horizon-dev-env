<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>
<%@page import="com.vgs.web.library.BLBO_Plugin"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request" />
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request" />

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>
  <v:widget caption="@Common.Settings" icon="settings.png">
	<v:widget-block>
      <v:form-field caption="@Common.DPI">
        <v:input-text field="settings.PrinterDPI" />
      </v:form-field>
	</v:widget-block>

	<v:widget-block>
  	  <table class="form-table">
  		<tr>
  		  <th><label for="settings.ConnectionType"><v:itl key="@Common.InterfaceType" /></label></th>
  		  <td>
            <select id="settings.ConnectionType" class="form-control">
			  <% String sel = (settings.getChildField("ConnectionType").getInt() == 1) ? "selected" : ""; %>
			  <option value="1" <%=sel%>>TCP/IP</option>
			  <% sel = (settings.getChildField("ConnectionType").getInt() == 2) ? "selected" : ""; %>
		      <option value="2" <%=sel%>>USB</option>
  		    </select>
          </td>
  		</tr>
  	  </table>
	</v:widget-block>
	<v:widget-block id="interface-tcp" clazz="v-hidden">
		<table class="form-table">
			<tr>
				<th><label for="settings.PrinterName"><v:itl
							key="@Common.HostName" /></label></th>
				<td><v:input-text field="settings.PrinterName"  /></td>
			</tr>
		</table>
	</v:widget-block>
</v:widget>

<script>
$(document).ready(function() {
  $("#settings\\.ConnectionType").val(<%=settings.getChildField("ConnectionType").getInt()%>);
  enableDisable(); 
});
	  
	$("#settings\\.ConnectionType").change(enableDisable);

	function enableDisable() {
	  var inter = $("#settings\\.ConnectionType").val();
	  $("#interface-tcp").setClass("v-hidden", inter != 1);
	  if(inter != 1)
	  	$("#settings\\.PrinterName").val('');
	}

	function getPluginSettings() {
		return {
			PrinterDPI : $("#settings\\.PrinterDPI").val(),
			PrinterName : $("#settings\\.PrinterName").val(),
			ConnectionType : $("#settings\\.ConnectionType").val()
		};
	}
</script>
