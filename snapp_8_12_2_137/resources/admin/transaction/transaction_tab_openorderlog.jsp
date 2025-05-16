<%@page import="com.vgs.snapp.dataobject.transaction.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTransaction" scope="request"/>
<jsp:useBean id="transaction" class="com.vgs.snapp.dataobject.transaction.DOTransaction" scope="request"/>

<v:tab-content>
  <v:grid>
    <thead>
      <tr class="header">
        <td width="50%">
          <v:itl key="@Account.Organization"/>
        </td>
        <td align="right" width="50%">
          <v:itl key="@Common.Amount"/><br/>
          <v:itl key="@Common.Balance"/>
        </td>
      </tr>
    </thead>
    
    <tbody>
      <% for (DOAccountOpenOrderLogRef item : transaction.OpenOrderLogList) { %>
        <tr class="grid-row">
          <td>
            <div class="list-title"><snp:entity-link entityType="<%=LkSNEntityType.Organization%>" entityId="<%=item.AccountId%>"><v:label field="<%=item.AccountName%>"/></snp:entity-link></div>
            <div class="list-subtitle"><v:label field="<%=item.AccountCode%>"/></div>
          </td>
          <td align="right">
            <div class="list-title"><v:label field="<%=item.LogAmount%>"/></div>
            <div class="list-subtitle"><v:label field="<%=item.OpenOrderBalance%>"/></div>
          </td>
        </tr>
      <% } %>
    </tbody>

  </v:grid>
</v:tab-content>

