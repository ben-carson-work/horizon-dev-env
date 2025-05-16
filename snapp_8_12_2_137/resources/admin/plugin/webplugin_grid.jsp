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
QueryDef qdef = new QueryDef(QryBO_Plugin.class)
    .addSort(Sel.DriverType)
    .addSort(Sel.PluginDisplayName)
    .setPaging(pageBase.getQP(), QueryDef.recordPerPageDefault)
    .addSelect(
        Sel.CommonStatus,
        Sel.IconName,
        Sel.DriverId,
        Sel.PluginDisplayName,
        Sel.DriverType,
        Sel.DriverLibraryName,
        Sel.ExtensionPackageEnabled,
        Sel.PluginId);

// Where
qdef.addFilter(Fil.PaymentPlugin, "");
if (pageBase.getNullParameter("DriverType") != null)
  qdef.addFilter(Fil.DriverType, pageBase.getNullParameter("DriverType"));

if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if (pageBase.getNullParameter("ExtPackStatus") != null)
  qdef.addFilter(Fil.PluginEnabled, JvArray.stringToArray(pageBase.getNullParameter("ExtPackStatus"), ","));

if (pageBase.getNullParameter("ExtPackExtension") != null)
  qdef.addFilter(Fil.ExtensionPackageId, pageBase.getNullParameter("ExtPackExtension"));

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
    <td width="70%">
      <v:itl key="@Plugin.ExtensionPackage"/><br/>
      <v:itl key="@Common.Status"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <% LookupItem driverType = LkSN.DriverType.getItemByCode(ds.getField(QryBO_Plugin.Sel.DriverType)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="PluginId" dataset="ds" fieldname="PluginId"/></td>
    <td><v:grid-icon name="<%=ds.getField(QryBO_Plugin.Sel.IconName).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(QryBO_Plugin.Sel.PluginId)%>" entityType="<%=LkSNEntityType.Plugin%>" clazz="list-title"><%=ds.getField(QryBO_Plugin.Sel.PluginDisplayName).getHtmlString()%></snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=driverType.getHtmlDescription(pageBase.getLang())%></span>
    </td>
    <td>
      <%=ds.getField(QryBO_Plugin.Sel.DriverLibraryName).getHtmlString()%><br/>
      <%String extPkgEnabled = ds.getField(QryBO_Plugin.Sel.ExtensionPackageEnabled).getNullString();%>
      <% String status = ds.getField(QryBO_Plugin.Sel.PluginEnabled).getBoolean() ? pageBase.getLang().Common.Enabled.getHtmlText() : pageBase.getLang().Common.Disabled.getHtmlText();%>
      <span class="list-subtitle"><%=extPkgEnabled==null ? "" : status%></span>
    </td>
  </v:grid-row>
</v:grid>

