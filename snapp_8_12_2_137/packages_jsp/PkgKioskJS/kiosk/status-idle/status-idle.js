class StatusIdleController extends KioskStatusController {
  constructor() {
    super();
    $("#status-idle .kiosk-header-title").attr("data-itl", "@StepIdle.Title");
  }
}