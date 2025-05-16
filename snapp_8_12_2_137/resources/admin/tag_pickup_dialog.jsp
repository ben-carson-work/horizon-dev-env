<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% 
LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType")); 
String contextId = JvString.replace(pageBase.getParameter("ContextId"), ".", "\\.");
boolean readOnly = pageBase.isParameter("ReadOnly", "true"); 

QueryDef qdef = new QueryDef(QryBO_Tag.class)
    .addFilter(QryBO_Tag.Fil.EntityType, entityType.getCode())
    .addSort(QryBO_Tag.Sel.TagName)
    .addSelect(
        QryBO_Tag.Sel.TagId,
        QryBO_Tag.Sel.TagCode,
        QryBO_Tag.Sel.TagName,
        QryBO_Tag.Sel.LinkCount);

JvDataSet dsTag = pageBase.execQuery(qdef);
%>

<v:dialog id="tag-pickup-dialog" width="700" height="550" title="@Common.TagPickup">

<style>
  #tag-pickup-dialog .tag-grid {margin-top: 10px;}
  #tag-pickup-dialog tr:not(.editing) .tag-item-input {display:none}
  #tag-pickup-dialog tr.editing .tag-item-view {display:none}
  #tag-pickup-dialog .tag-item-view-label {font-weight:bold}
  #tag-pickup-dialog .tag-grid tr:hover td {background-color:var(--highlight-color)}
  #tag-pickup-dialog .tag-grid tr:hover .tag-item-view-label {color:white}
  #tag-pickup-dialog .tag-item-view {display:flex; justify-content:space-between;}
</style>


<% if (!readOnly) { %>
  <v:input-group>
    <v:input-text field="new-tag-name" placeholder="@Common.TagNewPlaceholder"/>
    <v:input-group-btn>
      <v:button id="btn-new-tag" caption="@Common.Add" fa="plus"/>
    </v:input-group-btn>
  </v:input-group>
<% } %>

<v:grid clazz="tag-grid">
  <tbody>
    <v:ds-loop dataset="<%=dsTag%>">
    <tr class="grid-row" data-tagid="<%=dsTag.getField(QryBO_Tag.Sel.TagId).getEmptyString()%>">
      <td>
        <div class="tag-item-view">
          <div class="tag-item-view-label"><%=dsTag.getField(QryBO_Tag.Sel.TagName).getHtmlString()%></div>
          <v:button-group clazz="row-hover-visible">
            <v:button clazz="tag-item-rename-btn" caption="@Common.Rename" fa="pencil"/>
            <v:button clazz="tag-item-delete-btn" caption="@Common.Delete" fa="trash"/>
          </v:button-group>
        </div>
        <div class="tag-item-input">
          <v:input-group>
            <v:input-text defaultValue="<%=dsTag.getField(QryBO_Tag.Sel.TagName).getHtmlString()%>"/>
            <v:input-group-btn>
              <v:button clazz="tag-item-rename-confirm-btn" fa="check"/>
              <v:button clazz="tag-item-rename-cancel-btn" fa="times"/>
            </v:input-group-btn>
          </v:input-group>
        </div>
      </td>
    </tr>
    </v:ds-loop>
  </tbody>
</v:grid>
  

<script>
$(document).ready(function() {
  var $dlg = $("#tag-pickup-dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [dialogButton("@Common.Close", doCloseDialog)];
  });
  
  $dlg.find("#btn-new-tag").click(_newTagClick);
  $dlg.find("#new-tag-name").keyup(_newTagNameKeyUp);
  $dlg.find(".tag-item-view").click(_pickupClick);
  $dlg.find(".tag-item-rename-btn").click(_renameClick);
  $dlg.find(".tag-item-delete-btn").click(_deleteClick);
  $dlg.find(".tag-item-rename-confirm-btn").click(_renameConfirmClick);
  $dlg.find(".tag-item-rename-cancel-btn").click(_renameCancelClick);
  $dlg.find(".tag-item-input input").keyup(_inputKeyUp);
  
  function _inputKeyUp() {
    if (event.keyCode == KEY_ENTER) 
      _renameConfirm($(this).closest("tr"));
  }
  
  function _newTagNameKeyUp() {
    var tagName = $dlg.find("#new-tag-name").val().trim();
    var $labels = $dlg.find(".tag-item-view-label");

    $labels.each(function(index, elem) {
      var $label = $(elem);
      var match = $label.text().toUpperCase().indexOf(tagName.toUpperCase()) >= 0;
      $label.closest("tr").setClass("hidden", !match);
    });
  }

  function _newTagClick() {
    var tagName = $dlg.find("#new-tag-name").val().trim();
    if (tagName != "") {
      confirmDialog(itl("@Common.TagConfirmNew", tagName), function() {
        if (tagName != "") {
          var reqDO = {
            Command: "Save",
            Save: {
              Tag: {
                EntityType: <%=entityType.getCode()%>,
                TagName: tagName
              }
            }
          };
          
          showWaitGlass();
          vgsService("Tag", reqDO, false, function(ansDO) {
            hideWaitGlass();
            _pickup(ansDO.Answer.Save.TagId, tagName);
          });
        }
      });
    }
  }

  function _pickupClick() {
    var $tr = $(this).closest("tr");
    var tagId = $tr.attr("data-tagid");
    var tagName = $tr.find(".tag-item-view-label").text();
    _pickup(tagId, tagName);
  }
  
  function _pickup(tagId, tagName) {
    var context = $("#" + <%=JvString.jsString(contextId)%>);
    if (context.is(".selectized")) {
      var v = context[0].selectize;
      v.addOption({"value":tagId,"text":tagName});
      v.addItem(tagId);
    }
    else if (context.find(".tag-item[data-tagid='" + tagId + "']").length <= 0)
      context.find(".tag-add").before($("<div class='tag-item' data-tagid='" + tagId + "' onclick='tagRemove(this)'/>").html(tagName));
    
    $dlg.dialog("close");
  }

  function _renameClick(tagId) {
    event.stopPropagation();

    var $tr = $(this).closest("tr");
    $tr.addClass("editing");

    var $input = $tr.find(".tag-item-input input");
    $input.val($tr.find(".tag-item-view-label").text());
    $input.focus();
  }

  function _deleteClick() {
    event.stopPropagation();

    var $tr = $(this).closest("tr");
    var tagId = $tr.attr("data-tagid");
    
    confirmDialog(itl("@Common.ConfirmDelete"), function() {
      var reqDO = {
        Command: "Delete",
        Delete: {
          TagIDs: tagId
        }
      };
      
      showWaitGlass();
      vgsService("Tag", reqDO, false, function(ansDO) {
        hideWaitGlass();
        $dlg.find("tr[data-tagid='" + tagId + "']").remove();
      });
    });
  }
  
  function _renameConfirmClick() {
    event.stopPropagation();
    _renameConfirm($(this).closest("tr"));
  }
  
  function _renameConfirm($tr) {
    var $input = $tr.find(".tag-item-input input");
    var tagId = $tr.attr("data-tagid");
    
    var reqDO = {
      Command: "Rename",
      Rename: {
        TagId: tagId,
        TagName: $input.val()
      }
    };
    
    showWaitGlass();
    vgsService("Tag", reqDO, false, function() {
      hideWaitGlass();
      $tr.find(".tag-item-view-label").text($input.val());
      $tr.removeClass("editing");
    });
  }
  
  function _renameCancelClick() {
    event.stopPropagation();
    $(this).closest("tr").removeClass("editing");
  }
});

</script>

</v:dialog>
