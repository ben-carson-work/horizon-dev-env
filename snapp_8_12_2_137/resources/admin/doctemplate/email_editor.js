$(document).ready(function() {
  jQuery.fn.emailEditor = function(params) {
    params = params || {};
    params.defaultLangISO = params.defaultLangISO || "en"; 
    
    var $editor = $(this);
    var $tabs = $editor.find("#lang-tabs-container");
    var $tabNav = $editor.find(".v-tabs-nav");
    var $templates = $editor.find("#doctemplate-email-templates");

    var readOnly = params.readOnly || false;
    var email = params.template || {};
    email.LangList = email.LangList || [];
    for (const langItem of email.LangList) 
      _addLangTab(langItem);
    
    $editor.find(".email-editor").setClass("readonly", readOnly);
    $editor.find("#AddressFrom").setEnabled(!readOnly).val(email.AddressFrom);
    $editor.find("#AddressTo").setEnabled(!readOnly).val(email.AddressTo);
    $editor.find("#AddressCC").setEnabled(!readOnly).val(email.AddressCC);
    $editor.find("#AddressBCC").setEnabled(!readOnly).val(email.AddressBCC);
    
    $tabNav.find(".v-tabs-item").first().activateTab();
    $editor.find(".add-lang-popop-item").click(_addNewLang);
    
    
    function _addLangTab(langItem) {
      var id = "lang_" + langItem.LangISO;
      var $li = $templates.find(".v-tabs-item").clone();
      $li.find("a").attr("data-tabcode", id);
      $li.find(".v-tabs-caption").text(langItem.LangName);
      if (langItem.IconName)
        $li.find(".v-tabs-icon").css("background-image", "url(" + getIconURL(langItem.IconName, 16)  + ")");

      if (langItem.LangISO != params.defaultLangISO)
        $templates.find(".btn-close-tab").clone().appendTo($li).click(_removeLanguage);
      
      $tabNav.find("#plus_tab").setClass("hidden", readOnly).before($li);
      
      var $content =  $templates.find(".lang-tab-content").clone().appendTo($tabs);
      $content.attr("id", id);
      $content.attr("data-langiso", langItem.LangISO);
      $content.data("langItem", langItem);
      $content.find(".txt-subject").setEnabled(!readOnly).val(langItem.Subject); 
      $content.find("textarea").val(langItem.Body);
      $content.find(".btn-editor-html").setEnabled(!readOnly).click(_showEditorHTML);
      $content.find(".btn-plain-html").setEnabled(!readOnly).click(_showPlainHTML);
      $content.find(".btn-preview").click(_showPreview);
      
      $li.activateTab();
      
      // Editors instantiation is postponed to when the element becomes visible because of some CodeMirror bad effects if initializing when the component is not visible
      visibilityObserver($content, function() {
        if (!$content.is(".editor-initialized")) {
          $content.data("codemirror", CodeMirror.fromTextArea($content.find(".codemirror-container textarea")[0], {
            mode: "text/html",
            matchBrackets: true,
            lineNumbers: true,
            smartIndent: false,
            readOnly: readOnly
          }));
    
          $content.data("ckeditor", CKEDITOR.replace($content.find(".ckeditor-container textarea")[0], {
            toolbar:"Full", 
            readOnly: readOnly
          }));
          
          // This needs to be done after codemirror initialization
          $content.attr("data-plainhtml", langItem.PlainHTML || false);
          $content.addClass("editor-initialized");
        }
      });
    }

    function _removeLanguage() {
      var $tab = $(this).closest(".v-tabs-item");
      confirmDialog(null, function() {
        var $active = $tab.prev();
        if ($active.length == 0)
          $active = $tab.next();
        
        var code = $tab.find("a").attr("data-tabcode");
        $tab.remove();
        $editor.find("#" + code + ".lang-tab-content").remove();
        
        $active.activateTab();
      });
    }
    
    function _addNewLang() {
      var $this = $(this);
      var langISO = $this.attr("data-langiso");
      if ($tabs.find("[data-tabcode='lang_" + langISO + "']").length > 0)
        showMessage(itl("@RichDesc.LanguageAlreadySelectedError"));
      else {
        _addLangTab({
          LangISO: langISO, 
          LangName: $this.attr("data-langname"), 
          IconName: $this.attr("data-iconname")
        });
      }
    }

    function _showEditorHTML() {
      $(this).closest(".lang-tab-content").plainHTML(false);
    }
    
    function _showPlainHTML() {
      $(this).closest(".lang-tab-content").plainHTML(true);
    }
    
    function _showPreview() {
      var $content = $(this).closest(".lang-tab-content");
      var $dlg = $("<div><iframe style='border:none;position:absolute;top:0;left:0;width:100%;height:100%;'></iframe></div>").appendTo("body");
      
      $dlg.dialog({
        modal: true,
        title: itl("@Common.Preview"),
        width: 1024,
        height: 768,
        close: function() {
          $dlg.remove();
        }
      });
      
      var iframe = $dlg.find("iframe")[0];
      var iFrameDoc = iframe.contentDocument || iframe.contentWindow.document;
      iFrameDoc.write($content.contentBody());
      iFrameDoc.close();
    }
  };


  var origPlainHTML = jQuery.fn.plainHTML; 
  jQuery.fn.plainHTML = function(value) {
    var $content = $(this);
    
    if (!$content.is(".lang-tab-content"))
      return origPlainHTML(value);
    
    if (value === undefined)
      return $content.attr("data-plainhtml") == "true";

    var html = $content.contentBody();
    $content.attr("data-plainhtml", value);
    $content.contentBody(html);
    return this;
  };



  var origContentBody = jQuery.fn.contentBody; 
  jQuery.fn.contentBody = function(value) {
    var $content = $(this);
    
    if (!$content.is(".lang-tab-content"))
      return origContentBody(value);

    if ($content.plainHTML()) {
      var doc = $content.data("codemirror").getDoc();
      if (value === undefined) 
        return doc.getValue();

      doc.setValue(value);
      return this;
    }
    else {
      var doc = $content.data("ckeditor");
      if (value === undefined) 
        return doc.getData();

      doc.setData(value);
      return this;
    }
  };
  

  jQuery.fn.emailEditorData = function() {
    var $editor = $(this);
    
    var email = {
      AddressFrom: $editor.find("#AddressFrom").val(),
      AddressTo: $editor.find("#AddressTo").val(),
      AddressCC: $editor.find("#AddressCC").val(),
      AddressBCC: $editor.find("#AddressBCC").val(),
      LangList: []
    };
    
    $editor.find("#lang-tabs-container .lang-tab-content").each(function(index, elem) {
      var $content = $(elem);
      if ($content.is(".editor-initialized")) {
        email.LangList.push({
          LangISO: $content.attr("data-langiso"),
          PlainHTML: $content.plainHTML(),
          Subject: $content.find(".txt-subject").val(),
          Body: $content.contentBody()
        });
      }
      else
        email.LangList.push($content.data("langItem"));
    });
    
    return email;
  };
});
