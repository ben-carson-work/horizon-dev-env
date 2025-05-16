<%@page import="com.vgs.snapp.lookup.LkSN"%>
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
  <v:widget-block  id="interface-serial">
    <v:form-field caption="@Common.PortName">
      <select id="settings.PortName" class="form-control">
        <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
          <% String com = comPort.getDescription(); %>
          <% String sel = JvString.isSameText(com, settings.getChildField("PortName").getString()) ? "selected" : ""; %>
          <option value="<%=com%>" <%=sel%>><%=com%></option>
        <% } %>
      </select>
    </v:form-field>
    <v:form-field caption="@Common.Chinese">
			<v:db-checkbox field="settings.ChineseText" hint="Flag it if Chinese text has to shown" caption="" value="true" />
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

function getPluginSettings() {
  return {
    PortName: $("#settings\\.PortName").val(),
    ChineseText: $("#settings\\.ChineseText").isChecked()
  };
}

</script>
