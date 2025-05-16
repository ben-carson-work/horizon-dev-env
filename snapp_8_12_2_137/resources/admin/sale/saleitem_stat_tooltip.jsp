<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.snapp.dataobject.transaction.DOSale"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SaleItem.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<%
@SuppressWarnings("unchecked")
List<DOSale.DOSaleItemStat> list = (List<DOSale.DOSaleItemStat>)request.getAttribute("listStat");
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
%>

<style>

.tax-ref-grid {
  width: 100%;
  border-collapse: collapse;
}

.tax-ref-grid td {
  padding: 3px;
}

.tax-ref-items td {
  border-bottom: 1px #efefef solid;
  font-weight: bold;
}

.tax-ref-items tr:last-child td {
  border-bottom: none;
}

.tax-ref-footer td {
  border-top: 1px #aaaaaa solid;
}

</style>



<v:tooltip-content-static>

  <div style="min-width:270px; max-height:200px; overflow-y:auto">
  
    <div class="tooltip-title"><v:itl key="@Sale.StatBreakdown"/></div>
    
    <table class="tax-ref-grid">
      <tbody class="tax-ref-items">
        <% for (DOSale.DOSaleItemStat stat : list) { %>
          <tr class="grid-row">
            <tr>
              <td nowrap>
                <snp:entity-link entityId="<%=stat.ProductId%>" entityType="<%=LkSNEntityType.ProductType%>"><%=stat.ProductName.getHtmlString()%></snp:entity-link>
              </td>
              
              <td nowrap align="right">
                <%=stat.Quantity.getInt()%> x <%=pageBase.formatCurrHtml(stat.StatAmount)%>
              </td>
            </tr>
          </tr>
        <% } %>
      </tbody>
    </table>
  
  </div>

</v:tooltip-content-static>
