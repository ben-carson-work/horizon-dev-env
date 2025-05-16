export const EVENT_CODE = { NONE: "NONE",
                            READY: "READY",
                            INCOMING_MESSAGE: "INCOMING_MESSAGE",
                            CONNECTION_OK: "CONNECTION_OK",
                            CONNECTION_TIMEOUT: "CONNECTION_TIMEOUT",
                            CONNECTION_LOST: "CONNECTION_LOST",
                            GENERIC_ERROR: "GENERIC_ERROR",
                            COMMAND_OK: "COMMAND_OK",
                            COMMAND_ERROR: "COMMAND_ERROR"}

export function EventMessage(source, eventCode, message, pluginId) {
  /**
   * 
   * @param {string} source 
   * @param {EVENT_CODE} event 
   * @param {any} message
   * @param {string} pluginId  
   */
  const data = {
    source : source,
    pluginId : pluginId,
    eventCode : eventCode,
    payload : message
  }
	return data;
}