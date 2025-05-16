<%@page import="com.vgs.web.library.BLBO_Session"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Session.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Session.class);
// Select
qdef.addSelect(Sel.SessionId);
qdef.addSelect(Sel.SessionPoolId);
qdef.addSelect(Sel.SessionPoolName);
qdef.addSelect(Sel.WorkstationId);
qdef.addSelect(Sel.WorkstationName);
qdef.addSelect(Sel.WorkstationType);
qdef.addSelect(Sel.UserAccountId);
qdef.addSelect(Sel.UserAccountName);
qdef.addSelect(Sel.CreateDateTime);
qdef.addSelect(Sel.ExpireDateTime);
qdef.addSelect(Sel.IPAddress);
qdef.addSelect(Sel.SuperUser);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = 10;//QueryDef.recordPerPageDefault;

// Filters

if (pageBase.getNullParameter("SessionPoolId") != null)
  qdef.addFilter(Fil.SessionPoolId, pageBase.getNullParameter("SessionPoolId"));

if (pageBase.getNullParameter("WorkstationType") != null)
  qdef.addFilter(Fil.WorkstationType, pageBase.getNullParameter("WorkstationType"));

// Sort
qdef.addSort(Sel.CreateDateTime);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <tr class="header">
    <td width="30%">
      <v:itl key="@Common.Workstation"/><br/>
      <v:itl key="@Common.User"/>
    </td>
    <td width="30%">
      <v:itl key="@Common.Created"/><br/>
      <v:itl key="@Common.Expiration"/>
    </td>
    <td width="30%">
      <v:itl key="@Common.IPAddress"/><br/>
      SuperUser
    </td>
    <td width="10%">
      &nbsp;
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.WorkstationId).getString()%>" entityType="<%=LkSNEntityType.Workstation%>">
        <%=ds.getField(Sel.WorkstationName).getHtmlString()%>
      </snp:entity-link>
      <br/>      
      <snp:entity-link entityId="<%=ds.getField(Sel.UserAccountId).getString()%>" entityType="<%=LkSNEntityType.Person%>">
        <%=ds.getField(Sel.UserAccountName).getHtmlString()%>
      </snp:entity-link>      
    </td>    
    <td>
      <snp:datetime timestamp="<%=ds.getField(Sel.CreateDateTime)%>" format="shortdatetime" timezone="local"/><br/>
      <snp:datetime timestamp="<%=ds.getField(Sel.ExpireDateTime)%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
    </td>    
    <td>
      <%=ds.getField(Sel.IPAddress).getHtmlString()%><br/>
      <% String sSuperUser = ds.getField(Sel.SuperUser).getBoolean() ? "@Common.Yes" : "@Common.No"; %>
      <span class="list-subtitle"><v:itl key="<%=sSuperUser%>"/></span>
    </td>    
    <td align="right">
      <% if (!ds.getField(Sel.SuperUser).getBoolean()) { %>
        <% String hrefKillSession = "javascript:doKillSession('" + ds.getField(Sel.SessionId).getHtmlString() + "')"; %>
        <v:button fa="trash" clazz="row-hover-visible" href="<%=hrefKillSession%>"/>
      <% } %>
    </td>
  </v:grid-row>
</v:grid>

<script>
function doKillSession(sessionId) {
  var reqDO = {
    Command: "KillSession",
    KillSession: {
      SessionId: sessionId
    }
  };
  
  vgsService("session", reqDO, false, function() {
    changeGridPage("#session-grid", "first");
  });
}
</script>