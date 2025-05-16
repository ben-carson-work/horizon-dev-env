<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<script>

var doctemplate = doctemplate || {};
doctemplate.editor = doctemplate.editor || {};

(function() {
  'use strict';

  /* Parse DocTemplateVariable array to the JS object */
  var variablesToHierarchy = function(variables, processMetaFields) {
    var hierarchy = {};
    variables.forEach(function(variableObj) {
      var variable = variableObj.Name;
      var type = variableObj.Type;
      variable = variable.substring(2);
      variable = variable.substring(0, variable.length - 1);
      var tokens = variable.split('.');
      var parent = hierarchy;
      var last = parent;
      tokens.forEach(function(token, idx, array) {
        if (!parent[token]) {
          parent[token] = {};
        }
        if (idx !== array.length - 1) {
          parent = parent[token];
        } else if (type === 'MetaField' && processMetaFields) {
          last = [];
          parent[token][variableObj.MetaFieldName] = last; 
        } else {
          last = [];
          parent[token] = last;
        }
      });
      last.push(variableObj);
    });
    return hierarchy;
  };
  
  /* Parse DocTemplateVariable array to the special JS object for building tree */
  var parseVariables = function(variables) {
    var hierarchy = variablesToHierarchy(variables, true);
    
    var result = {
        Caption: 'All variables',
        Classes: 'collapsed',
        ChildNodes: []
    };
    
    var parseChildren = function(obj, arr, parent) {
      $.each(obj, function(key, value) {
        var node = {
            Caption: key,
            Classes: 'collapsed'
        };
        if (!$.isEmptyObject(value) && !Array.isArray(value)) {
          node.ChildNodes = [];
          parseChildren(value, node.ChildNodes, node.Id + '.');
        } else {
          node.Classes = 'leaf';
          node.Data = value[0];
        }
        arr.push(node);
      });
    };
    parseChildren(hierarchy, result.ChildNodes, '');
    return result;
  };
  
  /* Parse MetaDataField Variables array to the hierarchical JS object */
  var parseMetaDataFields = function(variables) {
    var metaDataFields = {};
    variables.forEach(function(variableObj) {
      if (variableObj.Type === "MetaField") {
        if (!metaDataFields[variableObj.MetaFieldName]) {
          metaDataFields[variableObj.MetaFieldName] = {
              type: variableObj.MetaFieldType,
              code: variableObj.MetaFieldCode
          };
          doctemplate.editor.parameters.fieldcode.push(variableObj.MetaFieldName);
          doctemplate.editor.parameters.fieldtype.push(variableObj.MetaFieldName);
        }
      }
    });
    return metaDataFields;
  };
  
  /* Parse CodeAlias Variables array to the hierarchical JS object */
  var parseCodeAliasTypes = function(variables) {
    var codeAliasTypes = {};
    variables.forEach(function(variableObj) {
      if (variableObj.Type === "CodeAliasType") {
        if (!codeAliasTypes[variableObj.CodeAliasTypeName]) {
          codeAliasTypes[variableObj.CodeAliasTypeName] = {
              code: variableObj.CodeAliasTypeCode
          };
          doctemplate.editor.parameters.codealiastype.push(variableObj.CodeAliasTypeName);
        }
      }
    });
    return codeAliasTypes;
  };
  
  var parseDataSourceVariables = function(variables) {
    if (variables) {
      variables.forEach(function(variableObj) {
        doctemplate.editor.parameters.ds.push(variableObj.Name);
      });
    }
  };
  
  /* Add autocomplete for codemirror without clickin "^space" */
  var initCodeMirror = function(editor) {
    editor.on('change', function(cm, event) {
      var cur = cm.getCursor();
      var from = CodeMirror.Pos(cur.line, cur.ch - 2);
      var s = cm.getRange(from, cur);
      if (event.origin !== '+delete' && s == '[@') {
          cm.showHint();
      } else {
        var txt = event.text.join('');
        var type = cm.getTokenTypeAt(cur);
        if (txt.startsWith('{}') && type === 'param-tag' ||
            txt.endsWith(':')    && type === 'param-value-sep' ||
            txt.endsWith(';')    && type === 'param-sep') {
          cm.showHint();
        } else if (type === 'variable') {
          var token = cm.getTokenAt(cur);
          var variable = token.state.variable;
          if (variable.endsWith('.')) {
            cm.showHint();
          }
        }
      }
    });
  };

  // document.ready
  doctemplate.editor.parameters = {
    caption: [],
    fieldcode: [],
    replacewithifempty: [],
    autowrap: ["true"],
    hideifempty: ["true"],
    showitemname: ["true"],
    fieldtype: [],
    filterfield: [],
    filtervalue: [],
    format: ["Currency", "CurrencyCents", "CurrencySymbol", "ShortDate", "ShortTime", "LongDate", "ShortDateTime", "LongDateTime"],
    transform: ["Uppercase", "Lowercase"],
    width: true,
    align: ["left", "center", "right"],
    translate: ["true"],
    aggregate: ["sum", "cnt", "min", "max", "avg"],
    math: ["absolute", "opposite"],
    ds: [],
    fieldname: [],
    fieldvalue: [],
    codealiastype: [],
    print_length: true,
    operator: ["greater", "greater_equals", "equals", "minor", "minor_equals"]
  };
  
  doctemplate.editor.variablesToHierarchy = variablesToHierarchy;
  doctemplate.editor.parseVariables = parseVariables;
  doctemplate.editor.parseMetaDataFields = parseMetaDataFields;
  doctemplate.editor.parseCodeAliasTypes = parseCodeAliasTypes;
  doctemplate.editor.parseDataSourceVariables = parseDataSourceVariables;
  doctemplate.editor.initCodeMirror = initCodeMirror;
})();
</script>