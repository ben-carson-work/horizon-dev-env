<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>


<% // This IF-BLOCK is supposed to always fail. Just a workaround to have this page highlighted as javascript. %>
<% if (request.getAttribute("BB63A701FB6F4C04B70C44E3CB161795") != null) { %>
<script>
<% } %>

<%--
  Params:
  - EntityType: entity type to look for. If passed along with EntityTypes, will be the default tab.
  - EntityTypes: (not mandatory) array of possible entity types
  - ShowCheckbox: (boolean - not mandatory - default false) Indicates if the dialog should show checkboxes for multiselection
  - isItemChecked(item): (method - not mandatory - return boolean) Method called for every item displayed. Shall return true/false to indicate if the "item" was already selected  
  - onPickup(item, add): event 
--%>
function showLookupDialog(params) {
  var dlg = $("<div class='v-lkdialog'/>");
  dlg.setClass("show-checkbox", params.ShowCheckbox === true);

  params = params || {};
  params.delay = isNaN(parseInt(params.delay)) ? 200 : parseInt(params.delay); 
  params.minLength = isNaN(parseInt(params.minLength)) ? 0 : parseInt(params.minLength); 
  dlg.data("params", params);

  var txtSearchCont = $("<div class='v-lkdialog-txt'/>").appendTo(dlg);
  var txtSearch = $("<input type='text'/>").appendTo(txtSearchCont);
  txtSearch.attr("placeholder", itl("@Common.FullSearch"));  
  $("<div class='v-combo-checkall'><div class='v-combo-check'><i class='fa'></i></div></div>").appendTo(txtSearchCont).click(_checkAllClick);
  var divList = $("<div class='v-lkdialog-itemlist'/>").appendTo(dlg);
  var entityTypeCount = 1;
  
  if (params.EntityTypes && (Object.prototype.toString.call(params.EntityTypes) === '[object Array]')) {
    entityTypeCount = params.EntityTypes.length;
    dlg.addClass("v-lkdialog-multientitytype");
    var divETCont = $("<div class='v-lkdialog-entitytype-cont'/>").appendTo(dlg);
    for (var i=0; i<params.EntityTypes.length; i++) {
      var entityType = parseInt(params.EntityTypes[i]);
      var divET = $("<div class='v-lkdialog-entitytype' data-EntityType='" + entityType + "'/>").appendTo(divETCont);
      divET.css("width", (100 / params.EntityTypes.length) + "%");
      divET.text(_getEntityTypeName(entityType));
      
      if (entityType == params.EntityType)
        divET.addClass("v-lkdialog-entitytype-active");
      
      divET.click(function() {
        params.EntityType = parseInt($(this).attr("data-EntityType"));
        dlg.data("params", params);
        dlg.find(".v-lkdialog-entitytype").removeClass("v-lkdialog-entitytype-active");
        $(this).addClass("v-lkdialog-entitytype-active");
        doVLKDialogSearch(dlg, txtSearch.val());
        txtSearch.focus();
      });
    }
  }

  var sTitle = itl("@Common.Search");
  if (entityTypeCount == 1)
    sTitle = _getEntityTypeName(parseInt(params.EntityType));
  
  dlg.dialog({
    modal: true,
    resizable: false,
    width: Math.max(350, entityTypeCount * 120),
    height: 445,
    title: sTitle,
    close: function() {
      dlg.remove();
    }
  });
  
  doVLKDialogSearch(dlg, "");

  txtSearch.keydown(function() {
    if (event.keyCode == KEY_DOWN) {
      var sel = divList.find(".selected");
      var next = sel.next();
      if (next.length > 0) {
        sel.removeClass("selected");
        next.addClass("selected");
        
        var scroll = next.position().top + next.height() - divList.height() + divList.scrollTop(); 
        if (scroll > 0) 
          divList.scrollTop(scroll);
      }
      event.stopPropagation();
      event.preventDefault();
    }
    else if (event.keyCode == KEY_UP) {
      var sel = divList.find(".selected");
      var prev = sel.prev();
      if (prev.length > 0) {
        sel.removeClass("selected");
        prev.addClass("selected");
        
        if (prev.position().top < 0) 
          divList.scrollTop(divList.scrollTop() + prev.position().top);
      }
      event.stopPropagation();
      event.preventDefault();
    }
    else if (event.keyCode == KEY_ENTER) {
      event.stopPropagation();
      event.preventDefault();
      _itemClick(divList.find(".selected"), true);
    }
  });
  
  var searchText = "";
  txtSearch.keyup(function() {
    if ((txtSearch.val() != searchText) && (event.keyCode != KEY_ENTER)) {
      searchText = txtSearch.val();
      clearTimeout(dlg.data("timer"));
      if (searchText.length < params.minLength)
        divList.empty();
      else {
        dlg.data("timer", setTimeout(function() {
          doVLKDialogSearch(dlg, searchText);
        }, params.delay));
      }
    }
  });
  
  function _itemClick($item, toggle) {
    txtSearch.val("");
    var item = $item.data("item");
    if (item) {
      var add = (toggle !== true) || !$item.is(".checked");
      $item.toggleClass("checked");
      if (params.onPickup)
        params.onPickup(item, add);
      if (!((params.ShowCheckbox == true) && (toggle == true)))
        dlg.dialog("close");
    }
  }
  
  function _checkAllClick() {
    var $checkall = $(this);
    var checked = !$checkall.is(".checked");
    $checkall.setClass("checked", checked);
    
    dlg.find(".v-combo-item").each(function(index, elem) {
      var $item = $(elem);
      if ($item.is(".checked") != checked)
        _itemClick($item, true);
    });
    
    dlg.find(".v-combo-item").setClass("checked", $checkall.is(".checked"));
  }
  
  function _getEntityTypeName(entityType) {
    switch (entityType) {
    <% for (LookupItem item : LkSN.EntityType.getItems()) { %>
      case <%=item.getCode()%>: return itl(<%=JvString.jsString(item.getRawDescription())%>);
    <% } %>
    default: return "[" + entityType + "]";
    }
  }

  function doVLKDialogSearch(dlg, txt) {
    var $list = dlg.find(".v-lkdialog-itemlist");
    vgsService("FullTextLookup", prepareVComboRequest(params, txt), false, function(ansDO) {
      if (dlg.find(".v-lkdialog-txt input").val() == txt) {
        $list.empty();
        if ((ansDO) && (ansDO.Answer) && ansDO.Answer.ItemList) {
          for (var i=0; i<ansDO.Answer.ItemList.length; i++) {
            var item = ansDO.Answer.ItemList[i];
            var $item = $("<div class='v-combo-item'><div class='v-combo-item-icon'></div><div class='v-combo-item-name'></div><div class='v-combo-item-code'></div><div class='v-combo-check'><i class='fa'></i></div></div>").appendTo($list);
            $item.find(".v-combo-item-name").text(item.ItemName);
            $item.find(".v-combo-item-code").text(item.ItemCode);
            $item.setClass("selected", (i == 0));
            
            var $icon = $item.find(".v-combo-item-icon");
            $icon.addClass((item.ProfilePictureId) ? "forpic" : "foricon");
            $icon.attr("style", "background-image:url(" + getVComboIconURL(item.IconName, item.ProfilePictureId) + ")");
            
            if (params.isItemChecked)
              $item.setClass("checked", params.isItemChecked(item));
            
            $item.data("item", item);
            $item.click(function() {
              _itemClick($(this), $(event.target).closest(".v-combo-check").length > 0);
            });
          }
        }
      }
    });
  }
}


<% // This IF-BLOCK is supposed to always fail. Just a workaround to have this page highlighted as javascript. %>
<% if (request.getAttribute("BB63A701FB6F4C04B70C44E3CB161795") != null) { %>
</script>
<% } %>
