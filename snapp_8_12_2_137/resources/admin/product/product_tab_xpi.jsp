<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>

<% 
boolean canEdit = pageBase.getRightCRUD().canUpdate() && !product.XPIOneToOne.getBoolean(); 

QueryDef qdef = new QueryDef(QryBO_ProductCrossSell.class);
// Select
qdef.addSelect(QryBO_ProductCrossSell.Sel.ProductId);
qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossPlatformId);
qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossPlatformName);
qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossPlatformStatus);
qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossPlatformType);
qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossPlatformTypeDesc);
qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossPlatformURL);
qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossProductId);
qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossProductCode);
qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossProductName);
qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossProductStatus);
qdef.addSelect(QryBO_ProductCrossSell.Sel.CrossProductStatusDesc);
qdef.addSelect(QryBO_ProductCrossSell.Sel.Price);
// Where
qdef.addFilter(QryBO_ProductCrossSell.Fil.ProductId, pageBase.getId());
// Sort
qdef.addSort(QryBO_ProductCrossSell.Sel.CrossPlatformName);
qdef.addSort(QryBO_ProductCrossSell.Sel.CrossProductName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);

request.setAttribute("ds", ds);

String undefined = pageBase.getLang().Common.Undefined.getHtmlText();
%>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" href="javascript:doSaveCrossPlatform()" enabled="<%=canEdit%>"/>
  <span class="divider"></span>
  <v:button caption="@Common.Add" fa="plus" href="javascript:showProductCrossSellPickupDialog()" enabled="<%=canEdit%>"/>
  <v:button caption="@Common.Remove" fa="minus" href="javascript:removeProductCrossSell()" enabled="<%=canEdit%>"/>
</div>

<div class="tab-content">
  <v:grid id="xpi_productsell_grid" >
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="35%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="35%">
      <v:itl key="@XPI.CrossPlatformName"/><br/>
      <v:itl key="@XPI.CrossPlatformType"/>
    </td>
      <td width="30%" align="right">
       <v:itl key="@Product.Price"/><br/>
       <v:itl key="@Common.Status"/>
    </td>
  </tr>
  <tbody id="xpi_productcrosssell-body">
  </tbody>
  
</v:grid>
  
</div>

<script>

$(document).on("OnEntityChange", function(event, params) {
  window.location.reload();
});

<v:ds-loop dataset="<%=ds%>">
  addProductCrossSell(
    "<%=LkSNEntityType.ProductType.getIconName()%>",    
    <%=JvString.jsString(ds.getField("CrossProductId").getString().toUpperCase())%>,
    <%=JvString.jsString(ds.getField("CrossProductName").getString())%>,
    <%=JvString.jsString(ds.getField("CrossProductCode").getString())%>,
    <%=JvString.jsString(ds.getField("CrossPlatformId").getString().toUpperCase())%>,
    <%=JvString.jsString(ds.getField("CrossPlatformName").getString())%>,
    <%=JvString.jsString(ds.getField("CrossPlatformType").getString())%>,    
    <%=JvString.jsString(ds.getField("CrossPlatformTypeDesc").getString())%>,
    <%=JvString.jsString(ds.getField("CrossProductStatus").getString())%>,
    <%=JvString.jsString(ds.getField("CrossProductStatusDesc").getString())%>,
    <%=JvString.jsString(ds.getField("Price").getString())%>
  );
</v:ds-loop>

function showProductCrossSellPickupDialog() {
  asyncDialogEasy("xpi/xpi_product_create_dialog", "id=<%=pageBase.getId()%>");
}

function productCrossSellPickupCallback(obj) {
  if (obj) {
    if ($("#xpi_productsell_grid tr[data-CrossPlatformId='" + obj.CrossPlatformId + "']").length > 0) {
      if ($("#xpi_productsell_grid tr[data-CrossProductId='" + obj.CrossProductId + "']").length > 0)
        showMessage(<v:itl key="@XPI.CrossProductAlreadyAssigned" encode="JS"/>);
      else {
        var msg = <v:itl key="@XPI.AnotherCrossProductAlreadyAssigned" param1="%1" encode="JS"/>;
        showMessage(msg.replace("%1", obj.CrossPlatformName));
      }
    }
    else 
      addProductCrossSell("<%=LkSNEntityType.ProductType.getIconName()%>", obj.CrossProductId, obj.CrossProductName, obj.CrossProductCode, obj.CrossPlatformId, obj.CrossPlatformName, obj.CrossPlatformType, obj.CrossPlatformTypeDesc, obj.CrossProductStatus, obj.CrossProductStatusDesc, obj.Price);
  }
}

function addProductCrossSell(iconName, crossProductId, crossProductName, crossProductCode, crossPlatformId, crossPlatformName, crossPlatformType, crossPlatformTypeDesc, crossProductStatus, crossProductStatusDesc, price) {
  var tr = $("<tr class='grid-row' " + 
      "data-CrossProductId='" + crossProductId + "' " +  
      "data-CrossProductName='" + crossProductName + "' " +
      "data-CrossProductCode='" + crossProductCode + "' " +
      "data-CrossPlatformId='" + crossPlatformId + "' " +
      "data-CrossPlatformName='" + crossPlatformName + "' " +
      "data-CrossPlatformType='" + crossPlatformType + "' " +
      "data-CrossPlatformTypeDesc='" + crossPlatformTypeDesc + "' " +
      "data-CrossProductStatus='" + crossProductStatus + "' " +
      "data-CrossProductStatusDesc='" + crossPlatformTypeDesc + "' " +
      "data-Price='" + price + "'/>").appendTo("#xpi_productcrosssell-body");
  
  var tdCB = $("<td/>").appendTo(tr);
  var tdIcon = $("<td/>").appendTo(tr);
  var tdProdNameCode = $("<td/>").appendTo(tr);
  var tdPlatformNameType = $("<td/>").appendTo(tr);
  var tbPriceStatus = $("<td align='right'/>").appendTo(tr);
  
  var hrefURL = <%=JvString.jsString(ConfigTag.getValue("site_url"))%> + "/admin?page=account&id=" + crossPlatformId;
  var imgURL = <%=JvString.jsString(ConfigTag.getValue("site_url"))%> + "/imagecache?name=" + iconName + "&amp;size=32";
  
  if (!crossProductCode)
    crossProductCode = <%=JvString.jsString(undefined)%>;
  
  tdCB.append("<input type='checkbox' class='cblist'>");
  tdIcon.append("<img class='list-icon' src=" + imgURL + " width='32' height='32'>");
  
  if (crossPlatformType != <%=LkSNCrossPlatformType.SnApp.getCode()%>) {
    var param1 = "'" + crossPlatformId + "'";
    var param2 = "'" + crossProductId + "'";
    prodHtml = '<a href="javascript:showProductDialog(' + param1 + ',' + param2 + ')">' +  crossProductName + '</a><br/><span class="list-subtitle">' + crossProductCode + '</span>';
  }
  else
    prodHtml = crossProductName + "<br/><span class='list-subtitle'>" + crossProductCode + "</span>";
  tdProdNameCode.html(prodHtml);
  
  tdPlatformNameType.html("<a href=" + hrefURL + ">" + crossPlatformName + "</a><br/><span class='list-subtitle'>" + crossPlatformTypeDesc + "</span>");
  
  tbPriceStatus.html(formatCurr(price) + "<br/><span class='list-subtitle'>" + crossProductStatusDesc + "</span>");
}

function removeProductCrossSell() {
  $("#xpi_productsell_grid .cblist:checked").not(".header").closest("tr").remove();
}

function getProductCrossSellList() {
  var list = [];
  var trs = $("#xpi_productcrosssell-body tr");

  for (var i=0; i<trs.length; i++) {
    var tr = $(trs[i]);
    list.push({
      CrossProductId: tr.attr("data-CrossProductId"),
      CrossProductName: tr.attr("data-CrossProductName"),
      CrossProductCode: tr.attr("data-CrossProductCode"),
      CrossPlatformId: tr.attr("data-CrossPlatformId"),
      CrossPlatformName: tr.attr("data-CrossPlatformName"),
      CrossProductStatus: tr.attr("data-CrossProductStatus"),
      Price: tr.attr("data-Price")
    });
  }
  return list;
}

function showProductDialog(crossPlatformId, crossProductId) {
  asyncDialogEasy("xpi/xpi_prodcrosssell_dialog", "id=" + <%=JvString.jsString(pageBase.getId())%> + "&CrossPlatformId=" + crossPlatformId + "&CrossProductId=" + crossProductId); 
}

function doSaveCrossPlatform() {
	showWaitGlass();
  var reqDO = {
      Command: "SaveProduct",
      SaveProduct: {
        Product: { 
          ProductId: <%=JvString.jsString(pageBase.getId())%>,
          ProductCrossSellList: getProductCrossSellList()
      }
    }
  }
  
  vgsService("Product", reqDO, false, function(ansDO) {
	  hideWaitGlass();
    showMessage("<v:itl key="@Common.SaveSuccessMsg"/>", function() {
      triggerEntityChange(<%=LkSNEntityType.ProductType.getCode()%>, <%=JvString.jsString(pageBase.getId())%>);
    });
  });
}
 
</script>