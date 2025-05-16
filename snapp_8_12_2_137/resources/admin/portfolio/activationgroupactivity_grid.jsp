<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_ActivationGroupActivity.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_ActivationGroupActivity.class);
//Select
qdef.addSelect(
  Sel.TransactionId,
  Sel.PrimaryTicketId,
  Sel.PrimaryTicketCode,
  Sel.PrimaryProductId,
  Sel.PrimaryProductName,
  Sel.SecondaryTicketId,
  Sel.SecondaryTicketCode,
  Sel.SecondaryProductId,
  Sel.SecondaryProductName,
  Sel.AddLink);

//Where
if (pageBase.hasParameter("TransactionId"))
  qdef.addFilter(Fil.TransactionId, pageBase.getNullParameter("TransactionId"));

//Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;

//Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="activationgroupactivity-grid" dataset="<%=ds%>" qdef="<%=qdef%>">
  <tr class="header">
    <td>&nbsp;</td>
    <td width="10%">
      <v:itl key="@Common.Action"/>
    </td>
    <td width="15%">
      <v:itl key="@ActivationGroup.PrimaryTicket"/><br/>
      <v:itl key="@Product.ProductType"/>
    </td>
    <td width="75%">
      <v:itl key="@ActivationGroup.SecondaryTicket"/><br/>
      <v:itl key="@Product.ProductType"/>
    </td>
  </tr>
  <tbody>
    <v:grid-row dataset="ds">
      <td>
        <% String iconAlias = ds.getField(Sel.AddLink).getBoolean() ? "plus" : "minus"; %>
        <i class="fa fa-2x fa-<%=iconAlias%>"></i>
      </td>
      <td>
        <%=ds.getField(Sel.AddLink).getBoolean() ? "Link created" : "Link deleted" %>
      </td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.PrimaryTicketId).getString()%>" entityType="<%=LkSNEntityType.Ticket%>" clazz="list-title">
          <%=ds.getField(Sel.PrimaryTicketCode).getHtmlString()%>
        </snp:entity-link><br/>
        <snp:entity-link entityId="<%=ds.getField(QryBO_ActivationGroupActivity.Sel.PrimaryProductId).getEmptyString()%>" entityType="<%=LkSNEntityType.ProductType%>"><%=ds.getField(QryBO_ActivationGroupActivity.Sel.PrimaryProductName).getHtmlString()%></snp:entity-link>
      </td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.SecondaryTicketId).getString()%>" entityType="<%=LkSNEntityType.Ticket%>" clazz="list-title">
          <%=ds.getField(Sel.SecondaryTicketCode).getHtmlString()%>
        </snp:entity-link><br/>
        <snp:entity-link entityId="<%=ds.getField(QryBO_ActivationGroupActivity.Sel.SecondaryProductId).getEmptyString()%>" entityType="<%=LkSNEntityType.ProductType%>"><%=ds.getField(QryBO_ActivationGroupActivity.Sel.SecondaryProductName).getHtmlString()%></snp:entity-link>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
