<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Survey.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Survey.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.SurveyId);
qdef.addSelect(Sel.SurveyCode);
qdef.addSelect(Sel.SurveyName);
qdef.addSelect(Sel.SurveyType);
qdef.addSelect(Sel.MaskNames);
// Filter
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getParameter("FullText"));
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(Sel.SurveyName, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Survey%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="80%">
        <v:itl key="@Common.Type"/><br/>
        <v:itl key="@Common.DataMasks"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <% LookupItem surveyType = LkSN.SurveyType.getItemByCode(ds.getField(Sel.SurveyType)); %>
      <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="SurveyId" dataset="ds" fieldname="SurveyId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.SurveyId)%>" entityType="<%=LkSNEntityType.Survey%>" clazz="list-title">
          <%=ds.getField(Sel.SurveyName).getHtmlString()%>
        </snp:entity-link>
        <br/>
        <span class="list-subtitle">
          <%=ds.getField(Sel.SurveyCode).getHtmlString()%>
        </span>
      </td>
      <td>
        <%=surveyType.getHtmlDescription(pageBase.getLang())%><br/>
        <span class="list-subtitle">
          <%=ds.getField(Sel.MaskNames).getHtmlString()%>
        </span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    