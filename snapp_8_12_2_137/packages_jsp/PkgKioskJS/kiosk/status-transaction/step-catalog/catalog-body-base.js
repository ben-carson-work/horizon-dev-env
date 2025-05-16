class CatalogBodyController {
  /*
  params = {
    step: catalog step
    parentCatalogId: string // on root will be null
    model: catalog body data model
  }
   */
  constructor(params) {
    this.params = params || {};
    this.$ui = this._createUI(params.model).appendTo("#catalog-body");
  }
  
  _createUI() {
    let model = this.params.model;
    let $body = $("#catalog-templates .catalog-body").clone();
    $body.data("controller", this);
    $body.data("model", model);
    $body.addClass("catalog-body-" + model.catalogTypeCode);
    $body.attr("data-catalogid", model.catalogId);
    $body.attr("data-parentcatalogid", this.params.parentCatalogId);
    
    return $body;
  }
  
  activate() {
    /*
    let model = this.params.model || {};
    let cssImage = (model.profilePictureId) ? "url(repository?id=" + model.profilePictureId + ")" : "none";
    $("#step-catalog #catalog-header-background").css("background-image", cssImage);
    */
  }
  
}