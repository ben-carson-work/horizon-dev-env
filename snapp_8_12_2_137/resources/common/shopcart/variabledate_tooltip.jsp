<%@page import="java.util.Map.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String shopCartId = pageBase.getParameter("ShopCartId");
String itemId = pageBase.getParameter("ShopCartItemId"); 

Map<String, Integer> map = new HashMap<>(); // <dates, quantity>

DOShopCart shopCart = pageBase.getBL(BLBO_ShopCart.class).getShopCartAndCheckStatus(shopCartId);
for (DOShopCart.DOShopCartItem item : shopCart.Items) {
  if (item.ShopCartItemId.isSameString(itemId)) {
    if (!item.ValidDateTo.isNull()) {
  String dates = pageBase.format(item.ValidDateTo.getDateTime(), pageBase.getShortDateFormat()); 
  if (item.ValidDateFrom.isNull())
    dates = pageBase.getLang().Common.Today.getText() + " to " + dates;
  else if (!item.ValidDateFrom.getDateTime().isSameDay(item.ValidDateTo.getDateTime()))
    dates = pageBase.format(item.ValidDateFrom.getDateTime(), pageBase.getShortDateFormat()) + " to " + dates;
  Integer oldqty = map.get(dates);
  map.put(dates, item.Quantity.getInt() + ((oldqty == null) ? 0 : oldqty));
    }

    break;
  }
}
%>

<div style="font-size:1.4em; margin-bottom:10px"><v:itl key="@Common.Validity"/></div>
<% for (Entry<String, Integer> entry : map.entrySet()) { %>
  <div><%=entry.getValue()%>&nbsp;&nbsp;&nbsp;x&nbsp;&nbsp;&nbsp;<b><%=JvString.escapeHtml(entry.getKey())%></b></div>
<% } %>
