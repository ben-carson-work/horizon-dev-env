class StatusMaintenanceController extends KioskStatusController {

  constructor() {
    super();
    $("#status-maintenance .kiosk-header-title").text("Maintenance");
    this._renderDeviceManager(DEVICE_MANAGER);
    $(document).on("device-manager-status", (event, s) => this._onDeviceManagerStatusChanged(s));
    $(document).on("device-status", (event, s) => this._onDeviceStatusChanged(s));
    $("#maintenance-reload-btn").click(() => location.reload());
    $("#maintenance-exit-btn").click(() => KIOSK_CONTROLLER.exitMaintenanceMode());
    $("#maintenance-force-btn").click(() => DEVICE_MANAGER.performMaintenance());

    
    const console_log = window.console.log;
    window.console.log = function(...args) {
			let $logger = $("#log");
			console_log(...args);
			args.forEach(arg => {
				let message = "";
				if (typeof arg == 'object')
					message = (JSON && JSON.stringify ? JSON.stringify(arg, undefined, 2) : arg);
				else
					message = arg;

				let now = new Date();
				$logger.append("[" + now.toLocaleString() + "." + now.getMilliseconds() + "]: " + message + "\n");
			});
			$logger.scrollTop($logger[0].scrollHeight);
    }
  }
  
	_onDeviceManagerStatusChanged() {
    this._renderDeviceManager(DEVICE_MANAGER);
	}
	
	_onDeviceStatusChanged() {
		this._renderDevices(DEVICE_MANAGER.deviceInstanceMap.values());
	}
  
  _renderDeviceManager(deviceManager) {
    let $container = $("#device-manager-container").empty();

    this._addDeviceUI($container, {
      "pluginName": deviceManager.deviceManagerName,
      "status": deviceManager.status,
      "errorMessage": deviceManager.errorMessage,
      "iconName": "device_connector.png"
    });
	}
  
  _renderDevices(deviceList) {
    let $container = $("#status-maintenance").find("#maintenance-devices").empty();

		for (let device of deviceList || []) {
      this._addDeviceUIWithButtons($container, {
        "deviceId": device.deviceId,
        "pluginName": device.pluginName,
        "status": device.deviceStatus,
        "errorMessage": device.errorMessage,
        "iconName": device.iconName
      });
    }
  }
  
  _addDeviceUI($container, model) {
    let $item = $("#maintenance-device-templates .maintenance-device").clone();
    $item.data("model", model);
    $item.find(".maintenance-device-icon img").attr("src", getIconURL(model.iconName, 32));
    $item.find(".maintenance-device-status-icon").addClass("status-"+model.status);
    $item.find(".maintenance-device-status-icon .fa").addClass(this._getDeviceStatusIcon(model.status));
    $item.find(".maintenance-device-title").text(model.pluginName);
    $item.find(".maintenance-device-subtitle").text(model.errorMessage);
    $item.find(".maintenance-device-status-value").text(model.status);
    $item.find(".maintenance-device-error").text(model.errorMessage);
    
    
    $container.append($item);
    return $item;
  }
  
  _addDeviceUIWithButtons($container, model) {
	  let $item = this._addDeviceUI($container, model);
	  $item.find(".maintenance-device-actions").removeClass("hidden");
    $item.find(".device-refresh-status-btn").click(() => this._onDeviceRefreshStatusClick($item));
    $item.find(".device-reset-btn").click(() => this._onDeviceResetClick($item));	  
	}
	 
  _getDeviceStatusIcon(status) {
	  if (status === "READY")
	  	return "fa-square-check";
	  if (status === "INITIALIZING")
	  	return "fa-triangle-exclamation";
	  if (status === "ERROR")
	  	return "fa-square-exclamation";
  }
   
  _onDeviceResetClick($item) {
	  SNP_LOGGER.debug($item.data("model").deviceId, 27, "Reset device: " + $item.data("model").pluginName);
	  let device = DEVICE_MANAGER.findDeviceById($item.data("model").deviceId);

	  if (device) {
		  KIOSK_UI_CONTROLLER.showConfirm({
	        "message": "Do you want to reset device: '" + $item.data("model").pluginName + "'?"
	      }).then(() => device.reset());
	  }
	  else
	  	KIOSK_UI_CONTROLLER.showError("Device not found: " + $item.data("model").pluginName);
  }
  
  _onDeviceRefreshStatusClick($item) {
	  SNP_LOGGER.debug($item.data("model").deviceId, 27, "Refresh device status: " + $item.data("model").pluginName);
	  let device = DEVICE_MANAGER.findDeviceById($item.data("model").deviceId);

	  if (device)
	    device.refreshStatus();
	  else
	  	KIOSK_UI_CONTROLLER.showError("Device not found: " + $item.data("model").pluginName);
  }
}