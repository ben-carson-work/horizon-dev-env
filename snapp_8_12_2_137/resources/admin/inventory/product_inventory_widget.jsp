<%@page import="java.util.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<%@ taglib uri="snp-tags" prefix="snp"%>

<%
  PageBO_Base<?> pageBase = (PageBO_Base<?>) request.getAttribute("pageBase");

  BLBO_Inventory bl = pageBase.getBL(BLBO_Inventory.class);
  DOProductInventory productInventory = bl.loadProductInventory(pageBase.getId());
  
  List<DOProductInventory> products = new ArrayList<>();
  products.add(productInventory);
  products.addAll(productInventory.AlternativeProductList.getItems());

  boolean disableLink = pageBase.isParameter("disableLink", "true");
%>

<style>
.product-table {
  width: 100%;
}
.product-table td {
  border: none !important;
}
.alt-prod-title {
  font-size: 15px;
  font-weight: bold;
  padding: 10px;
}
</style>

<div class="tab-content">
<% for (int i=0; i<products.size(); i++) { %>
  <% if (i == 1) { %>
    <div class="alt-prod-title"><v:itl key="@Product.AlternativeProducts"/></div>
  <% } %>
  <% DOProductInventory prodinv = products.get(i); %>
  <v:grid>
    <thead>
      <% String caption = prodinv.ProductName.getHtmlString() + " (" + prodinv.ProductCode.getHtmlString() + ")"; %>
      <tr>
        <td colspan="100%" class="widget-title">
          <table class="product-table">
            <tr>
              <td><v:grid-icon name="<%=prodinv.IconName.getString()%>" repositoryId="<%=prodinv.ProfilePictureId.getString()%>"/></td>
              <td width="50%">
                <div>
                  <% if (disableLink) { %> 
                    <%=prodinv.ProductName.getHtmlString()%>
                  <% } else { %> 
                  <snp:entity-link entityId="<%=prodinv.ProductId%>" entityType="<%=LkSNEntityType.ProductType%>">
                    <%=prodinv.ProductName.getHtmlString()%>
                  </snp:entity-link> 
                  <% } %> 
                </div>
                <div class="list-subtitle"><%=prodinv.ProductCode.getHtmlString()%></div>
              </td>
              <td width="50%" align="right">
                <div><%=pageBase.formatCurrHtml(prodinv.FacePrice)%></div>
                <div class="list-subtitle"><v:itl key="@Common.Total"/>: <%=prodinv.TotalAvailable.getInt()%></div>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td width="40%"><v:itl key="@Account.Location" /></td>
        <td width="40%"><v:itl key="@Common.Warehouse" /></td>
        <td width="20%" align="right"><v:itl key="@Common.Quantity" /></td>
      </tr>
    </thead>
    <tbody>
      <% for (DOProductInventory.DOProductWarehouseInventory prodWarehouseInv : prodinv.ProductWarehouseInventoryList) { %>
      <tr class="grid-row">
        <td>
          <% if (disableLink) { %> 
            <%=prodWarehouseInv.LocationName.getHtmlString()%>
          <% } else { %> 
          <snp:entity-link entityId="<%=prodWarehouseInv.LocationId%>" entityType="<%=LkSNEntityType.Location%>">
            <%=prodWarehouseInv.LocationName.getHtmlString()%>
          </snp:entity-link> 
          <% } %>
        </td>
        <td>
          <% if (disableLink) { %> 
            <%=prodWarehouseInv.WarehouseName.getHtmlString()%>
          <% } else { %> 
          <snp:entity-link entityId="<%=prodWarehouseInv.WarehouseId%>" entityType="<%=LkSNEntityType.Warehouse%>">
            <%=prodWarehouseInv.WarehouseName.getHtmlString()%>
          </snp:entity-link> 
          <% } %>
        </td>
        <td align="right"><%=prodWarehouseInv.Quantity.getHtmlString()%>
        </td>
      </tr>
      <% } %>
    </tbody>
  </v:grid>
<% } %>

</div>
