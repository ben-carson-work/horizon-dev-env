<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
boolean canEdit = !pageBase.isParameter("ReadOnly", "true");
DOProduct product = SrvBO_OC.getProduct(pageBase.getConnector(), pageBase.getId(), true).Product;
%>

<v:dialog id="saleconstr-dialog" width="640" height="480" title="@Product.SaleConstraints">
  <v:alert-box type="info" title="@Common.Info"><v:itl key="@Product.SaleConstraintsHints"/></v:alert-box>
  
  <v:grid id="saleconstr-grid">
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="70%"><v:itl key="@Product.ProductType"/></td>
        <td width="30%" nowrap>
          <v:itl key="@Product.ExpToleranceDays"/>
          <v:hint-handle hint="@Product.ExpToleranceDaysHint"/>
        </td>
      </tr>
    </thead>
    <tbody id="saleconstr-body">
    </tbody>
    <tbody>
      <tr>
        <td colspan="100%">
          <v:button caption="@Common.Add" fa="plus" href="javascript:showProductPickupDialog()" enabled="<%=canEdit%>"/>
          <v:button caption="@Common.Remove" fa="minus" href="javascript:removeConstraint()" enabled="<%=canEdit%>"/>
        </td>
      </tr>
    </tbody>
  </v:grid>

<script>

<% for (DOProduct.DOSaleConstraintRule rule : product.SaleConstraintRuleList) { %>
  addConstraint(<%=rule.RuleProductId.getJsString()%>, <%=rule.RuleProductName.getJsString()%>, <%=rule.ExpToleranceDays.getJsString()%>);
<% } %>


var dlg = $("#saleconstr-dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
 		Save : {
 			text: itl("@Common.Save"),
 			click: doSaveConstraint,
 			disabled: <%=!canEdit%>
 		},
 		Cancel : {
 			text: itl("@Common.Cancel"),
 			click: doCloseDialog
 		}
  };
});

function addConstraint(id, name, expdays) {
  var tr = $("<tr class='grid-row' data-RuleProductId='" + id + "'/>").appendTo("#saleconstr-body");
  var tdCB = $("<td/>").appendTo(tr);
  var tdProduct = $("<td/>").appendTo(tr);
  var tbExpToleranceDays = $("<td/>").appendTo(tr);  
  var hrefURL = BASE_URL + "/admin?page=product&id=" + id;
  
  tdCB.append("<input value='" + id + "' type='checkbox' class='cblist'>");
  tdProduct.html("<a href=" + hrefURL + ">" + name + "</a>");
  tbExpToleranceDays.append("<input type='text' class='form-control txt-exptolerancedays' placeholder='<v:itl key="@Common.Unlimited"/>''/>");
 
  if (expdays)
    tbExpToleranceDays.find("input").val(expdays);
}
 
function doSaveConstraint() {
  var reqDO = {
    Command: "SaveProduct",
    SaveProduct: {
      Product: {  
        ProductId: <%="'" + pageBase.getId() + "'"%>,
        SaleConstraintRuleList: getRuleList()
      }
    }
  }

  vgsService("Product", reqDO, false, function(ansDO) {
    $("#saleconstr-dialog").dialog("close");
  });
}
 
function showProductPickupDialog() {
  showLookupDialog({
    EntityType: <%=LkSNEntityType.ProductType.getCode()%>,
    onPickup: function(item) {
      if ($("#saleconstr-grid tr[data-RuleProductId='" + item.ItemId + "']").length > 0) 
        showMessage(itl("@Product.ProductAlreadyExistsError"));
      else
        addConstraint(item.ItemId, item.ItemName, "");
    }
  });
}

function getRuleList() {
  var list = [];
  var trs = $("#saleconstr-body tr");

  for (var i=0; i<trs.length; i++) {
    var tr = $(trs[i]);
    list.push({
      RuleProductId: tr.attr("data-RuleProductId"),
      ExpToleranceDays: tr.find(".txt-exptolerancedays").val()
    });
  }
  
  return list;
}

function removeConstraint() {
  $("#saleconstr-dialog .cblist:checked").not(".header").closest("tr").remove();
}
</script>  

</v:dialog>