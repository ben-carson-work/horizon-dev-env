<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_OutboundMessage.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_OutboundMessage.class);
// Select
qdef.addSelect(
    Sel.OutboundMessageId,
    Sel.OutboundMessageCode,
    Sel.OutboundMessageName,
    Sel.OutboundMessageStatus,
    Sel.OutboundMessagePriority,
    Sel.OutboundMessageDesc,
    Sel.WorkerClassName,
    Sel.CommonStatus,
    Sel.ExtensionPackageId,
    Sel.ExtensionPackageCode,
    Sel.ExtensionPackageName,
    Sel.ExtensionPackageVersion,
    Sel.BrokerPluginId,
    Sel.BrokerName,
    Sel.DataSourceId,
    Sel.DataSourceName);
// Where
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if (pageBase.getNullParameter("OutboundMessageStatus") != null)
  qdef.addFilter(Fil.OutboundMessageStatus, JvArray.stringToArray(pageBase.getNullParameter("OutboundMessageStatus"), ","));

if (pageBase.getNullParameter("ExtensionPackageId") != null)
  qdef.addFilter(Fil.ExtensionPackageId, pageBase.getNullParameter("ExtensionPackageId"));

if (pageBase.getNullParameter("BrokerPluginId") != null) 
  qdef.addFilter(Fil.BrokerPluginId, pageBase.getNullParameter("BrokerPluginId"));

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;

// Sort
qdef.addSort(Sel.OutboundMessageName);
qdef.addSort(Sel.OutboundMessageCode);

// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="outboundmessage-grid" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.OutboundMessage%>">
  <tr class="header">
    <td>
      <v:grid-checkbox header="true"/>
    </td>
    <td width="20%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="20%" valign="top">
      <v:itl key="@Common.Priority"/>         
    </td>
    <td width="20%" valign="top">
      <v:itl key="@Common.Description"/>         
    </td>
    <td width="20%" valign="top">
      <v:itl key="@Outbound.Broker"/><br/>         
      <v:itl key="@Common.DataSource"/>
    </td>
    <td width="20%">
      <v:itl key="@Plugin.ExtensionPackage"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox dataset="ds" fieldname="OutboundMessageId" name="OutboundMessageId"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.OutboundMessageId).getHtmlString()%>" entityType="<%=LkSNEntityType.OutboundMessage%>" clazz="list-title">
        <%=ds.getField(Sel.OutboundMessageName).getHtmlString()%> 
      </snp:entity-link>
      <br/>
      <span class="list-subtitle"><%= ds.getField(Sel.OutboundMessageCode).getHtmlString() %></span>
    </td>
    <td>
      <%= LkSN.OutboundMessagePriority.getItemByCode(ds.getField(Sel.OutboundMessagePriority)).getHtmlDescription()%>
    </td>
    <td>
      <span class="list-subtitle">
        <%= ds.getField(Sel.OutboundMessageDesc).getHtmlString() %>
      </span>
    </td>
    <td>
      <% if (ds.getField(Sel.BrokerPluginId).isNull()) { %>
        &mdash;
      <% } else { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.BrokerPluginId)%>" entityType="<%=LkSNEntityType.Plugin%>"><%=ds.getField(QryBO_OutboundMessage.Sel.BrokerName).getHtmlString()%></snp:entity-link>
      <% } %>
      <br/>
      <% if (ds.getField(Sel.DataSourceId).isNull()) { %>
        <span class="list-subtitle"><v:itl key="@Outbound.ProductionDataSource"/></span>
      <% } else { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.DataSourceId)%>" entityType="<%=LkSNEntityType.DataSource%>"><%=ds.getField(QryBO_OutboundMessage.Sel.DataSourceName).getHtmlString()%></snp:entity-link>
      <% } %>
    </td>
    <td>
    <%  if (ds.getField(Sel.ExtensionPackageId).isNull()) { %>
      <span class="list-subtitle">&mdash;</span>
    <% } else { %>
      <%=ds.getField(Sel.ExtensionPackageCode).getHtmlString()%>&nbsp;<%=ds.getField(Sel.ExtensionPackageVersion).getHtmlString()%><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.ExtensionPackageName).getHtmlString()%></span>
    <% } %>
    </td>
  </v:grid-row>
</v:grid>
