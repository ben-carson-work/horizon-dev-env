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
<% boolean readOnly = pageBase.isParameter("readOnly", "true"); %>

<v:dialog id="maskedit_multilang_dialog" title="@Common.Translation" width="800" height="600" autofocus="false">
  <v:grid>
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td>&nbsp;</td>
        <td width="20%"><v:itl key="@Common.Language"/></td>
        <td width="80%"><v:itl key="@Common.Translation"/></td>
      </tr>
    </thead>
    <tbody class="metafield-configlang-body">
    </tbody>
    <tbody class="bottom-buttons-body">
      <tr>
        <td colspan="100%">
          <v:button-group>
            <v:button id="" fa="plus" caption="@Common.Add" dropdown="true" enabled="<%=!readOnly%>"/>
            <v:popup-menu bootstrap="true">
			      <% 
            for (String langISO : SnappUtils.getLangISOs()) { 
			        String icon = SnappUtils.getFlagName(langISO); 
			        if (icon != null) { 
                Locale locale = new Locale(langISO); 
                String langName = JvString.getPascalCase(locale.getDisplayLanguage(pageBase.getLocale())); 
                String langDesc = langName + " | " + locale.getDisplayLanguage(locale); 
                TagAttributeBuilder attributes = TagAttributeBuilder.builder()
                    .put("data-langiso", langISO)
                    .put("data-iconname", icon)
                    .put("data-langname", langName);
                %><v:popup-item clazz="lang-menuitem" icon="<%=icon%>" caption="<%=langDesc%>" attributes="<%=attributes%>"/><%
			        }
			      } 
            %>
            </v:popup-menu>
          </v:button-group>
          
          <v:button id="btn-lang-remove" fa="minus" caption="@Common.Remove" enabled="<%=!readOnly%>"/>
        </td>
      </tr>
    </tbody>
  </v:grid>


<script>
$(document).ready(function() {
  var $dlg = $("#maskedit_multilang_dialog");
  var metaFieldId = <%=JvString.jsString(JvString.getNull(pageBase.getId()))%>;
  var selector = <%=JvString.jsString(pageBase.getNullParameter("selector"))%>;
  var readOnly = <%=readOnly%>; 

  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [];
    if (!readOnly)
      params.buttons.push(dialogButton("@Common.Save", _saveMultiLang));
    params.buttons.push(dialogButton("@Common.Cancel", doCloseDialog));
  });

  var list = _decodeValue();
  for (var i=0; i<list.TransList.length; i++) {
    var item = list.TransList[i];
    _addLang(item.LangISO, item.LangName, item.IconName, item.Translation);
  }
  
  $dlg.find(".lang-menuitem").click(_onLangMenuItemClick);
  $dlg.find("#btn-lang-remove").click(_onLangRemoveClick);
  
  function _decodeValue() {
    var json = null;
    if (metaFieldId)
      json = $("#MetaFieldId_" + metaFieldId).val();
    else
      json = $(selector).attr("data-jsonvalue");
    
    var result = JSON.parse(getNull(json) || "{}");
    result.TransList = result.TransList || [];
    return result;
  }
  
  function _encodeValue() {
    list.TransList = [];
    
    $dlg.find(".metafield-configlang-body tr").each(function() {
      var item = $(this);
      var desc = getNull(item.find(".txt-translation").val());
      if (desc) {
        list.TransList.push({
          LangISO: item.attr("data-id"),
          LangName: item.attr("data-name"),
          IconName: item.attr("data-icon"),
          Translation: desc
        });
      }
    });

    return JSON.stringify(list);
  }

  function _onLangMenuItemClick() {
    var $menuItem = $(this);
    _addLang($menuItem.attr("data-langiso"), $menuItem.attr("data-langname"), $menuItem.attr("data-iconname"));
  }

  function _addLang(langISO, langName, iconName, translation) {
    var obj = $dlg.find("#lang_" + langISO);
    if (obj.length) {
      showMessage(itl("@RichDesc.LanguageAlreadySelectedError"));
    } 
    else {
      var tr = $("<tr id='lang_" + langISO + "' class='grid-row' data-id='" + langISO + "' data-name='" + langName +"' data-icon='" + iconName + "'/>").appendTo($dlg.find(".metafield-configlang-body"));
      var tdCB = $("<td/>").appendTo(tr);
      var tdIcon = $("<td><img class='list-icon' src='" + getIconURL(iconName, 32) + "' width='32' height='32'></td>").appendTo(tr);
      var tdLanguage = $("<td>" + langName + "</td>").appendTo(tr);
      var tdTranslation = $("<td/>").appendTo(tr);
      tdCB.append("<input type='checkbox' class='cblist'>");
      var $txt = $("<input type='text'/ class='txt-translation form-control'>").appendTo(tdTranslation);
      $txt.val(translation);
      $txt.setEnabled(!readOnly);
    }
  }

  function _onLangRemoveClick() {
    $dlg.find(".cblist:checked").not(".header").closest("tr").remove();
  }

  function _saveMultiLang() {
    var value = _encodeValue();
    
    if (metaFieldId)
      $("#MetaFieldId_" + metaFieldId).val(value);
    else
      $(selector).attr("data-jsonvalue", value);
    
    $dlg.dialog("close");
  }
});

</script>

</v:dialog>

