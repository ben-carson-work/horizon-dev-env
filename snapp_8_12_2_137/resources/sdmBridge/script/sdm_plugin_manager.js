import { DrvMQTT, DrvMQTTConnectionOptions} from './sdm_connector.js';
import { EventMessage, EVENT_CODE } from './sdm_model.js';
import { SdmPrinter } from './sdm_printer.js';

  /**
   * 
   * @param {list} pluginList 
   * @param {EVENT_CODE} sdmUrl 
   * @param {string} workstationId
   * @param {any} listener  
   */
export function PluginManager(pluginList, sdmUrl, workstationId, listener) {
  
	const  sdmDriver = new DrvMQTT();
  const  plugins = new Map(); //PluginId, Plugin map  
	const  sdmCfg = _mapDOPluginIntoDODeviceSdm(pluginList);
    
  const data = {
		sdmUrl : sdmUrl,
    workstationId : workstationId,
		listener : listener,
		getPlugin: _getPlugin,
		initWorkstationPlugins: _initWorkstationPlugins,
		unloadWorkstationPlugins: _unloadWorkstationPlugins
  }

  function _mapDOPluginIntoDODeviceSdm(pluginList) {
		let sdmCfg = [];
		
		for (let plugin of pluginList) {
			let	pluginSettings = plugin.PluginSettings;
			let driverSettings = plugin.DriverSettings;
			let mergedSettings = '';
		
			if (pluginSettings) 
				mergedSettings += pluginSettings;
			
			if (driverSettings) {
				if (mergedSettings) {
					let index = mergedSettings.lastIndexOf('}');
					mergedSettings.delete(index, index);
					mergedSettings.append(driverSettings.trim().substring(1));
				} else {
					mergedSettings.append(driverSettings);
				}
			}
				
			sdmCfg.push({
				DeviceAlias: plugin.DeviceAlias,
				DriverClassAlias: plugin.DriverClassAlias,
				DriverId: plugin.DriverId,
				DriverName: plugin.DriverName,
				DeviceEnabled: plugin.PluginEnabled,
				DeviceId: plugin.PluginId,
				DeviceName: plugin.PluginName,
				DriverType: plugin.DriverType,
				DeviceSettings: mergedSettings
			});
			return sdmCfg;
		}
  }

  /**
   * Use this mehod to initialize SDM using workstation id
   */
  function _initWorkstationPlugins() {
    sdmCfg.forEach((item) => {
      switch (item.DriverType) {
        case 1: //Printer type
          let printer = new SdmPrinter(item.DeviceId, data.sdmUrl, _deviceMessageListener);
          plugins.set(item.DeviceId, { plugin: printer, active : false } );
          printer.connect();
          break;
        default:
          break;
      }
    });
    _sendConfgurationToSdm({ "DeviceList": sdmCfg });
  }
  
  /**
   * Handle message from plugin.
   * @param {EventMessage} message 
   */
  function _deviceMessageListener(message) {
    let plugin = plugins.get(message.pluginId);
    switch (message.eventCode) {
      case EVENT_CODE.CONNECTION_LOST:
      case EVENT_CODE.CONNECTION_TIMEOUT:
      case EVENT_CODE.GENERIC_ERROR:
        _checkPluginsStatusAndSendMessage();
        break;
      case EVENT_CODE.READY:
         plugin.active = true;
         _checkPluginsStatusAndSendMessage();
         break;
      case EVENT_CODE.GENERIC_ERROR:
        plugin.active = false;
        _checkPluginsStatusAndSendMessage();
        break; 
      case EVENT_CODE.COMMAND_ERROR:
      case EVENT_CODE.COMMAND_OK:
        data.listener(message);
        break;          
      default:
        break;
      }      
  }
    
  function _checkPluginsStatusAndSendMessage() {
    let allPluginActive = true;
    for (let plg of plugins.values()) {
      if (!plg.Active) {
        allPluginActive = false;
        break;        
      }
    }
    data.listener(new EventMessage(null, allPluginActive ? EVENT_CODE.READY : EVENT_CODE.GENERIC_ERROR));
  }
  
  function _unloadWorkstationPlugins() {
    for (let plg of plugins.values()) {
      plg.plugin.disconnect();
    }
    sdmDriver.disconnect();
  }
  
 /*
  * @param {string} plugiId 
  */
  function _getPlugin(pluginId) {
    return plugins.get(pluginId).plugin;
  }

  /**
   * Send configuration to SDM
   */
  function _sendConfgurationToSdm() {
    let cfgSendTopic = "SDM/manager/config";
    let cfgResponseTopic = "CLI/manager/config";
    let cfgListeningTopic = "CLI/manager/#";

    sdmDriver.subscribe(cfgListeningTopic);
    sdmDriver.registerListener(drvMessage => {	
      console.log(JSON.stringify(drvMessage));
      _handleMessage(drvMessage);
    });

    let clientId = data.workstationId + "_" + new Date().getTime();
    let connectionOptions = new DrvMQTTConnectionOptions(clientId, 4000);
    sdmDriver.connect(data.sdmUrl, connectionOptions);
    
    function _handleMessage(message) {
      if (message.source) {
        let response = message.payload;
        let json_resp = response.body;
        if (response.topic == cfgResponseTopic) {
          if (json_resp && json_resp.ResponseCode != 0) {
            let errorMessageStr = "SDM sent error code: " + json_resp.ResponseCode + " while initilization. Error: " + json_resp.Message;
            console.log(errorMessageStr);
            data.listener(new EventMessage(null, EVENT_CODE.GENERIC_ERROR, errorMessageStr));
          } 
        } else if (response.topic == "CLI/manager") {
           if (json_resp.ResponseCode == 0) {
            let cfgJsonStr = JSON.stringify({ DeviceList: sdmCfg});
            sdmDriver.sendMessageWithAnswer(cfgSendTopic, cfgJsonStr, cfgResponseTopic, 4000, false);
          }
        }
      } else {
          data.listener(message);        
      }
    }    
  }

	return data;
}