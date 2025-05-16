class StatusInitController extends KioskStatusController {
  constructor() {
    super();
    $("#status-init .kiosk-header-title").text("Initializing");
    $("#status-init .kiosk-header-subtitle").text("System will be ready shortly");
  }
}