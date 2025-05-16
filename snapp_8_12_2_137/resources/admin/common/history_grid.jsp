<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_HistoryLog.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_HistoryLog.class);
// Select
qdef.addSelect(Sel.LogDateTime);
qdef.addSelect(Sel.UserAccountId);
qdef.addSelect(Sel.UserAccountNameMasked);
qdef.addSelect(Sel.WorkstationId);
qdef.addSelect(Sel.WorkstationName);
qdef.addSelect(Sel.OpAreaId);
qdef.addSelect(Sel.OpAreaName);
qdef.addSelect(Sel.LocationId);
qdef.addSelect(Sel.LocationName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Filter
qdef.addFilter(Fil.EntityId, pageBase.getParameter("EntityId"));
// Sort
qdef.addSort(Sel.LogDateTime, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <thead>
    <tr>
      <td width="25%"><v:itl key="@Common.DateTime"/></td>
      <td width="25%"><v:itl key="@Common.User"/></td>
      <td width="50%"><v:itl key="@Common.Workstation"/></td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds" dateGroupFieldName="LogDateTime">
      <td><snp:datetime timestamp="<%=ds.getField(Sel.LogDateTime)%>" format="shortdatetime" timezone="local"/></td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.UserAccountId).getString()%>" entityType="<%=LkSNEntityType.Person%>">
          <%=ds.getField(Sel.UserAccountNameMasked).getHtmlString()%>
        </snp:entity-link>
      </td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.LocationId).getString()%>" entityType="<%=LkSNEntityType.Location%>">
          <%=ds.getField(Sel.LocationName).getHtmlString()%>
        </snp:entity-link>
        &raquo;
        <snp:entity-link entityId="<%=ds.getField(Sel.OpAreaId).getString()%>" entityType="<%=LkSNEntityType.OperatingArea%>">
          <%=ds.getField(Sel.OpAreaName).getHtmlString()%>
        </snp:entity-link>
        &raquo;
        <snp:entity-link entityId="<%=ds.getField(Sel.WorkstationId).getString()%>" entityType="<%=LkSNEntityType.Workstation%>">
          <%=ds.getField(Sel.WorkstationName).getHtmlString()%>
        </snp:entity-link>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    