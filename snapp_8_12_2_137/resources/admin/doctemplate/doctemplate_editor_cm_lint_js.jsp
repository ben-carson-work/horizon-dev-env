<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<script>
  (function(CodeMirror) {
    "use strict";
  
    /*
      Checks if the key contains in the obj properties, ignoring the case.
      @Param obj The object HashMap {key:value}
      @Param key The key to search in the given object
      @Return The correct case sensitive key if the key is found.
        Otherwise undefined
    */
    function caseInsensitiveIn(obj, key) {
      var result = {};
      $.each(obj, function(x, value) {
        if (x.toLowerCase)
          result[x.toLowerCase()] = x;
        else
          result[x] = x;
      });
      return result[key.toLowerCase()];
    }
  
    function validateVar(variable, fromIndex) {
      var hierarchy = doctemplate.editor.hierarchy;
      var variables = variable.split('.');
      var result = [];
      var msg = '';
      var severity = '';
      variables.some(function(key) {
        var correctKey = key;
        if (!hierarchy[key])
          correctKey = caseInsensitiveIn(hierarchy, key);
        if (!correctKey) {
          msg = 'Unknown variable "{0}"'.format(key);
          severity = 'error';
          result.push({
            fromColumn: fromIndex,
            toColumn: fromIndex + key.length,
            message: msg,
            severity: severity
          });
          return true;
        } else {
          hierarchy = hierarchy[correctKey];
          if (hierarchy.length >= 1 && hierarchy[0].Deprecated) {
             msg = hierarchy[0].VgsComment || 'Deprecated';
             severity = 'warning';
             result.push({
               fromColumn: fromIndex,
               toColumn: fromIndex + key.length,
               message: msg,
               severity: severity
             });
          }
        }
        fromIndex += key.length + 1; // 1 for . char
      });
      return result;
    }
  
    // parameters are without braces {}
    // e.g. key1:value1;key2:value2
    // fromIndex is related to the variable start [@
    function validateParams(parameters, fromIndex) {
      if (!parameters.trim()) {
        return [{
          fromColumn: fromIndex - 1, // add left brace
          toColumn: fromIndex + parameters.length + 1, // add right brace
          message: 'Empty parameter is not allowed'
        }];
      }
      var parametersArray = parameters.split(';');
      var errors = [];
      parametersArray.forEach(function(param) {
        param = param.trim();
        var shift = parameters.indexOf(param);
        errors = errors.concat(validateParam(param, fromIndex + shift));
      });
      return errors;
    }
  
    // param is pair "key:value"
    // fromIndex is related to a variable start [@
    function validateParam(param, fromIndex) {
      if (!param) {
        return [];
      }
      var parameters = doctemplate.editor.parameters;
      var tokens = param.match(/('[^']+'|[^:]+)/g);
      var msg, severity;
      var errors = [];
      var error = null;
      if (tokens.length !== 2) {
        return [{
          fromColumn: fromIndex,
          toColumn: fromIndex + param.length,
          message: "Can\'t parse {key:value} pair",
  
        }];
      } else {
        var key = tokens[0].trim();
        var shift = param.indexOf(key);
        var allowedValues = parameters[key];
        if (!allowedValues) {
          var correctKey = caseInsensitiveIn(parameters, key);
          if (!correctKey) {
            msg = 'Unknown key "{0}"'.format(key);
            severity = 'error';
            error = {
              fromColumn: fromIndex + shift,
              toColumn: fromIndex + shift + key.length,
              message: msg,
              severity: severity
            };
            errors.push(error);
            return errors;
          } else {
            key = correctKey;
            allowedValues = parameters[key];
          }
        }
        var value = tokens[1].trim();
  
        shift = param.indexOf(value);
        msg = 'Unknown value "{0}" for key "{1}"'.format(value, key);
        severity = 'error';
        if (key === 'fieldcode') {
          allowedValues = $.map(doctemplate.editor.metaDataFields, function(x) { return x.code; });
        }  else if (key == 'fieldtype') {
          allowedValues = $.map(doctemplate.editor.metaDataFields, function(x) { return x.type.toString(); });
        }  else if (key == 'codealiastype') {
          allowedValues = $.map(doctemplate.editor.codeAliasTypes, function(x) { return x.code; });
        } else if (key === 'filterfield') {
          allowedValues = undefined;
        }  else if (key == 'filtervalue') {
          allowedValues = undefined;
        }  else if (key == 'caption') {
          allowedValues = undefined;
        }  else if (key == 'replacewithifempty') {
          allowedValues = undefined;
        }  else if (key == 'autowrap') {
          allowedValues = undefined;
        }  else if (key == 'fieldvalue') {
          allowedValues = undefined;
        }  else if (key == 'fieldname') {
          allowedValues = undefined;
        } else if (key === 'format') {
          msg = 'It is better to use one of the predefined values instead of "{0}"'.format(value);
          severity = 'warning';
        } else if (key === 'width' || key === 'print_length') {
          allowedValues = undefined;
          var parsed = parseInt(value);
          if (isNaN(parsed)) {
            errors.push({
              fromColumn: fromIndex + shift,
              toColumn: fromIndex + shift + key.length,
              message: 'Parse Int error: "{0}"'.format(value)
            });
            return errors;
          }
        }
        if (allowedValues && allowedValues.indexOf(value) === -1) {
          var lowedValue = value.toLowerCase();
          var found = false;
          allowedValues.some(function(el) {
            if (el.toLowerCase() === lowedValue) {
              found = true;
              return true;
            }
          });
          if (!found) {
            errors.push({
              fromColumn: fromIndex + shift,
              toColumn: fromIndex + shift + value.length,
              message: msg,
              severity: severity
            });
            if (severity === 'error') {
              return errors;
            }
          }
        }
  
      }
      return errors;
    }
  
    function validate(searchArray) {
      var content = searchArray[0];
      var fromIndex = searchArray.index;
      var toIndex = fromIndex + content.length;
      // remove prefix [@ and suffix ]
      content = content.substring(2, content.length - 1).trim();
      if (content === '') {
        return [{
          fromColumn: fromIndex,
          toColumn: toIndex,
          message: 'Empty variable is not allowed',
        }];
      } else {
        fromIndex = fromIndex + searchArray[0].indexOf(content);
        var tokens = content.split(' {');
        var parseError = [{
          fromColumn: fromIndex,
          toColumn: fromIndex + content.length,
          message: 'Parse error: format should be "[@Variable {key1:value1;key2:value2}]"',
        }];
        if (tokens.length > 2) {
          return parseError;
        } else {
          // first token is always variable
          var errors = validateVar(tokens[0].trim(), fromIndex);
          if (errors.length) return errors;
          // we do not need to continue, if variable is not valid
          if (tokens.length === 2) {
            fromIndex = searchArray.index + searchArray[0].indexOf(tokens[1]);
            tokens = tokens[1].split('}');
            // check the tail for rubbish
            if (tokens.length > 1) {
              for (var i = 1; i < tokens.length; ++i) {
                if (tokens[i].trim()) {
                  return parseError;
                }
              }
            }
            return validateParams(tokens[0], fromIndex);
          }
        }
      }
      return [];
    }
  
    CodeMirror.registerHelper("lint", "vgslang", function(text) {
      var found = [];
      var regex = /\[@[^\]]*\]/gi;
      var result;
      var lines = text.split('\n');
      var callback = function(err) {
        found.push({
            from: CodeMirror.Pos(i, err.fromColumn),
            to: CodeMirror.Pos(i, err.toColumn),
            message: err.message,
            severity: err.severity
          });
      };
      for (var i = 0; i < lines.length; ++i) {
        while ( (result = regex.exec(lines[i])) ) {
          var validateErrors = validate(result);
          if (validateErrors.length) {
            validateErrors.forEach(callback);
          }
        }
      }
      return found;
    });
  })(CodeMirror);
</script>