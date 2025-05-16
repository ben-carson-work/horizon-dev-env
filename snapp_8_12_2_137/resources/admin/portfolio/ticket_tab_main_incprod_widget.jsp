<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.servlet.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTicket" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="ticket" class="com.vgs.snapp.dataobject.DOTicket" scope="request"/>

<v:widget caption="@Product.IncludedProducts" include="<%=!ticket.IncProductList.isEmpty()%>">
  <v:widget-block>
    <% for (DOIncProductRef item : ticket.IncProductList) { %>
      <snp:entity-link entityId="<%=item.ProductId.getString()%>" entityType="<%=LkSNEntityType.ProductType%>"><%=item.ProductName.getHtmlString()%></snp:entity-link>
      <span class="recap-value">
        <%=item.QtyAvailable.getInt()%> / <%=item.QtyTotal.getInt()%>
      </span><br/>
    <% } %>
  </v:widget-block>
</v:widget>
