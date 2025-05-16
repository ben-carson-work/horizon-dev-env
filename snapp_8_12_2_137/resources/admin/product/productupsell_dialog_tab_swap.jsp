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

<% boolean canEditProduct = (Boolean)request.getAttribute("canEditProduct"); %>

<div id="upsell-tab-swap" class="tab-content">
  <v:grid>
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="100%"><v:itl key="@Product.Upsell_TargetProduct"/> <v:hint-handle hint="@Product.Upsell_TargetProductSwapHint"/></td>
        <td>&nbsp;</td>
      </tr>
    </thead>
    <tbody class="upsell-tbody">
    </tbody>
    <tbody>
      <tr>
        <td colspan="100%">
          <v:button id="btn-add" caption="@Common.Add" fa="plus" enabled="<%=canEditProduct%>"/>
          <v:button id="btn-remove" caption="@Common.Remove" fa="minus" enabled="<%=canEditProduct%>"/>
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
          <snp:dyncombo field="TargetProductId" entityType="<%=LkSNEntityType.ProductType%>" enabled="<%=canEditProduct%>"/>
        </td>
        <td>
          <% if (canEditProduct) { %>
            <span class="row-hover-visible"><i class="fa fa-bars drag-handle"></i>
          <% } %>
        </td>
      </tr>
    </table>
  </div>
</div>

<script>
  $(document).ready(function() {
    const UPSELLTYPE_SWAP = <%=LkSNUpsellType.Swap.getCode()%>;
    var $tab = $("#upsell-tab-swap");
    var $tbody = $tab.find(".upsell-tbody");
    $tab.find("#btn-add").click(_addProduct);
    $tab.find("#btn-remove").click(_onRemoveClick);
    $tbody.sortable({
      handle: ".drag-handle",
      helper: fixHelper
    });
    
    $(document).von($tab, "product-upsell-load", function(event, params) {
      for (const item of params.ProductUpsellList)
        if (item.UpsellType == UPSELLTYPE_SWAP)
          _addProduct(item);
    });
    
    function _addProduct(item) {
      item = item || {};
      var $tr = $tab.find("#templates .upsell-product-row").clone().appendTo($tbody);
      $tr.find("#TargetProductId").val(item.TargetProductId);
    }
    
    function _onRemoveClick() {
      $tbody.find(".cblist:checked").closest("tr").remove();
    }
    
    $(document).von($tab, "product-upsell-save", function(event, reqCMD) {
      var productIDs = [];
      var errors = [];
      var $rows = $tbody.find("tr");

      reqCMD.Product.ProductUpsellList = reqCMD.Product.ProductUpsellList || [];

      $rows.removeAttr("data-status");
      $rows.each(function(index, elem) {
        var $tr = $(elem);
        var $targetProductId = $tr.find("#TargetProductId");
        var productId = getNull($targetProductId.val());

        if ((productId != null) && (productIDs.indexOf(productId) < 0)) {
          reqCMD.Product.ProductUpsellList.push({
            TargetProductId: productId,
            UpsellType: UPSELLTYPE_SWAP
          });
              
          productIDs.push(productId);
        }
      });
    });
  });
</script>
