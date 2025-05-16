class CatalogBodyPerformanceController extends CatalogBodyController {
  /*
  params = {
    step: catalog step
    performance: DOPerformanceRef 
    parentCatalogId: string // on root will be null
  }
   */
  constructor(params) {
    super(CatalogBodyPerformanceController._injectParams(params));
  }
  
  static _injectParams(params) {
    let perf = params.performance;
    params.model = {
      "catalogTypeCode": "performance",
      "catalogId": perf.PerformanceId,
      "title": perf.EventName,
      "subtitle": formatDate(perf.DateTimeFrom) + " " + formatTime(perf.DateTimeFrom)
    };
    return params;
  }
  
  _createUI() {
    let $body = super._createUI();
    let perf = this.params.performance;
    $body.find(".catalog-body-performance-title").text(this.params.model.subtitle);

    for (const prod of perf.ProductList || []) {
      var button = new CatalogButtonController({
        "step": this.params.step, 
        "perfprod": prod, 
        "performance": this.params.performance
      });
      $body.find(".catalog-body-content").append(button.$ui);
    }
    
    return $body;
  }

}