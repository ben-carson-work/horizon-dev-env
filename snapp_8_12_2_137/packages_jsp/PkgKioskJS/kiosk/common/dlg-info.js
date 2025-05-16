class DlgInfoController extends DialogBase {
  constructor() {
    super("#dlg-info");
  }
  
  execute(params) {
    params = params || {};
    params.title = params.title || "Info";
    
    this.$dlg.find(".modal-title").text(params.title);
    this.$dlg.find(".modal-body").html(params.richDesc);
    
    return super.execute();
  }
}