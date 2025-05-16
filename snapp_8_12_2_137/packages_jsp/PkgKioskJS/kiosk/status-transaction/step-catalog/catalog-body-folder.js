/* This class renders catalog-body for "FOLDER" and "EVENT" nodes */
class CatalogBodyFolderController extends CatalogBodyController {
  /*
  params = {
    step: catalog step
    node: catalog's node 
    parentCatalogId: string // on root will be null
  }
  */
  constructor(params) {
    super(CatalogBodyFolderController._injectParams(params));

    this.$performances = this.$ui.find(".event-body-performances");
    this.$scrollContainer = $("#catalog-body");
    this.performanceController = (params.node.EntityType == ENTITY_TYPE_EVENT) ? new PerformanceController(this.$performances, this.$scrollContainer, this.params.node.EntityId, this.params.node.CatalogId) : null;
    this.$scrollContainer.scroll(() => this._loadNextPerformancesIfNeeded());
  }

  static _injectParams(params) {
    params.model = {
      "catalogTypeCode": catalogTypeCode(params.node),
      "catalogId": params.node.CatalogId,
      "title": params.node.CatalogName,
      "iconName": params.node.IconName,
      "iconAlias": params.node.IconAlias,
      "profilePictureId": params.node.ProfilePictureId,
      "backgroundColor": params.node.BackgroundColor,
      "foregroundColor": params.node.ForegroundColor
    };
    return params;
  }

  _createUI() {
    let $body = super._createUI();
    let node = this.params.node;
    
    $body.attr("data-entitytype", node.EntityType);
    $body.attr("data-entityid", node.EntityId);

    if ((node.CatalogType == CATALOG_TYPE_FOLDER) || (node.CatalogType == CATALOG_TYPE_CATALOG)) {
      for (const childNode of (node.Nodes || [])) {
        const button = new CatalogButtonController({"step":this.params.step, "node":childNode});
        $body.find(".catalog-body-content").append(button.$ui);
        new CatalogBodyFolderController({"step":this.params.step, "node":childNode, "parentCatalogId":node.CatalogId});
      }
    }
    
    return $body;
  }

  activate() {
    super.activate();
    if (this.params.node.EntityType == ENTITY_TYPE_EVENT) {
      this.$performances.empty();
      this.performanceController.startPerformanceSearch((perf) => this._performanceClick(perf), 1);
    } 
  }
  
  _loadNextPerformancesIfNeeded() {
    this.performanceController && this.performanceController.loadNextPerformancesIfNeeded((perf) => this._performanceClick(perf));
  }
  
  _performanceClick(perf) {
    $("#catalog-body .catalog-body-performance").remove();
    new CatalogBodyPerformanceController({"step": this.params.step, "performance":perf, "parentCatalogId":this.params.node.CatalogId});
    this.params.step.setActiveCatalogId(perf.PerformanceId);
  }
}