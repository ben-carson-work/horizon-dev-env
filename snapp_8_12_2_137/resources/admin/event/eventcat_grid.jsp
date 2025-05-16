<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_EventCategory.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%

QueryDef qdef = new QueryDef(QryBO_EventCategory.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.EventCategoryId);
qdef.addSelect(Sel.EventCategoryCode);
qdef.addSelect(Sel.EventCategoryName);
qdef.addSelect(Sel.EventCategoryType);
// Where

if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if (pageBase.getNullParameter("EventCategoryType") != null)
  qdef.addFilter(Fil.EventCategoryType, JvArray.stringToIntArray(pageBase.getNullParameter("EventCategoryType"), ","));

// Sort
qdef.addSort(Sel.EventCategoryType);
qdef.addSort(Sel.EventCategoryName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="15%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="85%">
      <v:itl key="@Common.Type"/>           
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <% LookupItem eventCatType = LkSN.EventCategoryType.getItemByCode(ds.getField(Sel.EventCategoryType)); %>
    <td><v:grid-checkbox name="EventCategoryId" dataset="ds" fieldname="EventCategoryId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <a href="javascript:eventCatDialog('<%=ds.getField(Sel.EventCategoryId).getHtmlString()%>')" class="list-title"><%=ds.getField(Sel.EventCategoryName).getHtmlString()%></a><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.EventCategoryCode).getHtmlString()%>&nbsp;</span>
    </td>
    <td>
      <%=eventCatType.getDescription(pageBase.getLang())%><br/>
    </td>
  </v:grid-row>
</v:grid>

<script>
  function eventCatDialog(productId) {
    asyncDialogEasy("event/eventcat_dialog", "id=" + productId);
  }

</script>

