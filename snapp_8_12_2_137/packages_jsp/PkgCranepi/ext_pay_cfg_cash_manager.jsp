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
  <v:widget-block>
    <v:form-field caption="Maximum Change">
      <v:input-text field="settings.MaxChange"/>
    </v:form-field>
    <v:form-field caption="@Common.PortName">
      <select id="settings.BillAcceptorPort" class="form-control">
        <% for (LookupItem comPort : LkSN.ComPort.getItems()) { %>
          <% String com = comPort.getDescription(); %>
          <% String sel = JvString.isSameText(com, settings.getChildField("BillAcceptorPort").getString()) ? "selected" : ""; %>
          <option value="<%=com%>" <%=sel%>><%=com%></option>
        <% } %>
      </select>
    </v:form-field>
    <v:form-field caption="Bill to recycle">
      <% int[] bills = new int[] {5, 10, 20, 50, 100}; %>
      <select id="settings.BillToRecycle" class="form-control">
        <% for (int bill : bills) { %>
          <% String sel = (bill == settings.getChildField("BillToRecycle").getInt()) ? "selected" : ""; %>
          <option value="<%=bill%>" <%=sel%>><%=bill%></option>
        <% } %>
      </select>
    </v:form-field>
  </v:widget-block>
</v:widget>


<script>
function getPluginSettings() {
  return {
    MaxChange: $("#settings\\.MaxChange").val(),
    BillAcceptorPort: $("#settings\\.BillAcceptorPort").val(),
    BillToRecycle: $("#settings\\.BillToRecycle").val()
  };
}
</script>
