<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType")); %>
<% boolean canEdit = !pageBase.getParameter("ReadOnly").equals("true");%>

<div class="tab-toolbar">
  <v:button fa="plus" caption="@Common.Add" href="javascript:showProductPickupDialog()" enabled="<%=canEdit%>"/>
  <v:button fa="minus" caption="@Common.Remove" href="javascript:removeUpgrades()" enabled="<%=canEdit%>"/>
</div>

<div class="tab-content">
  <v:grid id="produpgrade-grid" style="margin-bottom:10px">
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="50%"><v:itl key="@Common.Name"/></td>
        <td width="50%"><v:itl key="@Product.UpgradePrice"/></td>  
        <td></td>              
      </tr>
    </thead>
    <tbody>      
    </tbody>
  </v:grid>
</div>

<script>

$("table#produpgrade-grid tbody").sortable({
  handle: "a#btn-move",
  helper: fixHelper
});  

$("a#btn-move").click(function(e) {
  e.stopPropagation();
});

//Init
function initQuickUpg() {
  if ((productUpgrade) && (productUpgrade.ProductList)) {
    for (var i=0; i<productUpgrade.ProductList.length; i++) {
      addProduct(productUpgrade.ProductList[i].ProductId, 
        productUpgrade.ProductList[i].ProductCode, 
        productUpgrade.ProductList[i].ProductName,
        productUpgrade.ProductList[i].UpgradePrice);
    }
  }
}

function addProduct(id, code, name, upgradePrice) {
  var sDisabled = <%=canEdit%> ? "" : " disabled='disabled'";
  var tr = $("<tr class='grid-row' data-ProductId='" + id + "'/>").appendTo("#produpgrade-grid tbody");
  var tdCB = $("<td/>").appendTo(tr);
  var tdProduct = $("<td><div><a></a></div><div class='list-subtitle'></div></td>").appendTo(tr);
  var tdUpgradePrice = $("<td/>").appendTo(tr);  
  var tdMove = $("<td align='right'></td>").appendTo(tr);
  var hrefURL = <%=JvString.jsString(ConfigTag.getValue("site_url"))%> + "/admin?page=product&id=" + id;
  
  tdCB.append("<input value='" + id + "' type='checkbox' class='cblist'>");
  tdProduct.find("a").attr("href", hrefURL).text(name);
  tdProduct.find(".list-subtitle").text(code);
  tdUpgradePrice.append("<input type='text' class='form-control txt-upgradeprice'" + sDisabled + "/>");
  if (<%=canEdit%>)
    tdMove.append("<span class='row-hover-visible'><a id='btn-move' style='cursor:move' title='<v:itl key="@Common.Move"/>' href='#'><img src='<v:image-link name="move_item.png" size="16"/>'</a></span>");
 
  if (upgradePrice || upgradePrice == 0)
    tdUpgradePrice.find("input").val(upgradePrice);
  
  tr.find("input").attr("placeholder", itl("@Common.Default"));
}

function showProductPickupDialog() {
  showLookupDialog({
    EntityType: <%=LkSNEntityType.ProductType.getCode()%>,
    onPickup: function(item) {
      if ($("#produpgrade-grid tr[data-ProductId='" + item.ItemId + "']").length > 0) 
        showMessage(itl("@Product.ProductAlreadyExistsError"));
      else
        addProduct(item.ItemId, item.ItemCode, item.ItemName, "");
    }
  });
}

 function removeUpgrades() {
   $("#produpgrade-grid tbody .cblist:checked").closest("tr").remove();
 }
 
 function getProductList() {
  var list = [];
  var trs = $("#produpgrade-grid tbody tr");
  for (var i=0; i<trs.length; i++) {
    var tr = $(trs[i]);
    
    var upgradePrice = convertPriceValue(tr.find(".txt-upgradeprice").val());
    list.push({
      ProductId: tr.attr("data-ProductId"),
      UpgradePrice: upgradePrice
    });
  }

  return list;
}
 
</script>
