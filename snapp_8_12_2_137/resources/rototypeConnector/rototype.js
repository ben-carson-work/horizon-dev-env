import { RotoServiceClient } from './services/roto-service-client.js';
import { SrvBarcodeReader }  from './services/roto-srv-barcode-reader.js';
import { SrvNFCReader }  from './services/roto-srv-nfc-reader.js';
import { SrvTicketPrinter }  from './services/roto-srv-ticket-printer.js';
import { SrvReceiptPrinter }  from './services/roto-srv-receipt-printer.js';
import { SrvLights }  from './services/roto-srv-lights.js';
import { SrvAuxiliaries }  from './services/roto-srv-auxiliaries.js';
import { SrvCCPay }  from './services/roto-srv-cc-pay.js';
import { createService } from './services/roto-service-factory.js';

export class Rototype {
  serviceClient;
  services;
	onServicesChanged;

	onBarcodeStatusChanged;
	onNFCStatusChanged;
	onTckStatusChanged;
	onReceiptStatusChanged;
  onLightsStatusChanged;
  onAuxiliariesStatusChanged;
  onCCPayStatusChanged;

	srvBarcodeReader;
	srvNFCReader;
	srvTicketPrinter;
	srvReceiptPrinter;
  srvLights;
  srvAuxiliaries;
  srvCCPay;

	onNewServices;
	
	constructor() {
		this.name = "Rototype client";
		this.serviceClient = new RotoServiceClient();
		this.serviceClient.onSocketOpen = e => this._onSocketOpen(e);
		this.services = [];
    this.onNewServices = serviceURIs => this.refreshServices(serviceURIs);
	}

	connect(serviceURL) {
    this.serviceClient.connect(serviceURL);
  }
  
	close() {
		this.closeCurrentServices();
		this.serviceClient.close();
	}
	
  _onSocketOpen(event) {
    this.getServices();
  }
    
	getServices() {
		console.log('\n[get services]');
/*
    let payload = {
        timeout: 5000
      };
      
    this.serviceClient.executeCommand("ServicePublisher.GetServices", payload)
      .then(e => triggerNewServicesEvent(e))
      .catch(e => console.log(e));
*/
    this.test_getServices();
	}
	
	refreshServices(serviceURIs) {
		console.log("new services detected")
		this.closeCurrentServices();
		
		serviceURIs.forEach((serviceURI) => {
			console.log(serviceURI); 
			let svc = createService(serviceURI);
			this.services.push(svc);

			if (svc instanceof SrvBarcodeReader)
				this.setSrvBarcodeReader(svc);				
			else if (svc instanceof SrvNFCReader)
				this.setSrvNFCReader(svc);				
			else if (svc instanceof SrvTicketPrinter)
				this.setSrvTicketPrinter(svc);				
			else if (svc instanceof SrvReceiptPrinter)
				this.setSrvReceiptPrinter(svc);				
      else if (svc instanceof SrvLights)
        this.setSrvLights(svc);       
      else if (svc instanceof SrvAuxiliaries)
        this.setSrvAuxiliaries(svc);       
      else if (svc instanceof SrvCCPay)
        this.setSrvCCPay(svc);       

			svc.connect();
		});
		
		this.onServicesChanged(this.services);
	}

	setSrvBarcodeReader(svc) {
		this.srvBarcodeReader = svc;
		svc.onStatusChanged = this.onBarcodeStatusChanged;
	}
	
	setSrvNFCReader(svc) {
		this.srvNFCReader = svc;
		svc.onStatusChanged = this.onNFCStatusChanged;
  }

	setSrvTicketPrinter(svc) {
		this.srvTicketPrinter = svc;
		svc.onStatusChanged = this.onTckStatusChanged;
  }

	setSrvReceiptPrinter(svc) {
		this.srvReceiptPrinter = svc;
		svc.onStatusChanged = this.onReceiptStatusChanged;
	}

	setSrvLights(svc) {
		this.srvLights = svc;
		svc.onStatusChanged = this.onLightsStatusChanged;
	}

  setSrvAuxiliaries(svc) {
    this.srvAuxiliaries = svc;
    svc.onStatusChanged = this.onAuxiliariesStatusChanged;
  }

  setSrvCCPay(svc) {
    this.srvCCPay = svc;
    svc.onStatusChanged = this.onCCPayStatusChanged;
  }

	closeCurrentServices() {
		this.services.forEach((service) => {
			service.close();
		});
		this.services = [];
	}
	
	barcodeRead() {
		if (this.srvBarcodeReader) {
      this.lightBarcodeOn();
      this.srvBarcodeReader.read();      
    }
	}

	barcodeReset() {
		if (this.srvBarcodeReader) {
      this.lightBarcodeOff();
      this.srvBarcodeReader.reset();
    }
	}

	barcodeTest() {
		if (this.srvBarcodeReader)
			this.srvBarcodeReader.test();
	}

	nfcReset() {
		if (this.srvNFCReader) {
      this.lightNfcOn();
			this.srvNFCReader.reset();
		}
	}

	nfcRead() {
		if (this.srvNFCReader) {
      this.lightNfcOn();
      this.srvNFCReader.read();
    }
	}

	nfcTest() {
		if (this.srvNFCReader)
			this.srvNFCReader.test();
	}

	tckReset() {
		if (this.srvTicketPrinter) {
      this.lightTicketPrinterOff();
      this.srvTicketPrinter.reset();
    }
	}

	tckPrintRaw(data, readRFID) {
		if (this.srvTicketPrinter) {
      this.lightTicketPrinterOn();
      this.srvTicketPrinter.printRaw(data, readRFID);
    }
	}

	tckTest(str) {
		if (this.srvTicketPrinter)
			this.srvTicketPrinter.test(str);
	}

	receiptReset() {
		if (this.srvReceiptPrinter) {
      this.lightReceiptPrinterOff();
      this.srvReceiptPrinter.reset();      
    }
	}

	receiptPrintForm(data) {
		if (this.srvReceiptPrinter) {
      this.lightReceiptPrinterOn();
      this.srvReceiptPrinter.printForm(data);
    }
	}

	receiptLoadDefinition(definition) {
		if (this.srvReceiptPrinter)
			this.srvReceiptPrinter.loadDefinition(definition);
	}

  lightOn(lightName, flashRate, color) {
    return new Promise((resolve, reject) => {
      if (!this.srvLights)
        reject("Service srvLights not available")
      else
        this.srvLights.lightOn(lightName, flashRate, color)
          .then(resolve)
          .catch(reject);
    });   
  }
  
  lightOff(lightName) {
    return new Promise((resolve, reject) => {
      if (!this.srvLights)
        reject("Service srvLights not available")
      else
        this.srvLights.lightOff(lightName)
          .then(resolve)
          .catch(reject);
    });   
  }
  
	/**
	 * @param {string} serviceName
	 */
	getServiceByName(serviceName) {
		let result = this.findServiceByName(serviceName);
		if (!result)
			throw new Error("Service not found: " + serviceName);
		
		return result;
	}

	findServiceByName(serviceName) {
		return this.services.find(s => s.serviceName === serviceName); 
	}

	triggerNewServicesEvent(payload) {
		let serviceURIs = [];
		payload.services.forEach((service) => {
			serviceURIs.push(service.serviceURI); 
		});

		if (this.onNewServices)
			this.onNewServices(serviceURIs);
	}

	test_getServices() {
		let payload = {
  			completionCode: "success", 
  			vendorName: "KAL", 
  			services: [ 
  				{serviceURI: "ws://rototypedyn.dyndns.org:5846/xfs4iot/v1.0/BarcodeReader/"}, 
  				{serviceURI: "ws://rototypedyn.dyndns.org:5846/xfs4iot/v1.0/Lights/"}, 
  				{serviceURI: "ws://rototypedyn.dyndns.org:5846/xfs4iot/v1.0/Auxiliaries/"}, 
  				{serviceURI: "ws://rototypedyn.dyndns.org:5846/xfs4iot/v1.0/TicketPrinter/"}, 
  				{serviceURI: "ws://rototypedyn.dyndns.org:5846/xfs4iot/v1.0/ReceiptPrinter/"}, 
  				{serviceURI: "ws://rototypedyn.dyndns.org:5846/xfs4iot/v1.0/CCPay/"},
  				{serviceURI: "ws://rototypedyn.dyndns.org:5846/xfs4iot/v1.0/NfcReader/"}
  			],
  			errorDescription: "ok"
			};
		
		this.triggerNewServicesEvent(payload)
	}
/*	
	createMessage(owner, name, payload) {		
		let message;

		if (name === "ServicePublisher.GetServices")
			message = new SocketMessage(payload, (s) => owner.triggerNewServicesEvent(s));
		else
			throw new Error("Unknown message type: " + name);
		
		return message;
	}
*/
}

