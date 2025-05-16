<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.web.bko.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = pageBase.getRightCRUD().canUpdate(); %>

<v:tab-toolbar>
  <v:button id="btn-save-prodguest" fa="save" caption="@Common.Save" enabled="<%=canEdit%>"/>
  <v:button-group>
    <v:button id="btn-add-prodguest" fa="plus" caption="@Common.Add" enabled="<%=canEdit%>"/>
    <v:button id="btn-del-prodguest" fa="minus" caption="@Common.Remove" enabled="<%=canEdit%>"/>
  </v:button-group>
</v:tab-toolbar>

<v:tab-content>
  <v:grid id="prodguest-grid">
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="75%"><v:itl key="@Product.ProductType"/></td>
        <td width="10%"><v:itl key="@Common.Quantity"/></td>
        <td width="5%" align="center"><v:itl key="@Common.AddToHostPortfolio"/><br/><v:hint-handle hint="@Common.AddToHostPortfolioHint"/></td>
        <td width="5%" align="center"><v:itl key="@Product.GuestAutoAddToCart"/><br/><v:hint-handle hint="@Product.GuestAutoAddToCartHint"/></td>
        <td width="5%" align="center"><v:itl key="@Product.GuestBindPerformance"/><br/><v:hint-handle hint="@Product.GuestBindPerformanceHint"/></td>
      </tr>
    </thead>
    <tbody id="prodguest-tbody">
    </tbody>
  </v:grid>
</v:tab-content>

<div id="prodguest-templates" class="hidden">
  <v:grid>
    <tr class="grid-row tr-guest">
      <td><v:grid-checkbox/></td>
      <td><snp:dyncombo name="ProductId" entityType="<%=LkSNEntityType.ProductType%>" clazz="prodguest-field" enabled="<%=canEdit%>"/></td>
      <td><v:input-text field="Quantity" type="number" clazz="prodguest-field" enabled="<%=canEdit%>"/>
      <td align="center"><v:db-checkbox field="AddToHostPortfolio" clazz="prodguest-field" value="true" caption="" enabled="<%=canEdit%>"/></td>
      <td align="center"><v:db-checkbox field="AutoAddToCart" clazz="prodguest-field" value="true" caption="" enabled="<%=canEdit%>"/></td>
      <td align="center"><v:db-checkbox field="BindPerformance" clazz="prodguest-field" value="true" caption="" enabled="<%=canEdit%>"/></td>
    </tr>
  </v:grid>
</div>

<script>

$(document).ready(function() {
  $("#btn-save-prodguest").click(_save);
  $("#btn-add-prodguest").click(_add);
  $("#btn-del-prodguest").click(_del);
  
  var $tbody = $("#prodguest-tbody");
  var $template = $("#prodguest-templates .tr-guest");
  
  $tbody.docToGrid({
    "doc": <%=product.GuestProductList.getJSONString()%>,
    "template": $template
  });

  function _add(item) {
    $template.clone().appendTo($tbody); 
  }
  
  function _del() {
    $tbody.find(".cblist:checked").closest("tr").remove();
  }
  
  function _save() {
    var reqDO = {
      Product: {
        ProductId: <%=JvString.jsString(pageBase.getId())%>,
        GuestProductList: $tbody.find("tr").gridToDoc({"fieldSelector":".prodguest-field"})
      }
    };

    snpAPI.cmd("Product", "SaveProduct", reqDO).then(ansDO => entitySaveNotification(<%=LkSNEntityType.ProductType.getCode()%>, ansDO.ProductId, "tab=guest"));
  }
});

</script>

