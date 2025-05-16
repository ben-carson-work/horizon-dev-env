<%@page import="com.vgs.cl.JvUtils"%>
<%@page import="com.vgs.snapp.web.docproc.DocProcessorBasePDF"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="doc" class="com.vgs.web.dataobject.DOUI_DocTemplate" scope="request"/>

<script>
//# sourceURL=doctemplate_editor_dialog_js.jsp

var doctemplate = doctemplate || {};
doctemplate.editor = doctemplate.editor || {};

(function() {
  'use strict';

  const BANDTYPE_TITLE       = "title";
  const BANDTYPE_DETAIL      = "detail";
  const BANDTYPE_PAGEHEADER  = "PageHeader";
  const BANDTYPE_PAGEFOOTER  = "PageFooter";
  const BANDTYPE_GROUPHEADER = "GroupHeader";
  const BANDTYPE_GROUPFOOTER = "GroupFooter";
  
  const BAND_NAMES = []; 
  BAND_NAMES[BANDTYPE_TITLE]       = "Band title";
  BAND_NAMES[BANDTYPE_DETAIL]      = "Band detail";
  BAND_NAMES[BANDTYPE_PAGEHEADER]  = "Page header";
  BAND_NAMES[BANDTYPE_PAGEFOOTER]  = "Page footer";
  BAND_NAMES[BANDTYPE_GROUPHEADER] = "Group header";
  BAND_NAMES[BANDTYPE_GROUPFOOTER] = "Group footer";
  
  const docTemplateId = '<%=pageBase.getId()%>';
  
  var errorState = false;
  var unit = "cm";
  var fontUnit = "pt";
  var editorClipboard = null;
  var undoStack = [];
  var redoStack = [];
  var mutationsStack = [];

  var mutationsCallback = function(mutations) {
    mutations = mutations.filter(function(mutation) {
      return mutation.type !== "attributes" || mutation.attributeName.startsWith("data-");
    }).map(function(mutation) {
      if (mutation.type === "attributes") {
        mutation.newValue = $(mutation.target).attr(mutation.attributeName);
      }
      return mutation;
    });
    if (mutations.length) {
      mutationsStack = mutationsStack.concat(mutations);
      redoStack = [];
    }
  };

  var observer = new MutationObserver(mutationsCallback);
  var observerConfig = {
      "attributes": true,
      "subtree": true,
      "childList": true,
      "attributeOldValue": true
  };

  function startMutationObserver() {
    if (mutationsStack.length) {
      throw "Forgot to run stopMutationObserver()?";
    }
    observer.observe($("#page")[0], observerConfig);
  }

  function stopMutationObserver() {
    var mutations = observer.takeRecords();
    observer.disconnect();
    mutationsCallback(mutations);
    if (mutationsStack.length) {
      undoStack.push(mutationsStack);
      mutationsStack = [];
      refreshToolbar();
    }
  }

  // calculate number of pixels for 1cm
  var measureDiv = $("<div>").css({position: "absolute", width: "1cm", height: "1px", left: -1000, top: 0}).appendTo(document.body);
  var measure = measureDiv.width();
  measureDiv.remove();

  function isPrimitive(value) {
    return ["number", "boolean", "string"].indexOf(typeof value) !== -1;
  }

  function getAttrType(field, obj) {
    var result = null;
    Object.keys(obj).some(function(key) {
      if (key.toLowerCase() === field.toLowerCase()) {
        result = obj[key];
        return true;
      }
      return false;
    });
    return result;
  }

  function getAttr(field, obj) {
    var result = null;
    Object.keys(obj).some(function(key) {
      if (key.toLowerCase() === field.toLowerCase()) {
        result = {key: key, type: obj[key]};
        return true;
      }
      return false;
    });
    return result;
  }

  function attrsToJson(element) {
    var attrs = doctemplate.editor.attributes;
    var json = {};
    $.each(element.attributes, function() {
      if (this.specified && this.name.startsWith("data-")) {
        var key = this.name.substr(5);
        var value = this.value;
        var attr;
        var isBandComponent = false;
        if (element.id === "page") 
          attr = getAttr(key, attrs.DOPdfDoc);
        else if ($(element).is(".snp-band-container")) {
          if (key.startsWith("comp-")) {
            key = key.substr(5);
            isBandComponent = true;
            attr = getAttr(key, attrs.DOPdfComp);
          } 
          else 
            attr = getAttr(key, attrs.DOBand);
        } 
        else
          attr = getAttr(key, attrs.DOPdfComp);

        if (!attr) {
          attr = {
            key: key,
            type: "FtString"
          };
        }
        var ignoreAttr = false;
        if (key.startsWith("border")) {
          var color;
          var width;
          var prefix = isBandComponent ? "data-comp-" : "data-";
          if (key.indexOf("top") !== -1) {
            color = prefix + "bordertopcolor";
            width = prefix + "bordertopwidth";
          } else if (key.indexOf("right") !== -1) {
            color = prefix + "borderrightcolor";
            width = prefix + "borderrightwidth";
          } else if (key.indexOf("bottom") !== -1) {
            color = prefix + "borderbottomcolor";
            width = prefix + "borderbottomwidth";
          } else if (key.indexOf("left") !== -1) {
            color = prefix + "borderleftcolor";
            width = prefix + "borderleftwidth";
          }
          if (!$(element).attr(color) || !$(element).attr(width)) {
            ignoreAttr = true;
          }
        }
        if (attr.type === "FtFloat") {
          var decimals = value.split(".");
          if (value && decimals.length > 1 && decimals[1].length > 2) {
            value = Number(Number(value).toFixed(2));
          } else if (value !== "") {
            value = Number(value);
          }
        } else if (attr.type === "FtBoolean") {
          value = value === "true";
        }
        if (attr.key === "Text") {
          var tokens = value.split(/\n/);
          if (tokens.length !== 1) {
            value = tokens;
          }
        }
        if (value === "") {
          ignoreAttr = true;
        }
        if (!ignoreAttr) {
          if (isBandComponent) {
            if (!json.Comp) {
              json.Comp = {};
            }
            json.Comp[attr.key] = value;
          } else {
            json[attr.key] = value;
          }
        }
      }
    });
    return json;
  }
  
  const MAP_BUTTON_VIEW = {
    "#btn-view-design": "#view-design",
    "#btn-view-preview": "#view-preview",
    "#btn-view-source": "#view-source"
  };
  
  function setActiveView(buttonSelector) {
    var $btn = $(buttonSelector);
    var viewSelector = MAP_BUTTON_VIEW["#" + $btn.attr("id")];
    var $view = $(viewSelector);
    
    if (!$view.is(".view-active")) { 
      $view.addClass("view-active").siblings(".snp-editor-view").removeClass("view-active");
      $(".btn-editor-view").removeClass("active");
      $btn.addClass("active");
      refreshToolbar();
      return true;
    }
    
    return false;
  }
  
  function applySourceChangesIfNeeded() {
    if ($("#btn-view-source").is(".active")) {
      var editor = $("#source-textarea").data("cm");
      if (editor) {
        var jsonObj;
        var json = $("#source-textarea").data("cm").getValue();
        try {
          jsonObj = JSON.parse(json);
          errorState = false;
        }
        catch (err) {
          console.error(err);
          showMessage("Template parsing error");
          errorState = true;
          return;
        }
        page.fromJson(jsonObj);
      }
    }
  }
  
  function doPreview() {
    if (setActiveView("#btn-view-preview")) {
      var iframe = $("#preview_iframe")[0];
      iframe.contentWindow.document.open();
      iframe.contentWindow.document.write("");
      iframe.contentWindow.document.close();

      var json = JSON.stringify(page.toJson());
      $("#preview-json").val(json);
      $("#docproc_form").submit();
    }
  }
  
  function initToolbar() {
    var lightMode = doctemplate.editor.lightMode;
    if (lightMode) 
      $(".band-buttonset").hide();

    $("#btn-save").click(doSave);
    $("#btn-close-dialog").click(doClose);
    
    $("#btn-view-preview").click(function() {
      var $this = $(this);
      if (!$this.is(".active")) {
        applySourceChangesIfNeeded();

        $this.addClass("active").siblings().removeClass("active");

        if (doctemplate.editor.lightMode) {
          $("#insert-media-code-dialog").dialog({
            buttons: {
              "Ok": function() {
                var $form = $("form", "#insert-media-code-dialog");
                // trigger html5 validation ui
                $("<input type='submit'>").hide().appendTo($form).click().remove();
              },
              "Cancel": function() {
                $(this).dialog("close");
              }
            }
          });
          return;
        } 
        else {
          doPreview();
        }
      }
    });
    
    $("#btn-view-design").click(function() {
      applySourceChangesIfNeeded();
      setActiveView(this); 
    });
    
    $("#btn-view-source").click(function() {
      if (setActiveView(this) && !errorState) {
        // Sometimes (often with cache disabled) CodeMirror isn't initialized properly  setTimeout fixes it
        setTimeout(function() {
          var $txtArea = $("#source-textarea");
          var json = JSON.stringify(page.toJson(), null, 2);
          var editor = $txtArea.data("cm");
          
          if (editor != null)
            editor.getDoc().setValue(json);
          else {
            $txtArea.val(json);
            editor = CodeMirror.fromTextArea($txtArea[0], {
              lineNumbers: true,
              mode: {name: "javascript", json: true},
              height: "100%"
            }, 100);            
            $txtArea.data("cm", editor);
          }
          editor.refresh();
        }, 100);
      }
    });

    $("#btn-undo").click(undo);
    $("#btn-redo").click(redo);
    
    function newBandJSON(bandType) {
      return {
        "BandType": bandType,
        "Comp": {
          "Height": 2
        }
      };
    }
    
    function doAddBand(button, bandType, detail) {
      var $button = $(button);
      if ($button.attr("disabled") !== "disabled") {
        startMutationObserver();
        
        if (detail === true)
        
        if ($((detailBandType == null) || ("#page.snp-selected").length > 0))
          page.addBand(newBandJSON(pageBandType));
        else {
          var $container = $(".snp-band-container.snp-selected[data-bandtype='" + BANDTYPE_DETAIL + "']");
          if ($container.length > 0) 
            $container.data("band").addBand(newBandJSON(detailBandType));
        }
        stopMutationObserver();
      }
    }
    
    function getButtonBandType($btn) {
      const MAP = {
        "btn-addband-title":       BANDTYPE_TITLE,  
        "btn-addband-pageheader":  BANDTYPE_PAGEHEADER,  
        "btn-addband-pagefooter":  BANDTYPE_PAGEFOOTER,  
        "btn-addband-groupheader": BANDTYPE_GROUPHEADER,  
        "btn-addband-groupfooter": BANDTYPE_GROUPFOOTER,  
        "btn-addband-detail":      BANDTYPE_DETAIL  
      };
      
      var id = $btn.attr("id");
      var result = MAP[id];
      
      if (result == null)
        throw "'add band' button not handled: " + id; 
      
      return result;
    }

    $(".btn-addband").click(function() {
      var $btn = $(this);
      if ($btn.attr("disabled") !== "disabled") {
        startMutationObserver();
        try {
          var targetObject = page;
          var newBandType = getButtonBandType($btn);
          if ($btn.is(".btn-addband-detail") && !((newBandType == BANDTYPE_DETAIL) && $("#page").is(".snp-selected"))) {
            var $detail = $(".ui-selected,.snp-selected").closest(".snp-band-container[data-bandtype='" + BANDTYPE_DETAIL + "']");
            if ($detail.length == 1)
              targetObject = $detail.data("band");
          }
          
          targetObject.addBand(newBandJSON(newBandType));
        }
        finally {
          stopMutationObserver();
        }
      }
    });

    $("#btn-remove").click(function() {
      if (this.getAttribute("disabled") !== "disabled") {
        startMutationObserver();
        $(".ui-selected").detach();
        var $selected = $(".snp-selected");
        if ($selected.attr("id") !== "page") {
          if ($selected.prev().length) {
            $selected.data("prev", $selected.prev());
          } else if ($selected.next().length) {
            $selected.data("next", $selected.next());
          }
          $selected.detach();
          stopMutationObserver();
          page.onSelect();
        }
      }
    });

    var addComponent = function(type) {
      var $container = $(".snp-band-container.snp-selected");
      if ($container.length == 0)
        $container = $(".snp-component.ui-selected").closest(".snp-band-container");
      
      $('.ui-selected').removeClass('ui-selected');
      var band = ($container.length == 0) ? null : $container.data("band");
      var comp = {
          Text: "new",
          Width: 1,
          Height: 1,
          X: 0,
          Y: 0,
          Type: type
      };
      if (band) {
        startMutationObserver();
        band.addComponent(comp);
        stopMutationObserver();
      } 
      else if (lightMode) {
        startMutationObserver();
        page.addComponent(comp);
        stopMutationObserver();
      }
    };

    $('#btn-add-component').click(function() {
      if (this.getAttribute('disabled') !== 'disabled') {
        addComponent();
      }
    });

    $('#btn-add-image').click(function() {
      if (this.getAttribute('disabled') !== 'disabled') {
        addComponent('image');
      }
    });

    $('#btn-add-barcode').click(function() {
      if (this.getAttribute('disabled') !== 'disabled') {
        addComponent('barcode');
      }
    });

    $('#btn-add-sub-component').click(function() {
      if (this.getAttribute('disabled') !== 'disabled') {
        var $component = $('.snp-component.ui-selected');
        if ($component.length === 1) {
          var data = $component.data('component');
          startMutationObserver();
          data.addComponent({
            Text: 'new',
            Width: 1,
            Height: 1,
            X: 0,
            Y: 0
          });
          stopMutationObserver();
        }
      }
    });
  }

  function refreshToolbar() {
    var lightMode = doctemplate.editor.lightMode;
    $("#btn-undo").attr("disabled", undoStack.length === 0);
    $("#btn-redo").attr("disabled", redoStack.length === 0);
    $(".design-mode-only").setClass("hidden", !$("#view-design").is(".view-active"));

    var isPageSelected = $("#page.snp-selected").length > 0;
    var isPageSelectedFullMode = isPageSelected && !lightMode;
    var pageHeaderExists = $("#page-header").length > 0;
    var pageFooterExists = $("#page-footer").length > 0;
    var $container = $(".snp-band-container.snp-selected");
    var headerOrFooterIsSelected = [BANDTYPE_PAGEHEADER, BANDTYPE_PAGEFOOTER, BANDTYPE_GROUPHEADER, BANDTYPE_GROUPFOOTER].indexOf($container.attr("data-bandtype")) >= 0;
    var isBandSelected = $container.length > 0;
    var countComponents = $('.snp-component.ui-selected').length;
    var isComponentSelected = countComponents > 0;
    var isSubComponentSelected = $('.snp-component > .snp-component').length > 0;
    var titleExists = $('.snp-band-title').length !== 0;

    var differentBandsComponentsSelected = $('.snp-component.ui-selected').closest('.snp-band').length > 1;
    
    var isCompDisabled = differentBandsComponentsSelected || isPageSelectedFullMode || isSubComponentSelected;

    function _setAddBandEnabled(buttonSelector, enabled) {
      var hide = (enabled !== true);
      $(buttonSelector).setClass("hidden", hide).attr("disabled", hide);
    }
    
    var detailSelected = $(".ui-selected,.snp-selected").closest(".snp-band-container[data-bandtype='" + BANDTYPE_DETAIL + "']").length > 0;
    _setAddBandEnabled("#btn-addband-title", !titleExists);
    _setAddBandEnabled("#btn-addband-pageheader", true);
    _setAddBandEnabled("#btn-addband-pagefooter", true);
    _setAddBandEnabled("#btn-addband-groupheader", detailSelected);
    _setAddBandEnabled("#btn-addband-groupfooter", detailSelected);
    
    $('#btn-add-comp-type').attr('disabled', isCompDisabled);
    if (countComponents !== 1)
      $('#btn-add-sub-component').addClass('disabled');
    else
      $('#btn-add-sub-component').removeClass('disabled');

    $('#btn-bold').attr('disabled', isPageSelected || isBandSelected);
    $('#btn-italic').attr('disabled', isPageSelected || isBandSelected);
    $('#btn-align-left').attr('disabled', isPageSelected || isBandSelected);
    $('#btn-align-center').attr('disabled', isPageSelected || isBandSelected);
    $('#btn-align-right').attr('disabled', isPageSelected || isBandSelected);

    $('#btn-remove').attr('disabled', isPageSelected || !isBandSelected && !isComponentSelected);
  }

  var pxToCm = function(px) {
    return px / measure;
  };

  var cmToPx = function(cm) {
    return cm * measure;
  };

  var undo = function() {
    if (this.getAttribute('disabled') !== 'disabled') {
      $(".snp-selected").removeClass("snp-selected");
      $(".ui-selected").removeClass("ui-selected");
      if (undoStack.length > 0) {
        var mutations = undoStack.pop();
        redoStack.push(mutations);
        var data = page;
        mutations.forEach(function(mutation) {
          if (mutation.type === 'attributes') {
            var $target = $(mutation.target);
            $target.attr(mutation.attributeName, mutation.oldValue);
            data = $target.data('band') || $target.data('component') || page;
            if (data instanceof Component) {
              data.select();
              data = componentBulk;
            }
          } else if (mutation.type === 'childList') {
            var i = 0, $node;
            for (i = 0; i < mutation.addedNodes.length; ++i) {
              $node = $(mutation.addedNodes[i]);
              if ($node.prev().length) {
                $node.data('prev', $node.prev());
              } else if ($node.next().length) {
                $node.data('next', $node.next());
              }
              $node.detach();
            }
            for (i = 0; i < mutation.removedNodes.length; ++i) {
              $node = $(mutation.removedNodes[i]);
              var $prev = $node.data('prev');
              var $next = $node.data('next');
              if ($prev) {
                $prev.after($node);
              } else if ($next) {
                $next.before($node);
              } else {
                $node.appendTo(mutation.target);
              }
              data = $node.data('band') || $node.data('component') || page;
              if (data instanceof Component) {
                data.select();
                data = componentBulk;
              }
            }
          }
        });
        data.onSelect();
        data.reInit();
      }
      refreshToolbar();
    }
  };

  var redo = function() {
    if (this.getAttribute('disabled') !== 'disabled') {
      $(".snp-selected").removeClass("snp-selected");
      $(".ui-selected").removeClass("ui-selected");
      if (redoStack.length > 0) {
        var mutations = redoStack.pop();
        undoStack.push(mutations);
        var data = page;
        mutations.forEach(function(mutation) {
          if (mutation.type === 'attributes') {
            var $target = $(mutation.target);
            $target.attr(mutation.attributeName, mutation.newValue);
            data = $target.data('band') || $target.data('component') || page;
            if (data instanceof Component) {
              data.select();
              data = componentBulk;
            }
          } else if (mutation.type === 'childList') {
            var i = 0, $node;
            for (i = 0; i < mutation.addedNodes.length; ++i) {
              $node = $(mutation.addedNodes[i]);
              var $prev = $node.data('prev');
              var $next = $node.data('next');
              if ($prev) {
                $prev.after($node);
              } else if ($next) {
                $next.before($node);
              } else {
                $node.appendTo(mutation.target);
              }
              data = $node.data('band') || $node.data('component') || page;
              if (data instanceof Component) {
                data.select();
                data = componentBulk;
              }
            }
            for (i = 0; i < mutation.removedNodes.length; ++i) {
              $node = $(mutation.removedNodes[i]);
              $node.detach();
            }
          }
        });
        data.onSelect();
        data.reInit();
      }
      refreshToolbar();
    }
  };

  function onInputBlur(input) {
    if (!input.value && input.type === 'number' && !input.validity.valid) {
      $('#' + input.id).val(input.value);
    }
  }

  var ComponentBulk = function() {
    var attrs = doctemplate.editor.attributes;
    var $this = this;
    var onAttrChange = function() {
      if (this.id.startsWith('comp-')) {
        var key = this.id.substr(5);
        var value = this.value;
        onInputBlur(this);
        if (key === 'text') {
          value = value.replace(/\\n/g, '\n');
        }
        startMutationObserver();
        $('.ui-selected').each(function(i, div) {
          $(div).attr('data-' + key, value);
        });
        stopMutationObserver();
        $this.reInit();
      }
    };

    Object.keys(attrs.DOPdfComp).forEach(function(key) {
      var $input = $('#comp-' + key.toLowerCase());
      if ($input.length) {
        $input.change(onAttrChange).blur(function() {onInputBlur(this);});
      }
    });

    $('#btn-bold').click(function(event) {
      var $btn = $('#btn-bold');
      var isBold;
      if ($btn.is('.active')) {
        isBold = false;
      } else {
        isBold = true;
      }
      var isItalic = $('#btn-italic').is('.active');
      startMutationObserver();
      $('.ui-selected').each(function(i, div) {
        var value = '';
        if (isBold && isItalic) {
          value = 'BoldItalic';
        } else if (isBold) {
          value = 'Bold';
        } else if (isItalic) {
          value = 'Italic';
        }
        $(div).attr('data-fontstyle', value);
      });
      stopMutationObserver();
      $btn.toggleClass('active');
      componentBulk.reInit();
    });

    $('#btn-italic').click(function(event) {
      var $btn = $('#btn-italic');
      var isItalic;
      if ($btn.is('.active')) {
        isItalic = false;
      } else {
        isItalic = true;
      }
      var isBold = $('#btn-bold').is('.active');
      startMutationObserver();
      $('.ui-selected').each(function(i, div) {
        var value = '';
        if (isBold && isItalic) {
          value = 'BoldItalic';
        } else if (isBold) {
          value = 'Bold';
        } else if (isItalic) {
          value = 'Italic';
        }
        $(div).attr('data-fontstyle', value);
      });
      stopMutationObserver();
      $btn.toggleClass('active');
      componentBulk.reInit();
    });

    var onAlignAttrChange = function(event) {
      var $btn = $(this);
      if (!$btn.is('.active')) {
        $btn.addClass("active").siblings(".align-group").removeClass("active");

        var id = $btn.attr('id');
        var value = '';
        if (id === 'btn-align-center') {
          value = 'Center';
        } else if (id === 'btn-align-right') {
          value = 'Right';
        } else {
          value = 'Left';
        }
        startMutationObserver();
        $('.ui-selected').each(function(i, div) {
          $(div).attr('data-alignment', value);
        });
        stopMutationObserver();
        componentBulk.reInit();
      }
    };

    $('#btn-align-left').click(onAlignAttrChange);
    $('#btn-align-center').click(onAlignAttrChange);
    $('#btn-align-right').click(onAlignAttrChange);
  };

  ComponentBulk.prototype.reInit = function() {
    $('.ui-selected').each(function() {
      $(this).data('component').reInit();
    });
  };

  ComponentBulk.prototype.toInspector = function() {
    var attrs = doctemplate.editor.attributes;
    var $selected = $('.ui-selected');
    $('#comp-bulk-count').val($selected.length);

    $('.snp-barcode').hide();

    var $first = $selected.first();
    Object.keys(attrs.DOPdfComp).forEach(function(key) {
      var $input = $('#comp-' + key.toLowerCase());
      if ($input.length) {
        var value = '';
        if ($first) {
          value = $first.attr('data-' + key) || '';
        }
        var type = getAttrType(key, attrs.DOPdfComp);
        if (type === 'FtFloat' && value) {
          var decimals = value.split('.');
          if (decimals.length > 1 && decimals[1].length > 2) {
            value = Number(value).toFixed(2);
          }
        }
        if (!value && $input.attr('type') === 'color') {
          if (key === 'FontColor') {
            value = '#000001';
          } else {
            value = '#fffffe';
          }
        }
        if (key === 'Text') {
          value = value.replace(/\n/g, '\\n');
        }
        if (key === 'Type' && !value) {
          value = 'text';
        }
        $input.val(value);
      }
    });

    $selected.each(function(i, div) {
      Object.keys(attrs.DOPdfComp).forEach(function(key) {
        var $input = $('#comp-' + key.toLowerCase());
        if ($input.length) {
          var value = $input.val();
          var type = getAttrType(key, attrs.DOPdfComp);
          var anotherValue = $(div).attr('data-' + key) || '';
          if (type === 'FtFloat' && anotherValue) {
            var decimals = anotherValue.split('.');
            if (decimals.length > 1 && decimals[1].length > 2) {
              anotherValue = Number(anotherValue).toFixed(2);
            }
          }
          if (key === 'Text') {
            anotherValue = anotherValue.replace(/\n/g, '\\n');
          }
          if (key === 'Type' && !anotherValue) {
            anotherValue = 'text';
          }
          if (!anotherValue && $input.attr('type') === 'color') {
            if (key === 'FontColor') {
              anotherValue = '#000001';
            } else {
              anotherValue = '#fffffe';
            }
          }
          if (anotherValue !== value) {
            anotherValue = '';
            if ($input.attr('type') === 'color') {
              if (key === 'FontColor') {
                anotherValue = '#000001';
              } else {
                anotherValue = '#fffffe';
              }
            }
          }

          $input.val(anotherValue);
        }
      });
    });

    $('#btn-bold').removeClass('active');
    $('#btn-italic').removeClass('active');
    $('#btn-align-left').removeClass('active');
    $('#btn-align-center').removeClass('active');
    $('#btn-align-right').removeClass('active');
    var fontStyle = $first.attr('data-fontstyle');
    if (fontStyle) {
      fontStyle = fontStyle.toLowerCase();
    }
    var isBold = fontStyle && fontStyle.startsWith('bold');
    var isItalic = fontStyle && fontStyle.indexOf('italic') !== -1;
    var alignment = $first.attr('data-alignment');
    if (alignment) {
      alignment = alignment.toLowerCase();
    }
    var isLeftAlignment = !alignment || alignment === 'left';
    var isCenterAlignment = alignment === 'center';
    var isRightAlignment = alignment === 'right';
    $selected.each(function(i, div) {
      fontStyle = $(div).attr('data-fontstyle');
      if (fontStyle) {
        fontStyle = fontStyle.toLowerCase();
      }
      var newIsBold = fontStyle && fontStyle.startsWith('bold');
      isBold = isBold && newIsBold;
      var newIsItalic = fontStyle && fontStyle.indexOf('italic') !== -1;
      isItalic = isItalic && newIsItalic;
      alignment = $(div).attr('data-alignment');
      if (alignment) {
        alignment = alignment.toLowerCase();
      }
      var newIsLeftAlignment = !alignment || alignment === 'left';
      isLeftAlignment = isLeftAlignment && newIsLeftAlignment;
      var newIsCenterAlignment = alignment === 'center';
      isCenterAlignment = isCenterAlignment && newIsCenterAlignment;
      var newIsRightAlignment = alignment === 'right';
      isRightAlignment = isRightAlignment && newIsRightAlignment;
    });
    if (isBold) {
      $('#btn-bold').addClass('active');
    }
    if (isItalic) {
      $('#btn-italic').addClass('active');
    }
    if (isLeftAlignment) {
      $('#btn-align-left').addClass('active');
    } else if (isCenterAlignment) {
      $('#btn-align-center').addClass('active');
    } else if (isRightAlignment) {
      $('#btn-align-right').addClass('active');
    }
    $('.snp-image-property').hide();
    $('.snp-resizestyle-property').hide();
    $('.snp-text-property').show();
    var type = $('#comp-type').val();
    if (type === 'barcode') {
      $('.snp-barcode').show();
    } else if (type === 'image') {
      $('.snp-image-property').show();
      $('.snp-resizestyle-property').show();
      $('.snp-text-property').hide();
    }

    var repository = $('#comp-text').val() || '';
    repository = repository.toLowerCase();
    $('#comp-image').val(repository);
  };

  ComponentBulk.prototype.onSelect = function() {
    $(":focus").blur();
    $('.snp-selected').removeClass('snp-selected');
    $('.snp-section').hide();
    $('.snp-comp-properties').show();

    this.toInspector();
    refreshToolbar();
  };

  var componentBulk = new ComponentBulk();

  var page = {};
  page.init = function() {
    var initJson = {
      PageWidth: 21,
      PageHeight: 29.7,
      MarginTop: 0,
      MarginBottom: 0,
      MarginLeft: 0,
      MarginRight: 0,
      UnitOfMeasure: "cm"
    };

    $('#page').selectable({
      filter: '.snp-component',
      distance: 10,
      stop: function () {
        componentBulk.onSelect();
      }
    });

    var onAttrChange = function() {
      if (this.id.startsWith('page-')) {
        var key = this.id.substr(5);
        onInputBlur(this);
        startMutationObserver();
        $('#page').attr('data-' + key, this.value);
        stopMutationObserver();
        page.reInit();
      }
    };

    var attrs = doctemplate.editor.attributes;
    Object.keys(attrs.DOPdfDoc).forEach(function(key) {
      var $input = $('#page-' + key.toLowerCase());
      if ($input.length) {
        $input.change(onAttrChange).blur(function() { onInputBlur(this);});
      }
    });


    this.titleDiv = $('#page > .snp-title').click(this.onSelect);
    this.bodyDiv = $('#page > .snp-body');
    this.initDropListener();

    this.keyboardListeners();
    this.fromJson(initJson);
    
    $(document).keydown(function(ctrlEvent) {
      if (ctrlEvent.ctrlKey) {
        $(document).off('wheel').on('wheel', function(event) {
          if (event.ctrlKey) {
            var e  = event.originalEvent;
            if (e.deltaY < 0) {
              zoom.next();
            } else if (e.deltaY > 0) {
              zoom.previous();
            }
            event.preventDefault();
          }
        });
      }
    });
  };

  page.initDropListener = function() {
    var lightMode = doctemplate.editor.lightMode;
    if (lightMode) {
      $('#page > .snp-body').droppable({
        drop: function(event, ui) {
          if (ui.draggable.is('.leaf')) {
            var $page = $('#page > .snp-body');
            var variable = ui.draggable.attr('data-name');
            var component = {
                Text: variable
            };
            var type = ui.draggable.attr('data-type');
            if (type === 'Image') {
              component.type = 'image';
            } else if (type === 'Barcode') {
              component.type = 'barcode';
            } else if (type === 'MetaField') {
              var text = variable.substring(0, variable.length - 1);
              var code = ui.draggable.attr('data-metafieldcode');
              text += ' {fieldcode:{0}}]'.format(code);
              component.Text = text;
            }
            var x = event.pageX - $page.offset().left;
            var y = event.pageY - $page.offset().top;
            component.X = pxToCm(x);
            component.Y = pxToCm(y);
            page.addComponent(component);
          }
        }
      });
    }
  };

  page.toInspector = function() {
    var page = $('#page').get(0);
    $.each(page.attributes, function() {
      if (this.specified && this.name.startsWith('data-')) {
        var key = this.name.substr(5);
        $('#page-' + key).val(this.value);
      }
    });
  };

  page.reInit = function() {
    var $page = $('#page');

    var marginTop = strToIntDef($page.attr("data-margintop"), 0);
    var marginRight = strToIntDef($page.attr("data-marginright"), 0);
    var marginBottom = strToIntDef($page.attr("data-marginbottom"), 0);
    var marginLeft = strToIntDef($page.attr("data-marginleft"), 0);
    var width = strToIntDef($page.attr("data-pagewidth"), 0);
    var height = strToIntDef($page.attr("data-pageheight"), 0);

    $page.css("margin-top", marginTop + unit);
    $page.css("margin-right", marginRight + unit);
    $page.css("margin-bottom", marginBottom + unit);
    $page.css("margin-left", marginLeft + unit);
    $page.css("width", width - marginLeft - marginRight + unit);
    $page.css("height", height - marginTop - marginBottom + unit);

    ruler('#ruler-h');
    ruler('#ruler-v', true);

    var defaultFontSize = $page.attr('data-defaultfontsize');
    $('.snp-component').each(function() {
      if (!$(this).attr('data-fontSize')) {
        $(this).css('font-size', defaultFontSize + fontUnit);
      }
    });
  };

  page.toJson = function() {
    var json = {};
    var el = $('#page').get(0);
    json = attrsToJson(el);

    page.bodyDiv.children('.snp-band-container').each(function() {
      var bandJson = $(this).data('band').toJson();
      if (!json.BandList) {
        json.BandList = [];
      }
      json.BandList.push(bandJson);
    });

    page.bodyDiv.children('.snp-component').each(function() {
      var compJson = $(this).data('component').toJson();
      if (!json.CompList) {
        json.CompList = [];
      }
      json.CompList.push(compJson);
    });

    return json;
  };

  page.fromJson = function(json) {
    var lightMode = doctemplate.editor.lightMode;
    Object.keys(json).forEach(function(key) {
      var value = json[key];
      if (isPrimitive(value)) {
        $('#page').attr('data-' + key, value);
      }
    });

    this.title = json.Title;
    $('#page-title').val(json.Title);
    $('#page-width').val(json.PageWidth);
    $('#page-height').val(json.PageHeight);
    $('#margin-top').val(json.MarginTop);
    $('#margin-right').val(json.MarginRight);
    $('#margin-bottom').val(json.MarginBottom);
    $('#margin-left').val(json.MarginLeft);
    $('#page-font-size').val(json.DefaultFontSize);
    $('#page-includepageheader').val(json.IncludePageHeader);
    $('#page-includepagefooter').val(json.IncludePageFooter);
    this.unitOfMeasure = json.UnitOfMeasure;
    $('#page > .snp-body').empty();
    var jsonComponent;
    var i, j, k;

    if (json.BandList) {
      for (i = 0; i < json.BandList.length; ++i) 
        this.addBand(json.BandList[i]);
    }
    
    if (lightMode && json.CompList) {
      for (i = 0; i < json.CompList.length; ++i) 
        page.addComponent(json.CompList[i]);
    }
    
    this.onSelect();
    this.reInit();
  };

  page.onSelect = function() {
    $(":focus").blur();
    $(".ui-selected").removeClass("ui-selected");
    $(".snp-selected").removeClass("snp-selected");
    $(".snp-section").hide();
    $(".snp-page-properties").show();
    $("#page").addClass("snp-selected");
    refreshToolbar();
    page.toInspector();
  };

  page.addBand = function(json) {
    const BAND_SORTING = [
      BANDTYPE_TITLE,
      BANDTYPE_PAGEHEADER,
      BANDTYPE_DETAIL,
      BANDTYPE_PAGEFOOTER
    ];
    
    var band = new Band(json);
    var $band = band.container;
    
    var newBandSortingIndex = BAND_SORTING.findIndex(bandType => bandType.toLowerCase() === json.BandType.toLowerCase());
    if (newBandSortingIndex < 0)
      throw "Band type not handled: " + json.BandType;
    
    var found = false;
    if (!found) {
      for (var i=newBandSortingIndex; i>=0; i--) {
        var $after = $("#page>.snp-band-container[data-bandtype='" + BAND_SORTING[i] + "']").last();
        if ($after.length > 0) {
          $after.after($band);
          found = true;
          break;
        }
      }
    }

    if (!found) {
      for (var i=newBandSortingIndex+1; i<BAND_SORTING.length; i++) {
        var $before = $("#page>.snp-band-container[data-bandtype='" + BAND_SORTING[i] + "']").first();
        if ($before.length > 0) {
          $before.before($band);
          found = true;
          break;
        }
      }
    }
    
    if (!found)
      page.bodyDiv.append($band);
    
    band.refreshTitle();
    band.onSelect();
    return band;
  };

  page.addComponent = function(json) {
    var $body = $("#page > .snp-body");
    var component = new Component(json);
    component.div.appendTo($body);
    $(".ui-selected").removeClass("ui-selected");
    component.select();
    componentBulk.onSelect();
    return component;
  };

  page.keyboardListeners = function() {
    $(window).keypress(function(event) {
      var tag = event.target.tagName.toLowerCase();
      if (tag !== 'input' && tag !== 'textarea') {
        var ch = String.fromCharCode(event.which);
        switch (ch) {
          case 'b':
            if ($('input:focus').length === 0 && !$('#btn-add-band').prop('disabled')) {
              $('#btn-add-band').click();
            }
            break;
          case 'a':
            if ($('input:focus').length === 0 && !$('#btn-add-component').prop('disabled')) {
             $('#btn-add-component').click();
            }
            break;
        }
      }
    }).keydown(function(event) {
      var tag = event.target.tagName.toLowerCase();
      if ($(event.target).closest(".snp-property-value").length > 0) {
        if ((event.keyCode == KEY_DOWN) || (event.keyCode == KEY_UP)) {
          event.preventDefault();
          var $props = $(event.target).closest(".ui-tabs-panel").find(":focusable");
          var idx = $props.index(event.target);
          if ((event.keyCode == KEY_UP) && (idx > 0)) 
            $($props[idx - 1]).focus();
          else if ((event.keyCode == KEY_DOWN) && (idx < $props.length - 1)) 
            $($props[idx + 1]).focus();
        }
      }
      else if (tag !== 'input' && tag !== 'textarea') {
        if (event.ctrlKey && !event.shiftKey) {
          if (event.keyCode === KEY_CHAR_B && !$('#btn-bold').prop('disabled')) 
            $('#btn-bold').click();
          else if (event.keyCode === KEY_CHAR_I && !$('#btn-italic').prop('disabled')) 
            $('#btn-italic').click();
          else if (event.keyCode === KEY_CHAR_Z && undoStack.length > 0) 
            $('#btn-undo').click();
          else if (event.keyCode === KEY_CHAR_Y && redoStack.length > 0) 
            $('#btn-redo').click();
          else if (event.keyCode === KEY_CHAR_C)
            editorClipboard = $(".snp-component.ui-selected");
          else if (event.keyCode === KEY_CHAR_V && editorClipboard != null) {
            startMutationObserver();
            $(".snp-component.ui-selected").removeClass("ui-selected");
            editorClipboard.each(function(idx, elem) {
              var band = $(elem).closest(".snp-band-container").data("band");
              var json = $(elem).data("component").toJson();
              json.X += 0.1;
              json.Y += 0.1;
              band.addComponent(json).div.addClass("ui-selected");
            });
            stopMutationObserver();
          }
        }
        var step = 1;
        if (event.ctrlKey) {
          step = 5;
        }
        if ([KEY_UP, KEY_RIGHT, KEY_DOWN, KEY_LEFT, KEY_DELETE].indexOf(event.keyCode) !== -1) {
          if (event.keyCode === KEY_DELETE) {
            if (!$("#btn-remove").prop("disabled")) 
              $("#btn-remove").click();
          } else {
            $(".ui-selected").each(function() {
              var $el = $(this).data("component").div;
              var width, height, top, left;
              startMutationObserver();
              if (event.shiftKey) {
                if (event.keyCode === KEY_UP) {
                  height = $el.attr("data-height") || 1;
                  height = Math.max(0, cmToPx(height) - step);
                  height = pxToCm(height);
                  $el.attr("data-height", height);
                }
                else if (event.keyCode === KEY_RIGHT) {
                  width = $el.attr("data-width") || 1;
                  width = cmToPx(width) + step;
                  width = pxToCm(width);
                  $el.attr("data-width", width);
                }
                else if (event.keyCode === KEY_DOWN) {
                  height = $el.attr("data-height") || 1;
                  height = Math.max(0, cmToPx(height) + step);
                  height = pxToCm(height);
                  $el.attr("data-height", height);
                }
                else if (event.keyCode === KEY_LEFT) {
                  width = $el.attr("data-width") || 1;
                  width = cmToPx(width) - step;
                  width = pxToCm(width);
                  $el.attr("data-width", width);
                }
              }
              else if (event.keyCode === KEY_UP) {
                top = $el.attr("data-y") || 0;
                top = Math.max(0, cmToPx(top) - step);
                top = pxToCm(top);
                $el.attr("data-y", top);
              }
              else if (event.keyCode === KEY_RIGHT) {
                left = $el.attr("data-x") || 0;
                left = cmToPx(left) + step;
                left = pxToCm(left);
                $el.attr("data-x", left);
              }
              else if (event.keyCode === KEY_DOWN) {
                top = $el.attr("data-y") || 0;
                top = Math.max(0, cmToPx(top) + step);
                top = pxToCm(top);
                $el.attr("data-y", top);
              }
              else if (event.keyCode === KEY_LEFT) {
                left = $el.attr("data-x") || 0;
                left = cmToPx(left) - step;
                left = pxToCm(left);
                $el.attr("data-x", left);
              }
            });
          }
          stopMutationObserver();
          componentBulk.toInspector();
          componentBulk.reInit();
          event.preventDefault();
        }
      }
    });
  };

  var Band = function(json) {
    json = json || {};

    this.title = $("<div class='snp-title'/>");
    this.body = $("<div class='snp-body'/>");
    this.band = $("<div class='snp-band'/>").append(this.body);
    this.container = $("<div class='snp-band-container'/>").append(this.title).append(this.band);
    this.container.addClass("snp-band-" + json.BandType.toLowerCase());
    this.title.click(this.onSelect.bind(this));
    this.container.click(this.onSelect.bind(this));

    var $container = this.container;
    $container.data("band", this);

    Object.keys(json).forEach(function(key) {
      var value = json[key];
      if (isPrimitive(value)) {
        $container.attr("data-" + key, value);
      } else if (key === "Comp") {
        Object.keys(json[key]).forEach(function(compKey) {
          var compValue = json[key][compKey];
          if (isPrimitive(compValue)) {
            $container.attr("data-comp-" + compKey, compValue);
          }
        });
      }
    });

    if (json.CompList) {
      for (var i=0; i<json.CompList.length; i++) 
        this.addComponent(json.CompList[i]);
    }

    if (json.BandList) {
      for (var i=0; i<json.BandList.length; i++) 
        this.addBand(json.BandList[i]);
    }
    
    this.refreshTitle();
    this.initDropListener();
    this.reInit();
  };
  
  Band.prototype.refreshTitle = function() {
    var $container = this.container;
    var title = BAND_NAMES[$container.attr("data-bandtype")];
    var $title = $container.find(".snp-title").first().text(title);
    
    var indent = $container.parents(".snp-band-container").length;
    if (indent > 0) {
      $title.prepend("<i class='fa fa-angle-right'></i>&nbsp;")
      for (var i=0; i<indent; i++)
        $title.prepend("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    }
    
    $container.find(".snp-band-container").each(function(index, elem) {
      $(elem).data("band").refreshTitle();
    });
  };

  Band.prototype.initDropListener = function() {
    var lightMode = doctemplate.editor.lightMode;
    if (!lightMode) {
      var $this = this;
      this.body.droppable({
        drop: function(event, ui) {
          if (ui.draggable.is('.leaf')) {
            var variable = ui.draggable.attr('data-name');
            var component = {
                Text: variable
            };
            var x = event.pageX - $this.body.offset().left;
            var y = event.pageY - $this.body.offset().top;
            component.X = pxToCm(x);
            component.Y = pxToCm(y);
            $this.addComponent(component);
          }
        }
      });
    }
  };

  Band.prototype.toJson = function() {
    var json = attrsToJson(this.container.get(0));

    json.CompList = [];
    this.body.find(".snp-component").each(function(index, elem) {
      json.CompList.push($(elem).data('component').toJson());
    });

    json.BandList = [];
    this.container.children(".snp-band-container").each(function(index, elem) {
      json.BandList.push($(elem).data("band").toJson());
    });

    return json;
  };

  Band.prototype.onSelect = function() {
    event.stopPropagation();

    var attrs = doctemplate.editor.attributes;
    $(":focus").blur();
    $(".ui-selected").removeClass("ui-selected");
    $(".snp-selected").removeClass("snp-selected");
    $(".snp-section").hide();
    $(".snp-band-properties").show();
    this.container.addClass("snp-selected");

    var $this = this;

    var onAttrChange = function() {
      if (this.id.startsWith('band-')) {
        var key = this.id.substr(5);
        var type = getAttrType(key, attrs.DOBand);
        if (key.startsWith('comp-')) {
          var compKey = key.substr(5);
          type = getAttrType(compKey, attrs.DOPdfComp);
        }
        var value = this.value;
        if (type === 'FtBoolean') {
          value = this.checked;
        }
        onInputBlur(this);
        startMutationObserver();
        $this.container.attr('data-' + key, value);
        stopMutationObserver();
        $this.reInit();
      }
    };

    Object.keys(attrs.DOBand).forEach(function(key) {
      var $input = $('#band-' + key.toLowerCase()).val('').prop('checked', false);
      if ($input.length) {
        $input.off('change').on('change', onAttrChange).off('blur').on('blur', function() { onInputBlur(this);});
      }
    });

    Object.keys(attrs.DOPdfComp).forEach(function(key) {
      var $input = $('#band-comp-' + key.toLowerCase()).prop('checked', false);
      if ($input.attr('type') === 'color') {
        $input.val('#fffffe');
      } else {
        $input.val('');
      }
      if ($input.length) {
        $input.off('change').on('change', onAttrChange).off('blur').on('blur', onInputBlur);
      }
    });

    refreshToolbar();
    this.toInspector();
  };

  Band.prototype.toInspector = function() {
    var attrs = doctemplate.editor.attributes;
    var el = this.container.get(0);
    $.each(el.attributes, function() {
      if (this.specified && this.name.startsWith("data-")) {
        var key = this.name.substr(5);
        var type = getAttrType(key, attrs.DOBand);
        if (key.startsWith("comp-")) {
          var compKey = key.substr(5);
          type = getAttrType(compKey, attrs.DOPdfComp);
        }
        var $input = $("#band-" + key);
        if (type === "FtBoolean") {
          var value = this.value === "true";
          $input.prop("checked", value);
        } else {
          $input.val(this.value);
        }
      }
    });
  };

  Band.prototype.reInit = function() {
    var height = this.container.attr('data-comp-height');
    this.body.css('height', height + unit);

    var bg = this.container.attr('data-comp-backgroundcolor');
    if (bg) {
      this.body.css('background-color', bg);
    } else {
      this.body.css('background-color', 'transparent');
    }

    var width = this.container.attr('data-comp-bordertopwidth');
    var color = this.container.attr('data-comp-bordertopcolor');
    if (width && color) {
      this.body.css('border-top', '{0}px solid {1}'.format(width * 2, color));
    } else {
      this.body.css('border-top', '');
    }

    width = this.container.attr('data-comp-borderrightwidth');
    color = this.container.attr('data-comp-borderrightcolor');
    if (width && color) {
      this.body.css('border-right', '{0}px solid {1}'.format(width * 2, color));
    } else {
      this.body.css('border-right', '');
    }

    width = this.container.attr('data-comp-borderbottomwidth');
    color = this.container.attr('data-comp-borderbottomcolor');
    if (width && color) {
      this.body.css('border-bottom', '{0}px solid {1}'.format(width * 2, color));
    } else {
      this.body.css('border-bottom', '');
    }

    width = this.container.attr('data-comp-borderleftwidth');
    color = this.container.attr('data-comp-borderleftcolor');
    if (width && color) {
      this.body.css('border-left', '{0}px solid {1}'.format(width * 2, color));
    } else {
      this.body.css('border-left', '');
    }
  };

  Band.prototype.addBand = function(json) {
    var childBand = new Band(json);

    if (childBand.container.attr("data-bandtype") == BANDTYPE_GROUPHEADER) 
      this.band.before(childBand.container);
    else 
      this.container.append(childBand.container);

    childBand.refreshTitle();
    childBand.onSelect();
    return childBand;
  };

  Band.prototype.addComponent = function(json) {
    var component = new Component(json);
    component.div.appendTo(this.body);
    component.select();
    componentBulk.onSelect();
    return component;
  };

  var PageHeader = function(json) {
    Band.call(this, json);
    this.container.attr('id', 'page-header');
  };

  PageHeader.prototype = Object.create(Band.prototype);
  PageHeader.prototype.constructor = PageHeader;

  var PageFooter = function(json) {
    Band.call(this, json);
    this.container.attr('id', 'page-footer');
  };

  PageFooter.prototype = Object.create(Band.prototype);
  PageFooter.prototype.constructor = PageFooter;

  var GroupHeader = function(json) {
    Band.call(this, json);
  };
  GroupHeader.prototype = Object.create(Band.prototype);
  GroupHeader.prototype.constructor = GroupHeader;

  var GroupFooter = function(json) {
    Band.call(this, json);
  };
  GroupFooter.prototype = Object.create(Band.prototype);
  GroupFooter.prototype.constructor = GroupFooter;

  var Component = function(json) {
    json = json || {};
    this.div = $('<div>');

    if (json.CompList) {
      this.compList = [];
      for (var i = 0; i < json.CompList.length; ++i) {
        this.addComponent(json.CompList[i]);
      }
    }

    this.div.data('component', this);
    this.textDiv = $('<div>').addClass('snp-text').appendTo(this.div);
    if (Array.isArray(json.Text)) {
      json.Text = json.Text.join('\n');
    }

    var $component = this.div;
    Object.keys(json).forEach(function(key) {
      var value = json[key];
      if (isPrimitive(value)) {
        $component.attr('data-' + key, value);
      }
    });
    this.reInit();

    var $this = this;
    this.div.addClass('snp-component').click(function(e) {
      if ($(this).is('.snp-noclick')) {
        $(this).removeClass('snp-noclick');
      } else {
        if (!e.ctrlKey) {
          $('.ui-selected').removeClass('ui-selected');
          $this.div.addClass('ui-selected');
        } else {
          if ($('.ui-selected').length > 1 && $this.div.is('.ui-selected')) {
            $this.div.removeClass('ui-selected');
          } else {
            $this.div.addClass('ui-selected');
          }
        }
        componentBulk.onSelect();
      }
      // this one is needed to select subcomponents of components
      e.stopPropagation();
    });
    this.div.draggable({
      distance: 5,
      start: function(event, ui) {
        if (ui.helper.is('.ui-selected')) {
          $('.ui-selected').each(function() {
            var position = $(this).position();
            $(this).data('original-left', position.left).data('original-top', position.top);
          });
        } else {
          $('.ui-selected').removeClass('ui-selected');
          ui.helper.addClass('ui-selected');
        }
        ui.helper.addClass('snp-noclick');
        startMutationObserver();
      },
      drag: function(event, ui) {
        ui.position.left *= zoom.factor();
        ui.position.top *= zoom.factor();

        // containment = parent
        if (ui.position.left < 0) {
          ui.position.left = 0;
        }
        if (ui.position.top < 0) {
          ui.position.top = 0;
        }
        var width = ui.helper.outerWidth();
        var parentWidth = ui.helper.parent().width();
        if (ui.position.left > parentWidth - width) {
          ui.position.left = parentWidth - width;
        }
        var height = ui.helper.outerHeight();
        var parentHeight = ui.helper.parent().height();
        if (ui.position.top > parentHeight - height) {
          ui.position.top = parentHeight - height;
        }

        var dx = (ui.position.left / zoom.factor() - ui.originalPosition.left);
        var dy = (ui.position.top / zoom.factor() - ui.originalPosition.top);

        $('.ui-selected').each(function() {
          if ($(this).get(0) != ui.helper.get(0)) {
            var originalLeft = $(this).data('original-left');
            var originalTop = $(this).data('original-top');
            var left = (originalLeft + dx) * zoom.factor();
            var top = (originalTop + dy) * zoom.factor();
            $(this).css('left', left).css('top', top);
          }
        });

      },
      stop: function(event, ui) {
        var left = pxToCm(ui.helper.position().left * zoom.factor());
        var top = pxToCm(ui.helper.position().top * zoom.factor());
        ui.helper.attr('data-x', left);
        ui.helper.attr('data-y', top);
        var originalLeft = ui.helper.attr('data-x');
        var originalTop = ui.helper.attr('data-y');
        var dx = (ui.position.left / zoom.factor() - ui.originalPosition.left);
        var dy = (ui.position.top / zoom.factor() - ui.originalPosition.top);
        $('.ui-selected').each(function() {
          if ($(this).get(0) != ui.helper.get(0)) {
            var originalLeft = $(this).data('original-left');
            var originalTop = $(this).data('original-top');
            var left = pxToCm((originalLeft + dx) * zoom.factor());
            var top = pxToCm((originalTop + dy) * zoom.factor());
            $(this).attr('data-x', left).attr('data-y', top);
          }
        });
        stopMutationObserver();
        componentBulk.onSelect();
        componentBulk.reInit();
      }
    }).resizable({
      minWidth: 0,
      minHeight: 0,
      handles : 'n, e, s, w, ne, se, sw, nw',
      start: function() {
        $('.ui-selected').removeClass('ui-selected');
        $this.div.addClass('ui-selected');
        startMutationObserver();
      },
      resize: function(event, ui) {
        var originalWidth = $this.div.attr('data-width') || 1;
        originalWidth = cmToPx(originalWidth);
        var dx = ui.size.width - ui.originalSize.width;
        if (dx !== 0) {
          ui.size.width = originalWidth + dx * zoom.factor();
          ui.originalSize.width = originalWidth;

          if (ui.size.width < 2) {
            ui.size.width = 2; // min-width
          }
          if (ui.originalPosition.left !== ui.position.left) {
            dx = ui.position.left - ui.originalPosition.left;
            ui.position.left = ui.originalPosition.left + dx * zoom.factor();
          }
        }

        var originalHeight = $this.div.attr('data-height') || 1;
        originalHeight = cmToPx(originalHeight);
        var dy = ui.size.height - ui.originalSize.height;
        if (dy !== 0) {
          ui.size.height = originalHeight + dy * zoom.factor();
          ui.originalSize.height = originalHeight;

          if (ui.size.height < 2) {
            ui.size.height = 2; // min-height
          }
          if (ui.originalPosition.top !== ui.position.top) {
            dy = ui.position.top - ui.originalPosition.top;
            ui.position.top = ui.originalPosition.top + dy * zoom.factor();
          }
        }
      },
      stop: function(event, ui) {
        if (ui.originalSize.width !== ui.size.width) {
          var originalWidthCm = $this.div.attr('data-width') || 1;
          var dx = ui.size.width - ui.originalSize.width;
          var width = pxToCm(cmToPx(originalWidthCm) + dx);
          $this.div.attr('data-width', width);
        }
        if (ui.originalSize.height !== ui.size.height) {
          var originalHeightCm = $this.div.attr('data-height') || 1;
          var dy = ui.size.height - ui.originalSize.height;
          var height = pxToCm(cmToPx(originalHeightCm) + dy);
          $this.div.attr('data-height', height);
        }

        if (ui.originalPosition.left !== ui.position.left) {
          var originalLeft = ui.helper.attr('data-x');
          var left = pxToCm(ui.position.left);
          ui.helper.attr('data-x', left);
        }
        if (ui.originalPosition.top !== ui.position.top) {
          var originalTop = ui.helper.attr('data-y');
          var top = pxToCm(ui.position.top);
          ui.helper.attr('data-y', top);
        }

        stopMutationObserver();
        componentBulk.onSelect();
        componentBulk.reInit();
      }
    }).dblclick(function() {
      $('#comp-text-btn').click();
    });
  };

  Component.prototype.select = function() {
    this.div.addClass('ui-selected');
  };

  Component.prototype.reInit = function() {
    var width = this.div.attr('data-width') || 1;
    this.div.css('width', cmToPx(width));

    var height = this.div.attr('data-height') || 1;
    this.div.css('height', cmToPx(height));

    var type = this.div.attr('data-type');
    var showText = true;
    if (type && type.toLowerCase() === 'image') {
      var code = this.div.attr('data-text');
      if (code) {
        var id = repositoryMap[code.toLowerCase()];
        if (id) {
          this.div.css('background-image', 'url("repository?id={0}")'.format(id));
          showText = false;
        }
      }
      if (showText) {
        this.div.css('background-image', 'none');
      }
    }
    if (showText) {
      var text = this.div.attr('data-text');
      if (text) {
        text = text.replace(/\n/g, '<br>').replace(/\s\s/g, '&nbsp;&nbsp;');
      }
      this.textDiv.html(text);
    }

    var defaultFontSize = $('#page').data('data-defaultfontsize');
    var fontSize = this.div.attr('data-fontsize') || defaultFontSize || 10;
    this.div.css('font-size', fontSize + fontUnit);

    var fontColor = this.div.attr('data-fontcolor') || '';
    this.div.css('color', fontColor);

    var top = this.div.attr('data-y') || 0;
    this.div.css('top', cmToPx(top));

    var left = this.div.attr('data-x') || 0;
    this.div.css('left', cmToPx(left));

    var bg = this.div.attr('data-backgroundcolor');
    if (bg) {
      this.div.css('background-color', bg);
    } else {
      this.div.css('background-color', 'transparent');
    }

    width = this.div.attr('data-bordertopwidth');
    var color = this.div.attr('data-bordertopcolor');
    if (width && color) {
      this.div.css('border-top', '{0}px solid {1}'.format(width * 2, color));
    } else {
      this.div.css('border-top', '');
    }

    width = this.div.attr('data-borderrightwidth');
    color = this.div.attr('data-borderrightcolor');
    if (width && color) {
      this.div.css('border-right', '{0}px solid {1}'.format(width * 2, color));
    } else {
      this.div.css('border-right', '');
    }

    width = this.div.attr('data-borderbottomwidth');
    color = this.div.attr('data-borderbottomcolor');
    if (width && color) {
      this.div.css('border-bottom', '{0}px solid {1}'.format(width * 2, color));
    } else {
      this.div.css('border-bottom', '');
    }

    width = this.div.attr('data-borderleftwidth');
    color = this.div.attr('data-borderleftcolor');
    if (width && color) {
      this.div.css('border-left', '{0}px solid {1}'.format(width * 2, color));
    } else {
      this.div.css('border-left', '');
    }

    var fontStyle = this.div.attr('data-fontstyle');
    if (fontStyle) {
      fontStyle = fontStyle.toLowerCase();
    }
    var isBold = fontStyle && fontStyle.startsWith('bold');
    if (isBold) {
      this.div.css('font-weight', 'bold');
    } else {
      this.div.css('font-weight', '400');
    }
    var isItalic = fontStyle && fontStyle.indexOf('italic') !== -1;
    if (isItalic) {
      this.div.css('font-style', 'italic');
    } else {
      this.div.css('font-style', 'normal');
    }

    var textAlign = this.div.attr('data-alignment') || 'left';
    this.div.css('text-align', textAlign);

    var deg = this.div.attr('data-rotation');
    if (deg) {
      deg = 'rotate({0}deg)'.format(deg);
    } else {
      deg = 'none';
    }
    this.div.css('-ms-transform', deg);
    this.div.css('-webkit-transform', deg);
    this.div.css('transform', deg);
  };

  Component.prototype.isSubComponent = function() {
    return this.div.parent().hasClass('snp-component');
  };

  Component.prototype.toJson = function() {
    var json = attrsToJson(this.div.get(0));

    this.div.children('.snp-component').each(function() {
      if (!json.CompList) {
        json.CompList = [];
      }
      var component = $(this).data('component');
      json.CompList.push(component.toJson());
    });
    return json;
  };

  Component.prototype.addComponent = function(json) {
    var component = new Component(json);
    component.div.appendTo(this.div);
  };

  var zoom = {}; // zoom namespace
  zoom.values = [10,20,30,40,50,60,70,80,90,100,130,160,190,220,250,280,310,340,370,400];
  zoom.index = 9;
  zoom.label = $('#zoom > span');
  zoom.div = $('#zoom > div');
  zoom.init = function() {
    zoom.div.slider({
      min: 0,
      max: 19,
      value: 9,
      slide: function(event, ui) {
        zoom.index = ui.value;
        zoom.slide();
      }
    });
  };

  zoom.next = function() {
    if (zoom.index !== zoom.values.length - 1) {
      zoom.index += 1;
      zoom.div.slider('value', this.index);
      zoom.slide();
    }
  };

  zoom.previous = function() {
    if (zoom.index !== 0) {
      zoom.index -= 1;
      zoom.div.slider('value', this.index);
      zoom.slide();
    }
  };

  zoom.value = function() {
    return zoom.values[zoom.index] / 100;
  };

  zoom.factor = function() {
    return 1 / zoom.value();
  };

  zoom.slide = function() {
    $(".snp-page-container").css("transform", "scale({0})".format(zoom.value()));
    this.label.text(zoom.values[zoom.index] + "%");
    resizeRuler();
  };

  function ruler(sel, isVertical) {
    $(sel).children().remove();
    var height = Number($("#page-pageheight").val()) + Number($("#page-margintop").val()) + Number($("#page-marginbottom").val());
    var width = Number($("#page-pagewidth").val()) + Number($("#page-marginleft").val()) + Number($("#page-marginright").val());
    var pageLength = isVertical ? height : width;
    var length  = isVertical ? screen.width : screen.height;
    length = pxToCm(length);
    var $ruler = $(sel);
    var invStep = 5;
    var step = 1 / invStep;
    var offsetType = isVertical ? "top" : "left";
    var suffix = isVertical ? "-v" : "-h";
    for (var i = 0; i < pageLength / step; ++i) {
      var offset = i * step;
      var $tick = $("<div>").css(offsetType, offset + unit).appendTo($ruler);
      $tick.data("init-offset", offset).addClass("snp-tick snp-scalable");
      $tick.addClass("snp-tick" + suffix);
      if (i % invStep === 0) {
        $tick.addClass("snp-long");
        var $lbl = $("<label>").addClass("snp-ruler-label snp-scalable");
        $lbl.text(offset).addClass("snp-ruler-label" + suffix);
        $lbl.data("init-offset", offset);
        $lbl.css(offsetType, offset + unit).appendTo($ruler);
      } else if (i !== 0) {
        $tick.addClass("snp-small");
      }
    }
  }
  
  function resizeRuler() {
    var factor = zoom.factor();
    $(".snp-scalable").each(function(i, tick) {
      var $tick = $(tick);
      var isVertical = $tick.is(".snp-tick-v") || $tick.is(".snp-ruler-label-v");
      var offsettype = isVertical ? "top" : "left";
      var offset = $tick.data("init-offset") * zoom.value();
      $tick.css(offsettype, offset + "cm");
    })
  }

  function importJson(json) {
    if (json) {
      try {
        var obj = eval("(" + json + ")");
        page.fromJson(obj);
      }
      catch (err) {
        console.error(err);
        errorState = true;
        $("#doctemplate_editor_dialog").on("dialogopen", function() {
          showMessage("Template parsing error");
          $("#source-textarea").val(json);
          $("#btn-source").click();
        })
      }
    }
  }

  function exportJson() {
    return page.toJson();
  }

  function doClose() {
    if (undoStack.length) {
      var $dlg = $("<div title='SnApp'/>");
      $dlg.text(itl("@Common.SaveChangeConfirm"));
      $dlg.dialog({
        resizable: false,
        modal: true,
        close: function() {
          $dlg.remove();
        },
        buttons: [
          dialogButton(itl("@Common.Save"), function() {
            $dlg.dialog("close");
            doSave();
          }),
          dialogButton(itl("@Common.SaveDont"), function() {
            $dlg.dialog("close");
            $("#doctemplate_editor_dialog").dialog("close");
          }),
          dialogButton(itl("@Common.Cancel"), doCloseDialog),
        ]
      });
    } 
    else 
      $("#doctemplate_editor_dialog").dialog("close");
  }

  function doSave() {
    var isDesignMode = $("#btn-view-design").is(".active");
    var isPreviewMode = $("#btn-view-preview").is(".active");
    var cm = $("#source-textarea").data("cm");
    var jsonString = $("#source-textarea").val();
    
    if (cm) 
      jsonString = cm.getValue();  

    if (isDesignMode || isPreviewMode) 
      jsonString = JSON.stringify(page.toJson(), null, 2);
    
    var reqDO = {
      Command: "SaveDocData",
      SaveDocData: {
        DocTemplateId: docTemplateId,
        DocData: jsonString
      }
    };

    vgsService("DocTemplate", reqDO, false, function(ansDO) {
      showMessage(itl("@Common.SaveSuccessMsg"), function() {
          window.location.reload();
      });
    });
  }

  function initInspector() {
    if (doctemplate.editor.lightMode) {
      $('#preview-tab').hide();
    }
    $('.snp-unset-color').click(function() {
      var input = $(this).siblings('input[type="color"]').get(0);
      var key = input.id.substr(5);
      if (key === 'fontcolor') {
        input.value = '#000001';
      } else {
        input.value = '#fffffe';
      }
      if (input.id.startsWith('band-comp-')) {
        var band = $(".snp-band-container.snp-selected").data("band");
        band.container.removeAttr('data-' + key);
        band.reInit();
      } else if (input.id.startsWith('comp-')) {
        $('.ui-selected').removeAttr('data-' + key);
        componentBulk.reInit();
      }
    });

    $(".snp-text-editor").click(function() {
      var $dialog = $("#cm-text-editor-dialog");
      var $input = $(this).siblings("input");
      var $textarea = $("#cm-comp-textarea");
      var text = $input.val().replace(/\\n/g, '\n');
      var isCodeMirror = false;
      var editor = $textarea.data("editor");

      $textarea.val(text).focus();
      if (!editor) {
        editor = CodeMirror.fromTextArea($textarea[0], {
          lineNumbers: true,
          mode: "vgslang",
          extraKeys: {"Ctrl-Space": "autocomplete"},
          autoCloseBrackets: true,
          gutters: ["CodeMirror-lint-markers"],
          lint: true
        });
        doctemplate.editor.initCodeMirror(editor);
        $textarea.data("editor", editor);
      }
      isCodeMirror = true;

      $dialog.dialog({
        width: 600,
        buttons: {
          Ok: function() {
            var text = isCodeMirror ? editor.getValue() : $('#comp-textarea').val();
            text = text.replace(/\n/g, '\\n');
            $input.val(text).change().focus();
            $dialog.dialog('close');
          },
          Cancel: function() {
            $dialog.dialog('close');
          }
        },
        open: function() {
          if (isCodeMirror) {
            var editor = $('#cm-comp-textarea').data('editor');
            editor.setValue(text);
            editor.clearHistory();
            editor.refresh();
          }
        }
      });
    });

    $('#comp-image').change(function() {
      var $selected = $(':selected', this);
      var group = $selected.closest('optgroup').data('value');
      $('.ui-selected').attr('data-imagetype', group).attr('data-text', this.value).each(function() {
        $(this).data('component').reInit();
      });
    });
    
    $('#comp-resizestyle').change(function() {
    	var resizeStyle = $(this).val(); 
         $('.ui-selected').css("background-size", resizeStyle);
      });
  }

  var parseDataSources = function(dataSources) {
    if (dataSources) {
      dataSources = dataSources.forEach(function(obj) {
        $('<option>').val(obj.Name).text(obj.Name).appendTo('#band-datasourcename');
      });
    }
  };

  var repositoryMap = {};
  var fillImageCombobox = function(repositories, pictureMetaFieldCodes) {
    if (repositories) {
      var $repoGroup = $('<optgroup>').attr('label', 'Repository').data('value', 'REPOSITORY').appendTo('#comp-image');
      repositories.forEach(function(repository) {
        if (repository.RepositoryCode) {
          repositoryMap[repository.RepositoryCode.toLowerCase()] = repository.RepositoryId;
          var name = repository.RepositoryCode.toLowerCase();
          $('<option>').val(name).text(name).appendTo($repoGroup);
        }
      });
    }
    var $accountGroup = $('<optgroup>').attr('label', 'Account').data('value', 'DYNAMIC').appendTo('#comp-image');
    $('<option>').val('<%=DocProcessorBasePDF.IMAGE_PROFILE.toLowerCase()%>').text('Profile picture').appendTo($accountGroup);
    var $metaFieldGroup = $('<optgroup>').attr('label', 'Meta Field').data('value', 'DYNAMIC').appendTo('#comp-image');
    for (let mf of pictureMetaFieldCodes) {
		let optVal = "[@DynAccount.MetaDataList {fieldcode:" + mf.code + "}]";
    	$('<option>').val(optVal.toLowerCase()).text(mf.name).appendTo($metaFieldGroup);
    }
  };

  var initIndexVariablesDialog = function(variables) {
    $('#move-var').click(function() {
      var $selected = $('.leaf.selected', '#index-vars');
      if ($selected.length) {
        var name = $selected.attr('data-name');
        $('<option>').text(name).appendTo('#index-vars-result');
      }
    });
    $('#remove-var').click(function() {
      var selected = $('#index-vars-result').val();
      if (selected) {
        $('#index-vars-result > option').each(function() {
          if (selected.indexOf(this.value) !== -1) {
            $(this).remove();
          }
        });
      }
    });
    $('#remove-all-vars').click(function() {
      $('#index-vars-result > option').remove();
    });

    function startLoading() {
      $('<div id="editor-overlay">').addClass('snp-overlay').appendTo('body');
      $('<div id="editor-spinner">').addClass('snp-spinner spinner-box').appendTo('body');
    }

    function stopLoading() {
      $('#editor-overlay').remove();
      $('#editor-spinner').remove();
    }

    function showIndexVarDialog(btn) {
      $('#index-vars-result').children().remove();
      $('.haschild', '#index-vars').addClass('collapsed');
      var valuesString = $(btn).prev().val();
      if (valuesString) {
        var values = valuesString.split(',');
        values.forEach(function(el) {
          $('<option>').text(el).appendTo('#index-vars-result');
        });
      }
      $('#index-vars-dialog').dialog({
        create: function() {
          $(this).parent().addClass('on-top');
        },
        width: 600,
        height: 350,
        buttons: {
          "Save": function() {
            var values = [];
            $('#index-vars-result > option').each(function() {
              values.push($(this).text());
            });
            var value = '';
            if (values) {
              value = values.join();
            }
            $('#band-indexvars').val(value);
            $(".snp-band-container.snp-selected").each(function() {
              $(this).attr('data-indexvars', value);
            });
            $(this).dialog( "close" );
          },
          Cancel: function() {
            $(this).dialog( "close" );
          }
        }
      });
    }

    var needsInit = true;
    $(".snp-multi-select-btn").click(function(event) {
      var variables = doctemplate.editor.variables;
      var parseVariables = doctemplate.editor.parseVariables;
      var $this = this;
      if (needsInit) {
        startLoading();
        setTimeout(function() {
          var hierarchy = parseVariables(variables);
          $('#index-vars').tree({
            data: hierarchy,
            nodeSelected: function($li) {
              $li.toggleClass('collapsed');
            }
          });
          needsInit = false;
          stopLoading();
          showIndexVarDialog($this);
        }, 100);
      } else {
        showIndexVarDialog(this);
      }
    });
  };

  var requireTabInit = true;
  $("[data-tabcode='tab-variable']").click(function() {
    setTimeout(function() {
      var variables = doctemplate.editor.variables;
      if (variables) {
        requireTabInit = false;
        var hierarchy = doctemplate.editor.parseVariables(variables);
        $("#variable-tree").tree({
          data: hierarchy,
          nodeSelected: function($li) {
            $li.toggleClass("collapsed");
          }
        });
        
        $("#tab-variable li.leaf").draggable({helper:"clone"});
        $("#variables-spinner").remove();
      }
    }, 0);
  });
  
  $("#insert-media-code-dialog").on("submit", function() {
    var mediaCode = $('#dlg-media-code-input').val();
    var reqDO = {
      Command: "Search",
      Search: {
        MediaCode: mediaCode
      }
    };

    vgsService("Media", reqDO, false, function(ansDO) {
      if (ansDO.Answer.Search.MediaList && ansDO.Answer.Search.MediaList.length > 0) {
        $('#insert-media-code-dialog').dialog('close');
        $('#media-code-input').val(mediaCode);
        doPreview();
      } 
      else
        showMessage(itl("@Common.MediaNotFound"));
    });
    return false;
  });

  zoom.init();
  page.init();
  
  var $canvas = $('.snp-canvas');
  var $rulerH = $('#ruler-h');
  var $rulerV = $('#ruler-v');
  $canvas.scroll(function() {
    $rulerH.css('margin-left', -$canvas.scrollLeft() + 'px');
    $rulerV.css('margin-top', -$canvas.scrollTop() + 'px');
  });

  initToolbar();
  initInspector();

  doctemplate.editor.importJson = importJson;
  doctemplate.editor.parseDataSources = parseDataSources;
  doctemplate.editor.initIndexVariablesDialog = initIndexVariablesDialog;
  doctemplate.editor.fillImageCombobox = fillImageCombobox;

  $(".buttonset").buttonset();
  
})();

</script>