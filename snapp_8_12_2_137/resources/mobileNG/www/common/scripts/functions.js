var COMMON_METHODS = {};

// NativeBridge must not be wrapped cause the native will call again this function:
var NativeBridge = {
	callbacksCount : 1,
	callbacks : {},

	// Automatically called by native layer when a result is available
	resultForCallback : function resultForCallback(callbackId, resultArray) {
	    var self = this;

		try {
			var callback = self.callbacks[callbackId];
			if (!callback) return;

			callback.apply(null, resultArray);
		} catch (e) {
			alert(e);
		}
	},

	// Use this in javascript to request native objective-c code
	// functionName : string (I think the name is explicit :p)
	// args : array of arguments
	// callback : function with n-arguments that is going to be called when the native code returned
	call : function call(functionName, args, callback) {
        var self = this;
        var hasCallback = callback && typeof callback == "function";
        var callbackId = hasCallback ? self.callbacksCount++ : 0;
        //alert('native bridge call');

        if (hasCallback)
          self.callbacks[callbackId] = callback;

        var iframe = document.createElement("IFRAME");
        iframe.setAttribute("src", "js-frame:" + functionName + ":" + callbackId
          + ":" + encodeURIComponent(JSON.stringify(args)));
        document.documentElement.appendChild(iframe);
        iframe.parentNode.removeChild(iframe);
        iframe = null;
	}
};

COMMON_METHODS.sendCommand = function(cmd) {
	NativeBridge.call(cmd, [], null);
};

COMMON_METHODS.activatePlugins = function(pluginList) {
  NativeBridge.call("SetPlugins", [ pluginList ], null);
};

COMMON_METHODS.keyboard = function(key) {
    var obj = {
      KEY_BACKSPACE: 8,
      KEY_TAB: 9,
      KEY_ENTER: 13,
      KEY_SHIFT: 16,
      KEY_CTRL: 17,
      KEY_CAPSLOCK: 20,
      KEY_ESC: 27,
      KEY_LEFT: 37,
      KEY_UP: 38,
      KEY_RIGHT: 39,
      KEY_DOWN: 40,
      KEY_DELETE: 46,
      KEY_0: 48,
      KEY_1: 49,
      KEY_2: 50,
      KEY_3: 51,
      KEY_4: 52,
      KEY_5: 53,
      KEY_6: 54,
      KEY_7: 55,
      KEY_8: 56,
      KEY_9: 57,
      KEY_NUM_0: 96,
      KEY_NUM_1: 97,
      KEY_NUM_2: 98,
      KEY_NUM_3: 99,
      KEY_NUM_4: 100,
      KEY_NUM_5: 101,
      KEY_NUM_6: 102,
      KEY_NUM_7: 103,
      KEY_NUM_8: 104,
      KEY_NUM_9: 105
    };

    return obj[key];
};

COMMON_METHODS.leadZero = function(value, digits) {
  var val = "" + value; // Convert to string
  while (val.length < digits)
    val = "0" + val;
  return val;
};

COMMON_METHODS.dateToXML = function(date) {
  return date.getFullYear() + "-" + COMMON_METHODS.leadZero(date.getMonth() + 1, 2) + "-" + COMMON_METHODS.leadZero(date.getDate(), 2) + "T" + COMMON_METHODS.leadZero(date.getHours(), 2) + ":" + COMMON_METHODS.leadZero(date.getMinutes(), 2) + ":" + COMMON_METHODS.leadZero(date.getSeconds(), 2) + "." + COMMON_METHODS.leadZero(date.getMilliseconds(), 3);
};

COMMON_METHODS.xmlToDate = function(s) {
  if ((s) && (s.length >= 10)) {
    var year = parseInt(s.substring(0,4));
    var month = parseInt(s.substring(5,7)) - 1;
    var day = parseInt(s.substring(8,10));
    var hh = 0;
    var mm = 0;
    var ss = 0;
    var ms = 0;
    if (s.length >= 16) {
      hh = parseInt(s.substring(11,13));
      mm = parseInt(s.substring(14,16));
    }
    if (s.length >= 19) 
      ss = parseInt(s.substring(17,19));
    if (s.length >= 23) 
      ms = parseInt(s.substring(20,23));
    return new Date(year, month, day, hh, mm, ss, ms);
  } else {
    return new Date();
  }
};

COMMON_METHODS.fmtDateMonths = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
COMMON_METHODS.fmtDateWeekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

COMMON_METHODS.formatDate = function(date, snpFormat) {
  if (date == null) {
    return null;
  } else {
    switch (parseInt(snpFormat)) {
      case 101: return COMMON_METHODS.leadZero(date.getDate(), 2) + "/" + COMMON_METHODS.leadZero(date.getMonth() + 1, 2) + "/" + date.getFullYear();
      case 102: return COMMON_METHODS.leadZero(date.getDate(), 2) + "/" + COMMON_METHODS.leadZero(date.getMonth() + 1, 2) + "/" + (""+date.getFullYear()).substring(2,4);
      case 103: return COMMON_METHODS.leadZero(date.getMonth() + 1, 2) + "/" + COMMON_METHODS.leadZero(date.getDate(), 2) + "/" + date.getFullYear();
      case 104: return COMMON_METHODS.leadZero(date.getMonth() + 1, 2) + "/" + COMMON_METHODS.leadZero(date.getDate(), 2) + "/" + (""+date.getFullYear()).substring(2,4);
      case 201: return COMMON_METHODS.fmtDateWeekDays[date.getDay()] + " " + date.getDate() + " " + COMMON_METHODS.fmtDateMonths[date.getMonth()] + " " + date.getFullYear();
      case 202: return date.getDate() + " " + COMMON_METHODS.fmtDateMonths[date.getMonth()] + " " + date.getFullYear();
      case 203: return COMMON_METHODS.fmtDateMonths[date.getMonth()] + " " + date.getDate() + ", " + date.getFullYear();
      case 204: return COMMON_METHODS.fmtDateWeekDays[date.getDay()] + ", " + COMMON_METHODS.fmtDateMonths[date.getMonth()] + " " + date.getDate() + ", " + date.getFullYear();
    }
  }
}

COMMON_METHODS.formatTime = function(date, snpFormat) {
  if (date == null) {
    return null;
  } else {
    var h12 = date.getHours();
    var ampm = ((h12 >= 0) && (h12 < 12)) ? "am" : "pm";
    if (h12 == 0)
      h12 = 12;
    else if (h12 > 12)
      h12-= 12;
    
    switch (parseInt(snpFormat)) {
      case 101: return COMMON_METHODS.leadZero(date.getHours(), 2) + ":" + COMMON_METHODS.leadZero(date.getMinutes(), 2);
      case 102: return h12 + ":" + COMMON_METHODS.leadZero(date.getMinutes(), 2) + " " + ampm;
      case 201: return COMMON_METHODS.leadZero(date.getHours(), 2) + ":" + COMMON_METHODS.leadZero(date.getMinutes(), 2) + ":" + COMMON_METHODS.leadZero(date.getSeconds(), 2);
      case 202: return h12 + ":" + COMMON_METHODS.leadZero(date.getMinutes(), 2) + ":" + COMMON_METHODS.leadZero(date.getSeconds(), 2) + " " + ampm;
    }
  }
}

COMMON_METHODS.formatShortDateTimeFromXML = function(xmlDateTime) {
  var dt = COMMON_METHODS.xmlToDate(xmlDateTime);
  return COMMON_METHODS.formatDate(dt, COMMON_JS.dateFormat) + " " + COMMON_METHODS.formatTime(dt, COMMON_JS.timeFormat);
};
