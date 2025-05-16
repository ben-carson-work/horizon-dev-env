class DlgInputController extends DialogBase {
  constructor() {
    super("#dlg-input");
    this.$input = this.$body.find("input");
    
    this.$dlg.keypress(event => this._onKeyPress(event));
    this.$dlg.find("#btn-yes").click(() => this._onConfirm());
  }
  
  execute(params) {
    params = params || {};
    params.title = params.title || "Confirm";
    
    this.$title.text(params.title);
    this.$body.find("label").text(params.message);
    this.$input.val(params.defaultValue || "");
    
    return super.execute();
  }
  
  _onKeyPress(event) {
    if (event.keyCode == 13)
      this._onConfirm();
  }
  
  _onConfirm() {
    this.dlgResolve(this.$input.val());
  }
}