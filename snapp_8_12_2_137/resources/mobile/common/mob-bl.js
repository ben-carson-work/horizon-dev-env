//# sourceURL=mob-bl.js

$(document).ready(function() {
  window.BLMob = {
    // Properties
    "DeviceInfo": null,
    "Workstation": null,
    "AccessPoint": null,
    "User": null,
    "Rights": null,
    "MainCurrency": null,
    "ChangePlugin": null,
    // Methods
    "afterLogin": afterLogin,
    "logout": logout,
    "handShake": handShake,
    "registerMobile": registerMobile,
    "changeApp": changeApp,
    "isAppAvailable": isAppAvailable,
    "changeWorkstation": changeWorkstation,
    "findHardwareStatus": findHardwareStatus,
    "showMediaPickupDialog": null // mob-dlg-mediapickup.js
  };
  
  $(document).keydown(onDocumentKeyDown);
  $(document).on("VGS_OnBackground", onAppBackground);
  $(document).on("VGS_OnForeground", onAppForeground);
  
  let keybuffer = "";
  let tsLast = (new Date()).getTime();
  function onDocumentKeyDown(e) {
    if (!$(':focus').is("input")) {
      let tsNow = (new Date()).getTime();
      if (tsNow - tsLast > 100) 
        keybuffer = "";
      
      if ((e.keyCode >= 48) && (e.keyCode <= 122))
        keybuffer += String.fromCharCode(e.keyCode);
      else if ((e.keyCode == KEY_ENTER) && (keybuffer.length >= 6)) {
        $(document).trigger(EVENT_InputRead, {
          "ReaderType": "barcode", 
          "MediaCode": keybuffer, 
          "Manual": false
        });
        keybuffer = "";
      }
      
      tsLast = tsNow;
    }
  }

  function afterLogin(workstation, user, rights) {
    BLMob.Workstation = workstation;
    if ((workstation) && (workstation.AccessPointList) && (workstation.AccessPointList.length > 0))
      BLMob.AccessPoint = workstation.AccessPointList[0];
    BLMob.User = user;
    BLMob.Rights = rights;
    BLMob.MainCurrency = getMainCurrency(workstation);
    BLMob.ChangePlugin = getChangePlugin(workstation);

    mainCurrencyFormat = BLMob.MainCurrency.CurrencyFormat;
    mainCurrencySymbol = BLMob.MainCurrency.Symbol;
    mainCurrencyISO = BLMob.MainCurrency.ISOCode;

    thousandSeparator = rights.ThousandSeparator;
    decimalSeparator = rights.DecimalSeparator;
    snpShortDateFormat = rights.ShortDateFormat;
    snpShortTimeFormat = rights.ShortTimeFormat;
    snpFirstDayOfWeek = rights.FirstDayOfWeek - 1;
    
    // TODO: Find better way
    $(document).trigger("login");
  }
  
  function getMainCurrency(wks) {
    let list = wks.CurrencyList || [];
    for (let i=0; i<list.length; i++) {
      let curr = list[i];
      if (curr.CurrencyId == wks.MainCurrencyId)
        return curr;
    } 
    throw Error("Unable to find main currency");
  }
  
  function getChangePlugin(wks) {
    let list = wks.PaymentMethodList || [];
    for (let i=0; i<list.length; i++) {
      let plugin = list[i];
      if (plugin.PluginId == wks.CashDefaultPluginId)
        return plugin;
    } 
    throw Error("Unable to find change plugin");
  }

  function logout() {
    snpAPI("Login", "Logout", {"WorkstationId":workstationId}).then(function() {
      window.location.reload();
    });
  }
  
  function handShake() {
    if (isNativeAvailable()) {
      let style = getComputedStyle(document.body);
      snpNative("setUIConfig", {
        "BackgroundColor": style.getPropertyValue('--menu-bg-color'),
        "StatusBarColor": style.getPropertyValue('--pagetitle-bg-color'),
        "StatusBarStyle": "dark"
      });
    }
    
    getDeviceInfo().then(function(deviceInfo) {
      BLMob.DeviceInfo = deviceInfo;
      
      let activationKey = getLocalStorage("ActivationKey");
      if (activationKey) {
        let workstationId = getLocalStorage("WorkstationId");
        if (workstationId) 
          BLMob.registerMobile(workstationId);
        else 
          UIMob.showView(PKG_COMMON, "select-workstation");
      }
      else 
        UIMob.showView(PKG_COMMON, "select-license");
    });
  }
  
  function refreshDeviceInfo() {
    getDeviceInfo().then(function(deviceInfo) {
      BLMob.DeviceInfo = deviceInfo;
    });
  }
  
  function getDeviceInfo() {
    return new Promise(function(resolve, reject) {
      if (isNativeAvailable()) {
        snpNative("getDeviceInfo", {}).then(function(data) {
          resolve(data);
        });
      }
      else {
        let deviceCode = getLocalStorage("DeviceCode");
        if (!(deviceCode)) {
          deviceCode = newStrUUID();
          setLocalStorage("DeviceCode", deviceCode);
        }

        let deviceInfo = {
          "OS": {
            "Platform": "desktop"
          },
          "App": {},
          "DeviceCode": deviceCode,
          "BarcodeCamera": false,
          "HardwareStatus": []
        };

        resolve(deviceInfo);
      }
    });
  }
  
  function registerMobile(workstationId) {
    let reqDO = {
      DeviceCode: BLMob.DeviceInfo.DeviceCode,
      WorkstationId: workstationId,
      ActivationKey: getLocalStorage("ActivationKey"),
      AppNames: selectedAppNames
    };

    snpAPI("Login", "RegisterMobile", reqDO)
      .then(function(ansDO) {
        setLocalStorage("ActivationKey", ansDO.ActivationKey);
        let availableApps = (ansDO.AppList) ? ansDO.AppList : [];
        window.workstationId = workstationId; 
        
        let appName = getLocalStorage("AppName");
        let appFound = false;
        for (let i=0; i<availableApps.length; i++) {
          if (availableApps[i].AppName == appName) {
            appFound = true;
            break;
          }        
        } 
        
        if (appFound)
          UIMob.showApp(appName);
        else
          UIMob.showView(PKG_COMMON, "applist");
      })
      .catch(function(error) {
        delLocalStorage("ActivationKey");
        registerMobile(workstationId);
      });
  }

  function changeApp() {
    delLocalStorage("AppName");
    window.location.reload();
  }

  function changeWorkstation() {
    delLocalStorage("WorkstationId");
    window.location.reload();
  }
  
  var tsBackground = null;

  function onAppBackground(event, data) {
    let tsLocal = (new Date()).getTime();
    tsBackground = tsLocal;
    
    setTimeout(function() {
      if (tsLocal === tsBackground) {
        UIMob.showView(PKG_COMMON, "login");
        snpAPI("Login", "Logout", {
          "WorkstationId": BLMob.Workstation.WorkstationId
        });
      }
    }, 10000);
  }

  function onAppForeground(event, data) {
    tsBackground = null;
  }
  
  function isAppAvailable(appName) {
    let apps = availableApps || [];
    for (let i=0; i<apps.length; i++)
      if (apps[i].AppName == appName)
        return true;
    return false;
  }
  
  function findHardwareStatus(hardwareType) {
    let list = (BLMob.DeviceInfo || {}).HardwareStatus || [];
    for (let i=0; i<list.length; i++)
      if (list[i].HardwareType == hardwareType)
        return list[i];
    return null;
  }
});
