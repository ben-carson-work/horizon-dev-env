<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_InstallmentPlan.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_InstallmentPlan.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.InstallmentPlanId);
qdef.addSelect(Sel.InstallmentPlanCode);
qdef.addSelect(Sel.InstallmentPlanName);
qdef.addSelect(Sel.ContractDocTemplateId);
qdef.addSelect(Sel.ContractDocTemplateName);
qdef.addSelect(Sel.EnabledPlatforms);
qdef.addSelect(Sel.ValidDateFrom);
qdef.addSelect(Sel.ValidDateTo);
qdef.addSelect(Sel.CalendarId);
qdef.addSelect(Sel.CalendarName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(Sel.InstallmentPlanName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="instplan-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.InstallmentPlan%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="20%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="20%">
      <v:itl key="@Common.Template"/><br/>
      <v:itl key="@Installment.EnabledPlatforms"/>
    </td>
    <td width="60%">
      <v:itl key="@Common.Calendar"/><br/>
      <v:itl key="@Common.Validity"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="InstallmentPlanId" dataset="ds" fieldname="InstallmentPlanId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.InstallmentPlanId).getString()%>" entityType="<%=LkSNEntityType.InstallmentPlan%>" clazz="list-title">
        <%=ds.getField(Sel.InstallmentPlanName).getHtmlString()%>
      </snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.InstallmentPlanCode).getHtmlString()%></span>
    </td>
    <td>
      <% String contractDocTemplateId = ds.getField(Sel.ContractDocTemplateId).getString(); %>
      <% if (contractDocTemplateId == null) { %>
        -
      <% } else { %>
	      <snp:entity-link entityId="<%=contractDocTemplateId%>" entityType="<%=LkSNEntityType.DocTemplate%>">
	        <%=ds.getField(Sel.ContractDocTemplateName).getHtmlString()%>
	      </snp:entity-link>
      <% } %>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.EnabledPlatforms).isNull() ? "-" : ds.getField(Sel.EnabledPlatforms).getHtmlString()%></span>&nbsp;
    </td>
    <td>
      <% String calendarId = ds.getField(Sel.CalendarId).getString(); %>
      <% if (calendarId == null) { %>
        -
      <% } else { %>
        <snp:entity-link entityId="<%=calendarId%>" entityType="<%=LkSNEntityType.Calendar%>">
          <%=ds.getField(Sel.CalendarName).getHtmlString()%>
        </snp:entity-link>
      <% } %>
      <br/>
      <span class="list-subtitle">
        <v:itl key="@Common.From"/> <%=pageBase.format(ds.getField(Sel.ValidDateFrom), pageBase.getShortDateFormat())%>
        <% if (!ds.getField(Sel.ValidDateTo).isNull()) { %>
          <v:itl key="@Common.To" transform="lowercase"/> <%=pageBase.format(ds.getField(Sel.ValidDateTo), pageBase.getShortDateFormat())%>
        <% } %>
      </span>&nbsp;
    </td>
  </v:grid-row>
</v:grid>
