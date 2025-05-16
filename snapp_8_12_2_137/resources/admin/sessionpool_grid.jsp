<%@page import="com.vgs.web.library.BLBO_Session"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SessionPool.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_SessionPool.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.SessionPoolId);
qdef.addSelect(Sel.SessionPoolName);
qdef.addSelect(Sel.Quantity);
qdef.addSelect(Sel.WorkstationType);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(Sel.WorkstationType);
qdef.addSort(Sel.SessionPoolName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.SessionPool%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="20%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="80%">
      <v:itl key="@Common.SessionInUse"/> / <v:itl key="@Common.Total"/>
    </td>
  </tr>
  <% LookupItem oldWT = null; %>
  <v:ds-loop dataset="<%=ds%>">
    <% LookupItem workstationType = LkSN.WorkstationType.getItemByCode(ds.getField(Sel.WorkstationType)); %>
    <% if (!workstationType.isLookup(oldWT)) { %>
      <% oldWT = workstationType; %>
      <% Integer qtyDefault = pageBase.getBL(BLBO_Session.class).getWorkstationTypeDefault(workstationType); %>
      <tr class="group"><td colspan="100%"><%=workstationType.getHtmlDescription(pageBase.getLang())%></td></tr>
	    <tr class="grid-row">
	      <td>&nbsp;</td>
	      <td><v:grid-icon name="sessionpool.png"/></td>
	      <td><a href="javascript:asyncDialogEasy('sessions_dialog', 'WorkstationType=<%=workstationType.getCode()%>')" class="list-title"><v:itl key="Generic"/></a></td>
        <td>
          <%=pageBase.getBL(BLBO_Session.class).getUsedSessions(workstationType, null)%>
          /
          <% if (qtyDefault == null) { %>
            <v:itl key="@Common.Unlimited"/>
          <% } else { %>
            <%=qtyDefault%>
          <% } %>
        </td>
    </tr>
    <% } %>
    <tr class="grid-row">
	    <td><v:grid-checkbox name="SessionPoolId" dataset="ds" fieldname="SessionPoolId"/></td>
	    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
	    <td>
	      <snp:entity-link entityId="<%=ds.getField(Sel.SessionPoolId).getString()%>" entityType="<%=LkSNEntityType.SessionPool%>" clazz="list-title">
	        <%=ds.getField(Sel.SessionPoolName).getHtmlString()%>
	      </snp:entity-link>
	    </td>
      <td>
        <%=pageBase.getBL(BLBO_Session.class).getUsedSessions(workstationType, ds.getField(Sel.SessionPoolId).getString())%>
        /
        <%=ds.getField(Sel.Quantity).getHtmlString()%>
      </td>
    </tr>
  </v:ds-loop>
</v:grid>
