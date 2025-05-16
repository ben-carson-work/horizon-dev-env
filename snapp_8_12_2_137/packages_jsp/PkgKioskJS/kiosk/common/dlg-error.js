class DlgErrorController extends DialogBase {
  constructor() {
    super("#dlg-error");
  }
  
  execute(params) {
    params = params || {};
    params.title = params.title || "Something went wrong";
    
    let message = "An error has occurred";
    if ((params.error) && (params.error.message))
      message = params.error.message;
    
    this.$dlg.find(".modal-title").text(params.title);
    this.$dlg.find(".modal-body").text(message);
    
    return super.execute();
  }
}