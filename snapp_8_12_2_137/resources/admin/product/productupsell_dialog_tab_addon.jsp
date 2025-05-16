<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@taglib uri="vgs-tags" prefix="v" %>
<%@taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>

<% boolean canEdit = (Boolean)request.getAttribute("canEditProduct"); %>

<div id="upsell-tab-addon" class="tab-content">
  <v:grid>
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="50%"><v:itl key="@Product.Upsell_TargetProduct"/> <v:hint-handle hint="@Product.Upsell_TargetProductAddonHint"/></td>
        <td width="20%"><v:itl key="@Common.Options"/></td>
        <td width="15%"><v:itl key="@Product.Upsell_QuantityMin"/> <v:hint-handle hint="@Product.Upsell_QuantityMinHint"/></td>
        <td width="15%"><v:itl key="@Product.Upsell_QuantityMax"/> <v:hint-handle hint="@Product.Upsell_QuantityMaxHint"/></td>
        <td>&nbsp;</td>
      </tr>
    </thead>
    <tbody class="upsell-tbody">
    </tbody>
    <tbody>
      <tr>
        <td colspan="100%">
          <v:button id="btn-add" caption="@Common.Add" fa="plus" enabled="<%=canEdit%>"/>
          <v:button id="btn-remove" caption="@Common.Remove" fa="minus" enabled="<%=canEdit%>"/>
        </td>
      </tr>
    </tbody>
  </v:grid>

  <div id="templates" class="hidden">
    <table>
      <tr class="grid-row upsell-product-row">
        <td>
          <v:grid-checkbox/>
        </td>
        <td>
          <snp:dyncombo field="TargetProductId" entityType="<%=LkSNEntityType.ProductType%>" enabled="<%=canEdit%>"/>
        </td>
        <td nowrap="nowrap">
          <div><v:db-checkbox field="SamePortfolio" value="true" caption="@Product.Upsell_SamePortfolio" hint="@Product.Upsell_SamePortfolioHint" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="BindPerformance" value="true" caption="@Product.Upsell_BindPerformance" hint="@Product.Upsell_BindPerformanceHint" enabled="<%=canEdit%>"/></div>
        </td>
        <td>
          <v:input-text field="QuantityMin" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
        </td>
        <td>
          <v:input-text field="QuantityMax" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/>
        </td>
        <td>
          <% if (canEdit) { %>
            <span class="row-hover-visible"><i class="fa fa-bars drag-handle"></i>
          <% } %>
        </td>
      </tr>
    </table>
  </div>
</div>

<script>
  $(document).ready(function() {
    const UPSELLTYPE_ADDON = <%=LkSNUpsellType.AddOn.getCode()%>;
    var $tab = $("#upsell-tab-addon");
    var $tbody = $tab.find(".upsell-tbody");
    $tab.find("#btn-add").click(_addProduct);
    $tab.find("#btn-remove").click(_onRemoveClick);
    $tbody.sortable({
      handle: ".drag-handle",
      helper: fixHelper
    });
    
    $(document).von($tab, "product-upsell-load", function(event, params) {
      for (const item of params.ProductUpsellList)
        if (item.UpsellType == UPSELLTYPE_ADDON)
          _addProduct(item);
    });
    
    function _addProduct(item) {
      item = item || {};
      var $tr = $tab.find("#templates .upsell-product-row").clone().appendTo($tbody);
      
      $tr.find("#TargetProductId").val(item.TargetProductId);
      $tr.find("#SamePortfolio").setChecked(item.SamePortfolio);
      $tr.find("#BindPerformance").setChecked(item.BindPerformance);
      $tr.find("#QuantityMin").val(item.QuantityMin);
      $tr.find("#QuantityMax").val(item.QuantityMax);
    }
    
    function _onRemoveClick() {
      $tbody.find(".cblist:checked").closest("tr").remove();
    }
    
    $(document).von($tab, "product-upsell-save", function(event, reqCMD) {
      var productIDs = [];
      var errors = [];
      var $rows = $tbody.find("tr");

      reqCMD.Product.ProductUpsellList = [];

      $rows.removeAttr("data-status");
      $rows.each(function(index, elem) {
        var $tr = $(elem);
        var $targetProductId = $tr.find("#TargetProductId");
        var productId = getNull($targetProductId.val());
        var quantityMin = getNull($tr.find("#QuantityMin").val());
        var quantityMax = getNull($tr.find("#QuantityMax").val());
        
        function __addError(tr, message) {
          errors.push({
            "row": tr,
            "message": message
          });
        }
          
        if (productId == null) 
          __addError($tr, itl("@Product.MissingTargetProductError"));
        else if (productIDs.indexOf(productId) >= 0) 
          __addError($tr, itl("@Common.DuplicatedItem") + ": " + $targetProductId.attr("data-itemname"));
        
        if ((quantityMin != null) && isNaN(parseInt(quantityMin)))
          __addError($tr, itl("@Common.InvalidValueError", quantityMin));
        
        if (isNaN((quantityMax != null) && parseInt(quantityMax)))
          __addError($tr, itl("@Common.InvalidValueError", quantityMax));
        
        reqCMD.Product.ProductUpsellList.push({
          TargetProductId: productId,
          UpsellType: UPSELLTYPE_ADDON,
          SamePortfolio: $tr.find("#SamePortfolio").isChecked(),
          BindPerformance: $tr.find("#BindPerformance").isChecked(),
          QuantityMin: quantityMin,
          QuantityMax: quantityMax
        });
            
        productIDs.push(productId);
      });
      
      if (errors.length > 0) {
        var messages = distinct(errors.map(it => "- " + it.message)).join("\n");
        showIconMessage("warning", messages);
        errors.forEach(it => it.row.attr("data-status", "error"));
        throw messages;
      }
    });
  });
</script>
