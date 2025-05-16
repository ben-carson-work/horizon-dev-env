<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Message.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%

QueryDef qdef = new QueryDef(QryBO_Message.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.MessageId);
qdef.addSelect(Sel.MessageType);
qdef.addSelect(Sel.MessageName);
qdef.addSelect(Sel.Enabled);
qdef.addSelect(Sel.ForcePopupDialog);
qdef.addSelect(Sel.DateTimeFrom);
qdef.addSelect(Sel.DateTimeTo);
qdef.addSelect(Sel.Message);
qdef.addSelect(Sel.ReadDateTime);
//Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Filter
qdef.addFilter(Fil.ReadUserAccountId, pageBase.getSession().getUserAccountId());
qdef.addFilter(Fil.ApplyRights, "true");
qdef.addFilter(Fil.ForNow, "true");
// Sort
qdef.addSort(Sel.DateTimeFrom, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.MessageUser%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="80%">
        <v:itl key="@Common.Message"/>
      </td>
      <td width="20%" align="right">
        <v:itl key="@Common.From"/><br/>
        <v:itl key="@Common.To"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <% LookupItem commonStatus = ds.getField(Sel.ReadDateTime).isNull() ? LkCommonStatus.Completed : LkCommonStatus.Draft; %>
      <td style="<v:common-status-style status="<%=commonStatus%>"/>"><v:grid-checkbox name="MessageId" dataset="ds" fieldname="TaxId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.MessageId).getString()%>" entityType="<%=LkSNEntityType.MessageUser%>" clazz="list-title">
          <%=ds.getField(Sel.MessageName).getHtmlString()%>
        </snp:entity-link>
        <br/>
        <% String msg = ds.getField(Sel.Message).getEmptyString(); %>
        <span class="list-subtitle"><%=JvString.escapeHtml(JvString.trunc(msg, 100)) + (msg.length() < 100 ? "" : "...")%></span>&nbsp;
      </td>
      <td align="right">
        <snp:datetime timestamp="<%=ds.getField(Sel.DateTimeFrom)%>" format="shortdatetime" timezone="local"/>
        <br/>
        <span class="list-subtitle">
        <% if (ds.getField(Sel.DateTimeTo).isNull()) { %>
          &mdash;
        <% } else { %>
          <snp:datetime timestamp="<%=ds.getField(Sel.DateTimeTo)%>" format="shortdatetime" timezone="local"/>
        <% } %>
        </span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    