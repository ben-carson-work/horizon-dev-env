import { DrvMQTT, DrvMQTTConnectionOptions } from './sdm_connector.js';
import { EventMessage, EVENT_CODE } from './sdm_model.js';

export function SdmPrinter(pluginId, sdmUrl, listener) {
  const STATUS_COMMAND = "status";
  const PRINT_COMMAND = "process_doc";
  const sdmDriver = new DrvMQTT();
  const listening_topic = "CLI/printer/" + pluginId + "/#";
  const sending_topic = "SDM/printer/" + pluginId + "/process_doc";
  const response_topic = "CLI/printer/" + pluginId + "/process_doc";
  
  const data = {
		pluginId : pluginId,
		sdmUrl : sdmUrl,
		listener : listener,
		connect: _connect,
		disconnect: _disconnect,
		processDoc: _processDoc
  }
  
  function _connect() {
    console.log(listening_topic);
    let connectionOptions = new DrvMQTTConnectionOptions("cli_"+data.pluginId, 100000);
    
    sdmDriver.registerListener((message) => {
      _handleMessage(message);
    })   
    sdmDriver.connect(data.sdmUrl, connectionOptions);
  }  
  
  function _handleMessage(message) {
		data.listener(message);
	  switch (message.eventCode) {

	    case EVENT_CODE.CONNECTION_LOST:
	    case EVENT_CODE.CONNECTION_TIMEOUT:
	      console.log("Disconnected from SDM");
        data.listener(new EventMessage(null, EVENT_CODE.CONNECTION_LOST, "Printer:"+ data.pluginId + " " + message.Description));
	      break;
	    case EVENT_CODE.CONNECTION_OK:
	      sdmDriver.subscribe(listening_topic);
	      console.log("Wating for SDM init message");
        break;
      case EVENT_CODE.INCOMING_MESSAGE:
        _handleDeviceMessage(message);
        break;              
	    default:
	      break;
	  }
  }
  
  function _handleDeviceMessage(message) {
      let topic = message.source;
      let resp = message.payload;
      let job_id = resp.jobId;
      
      if(topic.endsWith(STATUS_COMMAND)) {
        let status = resp.body;
        switch (status.Code) {
          case 2:
          case 4:
            console.log("Printer:"+ data.pluginId + " " + status.Description);
            data.listener(new EventMessage(topic, EVENT_CODE.READY, "Printer:"+ data.pluginId + " " + status.Description, data.pluginId));
            break;
          case 5:
            console.log("Printer: "+ data.pluginId + " loading ERROR");
            data.listener(new EventMessage(topic, EVENT_CODE.GENERIC_ERROR, "Printer:"+ data.pluginId + " " + status.Description, data.pluginId));
            break;            
          default:
            break;
        } 
      } else if(topic.endsWith(PRINT_COMMAND)) {
        let docPrintResponse = resp.body;
        docPrintResponse.JobId = job_id; //Add jobId to response
        
        if (0 != docPrintResponse.ResultCode) {
          let errorMessage = "Document with jobId:" + job_id + " print error.";
          console.log(errorMessage);
          data.listener(new EventMessage(topic, EVENT_CODE.COMMAND_ERROR, docPrintResponse, data.pluginId));
        } else {
          data.listener(new EventMessage(topic, EVENT_CODE.COMMAND_OK, docPrintResponse, data.pluginId));
          console.log("Document with jobId:" + job_id + " printed sucessfully!!!");
        }
      }
      data.listener(message);
  }  

  function _processDoc(document) {
    let docToPrintJson = JSON.stringify({"Doc": document});
    return sdmDriver.sendMessageWithAnswer(sending_topic, docToPrintJson, response_topic, 400000, false);
    
  }

  function _disconnect() {
    if (sdmDriver)
      sdmDriver.disconnect();
  }

	return data;
}