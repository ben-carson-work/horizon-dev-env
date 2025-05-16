<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.web.library.BLBO_DBInfo"%>
<%@page import="com.vgs.cl.document.JvFieldNode"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Server.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<style>

.snp-current-server {
  background-color: gray;
  border-radius: 14px;
  padding: 5px 10px;
  color: white;
}

.snp-service-active {
  color: var(--base-green-color);
}

.snp-service-draft {
  display: none;
}

.snp-service-warn {
  color: var(--base-orange-color);
}

.snp-service-deleted {
  color: var(--base-red-color);
}

.server-setting-btn {
  opacity: 0.4;
  font-size: 1.3em;
}

.server-setting-btn:hover {
  opacity: 1;
}

</style>

<%
QueryDef qdef = new QueryDef(QryBO_Server.class);
// Select
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.ServerId);
qdef.addSelect(Sel.ServerCode);
qdef.addSelect(Sel.ServerName);
qdef.addSelect(Sel.CheckDateTime);
qdef.addSelect(Sel.StartupDateTime);
qdef.addSelect(Sel.ServicesEnabled);
qdef.addSelect(Sel.WarVersion);
qdef.addSelect(Sel.ServicesEnabled);
qdef.addSelect(Sel.ServicesStarted);
qdef.addSelect(Sel.CalcServerURL);
qdef.addSelect(Sel.ServerProfileId);
qdef.addSelect(Sel.CalcServerProfileId);
qdef.addSelect(Sel.CalcServerProfileName);
qdef.addSelect(Sel.ParamServerProfileCode);
//Where
if (pageBase.getNullParameter("FullText") != null)
qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if (pageBase.getNullParameter("ServerProfileId") != null)
qdef.addFilter(Fil.ServerProfileId, pageBase.getNullParameter("ServerProfileId"));

// Sort
qdef.addSort(Sel.ServerId);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Server%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td align="center">
      #
    </td>
    <td width="25%">
      <v:itl key="@Common.Name"/><br>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="25%">
      Last Startup<br>
      Services
    </td>
    <td width="25%">
      Server Profile
    </td>
    <td width="25%">
      WAR Version<br>
      Server URL
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <%
    int status = ds.getInt(Sel.CommonStatus);
    int id = ds.getField(Sel.ServerId).getInt();
    
    boolean servicesEnabled = "true".equals(ds.getField(Sel.ServicesEnabled).getString());
    boolean servicesStarted = "true".equals(ds.getField(Sel.ServicesStarted).getString());
    String serviceStatus = "active";
    String serviceStatusDesc = "Running";
    if (!servicesEnabled) {
      serviceStatus = "warn";
      serviceStatusDesc = "Disabled";
    } else if (!servicesStarted) {
      serviceStatus = "deleted";
      serviceStatusDesc = "Enabled / Not Started";
    } else if (status == LkCommonStatus.Draft.getCode()) { // server watchdog service doesn't respond
      serviceStatus = "draft";
    }
     
    %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="ServerId" dataset="ds" fieldname="ServerId" value="<%=String.valueOf(id)%>" /></td>
    <td align="center" class="id-column" data-id="<%=id%>">
    <% if (id == BLBO_DBInfo.getServerId()) { %>
      <span class="snp-current-server"><%=id%></span>
    <% } else { %>
      <%=id%>
    <% } %>
    </td>
    <td>
      <snp:entity-link entityId="<%=String.valueOf(id)%>" entityType="<%=LkSNEntityType.Server%>" clazz="list-title"><%=ds.getField(Sel.ServerName).getHtmlString()%></snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.ServerCode).getHtmlString()%></span>
    </td>
    <td>
      <snp:datetime timestamp="<%=ds.getField(Sel.StartupDateTime)%>" format="shortdatetime" timezone="local"/>
      <br>
      <span class="list-subtitle">
        <span class="snp-service-<%=serviceStatus%>"><%=serviceStatusDesc %></span>
      </span>
    </td>
    <td>
      <% if (ds.getField(Sel.CalcServerProfileId).isNull()) { %>
        <span style="color:red;"><%=ds.getField(Sel.ParamServerProfileCode).getHtmlString()%></span>
      <% } else { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.CalcServerProfileId)%>" entityType="<%=LkSNEntityType.ServerProfile%>">
          <%=ds.getField(Sel.CalcServerProfileName).getHtmlString()%>
        </snp:entity-link>
      <% } %>
    </td>
    <td>
      <%=ds.getField(Sel.WarVersion).getEmptyString() %><br>
      <span class="list-subtitle"><%=ds.getField(Sel.CalcServerURL).getEmptyString() %></span>
    </td>
  </v:grid-row>
</v:grid>