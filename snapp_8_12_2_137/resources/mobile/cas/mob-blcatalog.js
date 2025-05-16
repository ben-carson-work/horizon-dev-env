//# sourceURL=mob-catalog.js

$(document).ready(function() {
  window.BLCatalog = {
    "createFolderButton": doCreateFolderButton,
    "createProdTypeButton": doCreateProdTypeButton,
    "createEventButton": doCreateEventButton
  };
  
  var $commonTemplates = $("#common-templates");
  var $folderTemplate = $commonTemplates.find(".btn-catalog.btn-catalog-folder"); 
  var $prodTypeTemplate = $commonTemplates.find(".btn-catalog.btn-catalog-prodtype"); 
  var $eventTemplate = $commonTemplates.find(".btn-catalog.btn-catalog-event"); 
  
  var BUTTON_DISPLAY_TYPES = {};
  BUTTON_DISPLAY_TYPES[LkSN.ButtonDisplayType._1x1.code] = "1x1";
  BUTTON_DISPLAY_TYPES[LkSN.ButtonDisplayType._2x1.code] = "2x1";
  BUTTON_DISPLAY_TYPES[LkSN.ButtonDisplayType._1x2.code] = "1x2";
  BUTTON_DISPLAY_TYPES[LkSN.ButtonDisplayType._2x2.code] = "2x2";
  
  $(document).on("ShopCartQuantityChange", onShopCartQuantityChange);

  function createBaseButton($template, params) {
    var $btn = $template.clone();
    var $btnBody = $btn.find(".btn-catalog-body"); 

    $btn.attr("data-buttondisplaytype", BUTTON_DISPLAY_TYPES[params.ButtonDisplayType]);
    $btn.find(".btn-catalog-name").text(params.CatalogName);

    if (params.ProfilePictureId) 
      $btnBody.css("background-image", "url('" + calcRepositoryURL(params.ProfilePictureId) + "')");
    
    if (params.BackgroundColor)
      $btnBody.css("background-color", "#" + params.BackgroundColor);
    
    if (params.ForegroundColor)
      $btnBody.css("color", "#" + params.ForegroundColor);

    return $btn;
  }

  function doCreateFolderButton(params) {
    var $btn = createBaseButton($folderTemplate, params);

    return $btn;
  }

  function doCreateProdTypeButton(params) {
    params = params || {};
    params.CatalogName = params.CatalogName || params.ProductName;
    
    var productId = params.ProductId;
    var $btn = createBaseButton($prodTypeTemplate, params);
    $btn.attr("data-productid", productId);
    $btn.find(".btn-catalog-price").text(formatCurr(params.Price, mainCurrencyFormat, ""));
    
    refreshProdInCart($btn);
    
    $btn.click(function() {
      BLCart.addToCart({
        "ProductId": productId,
        "PerformanceId": params.PerformanceId
      });
    });
    
    return $btn;
  }
  
  function refreshProdInCart($btn) {
    var qty = BLCart.getCartQuantity($btn.attr("data-productid"));
    $btn.setClass("prod-in-cart", qty !== 0);
    if (qty !== 0)
      $btn.find(".btn-catalog-qty").text("#" + qty);
  }
  
  function onShopCartQuantityChange() {
    $(".btn-catalog-prodtype").each(function(index, elem) {
      refreshProdInCart($(elem));
    });
  }

  function doCreateEventButton(params) {
    var $btn = createBaseButton($eventTemplate, params);
    $btn.attr("data-eventid", params.EventId);
    
    return $btn;
  }
});