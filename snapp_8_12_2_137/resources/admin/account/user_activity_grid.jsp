<%@page import="java.util.Map.Entry"%>
<%@page import="com.vgs.cl.database.JvDB"%>
<%@page import="com.vgs.web.library.BLBO_Resource"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.json.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_UserActivity.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
  QueryDef qdef = new QueryDef(QryBO_UserActivity.class);
  //Select
  qdef.addSelect(
  Sel.FiscalDate,
  Sel.LoginDateTime,
  Sel.LogoutDateTime,
  Sel.SessionMinutes,
  Sel.LocationAccountId,
  Sel.LocationName,
  Sel.OpAreaAccountId,
  Sel.OpAreaName,
  Sel.WorkstationId,
  Sel.WorkstationName,
  Sel.UserAccountId,
  Sel.UserAccountEntityType,
  Sel.UserName,
  Sel.ExtPluginId,
  Sel.ExtPluginName,
  Sel.TransactionCount);
  //Paging
  qdef.pagePos = pageBase.getQP();
  qdef.recordPerPage = QueryDef.recordPerPageDefault;
  //Sort
  qdef.addSort(Sel.FiscalDate, false);
//Filter
  if (pageBase.getNullParameter("FromDate") != null)
    qdef.addFilter(Fil.FromDate, pageBase.getNullParameter("FromDate"));

  if (pageBase.getNullParameter("ToDate") != null)
    qdef.addFilter(Fil.ToDate, pageBase.getNullParameter("ToDate"));
  
  if (pageBase.getNullParameter("UserAccountId") != null)
    qdef.addFilter(Fil.UserAccountId, pageBase.getNullParameter("UserAccountId"));
  
  if (pageBase.getNullParameter("WorkstationId") != null)
    qdef.addFilter(Fil.WorkstationId, pageBase.getNullParameter("WorkstationId"));
  
  //Exec
  JvDataSet ds = pageBase.execQuery(qdef);
  request.setAttribute("ds", ds);
%>


<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <tr class="header">
    <td width="20%" nowrap align="left">
      <v:itl key="@Common.Login"/>&nbsp;&mdash;&nbsp;<v:itl key="@Common.Logout"/><br/><v:itl key="@Common.Duration"/>
    </td>
    <td width="40%">
      <v:itl key="@Account.Location"/> &raquo; <v:itl key="@Account.OpArea"/> &raquo; <v:itl key="@Common.Workstation"/><br/>
      <v:itl key="@Common.User"/>
    </td>
    <td width="40%">
      <v:itl key="@Plugin.Plugin"/>
    </td>
    <td align="right">
      <v:itl key="@Common.Transactions"/>
    </td>
  </tr>
  <v:grid-row dataset="ds" dateGroupFieldName="<%=Sel.FiscalDate.name()%>">
    <td align="left">
    <%
      JvDateTime loginDate = ds.getField(Sel.LoginDateTime).getDateTime();
        JvDateTime logoutDate = ds.getField(Sel.LogoutDateTime).getDateTime();
    %>
      <snp:datetime timestamp="<%=loginDate%>" format="shortdatetime" timezone="local" clazz="list-title"/>&nbsp;&mdash;&nbsp;
      <%
        if (logoutDate != null){
      %>
        <snp:datetime timestamp="<%=logoutDate%>" format="shortdatetime" timezone="local" clazz="list-title"/>
      <%
        }else{
      %>
        <span class="list-title"><v:itl key="@Common.SessionInUse"/></span>
       <%
         }
       %>
      <br/><span class="list-subtitle" align="left"><%=JvDateUtils.getSmoothTime(((logoutDate == null ? new JvDateTime().getGMTInMills() : logoutDate.getGMTInMills()) - loginDate.getGMTInMills()))%></span>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.LocationAccountId).getString()%>" entityType="<%=LkSNEntityType.Location%>"><%=ds.getField(Sel.LocationName).getHtmlString()%></snp:entity-link> &raquo;
      <snp:entity-link entityId="<%=ds.getField(Sel.OpAreaAccountId).getString()%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=ds.getField(Sel.OpAreaName).getHtmlString()%></snp:entity-link> &raquo;
      <snp:entity-link entityId="<%=ds.getField(Sel.WorkstationId).getString()%>" entityType="<%=LkSNEntityType.Workstation%>"><%=ds.getField(Sel.WorkstationName).getHtmlString()%></snp:entity-link>
      <br/>
      <% if (ds.getField(Sel.UserAccountId).isNull()) { %>
        &nbsp;
      <% } else { %>
        <% LookupItem userAccountEntityType = LkSN.EntityType.getItemByCode(ds.getField(Sel.UserAccountEntityType)); %>
        <snp:entity-link entityId="<%=ds.getField(Sel.UserAccountId).getString()%>" entityType="<%=userAccountEntityType%>"><%=ds.getField(Sel.UserName).getHtmlString()%></snp:entity-link>
      <% }%>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.ExtPluginId).getString()%>" entityType="<%=LkSNEntityType.Plugin%>"><%=ds.getField(Sel.ExtPluginName).getHtmlString()%></snp:entity-link>
    </td>
    <td align="right">
      <%=ds.getField(Sel.TransactionCount).getHtmlString()%>
    </td>
  </v:grid-row>
</v:grid>
