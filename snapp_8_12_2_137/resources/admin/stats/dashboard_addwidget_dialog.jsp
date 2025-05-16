<%@page import="com.vgs.snapp.dataobject.DODashboard"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_DocTemplate.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>


<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_DocTemplate.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.DocTemplateId);
qdef.addSelect(Sel.DocTemplateName);
// Filter
qdef.addFilter(Fil.DocTemplateType, LkSNDocTemplateType.Widget.getCode());
// Sort
qdef.addSort(Sel.DocTemplateName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<div id="dashboard_addwidget_dialog">

<script>

var widgets = {};

</script>

<v:grid>
  <v:grid-row dataset="ds">
    <% 
    DODashboard.DOWidget widget = new DODashboard.DOWidget();
    widget.Column.setInt(0);
    widget.DocTemplateId.assign(ds.getField(Sel.DocTemplateId));
    widget.WidgetName.assign(ds.getField(Sel.DocTemplateName));
    %>
    <script>widgets["<%=ds.getField(Sel.DocTemplateId).getHtmlString()%>"] = <%=widget.getJSONString()%>;</script>
    <td><a href="javascript:doPickupWidget(widgets['<%=ds.getField(Sel.DocTemplateId).getHtmlString()%>'])" class="list-title"><%=ds.getField(Sel.DocTemplateName).getHtmlString()%></a></td>
  </v:grid-row>
</v:grid>


<script>

$(document).ready(function() {
  var dlg = $("#dashboard_addwidget_dialog");
  dlg.dialog({
    modal: true,
    width: 500,
    height: 400,
    close: function() {
      dlg.remove();
    }
  });
});

</script>

</div>


