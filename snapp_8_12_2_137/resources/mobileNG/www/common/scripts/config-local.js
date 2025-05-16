var site_url = '/api/';

var COMMON_JS = {
	debug: true,
	local: true,
	appName: 'MOB_NG',
	title: 'SnApp',
	site_url: site_url,
	base_url: '',
	apt: {
		"AptCheckValidPerf":false,
		"OpAreaCode":null,
		"AccessAreaIDs":"51AECCA7-9148-83C5-19D5-014C32EE7315",
		"AptExitControl":1,
		"LocationId":"38D77419-6F81-6FBD-16B0-014C323E0B64",
		"LocationCode":null,
		"ControllerWorkstationCode":"MOB-03",
		"ControllerOpAreaCode":"2S6CA5ZK2X6X20",
		"AptCounterMode":0,
		"LocationName":"Bollywood",
		"ControllerWorkstationName":"Mobile 03",
		"AccessPointName":"Access Bollywood 01",
		"AptEntryControl":1,
		"ControllerWorkstationId":"BF4C1191-3EE3-5D6B-01B2-014B93861A28",
		"ControllerOpAreaName":"Guest Relation",
		"AptReentryControl":0,
		"AccessPointId":"B1B87B22-DD86-CA91-024E-014CBCC367A6",
		"AccessPointCode":"DPR-BW01",
		"OpAreaName":"Asia",
		"OpAreaId":"E0F22D85-4FE6-4FE2-A556-3B78B9452EB0",
		"ControllerOpAreaId":"89B59BC8-5B64-4EB7-BD91-8FAEEC5820EB"
	},
	autoLogin: true,
	vgsSessionToken: "UH0RVJQEQRWSYESGQEQMQPQERGWEQJ0EQEQE",
	workstationId: "BF4C1191-3EE3-5D6B-01B2-014B93861A28",
	langISO: 'en',
	thousandSeparator: ',',
	decimalSeparator: '.',
	dateFormat: 101,
    timeFormat: 101,
	mob_apps_keys: {
      adm: 'AppMOB_Admission',
      operator: 'AppMOB_SalesOperator',
      guest: 'AppMOB_SalesGuest',
      payment: 'AppMOB_Payment'
    },
	accessPointControl: {
    	controlled: 1,
		closed: 0,
		free: 2
    },
	accessPointOperator: {
		none: 0,
		ticket: 1
	},
	usageTypeCodes: {
		entry: 1, 
		exit: 2 
	},
	usageTypes: {
		entry: site_url +'imagecache?name=adm_entry_green.png&size=128',
		simulate: site_url +'imagecache?name=adm_entry_green.png&size=128',
		exit: site_url +'imagecache?name=adm_exit_blue.png&size=128',
		lookup: site_url +'imagecache?name=adm_lookup_gray.png&size=128'
	},
	icons: { 
		keyboard: site_url +'imagecache?name=%5Bfont-awesome%5Dkeyboard&size=128',
		keyboard_active: site_url +'imagecache?name=%5Bfont-awesome%5Dkeyboard%7CTransformNegative&size=128',
		barcode: site_url +'imagecache?name=bkoact-barcode.png%7CTransformNegative&size=128',
		attendance: site_url +'imagecache?name=bkoact-attendance.png%7CTransformNegative&size=128',
		info: site_url +'imagecache?name=bkoact-info.png&size=128',
		infoNegative: site_url +'imagecache?name=bkoact-info.png%7CTransformNegative&size=128',
		check: site_url +'imagecache?name=bkoact-check.png&size=128',
		arrow_r: site_url +'imagecache?name=bkoact-forward-grey.png&size=128',
		event: site_url +'imagecache?name=bkoact-event.png&size=128',
		location: site_url +'imagecache?name=bkoact-location-black.png&size=128',
		payment: site_url +'imagecache?name=bkoact-pay.png&size=128',
		performance: site_url +'imagecache?name=bkoact-calendar.png&size=128',
		print: site_url +'imagecache?name=bkoact-print.png&size=128',
		product: site_url +'imagecache?name=bkoact-product.png&size=128',
		status: site_url +'imagecache?name=bkoact-flag.png&size=128',
		// sop
		catalog: site_url +'imagecache?name=mob-menu.png%7CTransformNegative&size=128',
		shopcart: site_url +'imagecache?name=bkoact-basket.png%7CTransformNegative&size=128'
	},
	profilePictureId: 'F624CEBA-A91F-BD0B-061F-014B748AED1E',
	logo: site_url +'repository?type=small&id=F624CEBA-A91F-BD0B-061F-014B748AED1E',
	operatingAreaCode: 14,
	buttonColor: '#fecc00',
	redColor: '#b00000',
	greenColor: '#30b513',
	orangeColor: '#fca100',
	grayColor: '#ccc',
	blueColor: '#156ee6',
    purpleColor: '#cc2ec2',
	mediaNotFound: 102,
	ticketStatusActive: 0,
    ticketStatusGoodLimit: 100,
	mediaLookupCommonStatus: {
      draft: 10,
      active: 20,
      warn: 30,
      deleted: 40,
      completed: 50,
      fatalError: 60
    },
	initScanType: function() {
		var result = '';

		if (COMMON_JS.apt.AptEntryControl === COMMON_JS.accessPointControl.controlled) {
		result = COMMON_JS.setScanType('entry');
		} else if (COMMON_JS.apt.AptExitControl === COMMON_JS.accessPointControl.controlled) {
		result = COMMON_JS.setScanType('exit');
		} else if (COMMON_JS.apt.AptEntryControl === COMMON_JS.accessPointControl.free) {
		result = COMMON_JS.setScanType('simulate');
		} else {
		result = COMMON_JS.setScanType('lookup');
		}

		return result;
  	},
	setScanType: function(scanType) {
		switch (scanType) {
			case 'entry':
				COMMON_JS.apt.AptEntryControl = COMMON_JS.accessPointControl.controlled;
				COMMON_JS.apt.AptExitControl = COMMON_JS.accessPointControl.closed;
				break;
			case 'simulate':
				COMMON_JS.apt.AptEntryControl = COMMON_JS.accessPointControl.free;
				COMMON_JS.apt.AptExitControl = COMMON_JS.accessPointControl.closed;
				break;
			case 'exit':
				COMMON_JS.apt.AptEntryControl = COMMON_JS.accessPointControl.closed;
				COMMON_JS.apt.AptExitControl = COMMON_JS.accessPointControl.controlled;
				break;
			default:
				COMMON_JS.apt.AptEntryControl = COMMON_JS.accessPointControl.closed;
				COMMON_JS.apt.AptExitControl = COMMON_JS.accessPointControl.closed;
				break;
		}

		return scanType;
	}
};

COMMON_JS.mob_apps = [
      {
        key: COMMON_JS.mob_apps_keys.adm,
        icon: site_url +'imagecache?name=mobgly-app-adm.png%7CTransformNegative&size=128'
      },
      {
        key: COMMON_JS.mob_apps_keys.operator,
        icon: site_url +'imagecache?name=mobgly-app-gst.png%7CTransformNegative&size=128'
      },
      {
        key: COMMON_JS.mob_apps_keys.guest,
        icon: site_url +'imagecache?name=mobgly-app-cas.png%7CTransformNegative&size=128'
      },
      {
        key: COMMON_JS.mob_apps_keys.payment,
        icon: site_url +'imagecache?name=mobgly-app-pay.png%7CTransformNegative&size=128'
      }
];
