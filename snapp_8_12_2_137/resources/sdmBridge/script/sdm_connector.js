import { EVENT_CODE, EventMessage } from './sdm_model.js';

export const QOS = { "QOS_0": 0, "QOS_1": 1, "QOS_2": 2 };

export function DrvMQTT() {
	
	let	topics = new Set();
	let	commandPromiseMap = new Map();
	let	mqttClient = null;
	let listener = null;
	
	const data = {
    registerListener: _registerListener,
		connect: _connect,
		disconnect : _disconnect,
		subscribe: _subscribe,
		sendMessage :_sendMessage,
		sendMessageWithAnswer: _sendMessageWithAnswer
  };

  function _registerListener(callback) {
    listener = callback;
  }

  /**
   * 
   * @param {string} url 
   * @param {DrvMQTTConnectionOptions} conn_options 
   */
  function _connect(url, conn_options) {
    if (mqttClient)
      mqttClient.end();
    data.conn_options = conn_options;
    mqttClient = mqtt.connect(url, conn_options);
    mqttClient.on('message', (topic, message, packet) => { _onMessage(topic, message, packet) });
    mqttClient.on('connect', () => { _onConnect() });
    mqttClient.on('close', () => _onDisconnect());
  }

  /**
   * 
   * @param {string} topic 
   */
  function _subscribe(topic) {
    topics.add(topic);
    try {
      mqttClient.subscribe(topic);
    } catch (err) {
      __onError(err);
    }
  }

  /**
   * 
   * @param {string} sendingTopic 
   * @param {[]} message 
   * @param {string} responseTopic 
   * @param {boolean} retained 
   */
   function _sendMessage(sendingTopic, message, responseTopic, retained) {
    _publish(sendingTopic, message, responseTopic, null, retained);
  }

  /**
   * 
   * @param {string} sendingTopic 
   * @param {[]} message 
   * @param {string} responseTopic 
   * @param {boolean} retained 
   * https://advancedweb.hu/how-to-add-timeout-to-a-promise-in-javascript/
   */
  function _sendMessageWithAnswer(sendingTopic, message, responseTopic, timeout, retained) {

    let jobId = createUUID();
    let correlationData = { "JobId": jobId };

    try {
        new Promise((_r, rej) => {
	        console.log("Response topic:"+responseTopic+" JobId:"+jobId);
	        _publish(sendingTopic, message, responseTopic, JSON.stringify(correlationData), retained);
	        commandPromiseMap.set(jobId, setTimeout(rej, timeout));
	      }).then();
    } catch (Error) {
      console.log("Command timeout");
      commandPromiseMap.delete(jobId);
    }
    return jobId;
  }

  /**
   * Disconnect from Broker
   */
  function _disconnect() {
    if (mqttClient)
      mqttClient.end();
    topics.clear();
    console.log("Client: " + data.conn_options.clientId + " disconnected");
  }

  /**
   * 
   * @param {string} topic 
   * @param {[]} message 
   * @param {string} response_topic 
   * @param {string} correlation_data 
   * @param {boolean} retained 
   */
  function _publish(topic, message, response_topic, correlation_data, retained) {
    let options = {
      qos: 0,
      retain: retained
    }

    if (response_topic || correlation_data) {
      let properties = {};
      if (response_topic)
        properties.responseTopic = response_topic;

      if (correlation_data)
        properties.correlationData = correlation_data;

      options.properties = properties;
    }
    mqttClient.publish(topic, message, options)
  }

  function _unSubscribe(topic) {
    if (topics.has(topic))
  		topics.remove(topic);
  }

  function _handleError(err) {
    if (!err) {
      throw Error;
    }
  }

  function _onConnect() {
    let drv_message = new EventMessage(null, EVENT_CODE.CONNECTION_OK);
    if (listener)
      listener(drv_message);

    topics.forEach(topic => mqttClient.subscribe(topic));
  }
  
  function _onDisconnect() {
    let drv_message = new EventMessage(null, EVENT_CODE.CONNECTION_LOST);
    if (listener)
      listener(drv_message);
  
    topics.forEach(topic => mqttClient.subscribe(topic));
  }

  /**
   * @param {string} topic
   * @param {string} message
   * @param {{ properties: { correlationData: any; }; }} packet
   */
  function _onMessage(topic, message, packet) {
		let parserd_message = JSON.parse(message);
    let decorated_message = new DrvMQTTMessage(topic, null, parserd_message, null);
    let drv_message = new EventMessage(topic, EVENT_CODE.INCOMING_MESSAGE, decorated_message)


    let correlation_data = null;

    if (packet && packet.properties && packet.properties.correlationData)
      correlation_data = packet.properties.correlationData;

    let jobId = null;
    if (correlation_data)
      jobId = JSON.parse(correlation_data).JobId;

    if (jobId) {
      decorated_message.jobId = jobId;
      let timer = commandPromiseMap.get(jobId);
      if (timer) {
        clearTimeout(timer);
        commandPromiseMap.delete(jobId);        
      } else {
        console.log("Warning: command response has JobId but is not present in map. Maybe this command was timed out")
      }

    }

    if (listener)
    	listener(drv_message);
  }

  function __onError(error) {

  }

  return data;
}

export function DrvMQTTMessage(topic, response_topic, body, jobId) {
  /**
   * 
   * @param {string} topic 
   * @param {string} body 
   * @param {string} jobId 
   */
  const data = {
    topic : topic,
    response_topic : response_topic,
    body : body,
    jobId : jobId
  }
	return data;
}


export function DrvMQTTConnectionOptions(clientId = 'test_js', connectTimeout = 3000) {
  const data = {
    protocolVersion : 5,
    clientId : clientId,
    connectTimeout : connectTimeout
  }
	return data;
}

function createUUID() {
  let dt = new Date().getTime();
  let uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    let r = (dt + Math.random() * 16) % 16 | 0;
    dt = Math.floor(dt / 16);
    return (c == 'x' ? r : (r & 0x3 | 0x8)).toString(16);
  });
  return uuid;
}


function include(file) {
  let script  = document.createElement('script');
  script.src  = file;
  script.type = 'text/javascript';
  script.defer = true; 
  document.getElementsByTagName('head').item(0).appendChild(script);
}

include('./libraries/mqtt/mqtt.min.js');


