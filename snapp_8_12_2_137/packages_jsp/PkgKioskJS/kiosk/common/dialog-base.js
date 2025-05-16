class DialogBase {
  constructor(selector, options) {
    this.dlg = new bootstrap.Modal(selector, options);
    this.resolve = null;
    this.reject = null;

    this.$dlg = $(selector);
    this.$title = this.$dlg.find(".modal-title");
    this.$body = this.$dlg.find(".modal-body");
    this.$footer = this.$dlg.find(".modal-footer");

    $(document).on("kiosk-status-change", (event, data) => this._onKioskStatusChange(data));
    $(selector).on("hide.bs.modal", (event) => this._onHide(event));
  }
  
  _onKioskStatusChange(data) {
    if (data.status == "IDLE")
      this.dlg.hide();
  }
  
  _onHide(event) {
    let reject = this.reject;
    this.resolve = null;
    this.reject = null;
    
    if (reject != null) 
      reject();
  }
  
  hide() {
    this.dlg.hide();
  }
  
  dlgResolve(p1, p2, p3, p4, p5) {
    let resolve = this.resolve;
    this.resolve = null;
    this.reject = null;
      
    this.hide();
    if (resolve != null) 
      resolve(p1, p2, p3, p4, p5);
  }

  execute() {
    return new Promise((resolve, reject) => {
      this.resolve = resolve;
      this.reject = reject;
      
      this.dlg.show();    
    });
  }
}