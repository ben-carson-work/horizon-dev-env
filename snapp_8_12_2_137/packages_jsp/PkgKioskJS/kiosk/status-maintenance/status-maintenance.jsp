<div id="status-maintenance" class="position-absolute-full vert-flex">

  <jsp:include page="../common/kiosk-header.jsp"></jsp:include>
  
  <div id="maintenace-body" class="kiosk-center-pane">
	  <div class="maintenance-toolbar">
	    <button id="maintenance-force-btn" class="btn btn-lg btn-primary" type="button">
	    	<span class="btn-icon"><i class="fa fa-person-digging"></i></span>
	    	<span class="btn-caption">Force maintenance</span>
	    </button>
	    <button id="maintenance-reload-btn" class="btn btn-lg btn-primary" type="button">
	    	<span class="btn-icon"><i class="fa fa-rotate-right"></i></span>
	    	<span class="btn-caption">Reload</span>
	    </button>
	    <button id="maintenance-exit-btn" class="btn btn-lg btn-primary" type="button">
	    	<span class="btn-icon"><i class="fa fa-xmark"></i></span>
	    	<span class="btn-caption">Exit</span>
	    </button>
	  </div>
    <div id="device-manager-container">
      <div class="device-manager-title">Device manager</div>
      <div class="device-manager-details">
	      <div class="device-manager-name"></div>
	      <div class="device-manager-status"></div>
      </div>
    </div>
    <div id="maintenance-devices"></div>
	 	<pre id="log" class="log-panel"></pre>
  </div>  
  
  
  <div id="maintenance-device-templates" class="hidden">
    <jsp:include page="maintenance-device.jsp"></jsp:include>
  </div>
</div>
