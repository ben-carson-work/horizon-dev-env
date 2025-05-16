<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Action.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_Action.class);
// Select
qdef.addSelect(
    Sel.CommonStatus,
    Sel.IconName,
    Sel.ActionId,
    Sel.ActionName,
    Sel.EntityType,
    Sel.Email_AddressTo,
    Sel.CreateAccountId,
    Sel.CreateAccountName,
    Sel.CreateDateTime,
    Sel.CloseDateTime);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(Sel.CreateDateTime, false);
// Where
if (pageBase.getNullParameter("LinkEntityId") != null)
  qdef.addFilter(Fil.LinkEntityId, pageBase.getNullParameter("LinkEntityId"));
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="20%">
      <v:itl key="@Action.Subject"/><br/>
      <v:itl key="@Common.Status"/>
    </td>
    <td width="60%">
      <v:itl key="@DocTemplate.Email_From"/><br/>
      <v:itl key="@DocTemplate.Email_To"/>
    </td>
    <td width="20%" align="right">
      <v:itl key="@Common.Created"/><br/>
      <v:itl key="@Common.Sent"/>
    </td>
  </tr>
  <v:grid-row dataset="ds" dateGroupFieldName="<%=Sel.CreateDateTime.name()%>">
    <% LookupItem actionStatus = LkSN.ActionStatus.getItemByCode(ds.getField(Sel.ActionStatus)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="ActionId" dataset="ds" fieldname="ActionId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.ActionId)%>" entityType="<%=ds.getField(Sel.EntityType)%>" clazz="list-title"><%=ds.getField(Sel.ActionName).getHtmlString()%></snp:entity-link><br/>
      <span class="list-subtitle"><%=actionStatus.getHtmlDescription(pageBase.getLang())%></span>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.CreateAccountId)%>" entityType="<%=LkSNEntityType.Account_All%>">
        <%=ds.getField(Sel.CreateAccountName).getHtmlString()%>
      </snp:entity-link>
      <div class="list-subtitle"><%=ds.getField(Sel.Email_AddressTo).getHtmlString()%></div>
    </td>
    <td align="right">
      <snp:datetime timestamp="<%=ds.getField(Sel.CreateDateTime)%>" format="shortdatetime" timezone="local"/>
      
      <div class="list-subtitle"> 
        <% if (ds.getField(Sel.CloseDateTime).isNull()) { %>
          &mdash;
        <% } else { %>
          <snp:datetime timestamp="<%=ds.getField(Sel.CloseDateTime)%>" format="shortdatetime" timezone="local"/>
        <% } %>
      </div>
    </td>
  </v:grid-row>
</v:grid>
