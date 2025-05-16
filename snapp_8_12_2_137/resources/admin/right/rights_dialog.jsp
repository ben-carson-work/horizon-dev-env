<%@page import="com.vgs.snapp.exception.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
BLBO_Right bl = pageBase.getBL(BLBO_Right.class);
if (!rights.RightsEdit.getBoolean())
  throw new EWsForbiddenException();

LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType"));
String entityId = pageBase.getParameter("EntityId");
if (entityType.isLookup(LkSNEntityType.Server) && pageBase.hasParameter("ServerId"))
  entityId = SnappUtils.encodeServerPseudoId(Integer.valueOf(pageBase.getParameter("ServerId")));
//boolean canEdit = pageBase.isParameter("ReadOnly", "true") ? false : true;

DORightDialogUI rightsUI = new DORightDialogUI();  
rightsUI.UsrEntities.setLkArray(LkSNEntityType.Person, LkSNEntityType.Role);
rightsUI.WksEntities.setLkArray(LkSNEntityType.Licensee, LkSNEntityType.Organization, LkSNEntityType.Location, LkSNEntityType.OperatingArea, LkSNEntityType.Workstation);
rightsUI.AptEntities.setLkArray(LkSNEntityType.Licensee, LkSNEntityType.Organization, LkSNEntityType.Location, LkSNEntityType.OperatingArea, LkSNEntityType.AccessPoint);
rightsUI.WksType.setXMLValue(pageBase.getNullParameter("wksType"));
rightsUI.ReadOnly.setBoolean(pageBase.isParameter("ReadOnly", "true"));

DORightRoot rightsEnt = bl.loadRights(entityType, entityId);
DORightRoot rightsDef = bl.loadMergedRights(entityType, entityId, false, true);

request.setAttribute("rightsUI", rightsUI);
request.setAttribute("rightsEnt", rightsEnt);
request.setAttribute("rightsDef", rightsDef);
request.setAttribute("rightsReadOnly", rightsUI.ReadOnly.getBoolean());

String title = pageBase.isParameter("Filter", "right") ? "@Common.Rights": "@Common.Configuration";
%>

<v:dialog id="rights-dialog" tabsView="true" title="<%=title%>" width="950" height="700">
  <jsp:include page="rights_dialog_css.jsp"></jsp:include>

<% if (pageBase.isParameter("Filter", "right")) { %>
  <jsp:include page="right/rights_dialog_right.jsp"></jsp:include>
<% } else if (pageBase.isParameter("Filter", "setup") || pageBase.isParameter("Filter", "setupB2B") || pageBase.isParameter("Filter", "setupB2C") || pageBase.isParameter("Filter", "setupEXT")) { %>
  <jsp:include page="setup/rights_dialog_setup.jsp"></jsp:include>
<% } else if (pageBase.isParameter("Filter", "rightB2B")) { %>
  <jsp:include page="rights_dialog_right_B2B.jsp"></jsp:include>
<% } else if (pageBase.isParameter("Filter", "server")) { %>
  <jsp:include page="rights_dialog_server.jsp"></jsp:include>
<% } %>

<script>

$(document).ready(function() {
  var canEdit = <%=!rightsUI.ReadOnly.getBoolean()%>;
  var dlg = $("#rights-dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      <% if (!rightsUI.ReadOnly.getBoolean()) { %>
        dialogButton(itl("@Common.Reset"), doReset),
        dialogButton(itl("@Common.Save"), doSave),
      <% } %>
      dialogButton(itl("@Common.Cancel"), doCloseDialog)
    ];
  });
  
  var rightItemList = $(".rights-item");

  refreshRightDef();
  $(".rights-item-checkbox").click(refreshRightDef);

  function refreshRightDef() {
    for (var i=0; i<rightItemList.length; i++) {
      var item = $(rightItemList[i]);
      var checked = item.find(".rights-item-checkbox").isChecked();
      item.setClass("default-value", !checked);
    }
  }
  
  var contentList = $(".rights-menu-content");
  for (var i=0; i<contentList.length; i++) {
    var content = $(contentList[i]);
    if (content.find(".rights-content-block:not(.v-hidden)").length == 0) {
      $("[data-Target='#" + content.attr("id") + "']").addClass("v-hidden");
    }
  }
  doSelectMenuItem($(".rights-menu-item:not(.v-hidden)")[0]);
  
  var menuItemList = $(".rights-menu-item");
  for (var i=0; i<menuItemList.length; i++) {
    var item = $(menuItemList[i]);
    var icon = item.attr("data-Icon");
    if (icon) 
      item.css("background-image", "url('" + getIconURL(icon, 26) + "')");
  }
  
  function doSelectMenuItem(item) {
    item = (item) ? $(item) : $(this);
    $(".rights-subbody").remove();
    $(".rights-body-content").show();
    $(".rights-menu-item").removeClass("selected");
    item.addClass("selected");
    $(".rights-menu-content").addClass("v-hidden");
    $(item.attr("data-Target")).removeClass("v-hidden");
    $("#rights-body").scrollTop(0);
  }
  
  $(".rights-menu-item").click(function() {
    doSelectMenuItem(this);
  });
  
  $(".right-plugin-control select").change(_refreshPluginConfig);
  $(".right-plugin-control .config-btn").click(_showPluginConfig);
  
  function doSave() {
    var reqDO = {
      Command: "Save",
      Save: {
        EntityType: <%=rightsEnt.EntityType.getInt()%>,
        EntityId: "<%=rightsEnt.EntityId.getString()%>",
        RightList: []
      }
    };

    $("#rights-body .btnclose").click();

    for (var i=0; i<rightItemList.length; i++) {
      var item = $(rightItemList[i]);
      var cb = item.find(".rights-item-checkbox");
      var rightType = cb.val();
      if (rightType != null) {
        var rv = null;
        if (cb.isChecked()) {
          rv = item.find("[name='Right" + rightType + "']").val();
          
          if (item.find(".rights-grouplevel").length > 0) {
            rv =
              item.find(".rights-grouplevel-login").val() + "/" +
              item.find(".rights-grouplevel-group").val() + "/" +
              item.find(".rights-grouplevel-all").val();
          }

          if (rv instanceof Array)
            rv = rv.join(",");

          var $switch = item.find(".this-control .v-switch");
          if ($switch.length > 0)
            rv = $switch.hasClass("v-switch-on");
          
          var $pluginControl = item.find(".this-control .right-plugin-control"); 
          if ($pluginControl.length > 0) 
            rv = $pluginControl.find("select").val() + "|" + $pluginControl.attr("data-settings");
          
          var $inputITL = item.find(".this-control .right-itl input");
          if ($inputITL.length > 0) {
            var itl = JSON.parse($inputITL.attr("data-jsonvalue"));
            itl.Default = $inputITL.val();
            rv = JSON.stringify(itl);
          }
        }
        
        reqDO.Save.RightList.push({
          RightType: rightType, 
          RightValue: rv
        });
      }
    }

    showWaitGlass();
    vgsService("Right", reqDO, false, function(ansDO) {
      hideWaitGlass();
      dlg.dialog("close");
    });
  }
  
  function doReset() {
    confirmDialog(itl("@Right.ResetConfirm"), function() {
      var reqDO = {
        Command: "Save",
        Save: {
          EntityType: <%=rightsEnt.EntityType.getInt()%>,
          EntityId: "<%=rightsEnt.EntityId.getString()%>",
          RightList: []
        }
      };

      for (var i=0; i<rightItemList.length; i++) {
        var item = $(rightItemList[i]);
        var cb = item.find(".rights-item-checkbox");
        var rightType = cb.val();
        if (rightType != null) {
          reqDO.Save.RightList.push({
            RightType: rightType, 
            RightValue: null
          });
        }
      }

      showWaitGlass();
      vgsService("Right", reqDO, false, function(ansDO) {
        hideWaitGlass();
        dlg.dialog("close");
      });
    });
  }
  
  function _refreshPluginConfig() {
    var $select = $(this);
    var value = getNull($select.val());
    $select.closest(".right-plugin-control").find(".config-btn").setEnabled(value != null);
  }
  
  function _showPluginConfig() {
    var $btn = $(this);
    var rightType = $btn.closest(".rights-item").attr("data-righttype");
    var driverId = $btn.closest(".input-group").find("select").val();
    var def = $btn.closest(".def-control").length > 0;
    var pCanEdit = (canEdit && !def);
    asyncDialogEasy("/right/rights_pluginconfig_dialog", "driverId=" + driverId + "&rightType=" + rightType + "&canEdit=" + pCanEdit);
  }
});

function showMultiEdit(elem, rightType, inline) {
  var speed = 200;
  var oldDIV = $(elem).closest(".rights-body-content");
  oldDIV.hide("slide", {direction:"left"}, speed);
  
  var sButtonHTML =
      "<button class='btnclose btn btn-default' style='margin-bottom:20px'>" + 
      "<i class='fa fa-chevron-left'></i> <v:itl key="@Common.Back"/>" +
      "</button>";
  
  var w = $('#rights-body').width();
  var newDIV = $("<div class='rights-subbody'><div class='rights-body-content'>" + sButtonHTML + "<div class='rights-content-block'><div class='rights-item'/></div></div></div>");
  newDIV.css({
    position: "absolute",
    top: 0,
    left: w,
    width: w
  });
  $("#rights-body").append(newDIV);
  newDIV.animate({left:0}, speed);
  
  var itemDIV = newDIV.find(".rights-item");
  
  var oldCBs = $("[name='Right" + rightType + "']");
  for (var i=0; i<oldCBs.length; i++) {
    var newLBL = $("<label class='checkbox-label'/>").appendTo(itemDIV);
    var newCB = $("<input type='checkbox'/>").appendTo(newLBL);
    newLBL.append("&nbsp;" + $(oldCBs[i]).attr("data-Description"));
    itemDIV.append("<br/>");
    newCB.attr("value", $(oldCBs[i]).val());
    newCB.setChecked($(oldCBs[i]).isChecked());
  }
  
  newDIV.find(".btnclose").button().click(function() {
    var newHTML = "";
    var newCBs = itemDIV.find("[type='checkbox']");
    var empty = true;
    for (var i=0; i<newCBs.length; i++) {
      var oldCB = $("[name='Right" + rightType + "'][value='" + $(newCBs[i]).val() + "']");
      oldCB.setChecked($(newCBs[i]).isChecked());
      if (oldCB.isChecked()) {
        if (!empty)
          newHTML += (inline ? ", " : "</br>");
        newHTML += oldCB.attr("data-Description");
        empty = false;
      }
    }        
    
    if (empty)
      newHTML += "<v:itl key="@Common.NoItems"/></br>";
    
    $("#rights-multi-edit-" + rightType).html(newHTML);
    oldDIV.show("slide", {direction:"left"}, speed);
    newDIV.animate({left:$('#rights-body').width()}, speed, "swing", function() {
      newDIV.remove();
    });
  });
}

function rightsSearch() {
  $("#rights-dialog .search-hide").removeClass("search-hide");

  var keys = getSearchKeys($("#rights-menu .txt-search").val());
  if (keys.length > 0) {
    $("#rights-menu .rights-menu-item").each(function(idx, menu) {
      var $menu = $(menu);
      var menuMatch = false;
      $("#rights-body " + $menu.attr("data-Target") + " .rights-content-section").each(function(idx, section) {
        var $section = $(section);
        var sectionMatch = isTextFullSearch($section.find("h3").text(), keys);
        if (!sectionMatch) {
          $section.find(".rights-item").each(function(idx, item) {
            var $item = $(item);
            if (isTextFullSearch($item.find(".rights-item-label").text(), keys)) 
              sectionMatch = true;
            else
              $item.addClass("search-hide");
          });
        }
        
        if (sectionMatch)
          menuMatch = true;
        else
          $section.addClass("search-hide");
      });
      $menu.setClass("search-hide", !menuMatch);
    });
  }
}

</script>

</v:dialog>
