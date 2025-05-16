<%@page import="java.util.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.database.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
List<DOExtMediaGroupBalance> balanceList = new ArrayList<>();
pageBase.getBL(BLBO_ExtMediaGroup.class).fillGroupBalance(pageBase.getNullParameter("AccountId"), balanceList);
%>

<v:grid id="extmediagroup-grid">
  <tr class="header">
    <td width="70%">
      <v:itl key="@Common.Name"/><br />
      <v:itl key="@Common.Code"/>         
    </td>
    <td align="right" width="10%">
      <v:itl key="@Lookup.ExtMediaCodeStatus.Available"/>         
    </td>
    <td align="right" width="10%">
      <v:itl key="@Lookup.ExtMediaCodeStatus.Suspended"/>         
    </td>
    <td align="right" width="10%">
      <v:itl key="@Lookup.ExtMediaCodeStatus.Expired"/>         
    </td>
  </tr>
  <% for (DOExtMediaGroupBalance balance: balanceList) {%>
    <tr class="grid-row">
      <td>
        <%=balance.ExtMediaGroupName.getHtmlString()%>
        <br/>
        <span class="list-subtitle"><%=balance.ExtMediaGroupCode.getHtmlString()%></span>
      </td>
      <td align="right">
        <%=balance.Available.getHtmlString()%>
      </td>
      <td align="right">
        <%=balance.Suspended.getHtmlString()%>
      </td>
      <td align="right">
        <%=balance.Expired.getHtmlString()%>
      </td>
    </tr>
  <%} %>
</v:grid>