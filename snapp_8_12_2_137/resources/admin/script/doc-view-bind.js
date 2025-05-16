/**
 * params = {
 *   elems:             Mandatory. jQuery set of elements each representing 1 single field to be written into "doc" object
 *   doc:               Optional. JSON object
 *   fncFieldValidator: Optional.  function($field, String fieldValue) - the function is supposed to throw an exception in case of failed validation
 * }
 * returns the modified "doc" object
 */
function viewToDoc(params) {
  if (params === undefined)
    throw "Missing 'params' parameter";
  
  if (params.elems === undefined)
    throw "Missing 'params.elems' parameter";
  
  let $elems = $(params.elems)
  let doc = params.doc || {};
  
  $elems.each(function() {
    let $elem = $(this);
    if ($elem.is(".form-field"))
      $elem = $elem.find(".form-field-caption input[type='checkbox']") || $elem;
      
    let value = __validateField($elem);
    let name = __calcFieldName($elem);
     
    if (name) {
      let nameSplits = name.split(".");
      let node = doc;
      if (nameSplits.length > 1) {
        for (const fieldName of nameSplits.slice(1, nameSplits.length-1)) {
          if (node[fieldName] === undefined)
            node[fieldName] = {};
          node = node[fieldName];
        }
      }
      node[nameSplits[nameSplits.length - 1]] = value;
    }
  });
  
  function __calcFieldName($elem) {
    let name = $elem.attr("name") || $elem.attr("id") || "";
    
    if ($elem.is(".v-datepicker") && name.endsWith("-picker"))
      name = name.slice(0, -"-picker".length);
      
    return name;
  }
  
  function __validateField($elem) {
    let value = getFieldValue($elem);
    let result = value;
    
    try {
      if ($elem.is("input[type='number']")) {
        if (value === "")
          result = null;
        else {
          result = parseInt(value);
          if (isNaN(result))
            throw "Invalid value '" + value + "'";
        }
      }
      else if ($elem.is("input[type='checkbox']")) {
        result = $elem.isChecked();
      }
      else if ($elem.is(".v-upload-tile")) {
        result = $elem.uploadTile_GetData();
      }
      else if ($elem.is(".v-radiogroup")) {
        result = $elem.find("input[type='radio']:checked").val();
      }
      
      if (params.fncFieldValidator)
        params.fncFieldValidator($elem, value);
    }
    catch (error) {
      showIconMessage("warning", error, function() {
        $elem.focus();
      });
      throw error;
    }
    
    return getNull(result);
  }
  
  return doc;
}

/**
 * params = {
 *   doc:           Mandatory. JSON object
 *   elem:          Mandatory. DOM element to inject data into
 *   fieldSelector: Optional.  If specified, target elements are filtered to match this "selector"
 *   rootNodeName:  Optional.  Initial part of the element's name. For example if name is "product.ProductName", this field should be valued "product"
 * }
 */
function docToView(params) {
  if (params === undefined)
    throw "Missing 'params' parameter";
  
  if (params.elem === undefined)
    throw "Missing 'params.elem' parameter";
  
  let doc = params.doc || {};
  
  Object.keys(doc).forEach(function(key) {
    let fieldName = key;
    if (params.rootNodeName)
    fieldName = params.rootNodeName + "." + fieldName;
    
    let $field = $(params.elem).find("[name='" + fieldName.replace() + "']");

    if (params.fieldSelector)
      $field = $field.filter(params.fieldSelector);
      
    if ($field.is("input[type='checkbox']"))
      $field.setChecked(doc[key] === true);
    else if ($field.is(".v-multibox")) {
      let value = doc[key];
      if ((value) && ((typeof value) == "string")) 
        value = value.split(",");
      
      $field[0].selectize.setValue(value, true);
    }
    else
      $field.val(doc[key]);
      
    let $datePicker = $(params.elem).find("#" + fieldName + "-picker");  
    if ($datePicker.length > 0)
      $datePicker.datepicker("setDate", xmlToDate(doc[key]));
  })
}

/**
 * params = {
 *   rows:              Mandatory. jQuery set of elements each representing 1 item of the returned array
 *   fieldSelector:     Mandatory. String of the "jQuery selector" to be used to find fields in each row
 *   fncFieldValidator: Optional.  function($field, String fieldValue) - the function is supposed to throw an exception in case of failed validation
 * }
 * 
 * returns array of JSON objects
 */
function gridToDoc(params) {
  if (params === undefined)
    throw "Missing 'params' parameter";
  
  if (params.rows === undefined)
    throw "Missing 'params.rows' parameter";
  
  if (params.fieldSelector === undefined)
    throw "Missing 'params.fieldSelector' parameter";
     
  let result = [];
  params.rows.each(function() {
    result.push(viewToDoc({
      "elems": $(this).find(params.fieldSelector), 
      "fncFieldValidator": params.fncFieldValidator
    }));
  });
  return result;
}

/*
 * params = {
 *   doc:              Mandatory. Array of JSON objects to be displayed in the grid 
 *   tbody:            Mandatory. DOM element of the TBODY which will be filled with 1 row per each item of the "doc" array
 *   template:         Mandatory. DOM "tr" template which will be cloned to display every item of the "doc" array
 *   rootNodeName:     Mandatory. Initial part of the element's name. For example if name is "product.ProductName", this field should be valued "product"
 *   addButtonHandler: Optional.  Handler of the "add"" button (ie "#btn-item-add" or $jqueryObject)
 *   delButtonHandler: Optional.  Handler of the "del" button (ie "#btn-item-add" or $jqueryObject)
 * }
 */
function docToGrid(params) {
  if (params === undefined)
    throw "Missing 'params' parameter";
  
  if (params.tbody === undefined)
    throw "Missing 'params.tbody' parameter";
  
  if (params.template === undefined)
    throw "Missing 'params.tbody' parameter";
    
  let $tbody = $(params.tbody); 
  let $template = $(params.template);
  
  $tbody.empty();
  for (const item of (params.doc || [])) {
    docToView({
      "doc": item,
      "rootNodeName": params.rootNodeName,
      "elem": $template.clone().appendTo($tbody)
    });
  }
  
  if (params.addButtonHandler)
    $(params.addButtonHandler).click(_onGridAddClick);
  
  if (params.delButtonHandler)
    $(params.delButtonHandler).click(_onGridDelClick);
    
  function _onGridAddClick() {
    $template.clone().appendTo($tbody);
  }
    
  function _onGridDelClick() {
    $tbody.find(".cblist:checked").closest("tr").remove();
  }
}

/**
 * Same parameters as "function viewToDoc()" except for parameter "elems" which will be overwritten with "this"
 */
$.fn.viewToDoc = function(params) {
  params = params || {};
  params.elems = this;
  return viewToDoc(params);
}

/**
 * Same parameters as "function viewToDoc()" except for parameter "rows" which will be overwritten with "this"
 */
$.fn.gridToDoc = function(params) {
  params = params || {};
  params.rows = this;
  return gridToDoc(params);
}

/**
 * Same parameters as "function docToView()" except for parameter "elem" which will be overwritten with "this"
 */
$.fn.docToView = function(params) {
  params = params || {};
  params.elem = this;
  docToView(params);
}

/**
 * Same parameters as "function docToGrid()" except for parameter "tbody" which will be overwritten with "this"
 */
$.fn.docToGrid = function(params) {
  params = params || {};
  params.tbody = this;
  docToGrid(params);
}
