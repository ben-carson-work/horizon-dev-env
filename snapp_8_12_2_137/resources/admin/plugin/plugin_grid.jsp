<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Plugin.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_Plugin.class);
// Select
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.PluginId);
qdef.addSelect(Sel.DriverType);
qdef.addSelect(Sel.PluginDisplayName);
qdef.addSelect(Sel.PaymentMethodNames);
qdef.addSelect(Sel.DeviceAlias);
// Where
if (pageBase.getNullParameter("WorkstationId") != null)
  qdef.addFilter(Fil.WorkstationId, pageBase.getNullParameter("WorkstationId"));
if (pageBase.getNullParameter("DriverType") != null)
  qdef.addFilter(Fil.DriverType, pageBase.getNullParameter("DriverType"));
// Sort
qdef.addSort(Sel.DriverType);
qdef.addSort(Sel.DriverName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Plugin%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="30%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Type"/>
    </td>
    <td width="20%">
      <v:itl key="@Common.Alias"/>
    </td>
    <td width="50%">
      <v:itl key="Payment method"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <% LookupItem driverType = LkSN.DriverType.getItemByCode(ds.getField(Sel.DriverType)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="PluginId" dataset="ds" fieldname="PluginId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.PluginId).getString()%>" entityType="<%=LkSNEntityType.Plugin%>" clazz="list-title">
        <%=ds.getField(Sel.PluginDisplayName).getHtmlString()%>
      </snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=driverType.getHtmlDescription(pageBase.getLang())%></span>
    </td>
    <td>
      <span class="list-subtitle"><%=ds.getField(Sel.DeviceAlias).getHtmlString()%></span>
    </td>
    <td>
      <span class="list-subtitle"><%=ds.getField(Sel.PaymentMethodNames).getHtmlString()%></span>
    </td>
  </v:grid-row>
</v:grid>
