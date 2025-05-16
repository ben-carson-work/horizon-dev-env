class DlgMediaReadController extends DialogBase {
  constructor() {
    super("#dlg-media-read");

    $(document).on("kiosk-media-read", (event, mediaRead) => this.dlgResolve(mediaRead));
  }
    
/*
  _onMediaRead(mediaRead) {
    let resolve = this.resolve;
    this.resolve = null;
    this.reject = null;
      
    if (resolve != null) {
      this.hide();
      resolve(mediaRead);
    }
  }
*/
  
  _onHide(event) {
    KIOSK_CONTROLLER.stopRead();
    super._onHide(event);
  }

  execute() {
    KIOSK_CONTROLLER.startRead();
    return super.execute();
  }
}