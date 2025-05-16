<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>


<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<div id="configlang_dialog" class="v-hidden" title="<v:itl key="@Common.Translation"/>">

<style>
#configlang_dialog .configlang-table {
  width: 100%;
}
#configlang_dialog .configlang-table input,
#configlang_dialog .configlang-table select {
  width: 95%;
}
</style>

<div class="templates v-hidden">
  <select class="lang-combo-template form-control">
    <option/>
  <% for (String langISO : SnappUtils.getLangISOs()) { %>
    <% String icon = SnappUtils.getFlagName(langISO); %>
    <% Locale locale = new Locale(langISO); %>
    <% String langName = JvString.getPascalCase(locale.getDisplayLanguage(pageBase.getLocale())); %>
    <% if (icon != null) { %>
      <option value="<%=langISO%>"><%=JvString.escapeHtml(langName)%></option>
    <% } %>
  <% } %>
  </select>
</div>

<table class="configlang-table">
  <tbody class="lang-body"></tbody>
  <tbody class="new-line-body"></tbody>
</table>

<script>

// "list" refers to DOConfigLang.DOTranslationItem list
function showConfigLangDialog(list, callback) {
  var dlg = $("#configlang_dialog");
  list = (list) ? list : [];
  
  dlg.find(".new-line-body").empty();
  dlg.find(".lang-body").empty();
  
  dlg.find(".new-line-body").append(createLangLine(""));
  for (var i=0; i<list.length; i++) 
    dlg.find(".lang-body").append(createLangLine(list[i].LangISO, list[i].Translation));
  
  dlg.dialog({
    modal: true,
    width: 640,
    height: 500,
    buttons: {
      "<v:itl key="@Common.Save"/>": function() {
        dlg.dialog("close");
        callback(encodeTranslationList());
      },
      "<v:itl key="@Common.Cancel"/>": doCloseDialog
    }
  });
  
  dlg.find(".new-line-body select").change(function() {
    var langISO = $(this).val();
    if (langISO != "") {
      var newTR = createLangLine(langISO, $(this).closest("input").val());
      dlg.find(".lang-body").append(newTR);
      newTR.find("input").focus();
      $(this).val("");
    }
  });


  function createLangLine(langISO, value) {
    var tr = $("<tr/>");
    
    // Combo
    var tdCombo = $("<td width='30%'/>").appendTo(tr);
    var combo = dlg.find(".templates .lang-combo-template").clone().appendTo(tdCombo);
    combo.val(langISO);
    
    // Value
    var tdValue = $("<td width='70%'/>").appendTo(tr);
    if (langISO != "") {
      var input = $("<input class='form-control' type='text'/>").appendTo(tdValue);
      input.val(value);
    }
    
    // Remove
    var tdRemove = $("<td/>").appendTo(tr);
    if (langISO != "") {
      var linkRemove = $("<a href='#'><%=JvString.escapeHtml(pageBase.getLang().Common.Remove.getText())%></a>").appendTo(tdRemove);
      linkRemove.click(function() {
        $(this).closest("tr").remove();
      });
    }
    
    return tr;
  }
  
  function encodeTranslationList() {
    var result = [];
    var trs = dlg.find(".lang-body tr");
    for (var i=0; i<trs.length; i++) {
      var langISO = $(trs[i]).find("select").val();
      var translation = $(trs[i]).find("input").val();
      if (langISO != "") {
        result.push({
          LangISO: langISO,  
          Translation: translation  
        });
      }
    }
    return result;
  }
}

<%--
$(document).ready(function() {
	$("#new-line-body").append(createLangLine(""));
	<% for (DOConfigLang.DOTranslationItem itemDO : configLang.TranslationList.getItems()) { %>
	  $("#lang-body").append(createLangLine("<%=itemDO.LangISO.getHtmlString()%>", "<%=itemDO.Translation.getHtmlString()%>"));
	<% } %> 
	
	$("#new-line-body select").change(function() {
		var langISO = $(this).val();
		if (langISO != "") {
			var newTR = createLangLine(langISO, $(this).closest("input").val());
			$("#lang-body").append(newTR);
			newTR.find("input").focus();
			$(this).val("");
		}
	});
	
	var dlg = $("#configlang_dialog");
	dlg.on("snapp-dialog", function(event, params) {
	  params.buttons = {
	    <v:itl key="@Common.Save" encode="JS"/>: doSaveTranslation,
	    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
	  };
	});
});

function doSaveTranslation() {
	var reqDO = {
		Command: "SaveConfigLang",
		SaveConfigLang: {
			ConfigLang: {
				EntityId: "<%=configLang.EntityId.getEmptyString()%>",
				EntityType: <%=configLang.EntityType.getInt()%>,
				LangField: <%=configLang.LangField.getInt()%>,
				TranslationList: []
			}
		}
	};
	
	var trs = $("#lang-body tr");
	for (var i=0; i<trs.length; i++) {
		var langISO = $(trs[i]).find("select").val();
		var translation = $(trs[i]).find("input").val();
		if (langISO != "") {
	    reqDO.SaveConfigLang.ConfigLang.TranslationList.push({
        LangISO: langISO,  
        Translation: translation  
      });
		}
	}
	
	vgsService("Language", reqDO, false, function(ansDO) {
    $("#configlang_dialog").dialog("close");
	});
	
}
--%>
</script>

</div>