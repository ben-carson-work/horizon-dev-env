<%@page import="com.vgs.snapp.library.SnappUtils"%>
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
        <td></td>
        <td width="25%"><v:itl key="@Common.Source"/></td>
        <td width="10%"><v:itl key="@Common.Type"/></td>
        <td width="25%"><v:itl key="@Common.Target"/></td>
        <td width="40%" align="right"><v:itl key="@Common.Quantity"/></td>
      </tr>
    </thead>
    
    <tbody>
      <% for (DOTransactionUpsellStatItem item : transaction.UpsellStatList) { %>
        <tr class="grid-row">
          <td>
            <v:grid-icon name="icon" iconAlias="<%=item.IconAlias%>"/>
          </td>
          <td>
            <div><snp:entity-link  entityId="<%=item.SourceProductId%>" entityType="<%=LkSNEntityType.ProductType%>" textWhenNull="@Common.None"><v:label field="<%=item.SourceProductName%>" clazz="list-title"/></snp:entity-link></div>
            <div class="list-subtitle"><v:label field="<%=item.SourceProductCode%>"/></div>
          </td>
          <td>
            <v:label field="<%=item.UpsellType%>" clazz="list-title"/>
          </td>
          <td>
            <div><snp:entity-link entityId="<%=item.TargetProductId%>" entityType="<%=LkSNEntityType.ProductType%>"><v:label field="<%=item.TargetProductName%>" clazz="list-title"/></snp:entity-link></div>
            <div class="list-subtitle"><v:label field="<%=item.TargetProductCode%>"/></div>
          </td>
          <td align="right">
            <v:label field="<%=item.Quantity%>" clazz="list-title"/>
          </td>
        </tr>
      <% } %>
    </tbody>

  </v:grid>
</v:tab-content>

