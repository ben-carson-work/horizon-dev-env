<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<script type="text/javascript">

$(document).ready(function() {
  console.log("Google doc ready");
  const pluginClassAlias = "eticket-google";
  const GOOGLE_DOC_HINT = "Please reterence to [Google documentation](https://developers.google.com/pay/passes/guides/pass-verticals/pass-template?vertical=event-tickets)";
  const GRID_ID_MESSAGES = "messages-fields";
  const GRID_ID_TEXT = "text-fields";
  const GRID_ID_LINKS = "links-fields";
  const GRID_ID_IMAGES = "links-images";
  
  $(".form-field-hint").attr("title", GOOGLE_DOC_HINT);
      
  $(document).off("doctemplate-eticket-load");
  $(document).on("doctemplate-eticket-load", function(event, params) {
    console.log("Google doctemplate-eticket-load event");
    var list = (params || {}).PluginList || [];
    var googleCfg = {};
    for (var i=0; i<list.length; i++) {
      var plugin = list[i];
      if (plugin.PluginClassAlias == pluginClassAlias) {
        googleCfg = JSON.parse(plugin.DocData);
        break;
      }
    }
    _fillFields(googleCfg);
  });
  
  $(document).off("doctemplate-eticket-save");
  $(document).on("doctemplate-eticket-save", function(event, params) {
    console.log("Google Before:"+JSON.stringify(params));
    _removeOldConfiguration(params.PluginList);
    console.log("Google After clean:"+JSON.stringify(params));
    var docData = _doSaveETicketTemplateGoogle();
    params.PluginList.push({"PluginClassAlias":pluginClassAlias, "DocData": JSON.stringify(docData)})
    console.log("Google After fill:"+JSON.stringify(params));
  });
  
  function _removeOldConfiguration(cfg) {
    var index = cfg.findIndex(function(o){
      return o.PluginClassAlias === pluginClassAlias;
    })
    if (index !== -1)
      cfg.splice(index, 1);
  }  
  
  function _fillFields(googleCfg) {
    console.log("google _fillFields");
    _createGenericItemGrid(GRID_ID_MESSAGES, "#google-templates .grid-generic-item", "#google-templates .tr-generic-item", "Messages", googleCfg.Messages, -1);
    _createGenericItemGrid(GRID_ID_TEXT, "#google-templates .grid-generic-item", "#google-templates .tr-generic-item", "Text Modules Data", googleCfg.TextModulesData, 10);
    _createGenericItemGrid(GRID_ID_LINKS, "#google-templates .grid-link-item", "#google-templates .tr-link-item", "Links Modules Data", googleCfg.LinksModulesData, -1);
    _createGenericItemGrid(GRID_ID_IMAGES, "#google-templates .grid-image-item", "#google-templates .tr-image-item", "Image Modules Data", googleCfg.ImageModulesData, 1);  
    
    $("#google-logoImage").val((googleCfg.Logo || {}).Value);
    $("#google-logoTxt").val((googleCfg.LogoTxt || {}).Value);
    $("#google-issuerName").val((googleCfg.IssuerName || {}).Value);
    $("#google-eventName").val((googleCfg.EventName || {}).Value);
    $("#google-gate").val((googleCfg.Gate || {}).Value);
    $("#google-section").val((googleCfg.Section || {}).Value);
    $("#google-row").val((googleCfg.Row || {}).Value);
    $("#google-seat").val((googleCfg.Seat || {}).Value);
    $("#google-heroImage").val((googleCfg.HeroImage || {}).Value);
    $("#google-backgroundColor").val((googleCfg.HexBackgroundColor || {}).Value);
    $("#google-ticketHolder").val((googleCfg.TicketHolderName || {}).Value);
    $("#google-ticketType").val((googleCfg.TicketType || {}).Value);
    $("#google-confirmationCode").val((googleCfg.ConfirmationCode || {}).Value);
    $("#google-termsAndConditions").val((googleCfg.TermsAndCondition || {}).Value);
    $("#google-doorsOpen").val((googleCfg.EventDateTimes || {}).DoorsOpenDateTime);
    $("#google-eventStart").val((googleCfg.EventDateTimes || {}).StartDateTime);
    $("#google-eventEnd").val((googleCfg.EventDateTimes || {}).EndDateTime);
    $("#google-validityStart").val((googleCfg.EventDateTimes || {}).ValidityDateTimeStart);
    $("#google-validityEnd").val((googleCfg.EventDateTimes || {}).ValidityDateTimeEnd);
    
    $("#google-venueName").val((googleCfg.Venue || {}).Name);
    $("#google-venueAddress").val((googleCfg.Venue || {}).Address);
    $("#google-barcodeValue").val((googleCfg.Redemption || {}).Value);
    $("#google-barcodeType").val((googleCfg.Redemption || {}).Type);
    $("#google-barcodeAltText").val((googleCfg.Redemption || {}).AltText);
    $("#google-enableSmartTap").prop('checked',(googleCfg.Redemption || {}).EnableSmartTap);
    $("#google-smartTapRedepmtionValue").val((googleCfg.Redemption || {}).SmartTapRedemptionValue);
  }
      
  function _createGenericItemGrid(id, template_grid_selector, template_item_selector, caption, values, max_items) {
    var $grid = $(template_grid_selector).clone().appendTo("#grid-generic-item-container-google");
    $grid.attr('id', id);
    $grid.find(".widget-title-caption").text(caption);
    
    if (max_items == 1)
      $grid.find(".toolbar-tbody").remove();
    
    values = (values || []);
    for (var i=0; i<values.length; i++) {
      var item = values[i];
      _addMultipleFields($grid, template_item_selector, item.Header, item.Body, item.Link, item.Image, item.Description);
    }
    
    if ((max_items == 1) && (values.length < 1))
      _addMultipleFields($grid, template_item_selector, "", "", "", "");
    
    $grid.find(".btn-item-add").click(function() {
      _addMultipleFields($grid, template_item_selector, "", "", "", "");
      var length = $grid.find(".data-tbody .cblist").length;
      if (max_items != -1 && length >= max_items)
        $(this).prop("disabled", true);
    });
    
    $grid.find(".btn-item-remove").click(function() {
      $grid.find(".data-tbody .cblist:checked").closest("tr").remove();
      var length = $grid.find(".data-tbody .cblist").length;
      if (max_items != -1 && length < max_items) {
        $grid.find(".btn-item-add").prop("disabled", false);        
      }
    });
    return $grid;
  }
  
  function _addMultipleFields(container, template_item_selector, header, body, link, image, description) {
    var $tr = $(template_item_selector).clone().appendTo(container);
    $tr.find("[name='Header']").val(header);
    $tr.find("[name='Body']").val(body);
    $tr.find("[name='Link']").val(link);
    $tr.find("[name='Image']").val(image);
    $tr.find("[name='Description']").val(description);
  } 
  
  function _extractSingleValue(selector) {
    return {
      "Value": $(selector).val()
    }
  }

  function _extractMultipleFields(gridId) {
    var $rows = $("#" + gridId + " .data-tbody tr");
    var result = [];
    for (var i=0; i < $rows.length; i++) {
      var $row = $($rows[i]);
      result.push({
        "Header": $row.find("[name='Header']").val(),
        "Body": $row.find("[name='Body']").val(),
        "Link": $row.find("[name='Link']").val(),
        "Image": $row.find("[name='Image']").val(),
        "Description": $row.find("[name='Description']").val()
      });
    }
    return result;
  }
  
  function _doSaveETicketTemplateGoogle() {
    console.log("_doSaveETicketTemplateGoogle");
    var docData =  
    {
      "Logo": _extractSingleValue("#google-logoImage"),
      "LogoTxt":_extractSingleValue("#google-logoTxt"),
      "IssuerName":_extractSingleValue("#google-issuerName"),
      "EventName":_extractSingleValue("#google-eventName"),
      "Gate":_extractSingleValue("#google-gate"),
      "Section":_extractSingleValue("#google-section"),      
      "Row":_extractSingleValue("#google-row"),
      "Seat":_extractSingleValue("#google-seat"),
      "HeroImage":_extractSingleValue("#google-heroImage"),
      "HexBackgroundColor":_extractSingleValue("#google-backgroundColor"),
      "TicketType":_extractSingleValue("#google-ticketType"),
      "TicketHolderName":_extractSingleValue("#google-ticketHolder"),
      "ConfirmationCode":_extractSingleValue("#google-confirmationCode"),
      "TermsAndCondition":_extractSingleValue("#google-termsAndConditions"),
      "EventDateTimes": {
         "DoorsOpenDateTime" : $("#google-doorsOpen").val(), 
         "StartDateTime"   : $("#google-eventStart").val(),
         "EndDateTime" : $("#google-eventEnd").val(),
         "ValidityDateTimeStart" : $("#google-validityStart").val(),
         "ValidityDateTimeEnd" : $("#google-validityEnd").val()
         },
      "Venue" :{
        "Name" : $("#google-venueName").val(),
        "Address" : $("#google-venueAddress").val()
      },
      "Redemption" :{
        "Value": $("#google-barcodeValue").val(),
        "Type": $("#google-barcodeType").val(),
        "AltText": $("#google-barcodeAltText").val(),
        "EnableSmartTap" : $("#google-enableSmartTap").is(':checked'),
        "SmartTapRedemptionValue" : $("#google-smartTapRedepmtionValue").val()
      },
      "Messages": _extractMultipleFields(GRID_ID_MESSAGES),
      "TextModulesData": _extractMultipleFields(GRID_ID_TEXT),
      "LinksModulesData":_extractMultipleFields(GRID_ID_LINKS),
      "ImageModulesData":_extractMultipleFields(GRID_ID_IMAGES)
    } 
    return docData;
  }
});
</script>


<h1>Google Mobile wallet template settings</h1>

<v:widget caption="Images and Background" hint = '...'>
  <v:widget-block>         
    <v:form-field caption="Logo image" mandatory="true">
       <v:input-text type="string" field="google-logoImage"/>
    </v:form-field>
    <v:form-field caption="Logo text">
      <v:input-text type="string" field="google-logoTxt"/>
    </v:form-field>         
    
    <v:form-field caption="Hero Image">
      <v:input-text type="string" field="google-heroImage"/>
    </v:form-field>
    
    <v:form-field caption="Background color HEX">
     <snp:color-edit field="google-backgroundColor"  enabled="true"/>
    </v:form-field> 
  </v:widget-block> 
</v:widget>  

<v:widget caption="Event Details" hint = '...'>
  <v:widget-block>  
    <v:form-field caption="Issuer Name/Ticket type">
      <v:input-text type="string" field="google-issuerName"/>
    </v:form-field>
    <v:form-field caption="Event Name">
      <v:input-text type="string" field="google-eventName"/>
    </v:form-field>
     <v:form-field caption="Start DateTime">
        <v:input-text type="string" field="google-eventStart"/>
     </v:form-field>
     <v:form-field caption="End DateTime">
       <v:input-text type="string" field="google-eventEnd"/>
     </v:form-field>
     <v:form-field caption="Doors open Date Time">
       <v:input-text type="string" field="google-doorsOpen"/>
     </v:form-field>  
     <v:form-field caption="Terms and conditions">
       <v:input-text type="string" field="google-termsAndConditions"/>
     </v:form-field>
  </v:widget-block> 
</v:widget>  
 
<v:widget caption="Place" hint = '...'>
 <v:widget-block>         
   <v:form-field caption="Venue name">
      <v:input-text type="string" field="google-venueName"/>
   </v:form-field>
   <v:form-field caption="Venue address">
      <v:input-text type="string" field="google-venueAddress"/>
   </v:form-field>
   <v:form-field caption="Gate">
      <v:input-text type="string" field="google-gate"/>
   </v:form-field>
   <v:form-field caption="Section">
      <v:input-text type="string" field="google-section"/>
   </v:form-field>
   <v:form-field caption="Row">
      <v:input-text type="string" field="google-row"/>
   </v:form-field>
   <v:form-field caption="Seat">
      <v:input-text type="string" field="google-seat"/>
   </v:form-field>                              
 </v:widget-block> 
</v:widget>   

<v:widget caption="Ticket information" hint = '...'>
 <v:widget-block> 
    <v:form-field caption="Ticket type">
      <v:input-text type="string" field="google-ticketType"/>
   </v:form-field>
   <v:form-field caption="Ticket holder Information">
      <v:input-text type="string" field="google-ticketHolder"/>
   </v:form-field>
   <v:form-field caption="Confirmation Code">
      <v:input-text type="string" field="google-confirmationCode"/>
   </v:form-field>
   <v:form-field caption="Validity DateTime Start">
      <v:input-text type="string" field="google-validityStart"/>
   </v:form-field>
   <v:form-field caption="Validity DateTime End">
      <v:input-text type="string" field="google-validityEnd"/>
   </v:form-field>                         
 </v:widget-block> 
</v:widget>

<v:widget caption="Redemption" hint = '...'>
 <v:widget-block>
   <v:form-field caption="Barcode Type">
    <select class="form-control" id="google-barcodeType">
      <option value="QR_CODE">QRCode</option>
      <option value="CODE_128">Code-128</option>
      <option value="AZTEC">Atzec</option>
      <option value="CODE_39">Code-39</option>
      <option value="CODABAR">Codabar</option>
      <option value="DATA_MATRIX">Data matrix</option>
      <option value="EAN_8">Ean-8</option>
      <option value="EAN_13">Ean-13</option>
      <option value="ITF_14">Itf-14</option>
      <option value="PDF_417">Pdf-417</option>
      <option value="UPC_A">Upc-A</option>
    </select>
  </v:form-field>  
   <v:form-field caption="Barcode Value">
      <v:input-text type="string" field="google-barcodeValue"/>
   </v:form-field>
   <v:form-field caption="Barcode Alternative Text">
      <v:input-text type="string" field="google-barcodeAltText"/>
   </v:form-field>
   <v:form-field caption="Enable SmartTap (NFC)">
      <input type="checkbox" id="google-enableSmartTap"/>
   </v:form-field>   
   <v:form-field caption="SmartTap Redemption Value">
      <v:input-text type="string" field="google-smartTapRedepmtionValue"/>
   </v:form-field>                      
 </v:widget-block> 
</v:widget>

<div id="grid-generic-item-container-google"></div>

<div id="google-templates" class="hidden">
  <table>
    <tr class="tr-generic-item">
      <td><input type="checkbox" class="cblist"/></td>
      <td><input type="text" class="form-control" name="Header"/></td>
      <td><input type="text" class="form-control" name="Body"/></td>
    </tr>
  </table>
  
  <!-- Multifields components -->
  <v:grid clazz="grid-generic-item" >
    <thead>
      <v:grid-title caption="..." hint = '...'/>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="50%"><v:itl key="Header"/></td>
        <td width="50%"><v:itl key="Body"/></td>
      </tr>
    </thead>
    <tbody class="data-tbody"></tbody>
    <tbody class="toolbar-tbody"> 
      <tr>
        <td colspan="100%">
          <v:button clazz="btn-item-add" caption="@Common.Add" fa="plus"/>
          <v:button clazz="btn-item-remove" caption="@Common.Remove" fa="minus"/>
        </td>
      </tr>
    </tbody>
  </v:grid>
  
  <!-- Link Grid Template -->
  <table>
    <tr class="tr-link-item">
      <td><input type="checkbox" class="cblist"/></td>
      <td><input type="text" class="form-control" name="Link"/></td>
      <td><input type="text" class="form-control" name="Description"/></td>
    </tr>
  </table>
  
  <v:grid clazz="grid-link-item" >
    <thead>
      <v:grid-title caption="..." hint = '...'/>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="50%"><v:itl key="Link"/></td>
        <td width="50%"><v:itl key="Description"/></td>
      </tr>
    </thead>
    <tbody class="data-tbody"></tbody>
    <tbody class="toolbar-tbody"> 
      <tr>
        <td colspan="100%">
          <v:button clazz="btn-item-add" caption="@Common.Add" fa="plus"/>
          <v:button clazz="btn-item-remove" caption="@Common.Remove" fa="minus"/>
        </td>
      </tr>
    </tbody>
  </v:grid>
  
    <!-- Image data Grid Template -->
  <table>
    <tr class="tr-image-item">
      <td><input type="checkbox" class="cblist"/></td>
      <td><input type="text" class="form-control" name="Image"/></td>
      <td><input type="text" class="form-control" name="Description"/></td>      
    </tr>
  </table>
  
  <v:grid clazz="grid-image-item" >
    <thead>
      <v:grid-title caption="..." hint = '...'/>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="50%"><v:itl key="Image"/></td>
        <td width="50%"><v:itl key="Description"/></td>
      </tr>
    </thead>
    <tbody class="data-tbody"></tbody>
    <tbody class="toolbar-tbody"> 
      <tr>
        <td colspan="100%">
          <v:button clazz="btn-item-add" caption="@Common.Add" fa="plus"/>
          <v:button clazz="btn-item-remove" caption="@Common.Remove" fa="minus"/>
        </td>
      </tr>
    </tbody>
  </v:grid>
</div>