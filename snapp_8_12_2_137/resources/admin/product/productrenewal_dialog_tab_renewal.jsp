<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% boolean canEdit = !pageBase.getParameter("ReadOnly").equals("true"); %>
<div class="tab-toolbar">
  <v:button fa="plus" caption="@Common.Add" href="javascript:showProductPickupDialog()" enabled="<%=canEdit%>"/>
  <v:button fa="minus" caption="@Common.Remove" href="javascript:removeRenewalProd()" enabled="<%=canEdit%>"/>
</div>

<div class="tab-content">
  <v:grid id="prodrenewal-grid" style="margin-bottom:10px">
    <thead>
      <tr>
        <td width="5%"><v:grid-checkbox header="true"/></td>
        <td width="80%"><v:itl key="@Common.Name"/></td>
        <td></td>              
      </tr>
    </thead>
    <tbody>      
    </tbody>
  </v:grid>
</div>

<script>

$("table#prodrenewal-grid tbody").sortable({
  handle: "a#btn-move",
  helper: fixHelper
});  

$("a#btn-move").click(function(e) {
  e.stopPropagation();
});

//Init
function initRenewalProd() {
  if (product && product.ProductRenewalList) {
    for (var i=0; i<product.ProductRenewalList.length; i++) {
      addProduct(product.ProductRenewalList[i].SourceProductId, product.ProductRenewalList[i].SourceProductName);
    }
  }
}

function addProduct(id, name) {
  var sDisabled = <%=canEdit%> ? "" : " disabled='disabled'";
  var tr = $("<tr class='grid-row' data-ProductId='" + id + "'/>").appendTo("#prodrenewal-grid tbody");
  var tdCB = $("<td/>").appendTo(tr);
  var tdProduct = $("<td/>").appendTo(tr);
  var tdMove = $("<td align='right'></td>").appendTo(tr);
  var hrefURL = <%=JvString.jsString(ConfigTag.getValue("site_url"))%> + "/admin?page=product&id=" + id;
  
  tdCB.append("<input value='" + id + "' type='checkbox' class='cblist'>");
  tdProduct.html("<a href=" + hrefURL + ">" + name + "</a>");
  if (<%=canEdit%>)
    tdMove.append("<span class='row-hover-visible'><a id='btn-move' style='cursor:move' title='<v:itl key="@Common.Move"/>' href='#'><img src='<v:image-link name="move_item.png" size="16"/>'</a></span>");
}

function showProductPickupDialog() {
  showLookupDialog({
    EntityType: <%=LkSNEntityType.ProductType.getCode()%>,
    onPickup: function(item) {
      if ($("#prodrenewal-grid tr[data-ProductId='" + item.ItemId + "']").length > 0) 
        showMessage("<v:itl key="@Product.ProductAlreadyExistsError" encode="UTF-8"/>");
      else
        addProduct(item.ItemId, item.ItemName);
    }
  });
}

 function removeRenewalProd() {
   $("#prodrenewal-grid tbody .cblist:checked").closest("tr").remove();
 }
 
 function getProductList() {
  var list = [];
  var trs = $("#prodrenewal-grid tbody tr");
  for (var i=0; i<trs.length; i++) {
    var tr = $(trs[i]);
    list.push({
      ProductId: product.ProductId,
      SourceProductId: tr.attr("data-ProductId")
    });
  }

  return list;
}
 
</script>
