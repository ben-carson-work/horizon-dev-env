UIMob.init("info-device", function($view, params) {

  $view.find("#os-platform").find(".pref-item-value").text(BLMob.DeviceInfo.OS.Platform);
  $view.find("#app-version").find(".pref-item-value").text(BLMob.DeviceInfo.App.Version);
  $view.find("#device-code").find(".pref-item-value").text(BLMob.DeviceInfo.DeviceCode);
  $view.find("#device-code").click(onDeviceCodeClick);
  
  var si = UIMob.getScreenInfo();
  $view.find("#screenres").find(".pref-item-value").text(si.Width + "x" + si.Height);
  $view.find("#pixelratio").find(".pref-item-value").text(devicePixelRatio);

  refreshHardwarePref("#hardware-nfc", "nfc");
  refreshHardwarePref("#hardware-barcode", "barcode");
  refreshHardwarePref("#hardware-magstripe", "magstripe");
  refreshHardwarePref("#hardware-gps", "gps");
  refreshHardwarePref("#hardware-vibrator", "vibrator");
  
  setHardwarePref("#hardware-barcodecamera", BLMob.DeviceInfo.BarcodeCamera, false);
  
  function findHardware(type) {
    var list = BLMob.DeviceInfo.HardwareStatus || [];

    for (var i=0; i<list.length; i++) 
      if (list[i].HardwareType == type)
        return list[i];
    
    return null;
  }
  
  function setHardwarePref(selector, available, active) {
    if (available !== true)
      $(selector).remove();
    else {
      var text = itl("@Common.Inactive");
      var color = "";

      if (active === true) {
        text = itl("@Common.Active");
        color = "var(--base-green-color)";
      }

      $(selector).find(".pref-item-value").css("color", color).text(text);
    }
    
  }
  
  function refreshHardwarePref(selector, hardwareType) {
    var item = findHardware(hardwareType);
    
    var available = false;
    var active = false;
    
    if ((item) && (item.Available === true)) {
      available = true;
      if (item.Active === true)
        active = true;
    }
    
    setHardwarePref(selector, available, active);
  }
  
  function onDeviceCodeClick() {
    UIMob.showMessage(itl("@Common.Warning"), "Do you want to un-register this APP?", [itl("@Common.Ok"), itl("@Common.Cancel")], function(index) {
      if (index == 0) 
        snpNative("unregister");
    });
  }
});