<%@page import="com.vgs.snapp.dataobject.DOAccountFinance"%>
<%@page import="com.vgs.web.library.BLBO_Account"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="accountFinance" scope="request" class="com.vgs.snapp.dataobject.DOAccountFinance"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>

<div class="tab-content">
  <v:grid>
    <thead>
      <tr>
        <td>Commission</td>
        <td>Finance group</td>
        <td><v:itl key="@Product.ExternalPricing"/></td>
        <td align="right">Total</td>
      </tr>
    </thead>
    <tbody>
      <% for (DOAccountFinance.DOCommission comm : accountFinance.CommissionList.getItems()) { %>
        <tr>
          <td><%=comm.CommissionName.getHtmlString()%></td>
          <td><%=comm.FinanceGroupTagName.getHtmlString()%></td>
          <td>
          <% if (comm.ExternalPricing.getBoolean()) {%>
            <i class="fa fa-check"></i>
          <% } %>
          </td>
          <td align="right"><%=pageBase.formatCurrHtml(comm.Amount)%></td>
        </tr>
      <% } %>
    </tbody>
  </v:grid>
</div>