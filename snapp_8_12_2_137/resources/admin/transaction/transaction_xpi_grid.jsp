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
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.CommonStatus);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.TransactionCrossPlatformId);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.CrossPlatformId);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.TransactionId);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.TransactionCode);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.TransactionDateTime);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.TransactionFiscalDate);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.SaleId);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.SaleCode);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.Status);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.AttemptCount);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.NextAttemptDateTime);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.LastAttemptDateTime);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.ServerId);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.ServerCode);
qdef.addSelect(QryBO_TransactionCrossPlatform.Sel.ServerName);
// Where
qdef.addFilter(QryBO_TransactionCrossPlatform.Fil.CrossPlatformId, pageBase.getNullParameter("CrossPlatformId"));
//Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
//Sort
qdef.addSort(QryBO_TransactionCrossPlatform.Sel.TransactionFiscalDate, false);
qdef.addSort(QryBO_TransactionCrossPlatform.Sel.TransactionDateTime, false);
qdef.addSort(QryBO_TransactionCrossPlatform.Sel.TransactionSerial, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<script>
function showXPITransactionDialog(transactionId, crossPlatformId) {
  asyncDialogEasy("xpi/xpi_transaction_dialog", "TransactionId=" + transactionId + "&CrossPlatformId=" + crossPlatformId);
}
</script>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="20%" nowrap>
      <v:itl key="@Common.Code"/><br/>
      <v:itl key="@Common.DateTime"/>
    </td>
    <td width="30%">
      <v:itl key="@Sale.PNR"/><br/>
      &nbsp;
    </td>
    <td width="25%">
      <v:itl key="@Common.Status"/><br/>
      <v:itl key="Last attempt"/>
    </td>
    <td width="25%">
      <v:itl key="Server"/><br/>
      <v:itl key="Next attempt"/>
    </td>
  </tr>    
  <v:grid-row dataset="ds" dateGroupFieldName="<%=QryBO_TransactionCrossPlatform.Sel.TransactionFiscalDate.name()%>">
    <td style="<v:common-status-style status="<%=ds.getField(QryBO_TransactionCrossPlatform.Sel.CommonStatus)%>"/>"><v:grid-checkbox name="CrossPlatformId" dataset="ds" fieldname="CrossPlatformId"/></td>
    <td><v:grid-icon name="transaction.png"/></td>
    <td>
      <a class="list-title" href="javascript:showXPITransactionDialog('<%=ds.getField(QryBO_TransactionCrossPlatform.Sel.TransactionId).getHtmlString()%>','<%=ds.getField(QryBO_TransactionCrossPlatform.Sel.CrossPlatformId).getHtmlString()%>')"><%=ds.getField(QryBO_TransactionCrossPlatform.Sel.TransactionCode).getHtmlString()%></a><br/>
      <snp:datetime timestamp="<%=ds.getField(QryBO_TransactionCrossPlatform.Sel.TransactionDateTime)%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(QryBO_TransactionCrossPlatform.Sel.SaleId).getString()%>" entityType="<%=LkSNEntityType.Sale%>">
        <%=ds.getField(QryBO_TransactionCrossPlatform.Sel.SaleCode).getHtmlString()%>
      </snp:entity-link><br/>
      &nbsp;
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

