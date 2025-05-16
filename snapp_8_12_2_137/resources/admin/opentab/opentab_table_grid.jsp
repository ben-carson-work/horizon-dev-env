<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
String opAreaAccountId = pageBase.getParameter("OpAreaId");
QueryDef qdef = new QueryDef(QryBO_OpentabTable.class);
// Select
qdef.addSelect(QryBO_OpentabTable.Sel.CommonStatus);
qdef.addSelect(QryBO_OpentabTable.Sel.TableId);
qdef.addSelect(QryBO_OpentabTable.Sel.TableCode);
qdef.addSelect(QryBO_OpentabTable.Sel.TableName);
qdef.addSelect(QryBO_OpentabTable.Sel.TableStatus);
qdef.addSelect(QryBO_OpentabTable.Sel.OpAreaAccountId);
qdef.addSelect(QryBO_OpentabTable.Sel.Quantity);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Filter
qdef.addFilter(QryBO_OpentabTable.Fil.OpAreaAccountId, pageBase.getParameter("OpAreaId"));
// Sort
qdef.addSort(QryBO_OpentabTable.Sel.TableName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>


<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.OpentabTable%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td width="50%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="50%">
        <v:itl key="@Common.Status"/><br/>
        <v:itl key="@OpenTab.Seats"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
	    <td style="<v:common-status-style status="<%=ds.getField(QryBO_OpentabTable.Sel.CommonStatus)%>"/>"><v:grid-checkbox name="TableId" dataset="ds" fieldname="TableId"/></td>
	    <td>
	      <% String hRef = "javascript:asyncDialogEasy('opentab/opentab_table_dialog', 'id=" + ds.getField(QryBO_OpentabTable.Sel.TableId).getString() + "&OpAreaId=" + opAreaAccountId + "')";%>
	      <a class="list-title" href="<%=hRef%>"><%=ds.getField(QryBO_OpentabTable.Sel.TableName).getHtmlString()%></a><br/>
	      <span class="list-subtitle"><%=ds.getField(QryBO_OpentabTable.Sel.TableCode).getHtmlString()%></span>
	    </td>
	    <td>
	      <% LookupItem status = LkSN.TableStatus.getItemByCode(ds.getField(QryBO_OpentabTable.Sel.TableStatus).getInt()); %>
	      <%=status.getHtmlDescription(pageBase.getLang())%><br/>
	      <span class="list-subtitle"><%=ds.getField(QryBO_OpentabTable.Sel.Quantity).getHtmlString()%></span>
	    </td>
    </v:grid-row>
  </tbody>
</v:grid>
    