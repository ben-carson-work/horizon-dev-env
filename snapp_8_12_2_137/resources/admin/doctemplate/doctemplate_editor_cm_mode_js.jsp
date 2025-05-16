<%@page import="com.vgs.web.library.BLBO_DocTemplate"%>
<%@page import="com.vgs.snapp.dataobject.DODocTemplate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<link rel="stylesheet" href="<v:config key="site_url"/>/libraries/codemirror/lib/codemirror.css"/>
<link rel="stylesheet" href="<v:config key="site_url"/>/libraries/codemirror/addon/hint/show-hint.css"/>
<link rel="stylesheet" href="<v:config key="site_url"/>/libraries/codemirror/addon/lint/lint.css"/>
<script src="<v:config key="site_url"/>/libraries/codemirror/lib/codemirror.js"></script>
<script src="<v:config key="site_url"/>/libraries/codemirror/mode/javascript/javascript.js"></script>
<script src="<v:config key="site_url"/>/libraries/codemirror/addon/hint/show-hint.js"></script>
<script src="<v:config key="site_url"/>/libraries/codemirror/addon/edit/closebrackets.js"></script>
<script src="<v:config key="site_url"/>/libraries/codemirror/addon/lint/lint.js"></script>
<script>

CodeMirror.defineMode("vgslang", function() {

  function inText(stream, state) {
    stream.eatWhile(/[^\[]/);
    if (stream.peek() === '[') {
      state.tokenize = inTag;
    }
    return 'text';
  }

  function inTag(stream, state) {
    if (stream.eat('[') && stream.eat('@')) {
      state.tokenize = inVariable;
      state.variable = '';
      return 'tag';
    } else {
      state.tokenize = inText;
      return 'text';
    }
  }

  function inVariable(stream, state) {
    var ch = stream.next();
    if (ch === '{') {
      state.variable = '';
      state.tokenize = inParameter;
      return 'param-tag';
    } else if (ch === ']') {
      state.tokenize = inText;
      return 'tag';
    }
    state.variable += ch;
    return 'variable';
  }

  function inParameter(stream, state) {
    stream.eatWhile(/[^:\}\]]/);
    if (stream.peek() === ':') {
      state.tokenize = function(stream, state) {
        stream.eat(':');
        state.tokenize = inParameterValue;
        return 'param-value-sep';
      };
    } else if (stream.peek() === '}') {
      state.tokenize = function(stream, state) {
        stream.eat('}');
        state.tokenize = inClosingTag;
        return 'param-tag';
      };
    } else if (stream.peek() === ']') {
      state.tokenize = function(stream, state) {
        stream.eat(']');
        state.tokenize = inText;
        return 'tag';
      };
    }
    state.variable = stream.current().trim();
    return 'param-name';
  }

  function inParameterValue(stream, state) {
    stream.eatWhile(/[^;\}]/);
    if (stream.peek() === ';') {
      state.tokenize = function(stream, state) {
        stream.eat(';');
        state.variable = '';
        state.tokenize = inParameter;
        return 'param-sep';
      };
    } else if (stream.peek() === '}') {
      state.tokenize = function(stream, state) {
        stream.eat('}');
        state.tokenize = inClosingTag;
        return 'param-tag';
      };
    }
    return 'param-value';
  }

  function inClosingTag(stream, state) {
    stream.eat(']');
    state.tokenize = inText;
    return 'tag';
  }

  return {
    startState: function() {
      return {tokenize: inText};
    },
    token: function(stream, state) {
      return state.tokenize(stream, state);
    }
  };
});

CodeMirror.registerHelper('hint', 'vgslang', function(cm, options) {
  var hierarchy = doctemplate.editor.hierarchy;
  var parameters = doctemplate.editor.parameters;
  var cur = cm.getCursor();
  var token = cm.getTokenAt(cur);
  var list = [];
  var beginString;
  if (token.type === 'tag' && (token.string === ']' || cur.ch !== token.end)) {
    return;
  } 
  else if (token.type === 'tag') {
    Object.keys(hierarchy).forEach(function(key) {
      var value = hierarchy[key];
      if (!Array.isArray(value)) {
        key += '.';
      }
      list.push(key);
    });
    return {
      list: list,
      from: CodeMirror.Pos(cur.line, cur.ch),
      to: CodeMirror.Pos(cur.line, cur.ch)
    };
  } 
  else if (token.type === 'variable') {
    var variables = token.state.variable.split('.');
    var newHierarchy = hierarchy;
    variables.forEach(function(element, i, arr) {
      if (i !== arr.length - 1) { // not last
        if (newHierarchy[element] && !Array.isArray(newHierarchy[element])) {
          var subHierarchy = {};
          Object.keys(newHierarchy[element]).forEach(function(key) {
            subHierarchy[key] = newHierarchy[element][key];
          });
          newHierarchy = subHierarchy;
        } 
        else {
          newHierarchy = {};
        }
      } 
      else {
        Object.keys(newHierarchy).forEach(function(key) {
          if (element === '' || key.toLowerCase().startsWith(element.toLowerCase())) {
            var value = newHierarchy[key];
            var variable = key;
            if (!Array.isArray(value)) {
              variable += '.';
            }
            list.push(variable);
          }
        });
      }
    });
    return {
      list: list,
      from: CodeMirror.Pos(cur.line, cur.ch - variables[variables.length - 1].length),
      to: CodeMirror.Pos(cur.line, cur.ch)
    };
  } 
  else if (token.type === 'param-tag') {
    if (token.string === '{') {
      return {
        list: Object.keys(parameters).map(function(x) { return x + ':';}),
        from: CodeMirror.Pos(cur.line, cur.ch),
        to: CodeMirror.Pos(cur.line, cur.ch)
      };
    }
  } 
  else if (token.type === "param-value-sep") {
    list = parameters[token.state.variable] || [];
    if (token.state.variable === "fieldtype") {
      list = list.map(function(x) {
        return {
          text: doctemplate.editor.metaDataFields[x].type.toString(),
          displayText: x
        };
      });
    } 
    else if (token.state.variable === "fieldcode") {
      list = list.map(function(x) {
        return {
          text: doctemplate.editor.metaDataFields[x].code,
          displayText: x
        };
      });
    }
    else if (token.state.variable === "codealiastype") {
      list = list.map(function(x) {
        return {
          text: doctemplate.editor.codeAliasTypes[x].code,
          displayText: x
        };
      });
    }
    return {
      list: list,
      from: CodeMirror.Pos(cur.line, cur.ch),
      to: CodeMirror.Pos(cur.line, cur.ch)
    };
  } 
  else if (token.type === 'param-sep') {
    return {
      list: Object.keys(parameters).map(function(x) { return x + ':';}),
      from: CodeMirror.Pos(cur.line, cur.ch),
      to: CodeMirror.Pos(cur.line, cur.ch)
    };
  } 
  else if (token.type === 'param-name') {
    beginString = token.string.trim().toLowerCase();
    Object.keys(parameters).forEach(function(param) {
      if (param.toLowerCase().startsWith(beginString)) {
        list.push(param + ':');
      }
    });
    return {  
      list: list,
      from: CodeMirror.Pos(cur.line, cur.ch - beginString.length),
      to: CodeMirror.Pos(cur.line, cur.ch)
    };
  } 
  else if (token.type === "param-value") {
    var values = parameters[token.state.variable] || [];
    if (values) {
      beginString = token.string.trim().toLowerCase();
      values.forEach(function(param) {
        if (param.toLowerCase().startsWith(beginString)) {
          if (token.state.variable === "fieldtype" && param in doctemplate.editor.metaDataFields) {
            list.push({
              text: doctemplate.editor.metaDataFields[param].type,
              displayText: param
            });
          } 
          else if (token.state.variable === "fieldcode" && param in doctemplate.editor.metaDataFields) {
            list.push({
              text: doctemplate.editor.metaDataFields[param].code,
              displayText: param
            });
          } 
          else if (token.state.variable === "codealiastype" && param in doctemplate.editor.codeAliasTypes) {
            list.push({
              text: doctemplate.editor.codeAliasTypes[param].code,
              displayText: param
            });
          } 
          else 
            list.push(param);
        }
      });
      return {
        list: list,
        from: CodeMirror.Pos(cur.line, cur.ch - beginString.length),
        to: CodeMirror.Pos(cur.line, cur.ch)
      };
    }
  } 
  else if (!token.type || token.type === 'text') {
    return {
      list: [{
        hint: function(cm, input, par) {
          cm.replaceRange('[@]', input.from, input.to);
          cur = cm.getCursor();
          cur.ch -= 1;
          cm.setCursor(cur);
        }
      }],
      from: CodeMirror.Pos(cur.line, cur.ch),
      to: CodeMirror.Pos(cur.line, cur.ch)
    };
  }
});
</script>