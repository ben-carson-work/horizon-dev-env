<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
DOProduct product = SrvBO_OC.getProduct(pageBase.getConnector(), pageBase.getId(), true).Product;
boolean canEditProduct = pageBase.getBL(BLBO_Right.class).getEntityRightCRUD(LkSNEntityType.ProductType, product.ProductId.getString()).canUpdate();
request.setAttribute("product", product);
request.setAttribute("canEditProduct", canEditProduct);
%>

<v:dialog id="productupsell_dialog" tabsView="true" title="@Product.Upsells" width="800" height="600" autofocus="false">
  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-addon" caption="@Product.Upsell_AddOns" icon="<%=LkSNUpsellType.AddOn.getIconName()%>" default="true">
      <jsp:include page="productupsell_dialog_tab_addon.jsp"/>
    </v:tab-item-embedded>
    <v:tab-item-embedded tab="tabs-swap" caption="@Product.Upsell_Swaps" icon="<%=LkSNUpsellType.Swap.getIconName()%>">
      <jsp:include page="productupsell_dialog_tab_swap.jsp"/>
    </v:tab-item-embedded>
  </v:tab-group>

  <script>
    $(document).ready(function() {
      var $dlg = $("#productupsell_dialog");
      
      $dlg.on("snapp-dialog", function(event, params) {
        params.buttons = [
          <% if (canEditProduct) { %>
            dialogButton("@Common.Save", _save),
          <% } %>
          dialogButton("@Common.Cancel", doCloseDialog)
        ]; 
      });
      
      $(document).trigger("product-upsell-load", {
        "ProductUpsellList": <%=product.ProductUpsellList.getJSONString()%> || []
      });
      
      function _save() {
        var reqDO = {
          Command: "SaveProduct",
          SaveProduct: {
            Product: {
              ProductId: <%=JvString.jsString(pageBase.getId())%>
            }
          }
        };
        
        $(document).trigger("product-upsell-save", reqDO.SaveProduct);
        
        showWaitGlass();
        vgsService("Product", reqDO, false, function() {
          hideWaitGlass();
          $dlg.dialog("close");
        });
      }
    });
  </script>  
</v:dialog>