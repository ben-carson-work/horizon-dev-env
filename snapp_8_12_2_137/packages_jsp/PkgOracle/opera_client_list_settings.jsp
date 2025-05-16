<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

	<v:grid id="client-config-grid">
	  <thead>
	    <v:grid-title caption="Clients"/>
	    <tr>
	      <td><v:grid-checkbox header="true"/></td>
	      <td width="20%">Description</td>
	      <td width="40%">API Key</td>
	      <td width="40%">ClientId</td>
	    </tr>
	  </thead>
	
		<tbody id="client-list"></tbody>
	  
		<tbody id="client-buttons">
		  <tr>
		    <td colspan="100%">
		      <v:button id="btn-add" fa="plus" caption="@Common.Add"/>
		      <v:button id="btn-remove" fa="minus" caption="@Common.Remove"/>
		    </td>
		  </tr>
		</tbody>
	</v:grid>
	
	<div id="client-templates" class="hidden">
			<v:widget caption="Prio configurations">
				<v:widget-block>
					<v:grid id="client-config-slot-grid">
						<thead>
							<tr class="client-row-template">
								<td><v:grid-checkbox/></td>
								<td><v:input-text clazz="txt-clientDescription" placeholder="Client description"/></td>
								<td>
									<div class="input-group">
										<v:input-text clazz="txt-clientSecret" placeholder="API key Token"/>
										<span class="input-group-btn">
											<v:button clazz="btn-apikey-regenerate" fa="redo" title="Generate a new random API key"/>
											<v:button clazz="btn-apikey-copy" fa="copy" title="Copy API key to clipboard"/>
										</span>
									</div>
								</td>
								<td>
									<div class="input-group">
										<v:input-text clazz="txt-clientId" placeholder="clientId"/>
										<span class="input-group-btn">
											<v:button clazz="btn-wksid-regenerate" fa="redo" title="Generate a new clientId"/>
											<v:button clazz="btn-wksid-copy" fa="copy" title="Copy clientId to clipboard"/>
										</span>
									</div>
								</td>
							</tr>
						</thead>
					</v:grid>
				</v:widget-block>
			</v:widget>
		</div>
<script>
//$(document).ready(function() {
  $("#client-buttons #btn-add").click(doAdd);
  $("#client-buttons #btn-remove").click(doRemove);
//});

  function doInitializeClientGrid(params) {
	  if (params.settings.ClientList) {
	    for (var i=0; i<params.settings.ClientList.length; i++)
	      doAdd(params.settings.ClientList[i]);
	  }
	}

	function doAdd(item) {
	  var $tr = $("#client-templates .client-row-template").clone().appendTo("#client-list");
	
	  item = (item) ? item : {};
	  
	  $tr.attr("data-rowid", newStrUUID());
	  $tr.find(".txt-clientId").val(item.ClientId);
	  $tr.find(".txt-clientDescription").val(item.Description);
	  $tr.find(".txt-clientSecret").val(item.ClientSecret);
	  $tr.data("item", item);
	  
	  $tr.find(".btn-apikey-regenerate").click(generateAPIKey);
	  $tr.find(".btn-apikey-copy").click(copyAPIKey);
	  $tr.find(".btn-wksid-regenerate").click(setNewWksId);
	  $tr.find(".btn-wksid-copy").click(copyWksId);
	}
	
	function doRemove() {
	  $("#client-list .cblist:checked").closest("tr").remove();
	}
	
	function generateAPIKey() {
	  function _s4() {
	    return Math.floor((1 + Math.random()) * 0x10000)
	      .toString(16)
	      .substring(1);
	    }
	  
	  var $txt = $(this).closest(".input-group").find(".txt-clientSecret");
	  var newval = "";
	  for (var i=0; i<10; i++)
	    newval += _s4();
	  $txt.val(newval);
	}
	
	function copyAPIKey() {
	  var apiKey = $(this).closest(".input-group").find(".txt-clientSecret")[0];
	  apiKey.select();
	  apiKey.setSelectionRange(0, 99999);
	  document.execCommand("copy");
	  $(apiKey).blur();
	  showMessage("API Key copied to clipboard");
	}
	
	function setNewWksId(){
	  var $txt = $(this).closest(".input-group").find(".txt-clientId");
	  $txt.val(newStrUUID());
	}
	
	function copyWksId() {
	  var wksId = $(this).closest(".input-group").find(".txt-clientId")[0];
	  wksId.select();
	  wksId.setSelectionRange(0, 99999);
	  document.execCommand("copy");
	  $(wksId).blur();
	  showMessage("clientId copied to clipboard");
	}
	function getClientListSettings() {
	  var result = []
		// Fill ClientList
		$("#client-list tr").each(function(idx, elem) {
		  var $tr = $(elem);
		  result.push({
		    Description: $tr.find(".txt-clientDescription").val(),
		    ClientSecret:   $tr.find(".txt-clientSecret").val(),
		    ClientId: $tr.find(".txt-clientId").val()
		  });
		});
	  
	  return result
	}
</script>
