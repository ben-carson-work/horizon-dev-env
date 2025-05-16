const CATALOG_TYPE_CATALOG = 1;
const CATALOG_TYPE_FOLDER  = 2;
const CATALOG_TYPE_ENTITY  = 3;
const ENTITY_TYPE_EVENT    = 5;
const ENTITY_TYPE_PRODUCT  = 12;

class StepCatalogController extends StepController {
  
  constructor() {
    super();
    this.initialized = false;
    this.mainCatalogId = null;
    this.catalogs = null;

    $(document).on("kiosk-init", () => this._updateCatalogs());
    $(document).on("kiosk-shopcart-change", (event, data) => this._onShopCartChange(data.shopCart));
  }
  
  activate() {
    super.activate();
    this.transactionController.upsellOptions = null;
    
    if (this.catalogs)
      this._renderCatalogs();
      
    if (this.mainCatalogId)
      this.setActiveCatalogId(this.mainCatalogId);
  }
  
  _onShopCartChange(shopCart) {
    if (this.active) {
      this.updateDisplayButtons(); 
      this._updateProductButtonsQuantities(shopCart);
    }
  }
  
  updateDisplayButtons() {
    super.updateDisplayButtons();
    let empty = KIOSK_CONTROLLER.isShopCartEmpty();
    let root = getNull($(".catalog-body.active").attr("data-parentcatalogid")) == null;
    this.displayController.$back.text((root === false) ? KIOSK_UI_CONTROLLER.itl("@StepCatalog.BackButtonCaption") : empty ? "HOME" : KIOSK_UI_CONTROLLER.itl("@StepCatalog.ClearButtonCaption"));
    this.displayController.$next.text(KIOSK_UI_CONTROLLER.itl("@StepCatalog.NextButtonCaption"));
    this.displayController.$next.setClass("disabled", empty);
  }
  
  _updateProductButtonsQuantities(shopCart) {
    let $buttons = $(".catalog-button");
    $buttons.removeClass("incart");
    
    for (const item of (shopCart.Items || [])) {
      this._updateProductButtonQuantities($buttons, item);
      for (const child of (item.Items || [])) 
        this._updateProductButtonQuantities($buttons, child);
    }
  }
  
  _updateProductButtonQuantities($buttons, shopCartItem) {
    let performances = shopCartItem.PerformanceList || [];
    let performanceId = (performances.length > 0) ? performances[0].PerformanceId : null;

    $buttons = $buttons.filter("[data-entityId='" + shopCartItem.ProductId + "']");
    if (performanceId)
      $buttons = $buttons.filter("[data-performanceid='" + performanceId + "']");
    else
      $buttons = $buttons.not("[data-performanceId]");
      
    $buttons.addClass("incart");
    $buttons.find(".catalog-button-incart-quantity").text(shopCartItem.Quantity);
  }
  
  backClick() {
    let parentCatalogId = getNull($(".catalog-body.active").attr("data-parentcatalogid"));
    
    if (parentCatalogId != null)
      this.setActiveCatalogId(parentCatalogId);
    else if (KIOSK_CONTROLLER.isShopCartEmpty()) 
      this.transactionController.activate();
    else {
      KIOSK_UI_CONTROLLER.showConfirm({"message":"Do you want to empty your shopping cart?"})
          .then(() => KIOSK_CONTROLLER.apiShopCart("EmptyShopCart"));
    }
  }
    
  setActiveCatalogId(catalogId, direction) {
    $(".catalog-body.active").removeClass("active");

    let $newBody = $(".catalog-body[data-catalogid='" + catalogId + "']").addClass("active");
    let newBodyModel = $newBody.data("model");
    this.$ui.find(".kiosk-header-title").text(newBodyModel.title);
    this.$ui.find(".kiosk-header-subtitle").text(newBodyModel.subtitle || "");
    if (direction != "backward") 
      $newBody.data("controller").activate();
    
    let $newTab = $(".catalog-tab[data-catalogid='" + catalogId + "']");
    if ($newTab.length >= 0) {
      $(".catalog-tab.active").removeClass("active");
      $newTab.addClass("active")
    }
    
    this.updateDisplayButtons();
  }
  
  _updateCatalogs() {
    SNP_LOGGER.info(null, null, "INITIALIZING CATALOG...");
    $(".transaction-step[data-step-code='CATALOG']").addClass("loading");
    $(".selection-view").removeClass("active");
    
    snappAPI().cmd("CATALOG", "GetChildNodes", {"Recursive":true, "PresaleActive":true})
       .then(ansDO => {
         this.catalogs = ansDO.Nodes || [];
         this._renderCatalogs();
       })
       .catch(error => SNP_LOGGER.error(null, null, error));
  }
  
  _renderCatalogs() {
    $("#catalog-tab,#catalog-body").empty();
    
    for (const catalog of this.catalogs) {
      if (this.mainCatalogId === null)
        this.mainCatalogId = catalog.CatalogId;

      this._createTabUI(catalog).appendTo("#catalog-tab");
      new CatalogBodyFolderController({"step":this, "node":catalog});
    }

    if (this.mainCatalogId)
      this.setActiveCatalogId(this.mainCatalogId);

    $(".transaction-step[data-step-code='CATALOG']").removeClass("loading");
  }
    
  _createTabUI(catalog) {
    let $tab = $("#catalog-templates .catalog-tab").clone();
    $tab.find(".catalog-tab-title").text(KIOSK_UI_CONTROLLER.getConfigLangTranslation(catalog.ITL_CatalogName, catalog.CatalogName));
    $tab.attr("data-catalogid", catalog.CatalogId);
    
    if (catalog.ProfilePictureId)
      $tab.css("background-image", "url('repository?id=" + catalog.ProfilePictureId + "')");
      
    if (catalog.BackgroundColor)
      $tab.css("background-color", "#" + catalog.BackgroundColor);
      
    if (catalog.ForegroundColor)
      $tab.css("foreground-color", "#" + catalog.ForegroundColor);
      
    $tab.click(() => this.setActiveCatalogId(catalog.CatalogId));
    
    return $tab;
  }  
}

function catalogTypeCode(node) {
  if (node.CatalogType == CATALOG_TYPE_CATALOG)
    return "catalog"; 
  else if (node.CatalogType == CATALOG_TYPE_FOLDER)
    return "folder"; 
  else if (node.CatalogType == CATALOG_TYPE_ENTITY) { 
    if (node.EntityType == ENTITY_TYPE_EVENT) 
      return "event"; 
    else if (node.EntityType == ENTITY_TYPE_PRODUCT) 
      return "product"; 
  }
  
  return "unknown";
}