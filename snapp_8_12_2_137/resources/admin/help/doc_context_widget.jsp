<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_DocTemplate.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<%
  QueryDef qdef = new QueryDef(QryBO_DocTemplate.class);
  // Select
  qdef.addSelect(Sel.IconName);
  qdef.addSelect(Sel.DocTemplateId);
  qdef.addSelect(Sel.DocTemplateName);
  qdef.addSelect(Sel.DocEditorType);
  // Filter
  qdef.addFilter(Fil.DocTemplateType, LkSNDocTemplateType.StatReport.getCode());
  qdef.addFilter(Fil.DocEnabled, "true");
  qdef.addFilter(Fil.ContextType, request.getParameter("ContextType"));
  if (!pageBase.getRights().SuperUser.getBoolean())
    qdef.addFilter(Fil.ForUserAccountId, pageBase.getSession().getUserAccountId());
  // Sort
  qdef.addSort(Sel.DocTemplateName);
  // Exec
  JvDataSet ds = pageBase.execQuery(qdef);
  request.setAttribute("ds", ds);
%>

<% if (!ds.isEmpty()) { %>
  <v:grid>
    <thead>
      <v:grid-title caption="@DocTemplate.StatReports" icon="chart.png"/>
    </thead>
    <tbody>
      <v:grid-row dataset="ds">
        <% LookupItem docEditorType = LkSN.DocEditorType.getItemByCode(ds.getField(Sel.DocEditorType)); %>
        <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
        <td width="100%">
          <%=ds.getField(Sel.DocTemplateName).getHtmlString()%><br/>
          <span class="list-subtitle"><%=docEditorType.getHtmlDescription(pageBase.getLang())%></span>
        </td>
      </v:grid-row>
    </tbody>
  </v:grid>
<% } %>
