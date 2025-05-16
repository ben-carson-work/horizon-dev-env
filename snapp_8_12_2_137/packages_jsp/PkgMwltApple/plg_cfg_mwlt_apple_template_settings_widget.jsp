<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<script type="text/javascript">

$(document).ready(function() {
  console.log("Apple doc ready");
  const pluginClassAlias = "eticket-apple";
  const GRID_ID_HEADER = "header-fields";
  const GRID_ID_PRIMARY = "primary-field";
  const GRID_ID_SECONDARY = "secondary-fields";
  const GRID_ID_AUXILIARY = "auxiliary-fields";
  const GRID_ID_BACK = "back-fields";
  const APPLE_DOC_HINT = "Please reterence to [Apple documentation](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/PassKit_PG/Creating.html#//apple_ref/doc/uid/TP40012195-CH4-SW1)";

 
  $(".form-field-hint").attr("title", APPLE_DOC_HINT);
  
  $(document).off("doctemplate-eticket-load");
  $(document).on("doctemplate-eticket-load", function(event, params) {
    console.log("Apple doctemplate-eticket-load event");
    var list = (params || {}).PluginList || [];
    var appleCfg = {};
    for (var i=0; i<list.length; i++) {
      var plugin = list[i];
      if (plugin.PluginClassAlias == pluginClassAlias) {
        appleCfg = JSON.parse(plugin.DocData);
        break;
      }
    }
    _fillFields(appleCfg);

  });

  $(document).off("doctemplate-eticket-save");
  $(document).on("doctemplate-eticket-save", function(event, params) {
    console.log("Apple Before:"+JSON.stringify(params));
    _removeOldConfiguration(params.PluginList);
    console.log("Apple After clean:"+JSON.stringify(params));
    var docData = _doSaveETicketTemplateApple();
    params.PluginList.push({"PluginClassAlias":pluginClassAlias, "DocData": JSON.stringify(docData)})
    console.log("Apple After fill:"+JSON.stringify(params));
  });
    
  function _removeOldConfiguration(cfg) {
    var index = cfg.findIndex(function(o){
      return o.PluginClassAlias === pluginClassAlias;
    })
    if (index !== -1)
      cfg.splice(index, 1);
  }
  
  function _fillFields(appleCfg) {
    console.log("apple _fillFields");
    _createGenericItemGrid(GRID_ID_HEADER, "Header fields", appleCfg.HeaderFields, true);
    _createGenericItemGrid(GRID_ID_PRIMARY, "Primary field", appleCfg.PrimaryField, false);
    _createGenericItemGrid(GRID_ID_SECONDARY, "Secondary fields", appleCfg.SecondaryFields, true);
    _createGenericItemGrid(GRID_ID_AUXILIARY, "Auxiliary fields", appleCfg.AuxiliaryFields, true);
    _createGenericItemGrid(GRID_ID_BACK, "Back fields", appleCfg.BackFields, true);

    $("#apple-logoTxt").val((appleCfg.LogoText || {}).Value);
    $("#apple-description").val((appleCfg.Description || {}).Value);
    $("#apple-logoTxt").val((appleCfg.LogoText || {}).Value);
    
    $("#apple-logoImage").val(((appleCfg.LogoImages || {})[0] || {}).Value);
    $("#apple-logoImageHQ").val(((appleCfg.LogoImages || {})[1] || {}).Value);
    
    $("#apple-iconImage").val(((appleCfg.IconImages || {})[0] || {}).Value);
    $("#apple-iconImageHQ").val(((appleCfg.IconImages || {})[1] || {}).Value);
    
    $("#apple-stripImage").val(((appleCfg.StripImages || {})[0] || {}).Value);
    $("#apple-stripImageHQ").val(((appleCfg.StripImages || {})[1] || {}).Value);
    
    $("#apple-thumbnailImage").val(((appleCfg.ThumbnailImages || {})[0] || {}).Value);
    $("#apple-thumbnailImageHQ").val(((appleCfg.ThumbnailImages || {})[1] || {}).Value);  
    
    $("#apple-backgroundImage").val(((appleCfg.BackgroundImages || {})[0] || {}).Value);
    $("#apple-backgroundImageHQ").val(((appleCfg.BackgroundImages || {})[1] || {}).Value);
   
    $("#apple-barcodeValue").val((appleCfg.Redemption || {}).Value);
    $("#apple-barcodeAltText").val((appleCfg.Redemption || {}).AltText);
    
    $("#apple-barcodeType").val((appleCfg.Redemption || {}).Type);

    $("#apple-enableNFC").prop('checked',(appleCfg.Redemption || {}).EnableNFC);
    $("#apple-NFCRedepmtionValue").val((appleCfg.Redemption || {}).NFCRedemptionValue);

    $("#apple-backgroundColor").val((appleCfg.BackgroundColor || {}).Value);
    $("#apple-foregroundColor").val((appleCfg.ForegroundColor || {}).Value);
    $("#apple-labelColor").val((appleCfg.LabelColor || {}).Value); 
  }
  
  function _createGenericItemGrid(id, caption, values, multi) {
    var $grid = $("#apple-templates .grid-generic-item").clone().appendTo("#grid-generic-item-container");
    $grid.attr('id', id);
    $grid.find(".widget-title-caption").text(caption);
    
    if (multi == false)
      $grid.find(".toolbar-tbody").remove();
    
    values = (values || []);
    for (var i=0; i<values.length; i++) {
      var item = values[i];
      _addMultipleFields($grid, item.Label, item.Value, item.Alignment);
    }
    
    if ((multi == false) && (values.length < 1))
      _addMultipleFields($grid, "", "", "CENTER");
    
    $grid.find(".btn-item-add").click(function() {
      _addMultipleFields($grid, "", "", "CENTER");
    });
    
    $grid.find(".btn-item-remove").click(function() {
      $grid.find(".data-tbody .cblist:checked").closest("tr").remove();
    });
    
    return $grid;
  }

  function _addMultipleFields(container, label, value, alignment) {
    var $tr = $("#apple-templates .tr-generic-item").clone().appendTo(container);
    $tr.find("[name='Label']").val(label);
    $tr.find("[name='Value']").val(value);
    $tr.find("[name='Alignment']").val(alignment);
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
        "Label": $row.find("[name='Label']").val(),
        "Value": $row.find("[name='Value']").val(),
        "Alignment": $row.find("[name='Alignment']").val()
      });
    }
    return result;
  }

  function _doSaveETicketTemplateApple() {
    console.log("_doSaveETicketTemplateApple");
    var docData =  
    {
      "Description": _extractSingleValue("#apple-description"),
      "LogoText": _extractSingleValue("#apple-logoTxt"),
      "LogoImages": [
        _extractSingleValue("#apple-logoImage"),
        _extractSingleValue("#apple-logoImageHQ")
      ],
      "IconImages": [
        _extractSingleValue("#apple-iconImage"),
        _extractSingleValue("#apple-iconImageHQ")
      ],
      "StripImages": [
        _extractSingleValue("#apple-stripImage"),
        _extractSingleValue("#apple-stripImageHQ")
      ],  
      "ThumbnailImages": [
        _extractSingleValue("#apple-thumbnailImage"),
        _extractSingleValue("#apple-thumbnailImageHQ")
      ],
      "BackgroundImages": [
        _extractSingleValue("#apple-backgroundImage"),
        _extractSingleValue("#apple-backgroundImageHQ")
      ],     
      "Redemption" :{
        "Value": $("#apple-barcodeValue").val(),
        "Type": $("#apple-barcodeType").val(),
        "AltText" : $("#apple-barcodeAltText").val(),
        "EnableNFC" : $("#apple-enableNFC").is(':checked'),
        "NFCRedemptionValue" : $("#apple-NFCRedepmtionValue").val()
      },
      "BackgroundColor": _extractSingleValue("#apple-backgroundColor"),
      "ForegroundColor": _extractSingleValue("#apple-foregroundColor"),
      "LabelColor":  _extractSingleValue("#apple-labelColor"),
      "HeaderFields": _extractMultipleFields(GRID_ID_HEADER),
      "PrimaryField": _extractMultipleFields(GRID_ID_PRIMARY),
      "SecondaryFields": _extractMultipleFields(GRID_ID_SECONDARY),
      "AuxiliaryFields": _extractMultipleFields(GRID_ID_AUXILIARY),
      "BackFields": _extractMultipleFields(GRID_ID_BACK)
    } 
    return docData;
  }
});

</script>


<h1>Apple Mobile wallet template settings</h1>

<div id="grid-generic-item-container"></div>

<v:widget caption="Icon images" hint = '...'>
  <v:widget-block>         
    <v:form-field caption="Standard image" mandatory="true">
       <v:input-text type="string" field="apple-iconImage"/>
    </v:form-field>
    <v:form-field caption="HQ image" mandatory="true">
       <v:input-text type="string" field="apple-iconImageHQ"/>
    </v:form-field>        
  </v:widget-block> 
</v:widget> 
<v:widget caption="Logo" hint = '...'>
  <v:widget-block>         
    <v:form-field caption="Standard image" >
       <v:input-text type="string" field="apple-logoImage"/>
    </v:form-field>
    <v:form-field caption="HQ image">
       <v:input-text type="string" field="apple-logoImageHQ"/>
    </v:form-field>
    <v:form-field caption="Text">
      <v:input-text type="string" field="apple-logoTxt"/>
    </v:form-field>         
  </v:widget-block> 
</v:widget>     
<v:widget caption="Strip images" hint = '...'>
  <v:widget-block>      
    <v:form-field caption="Standard image" >
      <v:input-text type="string" field="apple-stripImage"/>
    </v:form-field>
    <v:form-field caption="HQ image">
      <v:input-text type="string" field="apple-stripImageHQ"/>
    </v:form-field>
  </v:widget-block> 
</v:widget>
<v:widget caption="Thumbnail images" hint = '...'>
  <v:widget-block>        
    <v:form-field caption="Standard image" >
      <v:input-text type="string" field="apple-thumbnailImage"/>
    </v:form-field>
    <v:form-field caption="HQ image">
      <v:input-text type="string" field="apple-thumbnailImageHQ"/>
    </v:form-field> 
  </v:widget-block> 
</v:widget>  
<v:widget caption="Background images" hint = '...'>
  <v:widget-block>      
    <v:form-field caption="Standard image">
      <v:input-text type="string" field="apple-backgroundImage"/>
    </v:form-field>
    <v:form-field caption="HQ image">
      <v:input-text type="string" field="apple-backgroundImageHQ"/>
    </v:form-field>
  </v:widget-block> 
</v:widget>      
<v:widget caption="Redemption" hint = '...'>
  <v:widget-block>
     <v:form-field caption="Barcode Type">
       <select class="form-control" id="apple-barcodeType">
         <option value="QR_CODE">QRCode</option>
         <option value="CODE_128">Code-128</option>
         <option value="AZTEC">Atzec</option>
         <option value="PDF_417">Pdf-417</option>   
       </select>
     </v:form-field>  
     <v:form-field caption="Barcode Value">
       <v:input-text type="string" field="apple-barcodeValue"/>
     </v:form-field>
	   <v:form-field caption="Barcode Alternative Text">
	      <v:input-text type="string" field="apple-barcodeAltText"/>
	   </v:form-field>     
     <v:form-field caption="Enable NFC">
       <input type="checkbox" id="apple-enableNFC"/>
     </v:form-field>   
     <v:form-field caption="NFC Redemption Value">
       <v:input-text type="string" field="apple-NFCRedepmtionValue"/>
     </v:form-field>                      
  </v:widget-block> 
</v:widget>
<v:widget caption="Generic" hint = '...'>
	<v:widget-block>
		<v:form-field caption="Description" hint = '...' mandatory="true">
		  <v:input-text type="string" field="apple-description"/>
		</v:form-field>       
		<v:form-field caption="Background color" hint = '...' >
			<snp:color-edit field="apple-backgroundColor"  enabled="true"/>
		</v:form-field>
		<v:form-field caption="Foreground color" hint = '...'>
			<snp:color-edit field="apple-foregroundColor"  enabled="true"/>
		</v:form-field>
		<v:form-field caption="Label color" hint = '...'>
			<snp:color-edit field="apple-labelColor"  enabled="true"/>  
		</v:form-field>
	</v:widget-block> 
</v:widget>
                 

<div id="apple-templates" class="hidden">
  <table>
    <tr class="tr-generic-item">
      <td><input type="checkbox" class="cblist"/></td>
      <td><input type="text" class="form-control" name="Label"/></td>
      <td><input type="text" class="form-control" name="Value"/></td>
      <td>
        <select class="form-control" name="Alignment">
          <option value="CENTER">Center</option>
          <option value="RIGHT">Right</option>
          <option value="LEFT">Left</option>
        </select>
      </td>
    </tr>
  </table>
  
  <!-- Multifields components -->
  <v:grid clazz="grid-generic-item" >
    <thead>
      <v:grid-title caption="..." hint = '...'/>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="30%"><v:itl key="Label"/></td>
        <td width="30%"><v:itl key="Value"/></td>
        <td width="40%"><v:itl key="Alignment"/></td>
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
 

