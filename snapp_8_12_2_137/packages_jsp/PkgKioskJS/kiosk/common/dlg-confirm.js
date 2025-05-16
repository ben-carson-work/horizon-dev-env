class DlgConfirmController extends DialogBase {
  constructor() {
    super("#dlg-confirm");
    
    this.$dlg.find("#btn-yes").click(() => this.dlgResolve());
  }
  
  execute(params) {
    params = params || {};
    params.title = params.title || "Confirm";
    
    this.$dlg.find(".modal-title").text(params.title);
    this.$dlg.find(".modal-body").text(params.message);
    
    return super.execute();
  }
}