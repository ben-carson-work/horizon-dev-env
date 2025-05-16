<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Plugin.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_Plugin.class)
    .addSelect(
        Sel.PaymentIconName,
        Sel.PluginPaymentMethodIconAlias,
        Sel.PluginPaymentMethodForegroundColor,
        Sel.PluginPaymentMethodBackgroundColor,
        Sel.PluginPaymentMethodOnlineStatus,
        Sel.CommonStatus,
        Sel.PluginId,
        Sel.WorkstationId,
        Sel.WorkstationName,
        Sel.DriverId,
        Sel.DriverType,
        Sel.PluginName,
        Sel.PluginDisplayName,
        Sel.PluginEnabled,
        Sel.PluginDefault,
        Sel.PaymentMethodCode,
        Sel.PaymentGroupTagName, 
        Sel.DebitLedgerAccountCode,
        Sel.DebitLedgerAccountName,
        Sel.CreditLedgerAccountCode,
        Sel.CreditLedgerAccountName)
    .addFilter(Fil.DriverType, LkSNDriverType.getGroup(LkSNDriverType.GROUP_Payment))
    .addSort(Sel.PriorityOrder)
    .setPaging(pageBase.getQP(), QueryDef.recordPerPageDefault);
// Filter
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if (pageBase.getNullParameter("PaymentStatus") != null)
  qdef.addFilter(Fil.PluginEnabled, JvArray.stringToArray(pageBase.getNullParameter("PaymentStatus"), ","));

if (pageBase.getNullParameter("PaymentType") != null)
  qdef.addFilter(Fil.DriverType, JvArray.stringToArray(pageBase.getNullParameter("PaymentType"), ","));

JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="paymentmethod-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.PaymentMethod%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="20%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Type"/>
    </td>
    <td width="20%">
      <v:itl key="@Common.PriorityOrder"/><br/>
      <v:itl key="@Common.Default"/>
    </td>
    <td width="20%">
      <v:itl key="@Plugin.PaymentGroup"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="20%">
      <v:itl key="@Ledger.RuleSource"/>
    </td>
    <td width="20%">
      <v:itl key="@Ledger.RuleTarget"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <% LookupItem driverType = LkSN.DriverType.getItemByCode(ds.getField(Sel.DriverType)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="PluginId" dataset="ds" fieldname="PluginId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.PaymentIconName).getString()%>" iconAlias="<%=ds.getField(Sel.PluginPaymentMethodIconAlias).getString()%>" foregroundColor="<%=ds.getField(Sel.PluginPaymentMethodForegroundColor).getString()%>" backgroundColor="<%=ds.getField(Sel.PluginPaymentMethodBackgroundColor).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.PluginId)%>" entityType="<%=LkSNEntityType.PaymentMethod%>" clazz="list-title">
        <%=ds.getField(Sel.PluginDisplayName).getHtmlString()%>
      </snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=driverType.getDescription(pageBase.getLang())%></span>
    </td>
    <td>
      <%=ds.getField(Sel.PriorityOrder).getHtmlString()%>
      <br/>
      <% if (ds.getField(Sel.PluginDefault).getBoolean()) { %>
        <span class="list-subtitle"><v:itl key="@Common.Default"/></span>
      <% } %>
      &nbsp;
    </td>
    <td>
      <span class="list-subtitle">
        <% if (ds.getField(Sel.PaymentGroupTagName).isNull()) { %>
          &mdash;
        <% } else { %>
          <%=ds.getField(Sel.PaymentGroupTagName).getHtmlString()%>
        <% } %>
      </span>
      <br/>
      <span class="list-subtitle">
        <% if (ds.getField(Sel.PaymentMethodCode).isNull()) { %>
          &mdash;
        <% } else { %>
          <%=ds.getField(Sel.PaymentMethodCode).getHtmlString()%>
        <% } %>
      </span>
    </td>
    <td>
      <%=ds.getField(Sel.DebitLedgerAccountName).getHtmlString()%>
    </td>
    <td>
      <%=ds.getField(Sel.CreditLedgerAccountName).getHtmlString()%>
    </td>
  </v:grid-row>
</v:grid>
