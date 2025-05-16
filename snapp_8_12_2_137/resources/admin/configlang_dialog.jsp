<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
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

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
  String entityId = pageBase.getNullParameter("EntityId");
  LookupItem langField = LkSN.HistoryField.getItemByCode(pageBase.getNullParameter("LangField"));
  DOConfigLang configLang = pageBase.getBL(BLBO_Lang.class).loadConfigLang(entityId, langField); 
  if (configLang.EntityType.isNull())
    configLang.EntityType.setString(pageBase.getNullParameter("EntityType"));
%>

<v:dialog id="configlang_dialog" title="@Common.Translation" width="640" height="500">

<style>
#configlang-table {
  width: 100%;
}
#configlang-table td {
  padding: 4px;
}
</style>

<div class="v-hidden">
  <select id="lang-combo-template" class="form-control">
    <option/>
  <% for (String langISO : Locale.getISOLanguages()) { %>
    <% String icon = SnappUtils.getFlagName(langISO); %>
    <% Locale locale = new Locale(langISO); %>
    <% String langName = JvString.getPascalCase(locale.getDisplayLanguage(pageBase.getLocale())); %>
    <% if (icon != null) { %>
      <option value="<%=langISO%>"><%=JvString.escapeHtml(langName)%></option>
    <% } %>
  <% } %>
  </select>
</div>

<table id="configlang-table">
  <tbody id="lang-body"></tbody>
  <tbody id="new-line-body"></tbody>
</table>

<script>

function createLangLine(langISO, value) {
  var tr = $("<tr/>");
  
  // Combo
  var tdCombo = $("<td width='30%'/>").appendTo(tr);
  var combo = $("#lang-combo-template").clone().appendTo(tdCombo);
  combo.val(langISO);
  
  // Value
  var tdValue = $("<td width='70%'/>").appendTo(tr);
  if (langISO != "") {
    var input = $("<input type='text' class='form-control'/>").appendTo(tdValue);
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

$(document).ready(function() {
  $("#new-line-body").append(createLangLine(""));
  <% for (DOConfigLang.DOTranslationItem itemDO : configLang.TranslationList.getItems()) { %>
    $("#lang-body").append(createLangLine("<%=itemDO.LangISO.getHtmlString()%>", <%=itemDO.Translation.getJsString()%>));
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

</script>

</v:dialog>