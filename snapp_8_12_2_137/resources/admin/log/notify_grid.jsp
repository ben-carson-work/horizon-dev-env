<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_NotifyRule.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_NotifyRule.class);
  // Select
  qdef.addSelect(QryBO_NotifyRule.Sel.NotifyRuleId,
      QryBO_NotifyRule.Sel.NotifyRuleType,
      QryBO_NotifyRule.Sel.NotifyRuleName,
      QryBO_NotifyRule.Sel.SendEmail,
      QryBO_NotifyRule.Sel.SendSMS,
      QryBO_NotifyRule.Sel.Active,
      QryBO_NotifyRule.Sel.NotifySale_SaleType,
      QryBO_NotifyRule.Sel.NotifySale_Config,
      QryBO_NotifyRule.Sel.NotifyEntityChange_EntityType,
      QryBO_NotifyRule.Sel.CommonStatus,
      QryBO_NotifyRule.Sel.TagNames);
  
  //Filter
  if (pageBase.getNullParameter("FullText") != null)
    qdef.addFilter(QryBO_NotifyRule.Fil.FullText, pageBase.getParameter("FullText"));
  
  if (pageBase.getNullParameter("NotifyRuleType") != null)
    qdef.addFilter(QryBO_NotifyRule.Fil.NotifyRuleType, JvArray.stringToIntArray(pageBase.getParameter("NotifyRuleType"), ","));

  //Sorting
  qdef.addSort(QryBO_NotifyRule.Sel.NotifyRuleType);
  // Paging
  qdef.pagePos = pageBase.getQP();
  qdef.recordPerPage = QueryDef.recordPerPageDefault;
  
  // Exec
  JvDataSet ds = pageBase.execQuery(qdef);
  request.setAttribute("ds", ds);
%>

<style>
  .user-role-item {
    background: #e0e0e0; 
    margin: 2px; 
    padding: 2px 5px; 
    border-radius: 3px;
    display: inline-block;
    float: left; 
  }
</style>

<v:grid id="notifyrule-grid" dataset="<%=ds%>" qdef="<%=qdef%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td width="20%">
      <v:itl key="@Common.Name"/><br>
      <v:itl key="@Common.Type"/>
    </td>
    <td width="30%">
      <v:itl key="@Common.Details"/>
    </td>
    <td width="20%"><v:itl key="@Common.Notifications"/></td>
    <td width="30%">
      <v:itl key="@Stats.Users"/> / <v:itl key="@Stats.Roles"/>
    </td>
  </tr>
  
  <v:grid-row dataset="ds">
    <% 
      LookupItem notifyRuleType = LkSN.NotifyRuleType.getItemByCode(ds.getField(QryBO_NotifyRule.Sel.NotifyRuleType));
      LookupItem notifySaleType = null;
      if(notifyRuleType.isLookup(LkSNNotifyRuleType.Sales))
        notifySaleType = LkSN.NotifySaleType.getItemByCode(ds.getField(QryBO_NotifyRule.Sel.NotifySale_SaleType)); 
    %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox dataset="ds" fieldname="NotifyRuleId" name="NotifyRuleId"/></td>
     <td>
      <snp:entity-link entityId="<%=ds.getField(QryBO_NotifyRule.Sel.NotifyRuleId)%>" entityType="<%=LkSNEntityType.NotifyRule%>" clazz="list-title">
        <%=ds.getField(QryBO_NotifyRule.Sel.NotifyRuleName).getHtmlString()%>
      </snp:entity-link> <br>
      <span class="list-subtitle"><%=notifyRuleType.getHtmlDescription(pageBase.getLang())%></span>
    </td>
    
    <td>
      <% if (notifyRuleType.isLookup(LkSNNotifyRuleType.EntityChange)) { %>
        <div><%=LkSN.EntityType.getItemByCode(ds.getField(Sel.NotifyEntityChange_EntityType)).getDescription(pageBase.getLang())%></div>
        <div class="list-subtitle">
          Tags: <%=ds.getField(Sel.TagNames).getString().isEmpty() ? "All" : ds.getField(Sel.TagNames).getString()%>
        </div>
      <% } else if (notifyRuleType.isLookup(LkSNNotifyRuleType.Sales)) { %>
        <div><%=LkSN.NotifySaleType.getItemByCode(ds.getField(Sel.NotifySale_SaleType)).getDescription(pageBase.getLang())%></div>
        <div class="list-subtitle">
          <% if (notifySaleType.isLookup(LkSNNotifySaleType.CashInput)) { %>
          <%
          DONotifyRule.DONotifyRuleSale.DONotifyRuleConfig_CashInput cfg = new DONotifyRule.DONotifyRuleSale.DONotifyRuleConfig_CashInput();
          String cfgText = ds.getField(Sel.NotifySale_Config).getNullString(true);
          if (cfgText != null) {
            cfg.setJSONString(cfgText);
          }
          %>
          Cash Amount: <%=pageBase.formatCurrHtml(cfg.CashAmount)%>
          <% } %>
        </div>
      <% } %>
    </td>
    
    <td>
    <%
      String[] notifications = new String[0];
      if(ds.getField(QryBO_NotifyRule.Sel.SendEmail).getBoolean())
        notifications = JvArray.add("<i class='fa fa-envelope'/></i>", notifications);
      if(ds.getField(QryBO_NotifyRule.Sel.SendSMS).getBoolean())
        notifications = JvArray.add("<i class='fa fa-comment'/></i>", notifications);
     %>
      <span class="list-subtitle"><%=(notifications.length == 0) ? "&mdash;" : JvArray.arrayToString(notifications, ", ") %></span>
    </td>
    <td>
      <%
        QueryDef qdefUser = new QueryDef(QryBO_NotifyRuleUser.class);
        // Select
        qdefUser.addSelect(
            QryBO_NotifyRuleUser.Sel.EntityType,
            QryBO_NotifyRuleUser.Sel.EntityId,        
            QryBO_NotifyRuleUser.Sel.EntityName);
        //Filter
        qdefUser.addFilter(QryBO_NotifyRuleUser.Fil.NotifyRuleId, ds.getField(QryBO_NotifyRule.Sel.NotifyRuleId).getString());
        // Exec
        JvDataSet dsUser = pageBase.execQuery(qdefUser);
      %>
      <v:ds-loop dataset="<%=dsUser%>">
        <span class="user-tag-item">
          <snp:entity-link entityId="<%=dsUser.getField(QryBO_NotifyRuleUser.Sel.EntityId).getString()%>" entityType="<%=dsUser.getField(QryBO_NotifyRuleUser.Sel.EntityType)%>"><%=dsUser.getField(QryBO_NotifyRuleUser.Sel.EntityName).getHtmlString()%></snp:entity-link>
        </span>
      </v:ds-loop>
    </td>
  </v:grid-row>
</v:grid>