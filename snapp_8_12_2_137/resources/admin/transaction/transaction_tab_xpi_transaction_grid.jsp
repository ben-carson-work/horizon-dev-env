<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
 
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_TransactionCrossPlatform.class);
// Select
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.IconName);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.CommonStatus);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.TransactionCrossPlatformId);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.TransactionId);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.SaleId);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.CrossPlatformId);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.CrossPlatformName);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.CrossPlatformType);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.Status);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.AttemptCount);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.NextAttemptDateTime);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.LastAttemptDateTime);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.ServerId);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.ServerCode);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.ServerName);

// Where
if (pageBase.getNullParameter("TransactionId") != null)
  qdef.addFilter(QryBO_TransactionCrossPlatform.Fil.TransactionId, pageBase.getNullParameter("TransactionId"));
else if (pageBase.getNullParameter("SaleId") != null)
  qdef.addFilter(QryBO_TransactionCrossPlatform.Fil.SaleId, pageBase.getNullParameter("SaleId"));

// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<script>
function showXPITransactionDialog(saleId, crossPlatformId) {
  asyncDialogEasy("xpi/xpi_transaction_dialog", "SaleId=" + saleId + "&CrossPlatformId=" + crossPlatformId);
}
</script>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="30%">
      <v:itl key="@XPI.CrossPlatformName"/><br/>
      <v:itl key="@XPI.CrossPlatformType"/>
    </td>
    <td width="40%">
      <v:itl key="@Common.Status"/><br/>
      <v:itl key="Last attempt"/>
    </td>
    <td width="30%">
      <v:itl key="Server"/><br/>
      <v:itl key="Next attempt"/>
    </td>
  </tr>    
  <v:grid-row dataset="ds">
    <td style="<v:common-status-style status="<%=ds.getField(QryBO_TransactionCrossPlatform.Sel.CommonStatus)%>"/>"><v:grid-checkbox name="TransactionCrossPlatformId" dataset="ds" fieldname="TransactionCrossPlatformId"/></td>
    <td><v:grid-icon name="<%=ds.getField(QryBO_TransactionCrossPlatform.Sel.IconName).getString()%>"/></td>
    <td>
      <a class="list-title" href="javascript:showXPITransactionDialog('<%=ds.getField(QryBO_TransactionCrossPlatform.Sel.SaleId).getHtmlString()%>','<%=ds.getField(QryBO_TransactionCrossPlatform.Sel.CrossPlatformId).getHtmlString()%>')"><%=ds.getField(QryBO_TransactionCrossPlatform.Sel.CrossPlatformName).getHtmlString()%></a><br/>
      <span class="list-subtitle">
        <% LookupItem type = LkSN.CrossPlatformType.findItemByCode(ds.getField(QryBO_TransactionCrossPlatform.Sel.CrossPlatformType).getInt());%>
        <%=type.getHtmlDescription()%>
      </span>
    </td>
    <td>
      <% LookupItem status = LkSN.TransactionCrossPlatformStatus.findItemByCode(ds.getField(QryBO_TransactionCrossPlatform.Sel.Status).getInt());%>
      <%=status.getHtmlDescription()%><br/>
      <span class="list-subtitle">
        <% if (ds.getField(QryBO_TransactionCrossPlatform.Sel.LastAttemptDateTime).isNull()) { %>
          &mdash;
        <% } else { %>
          <%=ds.getField(QryBO_TransactionCrossPlatform.Sel.LastAttemptDateTime).getHtmlString()%>
        <% } %>
      </span>
    </td>
    <td>
      <% if (ds.getField(QryBO_TransactionCrossPlatform.Sel.ServerId).isNull()) { %>
        &mdash;
      <% } else { %>
        <snp:entity-link entityId="<%=ds.getField(QryBO_TransactionCrossPlatform.Sel.ServerId)%>" entityType="<%=LkSNEntityType.Server%>">
        <%=ds.getField(QryBO_TransactionCrossPlatform.Sel.ServerName).getHtmlString()%>
        </snp:entity-link>
      <% } %>
      <br/>
      <span class="list-subtitle">
        <% if (ds.getField(QryBO_TransactionCrossPlatform.Sel.NextAttemptDateTime).isNull()) { %>
          &mdash;<br/>
        <% } else { %>
          <%=ds.getField(QryBO_TransactionCrossPlatform.Sel.NextAttemptDateTime).getHtmlString()%>
        <% } %>
      </span>      
    </td>
  </v:grid-row>
</v:grid>

