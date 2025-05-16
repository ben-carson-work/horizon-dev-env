/*
param = {
  step: StepSelectionController,
  node: catalog's node
  perfprod: DOPerformanceRef.DOPerfProductRef
  performance: DOPerformanceRef
}
*/
class CatalogButtonController {
  constructor(params) {
    this.params = params || {};
    
    this.model = {};
    if (params.node) {
      let node = params.node;
      this.model = {
        "catalogTypeCode": catalogTypeCode(node),
        "entityId": node.EntityId,
        "title": KIOSK_UI_CONTROLLER.getConfigLangTranslation(node.ITL_CatalogName, node.CatalogName),
        "richDesc": KIOSK_UI_CONTROLLER.getRichDescTranslation(node.RichDescList),
        "profilePictureId": node.ProfilePictureId,
        "backgroundColor": node.BackgroundColor,
        "foregroundColor": node.ForegroundColor,
        "iconAlias": node.IconAlias,
        "variablePrice": node.VariablePrice,
        "price": node.Price
      };
    } 
    else if (params.perfprod) {
      let prod = params.perfprod;
      this.model = {
        "entityId": prod.ProductId,
        "performanceId": (params.performance) ? params.performance.PerformanceId : null,
        "catalogTypeCode": "perfprod",
        "title": KIOSK_UI_CONTROLLER.getConfigLangTranslation(prod.ITL_ProductName, prod.ProductName),
        "richDesc": KIOSK_UI_CONTROLLER.getRichDescTranslation(prod.RichDescList),
        "profilePictureId": prod.ProfilePictureId,
        "backgroundColor": prod.BackgroundColor,
        "foregroundColor": prod.ForegroundColor,
        "iconAlias": prod.IconAlias,
        "variablePrice": prod.VariablePrice,
        "price": prod.Price
      };
    } 
    
    this.$ui = this._createUI(this.model);
  }
  
  _createUI(model) {
    let $btn = $("#catalog-templates .catalog-button").clone();
    $btn.addClass(`catalog-button-${model.catalogTypeCode}`); 
    $btn.attr("data-entityid", model.entityId);
    $btn.attr("data-performanceid", model.performanceId);
    $btn.setClass("richdesc", (model.richDesc != null));

    $btn.find(".catalog-button-title").text(model.title);
    
    if (model.profilePictureId)
      $btn.css("background-image", "url('repository?id=" + model.profilePictureId + "')");
    
    if (model.backgroundColor)
      $btn.css("background-color", "#" + model.backgroundColor);
    
    if (model.foregroundColor)
      $btn.css("color", "#" + model.foregroundColor);
    
    if (model.iconAlias)
      $btn.find(".catalog-button-icon .fa").addClass("fa-" + model.iconAlias);
    
    if ((model.catalogTypeCode == "product") || (model.catalogTypeCode == "perfprod")) {
      let text = model.variablePrice ? "..." : formatCurr(model.price);
      let $price = $btn.find(".catalog-button-price");
      $price.text(text);
      $price.removeClass("hidden");
    }
    
    $btn.click(() => this._onClick());
    
    if (model.richDesc != null)
      $btn.find(".catalog-button-info").click(event => {
        event.stopPropagation();
        KIOSK_UI_CONTROLLER.showInfo({
          "title": model.title,
          "richDesc": model.richDesc
        });
      });
    
    return $btn;
  }
      
  _findShopCartItemById(shopCartItemId) {
    for (const item of KIOSK_CONTROLLER.shopCart.Items || []) 
      if (item.ShopCartItemId == shopCartItemId)
        return item;
    return null;
  }

  _onClick() {
    let params = this.params;
    let catalogTypeCode = this.model.catalogTypeCode;
    
    if (catalogTypeCode == "product")
      this._addToCart(params.node.EntityId);
    else if (catalogTypeCode == "perfprod")
      this._addToCart(params.perfprod.ProductId, params.performance.PerformanceId);
    else if (["folder", "event"].indexOf(catalogTypeCode) >= 0)
      this.params.step.setActiveCatalogId(params.node.CatalogId);
  }
  
  _addToCart(productId, performanceId) {
    this.$ui.addClass("spinner");
    KIOSK_CONTROLLER.apiShopCart("AddToCart", {
      "ItemList": [
        {
          "Product": {
            "ProductId": productId
          },
          "PerformanceIDs": performanceId
        }
      ]
    }).then(ansDO => {
      let $ui = this.$ui;
      $ui.removeClass("spinner");
      $ui.addClass("checkmark");
      setTimeout(function() {
        $ui.removeClass("checkmark");
      }, 1000);
    });
  }
}