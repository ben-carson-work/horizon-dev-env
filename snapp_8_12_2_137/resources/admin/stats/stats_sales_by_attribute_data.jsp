<%@page import="com.vgs.web.dataobject.DOStat"%>
<%@page import="com.vgs.web.library.BLBO_Stats"%>
<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
JvDateTime dateFrom = JvDateTime.createByXML(pageBase.getParameter("DateFrom"));
JvDateTime dateTo = JvDateTime.createByXML(pageBase.getParameter("DateTo"));
String locationId = pageBase.getNullParameter("LocationId");
String opAreaId = pageBase.getNullParameter("OpAreaId");
String workstationId = pageBase.getNullParameter("WorkstationId");
String saleChannelId = pageBase.getNullParameter("SaleChannelId");
String[] tagIDs = JvArray.stringToArray(pageBase.getNullParameter("TagIDs"), ","); 
DOStat stats = pageBase.getBL(BLBO_Stats.class).getSalesActivityByAttribute(dateFrom, dateTo, locationId, opAreaId, workstationId, saleChannelId, tagIDs);
%>
<v:grid>
  <thead>
    <tr>
      <td width="60%"><v:itl key="@Product.ProductType"/></td>
      <td align="right" width="20%"><v:itl key="@Common.Quantity"/></td>
      <td align="right" width="20%"><v:itl key="@Common.Amount"/></td>
    </tr>
  </thead>
  <tbody>
   <% for (DOStat attribute : stats.ItemList.getItems()) { %>
     <tr class="group attribute">
       <td class="item-desc"><%=attribute.ItemDesc.getHtmlString()%></td>
       <td class="quantity"><%=attribute.Quantity.getHtmlString()%></td>
       <td class="amount"><%=(attribute.Amount.getMoney() == 0) ? "" : pageBase.formatCurrHtml(attribute.Amount)%></td>
     </tr>
     <% for (DOStat optional : attribute.ItemList.getItems()) { %>
       <tr class="optional">
         <td class="item-desc"><%=optional.ItemDesc.getHtmlString()%></td>
         <td class="quantity"><%=optional.Quantity.getHtmlString()%></td>
         <td class="amount"><%=(optional.Amount.getMoney() == 0) ? "" : pageBase.formatCurrHtml(optional.Amount)%></td>
       </tr>
       <% for (DOStat product : optional.ItemList.getItems()) { %>
         <tr class="grid-row product">
           <td class="item-desc"><%=product.ItemDesc.getHtmlString()%></td>
           <td class="quantity"><%=product.Quantity.getHtmlString()%></td>
           <td class="amount"><%=(product.Amount.getMoney() == 0) ? "" : pageBase.formatCurrHtml(product.Amount)%></td>
         </tr>
       <% } %>
     <% } %>
   <% } %>
   </tbody>
</v:grid>
