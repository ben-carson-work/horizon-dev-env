<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
String widgetId = "ent-" + JvUtils.newSqlStrUUID();
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
boolean canEdit = pageBase.getRightCRUD().canUpdate();
String entitlementWidgetCaption = pageBase.getNullParameter("entitlement-widget-caption");
LookupItem entitlementStatus = JvUtils.coalesce((LookupItem)request.getAttribute("entitlement-status"), LkSNEntitlementStatus.Static);
%>

<style>
.ent-dialog {display:none}
</style>

<v:widget id="<%=widgetId%>" clazz="entitlement-widget" caption="<%=entitlementWidgetCaption%>">
  <v:widget-block id="entitlement-toolbar" clazz="hidden">
    <v:button-group>
      <v:button-group>
        <v:button caption="@Common.Add" fa="plus" id="add-ent-btn" dropdown="true" enabled="<%=canEdit%>"/>
        <v:popup-menu id="add-menu" bootstrap="true">
          <v:popup-item caption="@Entitlement.Group" fa="folder-plus" id="add-group-menu" clazz="val-node"/>
          <v:popup-item caption="@Event.AllEvents" fa="masks-theater" id="add-all-events-menu" clazz="val-node"/>
          <v:popup-item caption="@Event.PPUEvents" fa="award-simple" id="add-ppu-events-menu" clazz="val-node"/>
          <v:popup-item caption="@Event.Event" fa="masks-theater" id="add-event-menu" clazz="val-node"/>
          <v:popup-item caption="@Product.ProductType" fa="tag" id="add-product-menu" clazz="val-node"/>
          <v:popup-divider/>
          <v:popup-item caption="@Entitlement.Entry" fa="arrow-up" id="add-entry-menu"/>
          <v:popup-item caption="@Entitlement.ReEntry" fa="arrow-up fa-rotate-45" id="add-reentry-menu"/>
          <v:popup-item caption="@Entitlement.ExtraEntry" fa="thumbs-up" id="add-extraentry-menu"/>
          <v:popup-item caption="@Entitlement.IncProd" fa="hashtag" id="add-incprod-menu"/>
          <v:popup-item caption="@Entitlement.IncProdValue" fa="dollar-sign" id="add-incprodvalue-menu"/>
        </v:popup-menu>
      </v:button-group>
      
      <v:button-group>
        <v:button caption="@Common.Options" fa="cog" id="opt-ent-btn" dropdown="true" enabled="<%=canEdit%>"/>
        <v:popup-menu id="opt-menu" bootstrap="true">
          <v:popup-item caption="@Entitlement.RequireExitForReEntry" fa="sign-out" id="require-exit-for-reentry-menu"/>
          <v:popup-item caption="@Entitlement.FlashAtAPT" fa="lightbulb-on" id="flash-at-apt-menu"/>
          <v:popup-item caption="@Entitlement.AntiPassBackMinutes" fa="clock" id="add-antipassbackmin-menu"/>
          <v:popup-item caption="@Entitlement.AptSingleUseMinutes" fa="clock" id="add-aptsingleusemin-menu"/>
          <v:popup-item caption="@Entitlement.Crossover" fa="random" id="crossover-menu"/>
          <% if (entitlementStatus.isLookup(LkSNEntitlementStatus.Static)) { %>
            <v:popup-item caption="@Entitlement.WalletInitialDeposit" fa="dollar-sign" id="walletdeposit-menu"/>
            <v:popup-item caption="@Entitlement.RewardPointsDeposit" fa="dollar-sign" id="rewardpoints-deposit-menu"/>
          <% } %>
          <v:popup-item caption="@Entitlement.PPUEntryCharge" fa="dollar-sign" id="ppu-entry-charge-menu"/>
          <v:popup-item caption="@Entitlement.PPUReentryCharge" fa="dollar-sign" id="ppu-reentry-charge-menu"/>
          <v:popup-item caption="@Product.TimedTicketRule" fa="clock" id="add-ttrule-menu"/>
          <v:popup-item caption="@Entitlement.Passthrough" fa="person-walking-dashed-line-arrow-right" id="passthrough-menu"/> 
          <v:popup-item caption="@Entitlement.StopOnInvalidCrossover" fa="times" id="stop-on-invalid-crossover-menu"/>
          <v:popup-item caption="@Entitlement.ContinueOnInvalidReentry" fa="repeat" id="continue-on-invalid-reentry-menu"/>
          <v:popup-item caption="@Entitlement.ApplyReentryAsEntry" fa="arrow-up fa-rotate-45" id="apply-reentry-as-entry-menu"/>
          <v:popup-item caption="@Entitlement.PerformanceQuantity" fa="stream" id="perfqty-menu"/>
        </v:popup-menu>
      </v:button-group>
      
      <v:button-group>
        <v:button caption="@Common.Validity" fa="calendar-alt" id="val-ent-btn" dropdown="true" enabled="<%=canEdit%>"/>
        <v:popup-menu id="val-menu" bootstrap="true">
          <v:popup-item caption="@Common.Calendar" fa="calendar-alt" id="calendar-menu"/>
          <v:popup-item caption="@Entitlement.ExpirationRule" fa="calendar-times" id="exprule-menu"/>
          <v:popup-item caption="@Entitlement.FirstUsageRule" fa="calendar-times" id="firstusage-rule-menu"/>
          <v:popup-item caption="@Entitlement.DateRange" fa="exchange-alt" id="daterange-menu"/>
          <v:popup-item caption="@Entitlement.TimeRange" fa="clock" id="timerange-menu"/>
          <v:popup-item caption="@Entitlement.WeekDays" fa="calendar-week" id="weekdays-menu"/>
          <v:popup-item caption="@Entitlement.PerfValidity" fa="masks-theater" id="perfbaseddays-menu"/>
          <v:popup-item caption="@Entitlement.ResourceBasedValidity" fa="graduation-cap" id="resourcebaseddays-menu"/>
          <v:popup-item caption="@Entitlement.CrossoverTimeRange" fa="random" id="crossover-timerange-menu"/>
          <v:popup-item caption="@Entitlement.SecUsageWaitDays" fa="list-ol" id="secusage-waitdays-menu"/>
          <v:popup-item caption="@Entitlement.PeriodConstraint" fa="arrow-up-to-line" id="period-constraint-menu"/>
          <v:popup-item caption="@Entitlement.ValidAfterGroup" fa="sort-size-down" id="valid-after-group-menu"/>
        </v:popup-menu>
      </v:button-group>
    </v:button-group>

    <v:button-group>
      <v:button caption="@Common.Edit" fa="pencil" id="edit-ent-btn" enabled="<%=canEdit%>"/>
      <v:button caption="@Common.Remove" fa="minus" id="remove-ent-btn" enabled="<%=canEdit%>"/>
    </v:button-group>
  </v:widget-block>
  <v:widget-block>
    <ul id="ent-tree"></ul>
  </v:widget-block>

  <jsp:include page="ent-group-dialog.jsp"/>
  <jsp:include page="ent-entry-dialog.jsp"/>
  <jsp:include page="ent-reentry-dialog.jsp"/>
  <jsp:include page="ent-override-dialog.jsp"/>
  <jsp:include page="ent-incprod-dialog.jsp"/>
  <jsp:include page="ent-incprodvalue-dialog.jsp"/>
  <jsp:include page="ent-antipassbackmin-dialog.jsp"/>
  <jsp:include page="ent-aptsingleusemin-dialog.jsp"/>
  <jsp:include page="ent-calendar-dialog.jsp"/>
  <jsp:include page="ent-exprule-dialog.jsp"/>
  <jsp:include page="ent-firstusagerule-dialog.jsp"/>
  <jsp:include page="ent-crossover-rule-dialog.jsp"/>
  <jsp:include page="ent-daterange-dialog.jsp"/>
  <jsp:include page="ent-timerange-dialog.jsp"/>
  <jsp:include page="ent-weekdays-dialog.jsp"/>
  <jsp:include page="ent-walletinitialdeposit-dialog.jsp"/>
  <jsp:include page="ent-rewardpointsdeposit-dialog.jsp"/>
  <jsp:include page="ent-ppuentrycharge-dialog.jsp"/>
  <jsp:include page="ent-ppureentrycharge-dialog.jsp"/>
  <jsp:include page="ent-timedticketrule-dialog.jsp"/>
  <jsp:include page="ent-perfbaseddays-dialog.jsp"/>
  <jsp:include page="ent-resourcebaseddays-dialog.jsp"/>
  <jsp:include page="ent-passthrough-dialog.jsp"/>
  <jsp:include page="ent-perfqty-dialog.jsp"/>
  <jsp:include page="ent-crossover-timerange-dialog.jsp"/>
  <jsp:include page="ent-secusage-waitdays-dialog.jsp"/>
  <jsp:include page="ent-period-constraint-dialog.jsp"/>
  <jsp:include page="ent-valid-after-group-dialog.jsp"/>
</v:widget>

<script>
//# sourceURL=entitlement_widget.jsp

$(document).ready(function() {
  var $widget = $(<%=JvString.jsString("#" + widgetId)%>);
  var readOnly = <%=pageBase.isParameter("entitlement-readonly", "true")%>;
  const ppuEventId = <%=JvString.jsString(SnappUtils.encodeLookupPseudoId(LkSN.EntityType, LkSNEntityType.PPUEvent))%>;
  
  var $dialogs = $widget.find(".ent-dialog");
  
  function showEntDialog(id, obj, callback) {
    var $dlg = $dialogs.filter("#" + id);
    var controller = $dlg.data("controller");

    $dlg.dialog({
      modal: true,
      width: controller.width,
      buttons: [
        dialogButton("@Common.Ok", controller.onSave),
        dialogButton("@Common.Cancel", doCloseDialog)
      ]
    });
    
    controller.onShow(obj, function() {
      $dlg.dialog("close");
      callback();
    });
  };
  
  function entDialog(id, fnc) {
    var $dlg = $dialogs.filter("#" + id);
    var controller = fnc($dlg);
    $dlg.data("controller", controller);
    $dlg.keypressEnter(controller.onSave);
  }

  <%@ include file="ent-group-dialog.js" %>
  <%@ include file="ent-entry-dialog.js" %>
  <%@ include file="ent-reentry-dialog.js" %>
  <%@ include file="ent-override-dialog.js" %>
  <%@ include file="ent-incprod-dialog.js" %>
  <%@ include file="ent-incprodvalue-dialog.js" %>
  <%@ include file="ent-antipassbackmin-dialog.js" %>
  <%@ include file="ent-aptsingleusemin-dialog.js" %>
  <%@ include file="ent-calendar-dialog.js" %>
  <%@ include file="ent-exprule-dialog.js" %>
  <%@ include file="ent-firstusagerule-dialog.js" %>
  <%@ include file="ent-crossover-rule-dialog.js" %>
  <%@ include file="ent-daterange-dialog.js" %>
  <%@ include file="ent-timerange-dialog.js" %>
  <%@ include file="ent-weekdays-dialog.js" %>
  <%@ include file="ent-walletinitialdeposit-dialog.js" %>
  <%@ include file="ent-rewardpointsdeposit-dialog.js" %>
  <%@ include file="ent-ppuentrycharge-dialog.js" %>
  <%@ include file="ent-ppureentrycharge-dialog.js" %>
  <%@ include file="ent-timedticketrule-dialog.js" %>
  <%@ include file="ent-perfbaseddays-dialog.js" %>
  <%@ include file="ent-resourcebaseddays-dialog.js" %>
  <%@ include file="ent-passthrough-dialog.js" %>
  <%@ include file="ent-perfqty-dialog.js" %>
  <%@ include file="ent-crossover-timerange-dialog.js" %>
  <%@ include file="ent-secusage-waitdays-dialog.js" %>
  <%@ include file="ent-period-constraint-dialog.js" %>
  <%@ include file="ent-valid-after-group-dialog.js" %>



  $widget.find("#add-ent-btn").click(function(event) {
    var valNode = getValidityNode(getSelectedNode());
    var entType = (valNode == null) ? "<%=LkSNEntitlementType.Group.getCode()%>" : getObjEnt(valNode).EntType;
    var isGroup = (entType == "<%=LkSNEntitlementType.Group.getCode()%>");
    var isEvent = (entType == "<%=LkSNEntitlementType.Event.getCode()%>");
    var isProductType = (entType == "<%=LkSNEntitlementType.ProductType.getCode()%>");
    setVisible($widget.find("ul#add-menu li.val-node"), isGroup);
    setVisible($widget.find("#add-entry-menu"), isGroup || isEvent);
    setVisible($widget.find("#add-reentry-menu"), isGroup || isEvent);
    setVisible($widget.find("#add-extraentry-menu"), isGroup || isEvent);
    setVisible($widget.find("#add-ttrule-menu"), isGroup || isEvent);
    setVisible($widget.find("#add-incprod-menu"), isGroup || isProductType);
    setVisible($widget.find("#add-incprodvalue-menu"), isProductType);
  });
  $widget.find("#opt-ent-btn").click(function(event) {
    var valNode = getValidityNode(getSelectedNode());
    var entType = (valNode == null) ? "<%=LkSNEntitlementType.Group.getCode()%>" : getObjEnt(valNode).EntType;
    setVisible($widget.find("#perfbaseddays-menu"), (entType == "<%=LkSNEntitlementType.Group.getCode()%>"));
    setVisible($widget.find("#resourcebaseddays-menu"), (entType == "<%=LkSNEntitlementType.Group.getCode()%>"));
    setVisible($widget.find("#passthrough-menu"), (entType == "<%=LkSNEntitlementType.Event.getCode()%>"));
  });
  $widget.find("#val-ent-btn").click(function(event) {
    var valNode = getValidityNode(getSelectedNode());
    var entType = (valNode == null) ? "<%=LkSNEntitlementType.Group.getCode()%>" : getObjEnt(valNode).EntType;
    setVisible($widget.find("#perfqty-menu"), (valNode == null));
  });
  
  var fncNodeClicked = function() {
    setSelectedNode($(this).parent());
  };
  
  var defaultGroupCode = "DEFAULT";
  var itemTypes = [
      "itUnknown", "itEntry", "itReentry", "itExtraEntry", "itAntipassBack", "itCrossover", "itWalletInitialDeposit", "itRewardPointsDeposit", 
      "itPPUEntryCharge",  "itPPUReentryCharge", "itExpRule", "itFirstUsageRule", "itDateRange", "itTimeRange", "itWeekDays", 
      "itTicket2MediaLink", "itRefundPercentage", "itIncProd", "itIncProdValue", "itAntipassBackMin", "itAptSingleUseMin", "itTimedTicketRule", 
      "itCalendar", "itFlashAtAPT", "itPerfBasedDays", "itResourceBasedDays", "itPassthrough", "itContinueOnInvalidReentry", 
      "itStopOnInvalidCrossover", "itApplyReentryAsEntry", "itPerfQty", "itCrossoverTimeRange", "itSecUsageWaitDays", "itPeriodConstraint", "itValidAfterGroup"];
   
  <%DOEntitlement ent = (DOEntitlement)request.getAttribute("entitlement");
  BLBO_Entitlement.recursiveClearDeprecatedFields(ent);
  
  String eventCache = "[]";
  if (ent != null) {
    try (JvDataSet ds = pageBase.getBL(BLBO_Entitlement.class).getEventDS(ent)) {
      eventCache = ds.getDocJSON();
    }
  }
  
  String productCache = "[]";
  if (ent != null) {
    try (JvDataSet ds = pageBase.getBL(BLBO_Entitlement.class).getProductDS(ent)) {
      productCache = ds.getDocJSON();
    }
  }
  
  String rewardPointsCache = "[]";
  if (ent != null) {
    try (JvDataSet ds = pageBase.getBL(BLBO_RewardPoint.class).getRewardPointDS()) {
      rewardPointsCache = ds.getDocJSON();
    }
  }
 
  JvDataSet dsCalendar = pageBase.getBL(BLBO_Calendar.class).getCalendarDS((String)null);
  QueryDef qdef = new QueryDef(QryBO_TimedTicketRule.class);
  qdef.addSelect(QryBO_TimedTicketRule.Sel.TimedTicketRuleId);
  qdef.addSelect(QryBO_TimedTicketRule.Sel.RuleName);
  JvDataSet dsTTRule = pageBase.execQuery(qdef);%>
 
  <%if (ent == null) {%>
    var objEntRoot = newObjEnt();
  <%} else {%>
    var objEntRoot = <%=ent.getJSONString()%>;
  <%}%>
  $widget.data("entitlement", objEntRoot);
  
  var eventCache = <%=eventCache%>
  var productCache = <%=productCache%>
  var ttruleCache = <%=(dsTTRule == null) ? "[]" : dsTTRule.getDocJSON()%>
  var calendarCache = <%=(dsCalendar == null) ? "[]" : dsCalendar.getDocJSON()%>
  var rewardPointsCache = <%=rewardPointsCache%>
  
  initEntitlements();
  
  $widget.on("update-entitlement", function(event, params) {
    objEntRoot = params.Entitlement || newObjEnt();
    eventCache = params.EventCache || [];
    productCache = params.ProductCache || [];
    $widget.data("entitlement", objEntRoot);
    initEntitlements();
  });
  
  function loadEntTree(objEnt, parentNode) {
    if (objEnt.EntType != null) 
      parentNode = addEntNode(parentNode, objEnt, objEnt.EntType, "");
    
    if (objEnt.EntList != null) {
      for (var i=0; i<objEnt.EntList.length; i++)
        loadEntTree(objEnt.EntList[i], parentNode);
    }
  }

  $widget.find("#remove-ent-btn").click(function(event) {
    var node = $widget.find("#ent-tree li.selected");
    var objEnt = node.data("ObjEnt");
    switch (node.attr("data-nodetype")) {
    case "ntEntitlement":
      recursiveDelObjEnt(objEntRoot, objEnt);
      node.remove();
      break;
    case "ntHeader":
      var headerType = node.attr("data-headertype");
      if (headerType == "htValidity")
        objEnt.EntList = [];
      else {
        for (const itemType of itemTypes) {
          if (headerType == getHeaderType(itemType))
            clearItemValidity(objEnt, itemType);
        }
      }
      node.remove();
      break;
    case "ntItem":
      switch (node.attr("data-itemtype")) {
      case "itRewardPointsDeposit": 
        delObjPoints(objEnt);
        node.remove();
        break;
      default:
        clearItemValidity(objEnt, node.attr("data-itemtype"));
        refreshConstraintItems(node);
        break;
      }
      break;
    }
  });
  
  function initEntitlements() {
    setVisible($widget.find("#entitlement-toolbar"), !readOnly);

    $widget.find("#ent-tree").empty();
    loadEntTree(objEntRoot, null);
    refreshConstraintItems(null);
    
    enableDisable();
    $widget.trigger("click");  //We need to trigger an event in order to syncronize the loading of the widget in the history_detail_entitlement_comparison page.
  }

  function enableDisable() {
    var node = $widget.find("#ent-tree li.selected");
    var objEnt = node.data("ObjEnt");
    var nodeType = node.attr("data-nodetype");
    var entType = node.attr("data-enttype");
    var itemType = node.attr("data-itemtype");
    setVisible("#edit-ent-btn", 
      (nodeType == "ntEntitlement" && entType == "<%=LkSNEntitlementType.Group.getCode()%>" && objEnt.GroupCode != defaultGroupCode) ||
      (nodeType == "ntItem" && ["itEntry", "itReentry", "itExtraEntry", "itExpRule", "itFirstUsageRule", "itCrossover", "itDateRange", "itTimeRange", "itWeekDays", "itAntipassBackMin", 
                                "itAptSingleUseMin", "itWalletInitialDeposit", "itRewardPointsDeposit", "itPPUEntryCharge", "itPPUReentryCharge", "itTimedTicketRule", 
                                "itFlashAtAPT", "itPerfBasedDays", "itResourceBasedDays", "itPassthrough", "itContinueOnInvalidReentry", "itStopOnInvalidCrossover", "itApplyReentryAsEntry", "itPerfQty", 
                                "itCrossoverTimeRange", "itSecUsageWaitDays", "itPeriodConstraint", "itValidAfterGroup"].indexOf(itemType) >= 0)
    );
  }
  
  function getObjEnt(node) {
    var result = null;
    if (node == null)
      result = objEntRoot;
    else
      result = $(node).data("ObjEnt");
    
    if (!(result))
      result = {};

    if (!(result.EntList))
      result.EntList = [];
    return result;
  }
  
  function getSelectedNode() {
    var node = $widget.find("#ent-tree li.selected");
    if (node.length == 0)
      return null;
    else
      return node;
  }
  
  function setSelectedNode(node) {
    if (!readOnly) {
      $widget.find("#ent-tree li.selected").removeClass("selected");
      if (node != null) 
        $(node).addClass("selected");
      enableDisable();
    }
  }

  function setNodeCaption(node, caption) {
    node.children("span.title").html(caption);
  }
  
  function setNodeIcon(node, icon) {
    node.children("span.title").css("background-image", "url('<v:config key="site_url"/>/imagecache?name=" + icon + "&size=16')");
  }
  
  function recursiveDelObjEnt(objEntParent, objEnt) {
    for (var i=0; i<objEntParent.EntList.length; i++) {
      var objEntChild = objEntParent.EntList[i];
      if (objEntChild == objEnt) {
        removeArrayElem(objEntParent.EntList, objEntChild);
        break;
      }
      else 
        recursiveDelObjEnt(objEntChild, objEnt);
    }
  }
  
  function delObjPoints(objEnt) {
    for (var i=0; i<objEntRoot.PointsDepList.length; i++) {
      var objEntChild = objEntRoot.PointsDepList[i];
      if (objEntChild == objEnt) {
        removeArrayElem(objEntRoot.PointsDepList, objEntChild);
        break;
      }
    }
  }
  
  function clearItemValidity(objEnt, itemType) {
    switch (itemType) {
    case "itEntry":
      delete objEnt["EntryType"];
      delete objEnt["EntryQty"];
      break;
    case "itReentry":
      delete objEnt["ReEntryType"];
      delete objEnt["ReEntryQty"];
      break;
    case "itExtraEntry":
      delete objEnt["OverrideType"];
      delete objEnt["OverrideQty"];
      break;
    case "itAntipassBack":
      delete objEnt["AntiPassBack"];
      break;
    case "itFlashAtAPT":
      delete objEnt["FlashAtAPT"];
      break;
    case "itApplyReentryAsEntry":
      delete objEnt["ApplyReentryAsEntry"];
      break;
    case "itContinueOnInvalidReentry":
      delete objEnt["ContinueOnInvalidReentry"];
      break;
    case "itStopOnInvalidCrossover":
      delete objEnt["StopOnInvalidCrossover"];
      break;
    case "itAntipassBackMin":
      delete objEnt["AntiPassBackMinutes"];
      break;
    case "itAptSingleUseMin":
      delete objEnt["AptSingleUseMinutes"];
      break;
    case "itCrossover":
      delete objEnt["CrossoverRule"];
      break;
    case "itWalletInitialDeposit":
      delete objEnt["WalletInitialDeposit"];
      delete objEnt["WalletInheritFromSalePrice"];
      break;
    case "itRewardPointsDeposit":
      delete objEnt["PointsDepList"];
      if (objEnt.PointsId)
        delete objEnt;
      break;  
    case "itPPUEntryCharge":
      delete objEnt["PPUEntryChargeApplyRules"];
      delete objEnt["PPUEntryChargeList"];
      break;
    case "itPPUReentryCharge":
      delete objEnt["PPUReentryChargeApplyRules"];
      delete objEnt["PPUReentryChargeList"];
      break;
    case "itExpRule":
      delete objEnt["ExpRule"];
      delete objEnt["ExpRuleQty"];
      delete objEnt["ExpRuleFirstUsageFromNode"];
      break;
    case "itFirstUsageRule":
      delete objEnt["FirstUsageRule"];
      delete objEnt["FirstUsageRuleQty"];
      delete objEnt["FirstUsageRuleDate"];
      break;
    case "itDateRange":
      delete objEnt["DateRangeValidityType"];
      delete objEnt["ValidFromDate"];
      delete objEnt["ValidToDate"];
      break;
    case "itTimeRange":
      delete objEnt["ValidFromTime"];
      delete objEnt["ValidToTime"];
      delete objEnt["FirstDayValidFromTime"];
      delete objEnt["FirstDayValidToTime"];
      delete objEnt["SelectionFromTime"];
      delete objEnt["SelectionToTime"];
      break;
    case "itWeekDays":
      delete objEnt["WeekDays"];
      break;
    case "itTimedTicketRule":
      delete objEnt["TimedTicketRuleId"];
      delete objEnt["RuleName"];
      break;
    case "itCalendar":
      delete objEnt["CalendarId"];
      break;
    case "itIncProd":
      delete objEnt["IncProdQty"];
      break;
    case "itIncProdValue":
        delete objEnt["IncProdValue"];
        break;      
    case "itPerfBasedDays": 
      delete objEnt["PerfExpDays"];
      delete objEnt["PerfStartDays"];
      delete objEnt["PerfMatch"];
      break;
    case "itResourceBasedDays": 
        delete objEnt["ResourceExpDays"];
        delete objEnt["ResourceStartDays"];
        break;  
    case "itPassthrough": 
      delete objEnt["PassthroughType"];
      delete objEnt["PassthroughTolStart"];
      delete objEnt["PassthroughTolEnd"];
      delete objEnt["PassthroughEventIDs"];
      break;
    case "itPerfQty":
      delete objEnt["PerfQty"];
      break;
    case "itCrossoverTimeRange":
      delete objEnt["CrossoverFromTime"];
      delete objEnt["CrossoverToTime"];
      break;
    case "itSecUsageWaitDays":
        delete objEnt["SecUsageWaitDays"];
        break;
    case "itPeriodConstraint":
        delete objEnt["PeriodConstraint"];
        break;
    case "itValidAfterGroup":
      delete objEnt["ValidAfterGroup"];
      break;
    }
  }
  
  // return TTreeNode
  function addNode(parent, objEnt, nodeType, nodeWeight) {
    var node = $("<li><span class=\"title\"></span><ul></ul></li>");
    node.data("ObjEnt", objEnt);
    node.attr("data-nodetype", nodeType);
    node.attr("data-nodeweight", nodeWeight);
    node.children("span.title").click(fncNodeClicked);
    setSelectedNode(node);

    var ul = (parent == null) ? $widget.find("ul#ent-tree") : $(parent).children("ul");

    var added = false;
    var nodes = ul.children("li");
    for (var i=0; i<nodes.length; i++) {
      var sibling = $(nodes[i]);
      if (nodeWeight < sibling.attr("data-nodeweight")) {
        node.insertBefore(sibling);
        added = true;
      }
    }
    if (!added)
      node.appendTo(ul);

    return node;
  }

  // return TTreeNode
  function addHeaderNode(parent, objEnt, headerType) {
    var result = addNode(parent, objEnt, "ntHeader", getHeaderWeight(headerType));
    result.attr("data-headertype", headerType);
    refreshProperties(result);
    enableDisable();
    return result;
  }

  // return TTreeNode
  function findHeaderNode(objEnt, headerType) {
    var elems = $widget.find("ul#ent-tree li");
    for (var i=0; i<elems.length; i++) {
      var elem = $(elems[i]);
      if (elem.attr("data-headertype") == headerType && elem.data("ObjEnt") == objEnt)
        return elem;
    }
    return null;
  }
  
  // return TTreeNode
  function getHeaderNode(node, objEnt, headerType) {
    var result = findHeaderNode(objEnt, headerType);
    if (result == null) 
      result = addHeaderNode(node, objEnt, headerType);
    return result;
  }  
  
  // return TTreeNode
  function addEntNode(parent, objEnt, entType, caption) {
    parent = getHeaderNode(parent, getObjEnt(parent), "htValidity");
    var result = addNode(parent, objEnt, "ntEntitlement");
    result.data("Caption", caption);
    result.attr("data-enttype", entType);
    refreshProperties(result);
    refreshConstraintItems(result);
    
    return result;
  }
  
  // return TTreeNode
  function addItemNode(parent, objEnt, itemType) {
    var headerNode = getHeaderNode(parent, objEnt, getHeaderType(itemType));
    var result = addNode(headerNode, objEnt, "ntItem");
    result.attr("data-itemtype", itemType);
    refreshProperties(result);
    enableDisable();
    return result;
  }

  function getHeaderType(itemType) {
    switch (itemType) {
    case "itEntry":
    case "itReentry":
    case "itExtraEntry":
    case "itIncProd":
      return "htQuantity";
    case "itIncProdValue":
    case "itExpRule":
    case "itFirstUsageRule":
    case "itDateRange":
    case "itTimeRange":
    case "itWeekDays":
    case "itFlashAtAPT":
    case "itApplyReentryAsEntry":
    case "itContinueOnInvalidReentry":
    case "itStopOnInvalidCrossover":
    case "itAntipassBack":
    case "itAntipassBackMin":
    case "itAptSingleUseMin":
    case "itCrossover":
    case "itTicket2MediaLink":
    case "itRefundPercentage":
    case "itTimedTicketRule":     
    case "itCalendar":
    case "itPerfBasedDays":
    case "itResourceBasedDays":
    case "itPassthrough":
    case "itPerfQty":
    case "itCrossoverTimeRange":
    case "itSecUsageWaitDays":
    case "itPeriodConstraint":
    case "itValidAfterGroup":
      return "htOptions";
    case "itWalletInitialDeposit":
    case "itRewardPointsDeposit":      
      return "htInitialDeposit";
    case "itPPUEntryCharge":
    case "itPPUReentryCharge":
      return "htPayPerUse";
    default:
      return "htUnknown";
    }
  }

  function getHeaderText(headerType) {
    switch (headerType) {
    case "htQuantity":
      return itl("@Entitlement.Quantities");
    case "htOptions":
      return itl("@Entitlement.Options");
    case "htInitialDeposit":
      return itl("@Entitlement.InitialDeposit");
    case "htPayPerUse":
      return itl("@Entitlement.PayPerUse");
    case "htValidity":
      return itl("@Entitlement.GroupsEventsProducts");
    default:
      return "UNKNOWN";
    }
  }
  
  function getHeaderWeight(headerType) {
    switch (headerType) {
    case "htQuantity":
      return "1";
    case "htOptions":
      return "2";
    case "htInitialDeposit":
      return "3";
    case "htPayPerUse":
      return "4";
    case "htValidity":
      return "5";
    default:
      return "UNKNOWN";
    }
  }
  
  function getItemEntryText(objEnt) {
    if (objEnt.EntryType == null && objEnt.NumEntry == null) 
      return null;
    else {
      var result = itl("@Entitlement.Entries") + "(";
      if (objEnt.EntryCount != null)
        result += objEnt.EntryCount + "/";
      if (objEnt.EntryQty == null || objEnt.EntryQty == "")
        result += itl("@Common.Unlimited");
      else
        result += objEnt.EntryQty;
      result += "): ";

      switch (parseInt(objEnt.EntryType)) {
      case <%=LkSNEntryType.Automatic.getCode()%>:
        result += itl("@Entitlement.PerfSelAuto");
        break;
      case <%=LkSNEntryType.BeforeEncoding.getCode()%>:
        result += itl("@Entitlement.PerfSelBeforeEncoding");
        break;
      case <%=LkSNEntryType.BeforeUsage.getCode()%>:
        result += itl("@Entitlement.PerfSelBeforeUsage");
        break;
      case <%=LkSNEntryType.Dynamic.getCode()%>:
          result += itl("@Entitlement.PerfSelDynamic");
          break;
      default:
        result += "UNKNOWN ENTRY TYPE '" + objEnt.EntryType + "'";
      }

      if (objEnt.AutoSelectPerformance == "true")
        result += " (auto select performance)";

      return result;
    }
  }
  
  function getItemReentryText(objEnt) {
    if (objEnt.ReEntryType != <%=LkSNReEntryType.Permitted.getCode()%>)
      return null;
    else {
      var result = itl("@Entitlement.ReEntries") + "(";
      if (objEnt.ReEntryCount != null)
        result += objEnt.ReEntryCount + "/"; 
      if (objEnt.ReEntryQty == null || objEnt.ReEntryQty == "")
        result += itl("@Common.Unlimited");
      else
        result += objEnt.ReEntryQty;
      result += ")";

      return result;
    }
  }
  
  function getItemExtraEntryText(objEnt) {
    if (objEnt.OverrideType != <%=LkSNEntOverrideType.Permitted.getCode()%>)
      return null;
    else {
      var result = itl("@Entitlement.ExtraEntry") + "(";
      if (objEnt.OverrideCount != null)
        result += objEnt.OverrideCount + "/"; 
      if (objEnt.OverrideQty == null || objEnt.OverrideQty == "")
        result += itl("@Common.Unlimited");
      else
        result += objEnt.OverrideQty;
      result += ")";
      
      return result;
    }
  }
  
  function getItemTTRuleText(objEnt) {
    if ((objEnt.TimedTicketRuleId == null) || (objEnt.TimedTicketRuleId == ""))
      return null;
    else {
      var result = itl("@Product.TimedTicketRule") + "(";
      if (objEnt.TimedTicketRuleId != null)
        result += getTTRuleName(objEnt.TimedTicketRuleId);
      result += ")";

      return result;
    }
  }
  
  function getItemCalendarText(objEnt) {
    if ((objEnt.CalendarId == null) || (objEnt.CalendarId == ""))
      return null;
    else {
      var result = itl("@Common.Calendar") + "(";
      if (objEnt.CalendarId != null)
        result += getCalendarName(objEnt.CalendarId);
      result += ")";

      return result;
    }
  }
  
  function getItemIncProdText(objEnt) {
    if ((objEnt.IncProdQty == null) || (objEnt.IncProdQty == ""))
      return null;
    else {
      var result = itl("@Entitlement.IncProd") + " (";
      if (objEnt.IncProdCount != null)
        result += objEnt.IncProdCount + "/"; 
      result += objEnt.IncProdQty + ")";
      
      return result;
    }
  }
  
  function getItemIncProdValueText(objEnt) {
    var value = parseFloat(objEnt.IncProdValue);
    if (isNaN(value))
      return null;
    else {
      if (objEnt.IncProdValueType == <%=LkSNPriceValueType.Percentage.getCode()%>) 
        return itl("@Entitlement.IncProdValue") + ": " + value + "%";
      else 
        return itl("@Entitlement.IncProdValue") + ": " + formatCurr(value);
    }
  }
    
  function getItemFlashAtAPTText(objEnt) {
    if (objEnt.FlashAtAPT == "1")
      return itl("@Entitlement.FlashAtAPT");
    else
      return null;
  }
    
  function getItemApplyReentryAsEntryText(objEnt) {
    if (objEnt.ApplyReentryAsEntry == "1")
      return itl("@Entitlement.ApplyReentryAsEntry");
    else
      return null;
  }
    
  function getItemContinueOnInvalidReentryText(objEnt) {
    if (objEnt.ContinueOnInvalidReentry == "1")
      return itl("@Entitlement.ContinueOnInvalidReentry");
    else
      return null;
  }
  
  function getItemStopOnInvalidCrossoverText(objEnt) {
    if (objEnt.StopOnInvalidCrossover == "1")
      return itl("@Entitlement.StopOnInvalidCrossover");
    else
      return null;
  }
  
  function getItemAntipassBackText(objEnt) {
    if (objEnt.AntiPassBack == "1")
      return itl("@Entitlement.RequireExitForReEntry");
    else
      return null;
  }
  
  function getItemAntipassBackMinText(objEnt) {
    if (objEnt.AntiPassBackMinutes != null)
        return itl("@Entitlement.AntiPassBackMinutes") + ": " + objEnt.AntiPassBackMinutes;
    else
      return null;
  }
  
  function getItemAptSingleUseMinText(objEnt) {
    if (objEnt.AptSingleUseMinutes != null)
        return itl("@Entitlement.AptSingleUseMinutes") + ": " + objEnt.AptSingleUseMinutes;
    else
      return null;
  }
    
  function getItemCrossOverText(objEnt) {
    if (isNaN(parseInt(objEnt.CrossoverRule))) 
      return null;
    else 
      return itl("@Entitlement.Crossover") + ": " + getCrossoverRuleDesc(objEnt.CrossoverRule);
  }
  
  function getCrossoverRuleDesc(crossoverRule) {
    switch (crossoverRule) {
    <%for (LookupItem item : LkSN.CrossoverRule.getItems()) {%>
    case <%=item.getCode()%>: return "<%=item.getHtmlDescription(pageBase.getLang())%>";  
    <%}%>
    }
    return "";
  }

  function getItemWalletInitialDepositText(objEnt) {
    var inherit = objEnt.WalletInheritFromSalePrice;
    if (inherit)
      return itl("@Entitlement.WalletInitialDeposit") + ": " + itl("@Entitlement.InheritFromSalePrice");
    else {  
      var value = parseFloat(objEnt.WalletInitialDeposit);
      if (isNaN(value))
        return null;
      else
        return itl("@Entitlement.WalletInitialDeposit") + ": " + formatCurr(value);
    }
  }
  
  function getItemRewardPointsDepositText(objEnt) {
    var result = null;
    if ((objEnt.PointsId != null) && (objEnt.PointsId != "")) {
      var inherit = objEnt.PointsInheritFromSalePrice;
      if (inherit) 
        result = getRewardPointsName(objEnt.PointsId) + ": " + itl("@Entitlement.InheritFromSalePrice");  
      else {
        result = getRewardPointsName(objEnt.PointsId) + ": " + objEnt.PointsAmount;
        if ((objEnt.FaceValue != null) && (objEnt.FaceValue != ""))       
          result += " (" + itl("@Entitlement.FaceValue") + ": " + objEnt.FaceValue + ")"  
      }
    }
      
    return result;
  }

  function getItemPPUEntryChargeText(objEnt) {
    if (objEnt.PPUEntryChargeApplyRules == true)
      return itl("@Entitlement.PPUEntryCharge") + ": " + itl("@Product.PPURules");

    if (objEnt.PPUEntryChargeList && (objEnt.PPUEntryChargeList.length > 0)) {
      var result = itl("@Entitlement.PPUEntryCharge") + ": ";
      for (var i=0; i<objEnt.PPUEntryChargeList.length; i++) {
        var charge = objEnt.PPUEntryChargeList[i];
        if (charge.PointId == <%= JvString.jsString(BLBO_DBInfo.getSystemPointId_Wallet()) %>)
          result += formatCurr(charge.Amount);
        else
          result += charge.Amount + " " + getRewardPointsName(charge.PointId);
        if (i < objEnt.PPUEntryChargeList.length-1)
          result += " | ";
      }
      return result;
    }

    return null;
  }

  function getItemPPUReentryChargeText(objEnt) {
    if (objEnt.PPUReentryChargeApplyRules == true)
      return itl("@Entitlement.PPUReentryCharge") + ": " + itl("@Product.PPURules");

    if (objEnt.PPUReentryChargeList && (objEnt.PPUReentryChargeList.length > 0)) {
      var result = itl("@Entitlement.PPUReentryCharge") + ": ";
      for (var i=0; i<objEnt.PPUReentryChargeList.length; i++) {
        var charge = objEnt.PPUReentryChargeList[i];
        if (charge.PointId == <%= JvString.jsString(BLBO_DBInfo.getSystemPointId_Wallet()) %>)
          result += formatCurr(charge.Amount);
        else
          result += charge.Amount + " " + getRewardPointsName(charge.PointId);
        if (i < objEnt.PPUReentryChargeList.length-1)
          result += " | ";
      }
      return result;
    }

    return null;
  }
  
  function getExpRuleDesc(expRule) {
    switch (expRule) {
    <%for (LookupItem item : LkSN.ExpirationRule.getItems()) {%>
    case <%=item.getCode()%>: return "<%=item.getHtmlDescription(pageBase.getLang())%>";  
    <%}%>
    }
    return "";
  }
  
  function getItemExpRuleText(objEnt) {
    if (objEnt.ExpRule == null || objEnt.ExpRule == "") 
      return null;
    else {
      var result = itl("@Entitlement.ExpirationRule") + ": " + getExpRuleDesc(objEnt.ExpRule);
      var options = [];
      if (objEnt.ExpRuleQty != null && objEnt.ExpRuleQty != "")
        options.push(objEnt.ExpRuleQty);
      if (objEnt.ExpRuleFirstUsageFromNode === true)
        options.push(itl("@Entitlement.ExpRuleFirstUsageFromNode"));
      if (options.length > 0)
        result += " (" + options.join(" / ") + ")";
      return result;
    }
  }
  
  function getPassthroughTypeDesc(type) {
    switch(parseInt(type)) {
    case <%=LkSNSubEventPassthroughType.Day.getCode()%>: return itl("@Lookup.SubEventPassthroughType.Day");
    case <%=LkSNSubEventPassthroughType.Minute.getCode()%>: return itl("@Lookup.SubEventPassthroughType.Minute");
    }
    return "unknown";
  }
  
  function getItemPassthroughText(objEnt) {
    if (objEnt.PassthroughType) {
      var result = itl("@Entitlement.Passthrough") + ": " + getPassthroughTypeDesc(objEnt.PassthroughType);
      if (objEnt.PassthroughType == <%=LkSNSubEventPassthroughType.Minute.getCode()%>) {
        result +=  " (";
        result += (objEnt.PassthroughTolStart) ? objEnt.PassthroughTolStart : itl("@Entitlement.PerformanceStart").toLowerCase();
        result += " / ";
        result += (objEnt.PassthroughTolEnd) ? objEnt.PassthroughTolEnd : itl("@Entitlement.PerformanceEnd").toLowerCase();
        result += ")";
      }
      return result;
    }
    
    return null; 
  }
  
  function getItemPerfQtyText(objEnt) {
    if (objEnt.PerfQty) {
      return itl("@Entitlement.PerformanceQuantity") + ": " + objEnt.PerfQty;
    }
    
    return null; 
  }
    
  function getItemFirstUsageRuleText(objEnt) {
    if (objEnt.FirstUsageRule == null || objEnt.FirstUsageRule == "") 
      return null;
    else {
      var result = itl("@Entitlement.ToBeUsedWithin") + ": " + getFirstUsageRuleDesc(objEnt.FirstUsageRule);
      if (getNull(objEnt.FirstUsageRuleQty) != null)
        result += " (" + objEnt.FirstUsageRuleQty + ")";
      else if (getNull(objEnt.FirstUsageRuleDate) != null)
        result += " (" + formatDate(xmlToDate(objEnt.FirstUsageRuleDate)) + ")";
      return result;
    }
  }
  
  function getFirstUsageRuleDesc(firstUsageRule) {
    switch (firstUsageRule) {
    <%for (LookupItem item : LkSN.FirstUsageRule.getItems()) {%>
    case <%=item.getCode()%>: return "<%=item.getHtmlDescription(pageBase.getLang())%>";  
    <%}%>
    }
    return "";
  }
    
  function getItemDateRangeText(objEnt) {
    var result = null;
    
    if (objEnt.DateRangeValidityType == <%=LkSNDateRangeValidityType.Invalid.getCode()%>) {
      if (objEnt.ValidFromDate != null && objEnt.ValidFromDate != "")
        result = itl("@Entitlement.InvalidFrom") + " " + formatDate(xmlToDate(objEnt.ValidFromDate), <%=rights.ShortDateFormat.getInt()%>);
      
      if (objEnt.ValidToDate != null && objEnt.ValidToDate != "") {
        if (result == null)
          result = itl("@Entitlement.InvalidUntil") + " " + formatDate(xmlToDate(objEnt.ValidToDate), <%=rights.ShortDateFormat.getInt()%>);
        else
          result += " " + itl("@Entitlement.InvalidTo") + " " + formatDate(xmlToDate(objEnt.ValidToDate), <%=rights.ShortDateFormat.getInt()%>);
      }     
    }
    else {
      if (objEnt.ValidFromDate != null && objEnt.ValidFromDate != "")
        result = itl("@Entitlement.ValidFrom") + " " + formatDate(xmlToDate(objEnt.ValidFromDate), <%=rights.ShortDateFormat.getInt()%>);
      
      if (objEnt.ValidToDate != null && objEnt.ValidToDate != "") {
        if (result == null)
          result = itl("@Entitlement.ValidUntil") + " " + formatDate(xmlToDate(objEnt.ValidToDate), <%=rights.ShortDateFormat.getInt()%>);
        else
          result += " " + itl("@Entitlement.ValidTo") + " " + formatDate(xmlToDate(objEnt.ValidToDate), <%=rights.ShortDateFormat.getInt()%>);
      }
    }
 
    return result;
  }
  
  function getItemTimeRangeText(objEnt) {
    var result = _getTimeRangeText(objEnt.ValidFromTime, objEnt.ValidToTime);
    var firstDay = _getTimeRangeText(objEnt.FirstDayValidFromTime, objEnt.FirstDayValidToTime);
    var selection = _getTimeRangeText(objEnt.SelectionFromTime, objEnt.SelectionToTime);
    
    var ranges = [];
    if (result != null)
      ranges.push(result);
    if (firstDay != null)
      ranges.push(itl("@Entitlement.FirstDayTimeRange") + " (" + firstDay + ")");
    if (selection != null)
      ranges.push(itl("@Entitlement.SelectionTimeRange") + " (" + selection + ")");
    
    if (ranges.length > 0)
      result = ranges.join(" " + CHAR_MDASH + " ");
        
    function _getTimeRangeText(timeFrom, timeTo) {
      var text = null;
      if (getNull(timeFrom) != null) 
        text = itl("@Entitlement.ValidFrom") + " " + formatTime("0000-00-00T" + timeFrom);
      
      if (getNull(timeTo) != null) {
        if (text == null)
          text = itl("@Entitlement.ValidUntil") + " " + formatTime("0000-00-00T" + timeTo);
        else
          text += " " + itl("@Entitlement.ValidTo") + " " + formatTime("0000-00-00T" + timeTo);
      }
      return text;
    }
    
    return result;
  }
  
  function getItemCrossoverTimeRangeText(objEnt) {
    var result = null;
    if (getNull(objEnt.CrossoverFromTime) != null) 
      result = itl("@Entitlement.CrossoverFrom") + " " + formatTime("0000-00-00T" + objEnt.CrossoverFromTime);
    
    if (getNull(objEnt.CrossoverToTime) != null) {
      if (result == null)
        result = itl("@Entitlement.CrossoverUntil") + " " + formatTime("0000-00-00T" + objEnt.CrossoverToTime);
      else
        result += " " + itl("@Entitlement.CrossoverTo") + " " + formatTime("0000-00-00T" + objEnt.CrossoverToTime);
    }
    
    return result;
  }
  
  function getItemSecUsageWaitDaysText(objEnt) {
    var result = null;
    if (getNull(objEnt.SecUsageWaitDays) != null) 
      result = itl("@Entitlement.SecUsageWaitDays") + ": " + objEnt.SecUsageWaitDays;
    
    return result;
  }
  
  function getItemPeriodText(objEnt) {
    if ((objEnt.PeriodQty == null) || (objEnt.PeriodQty == ""))
      return null;
    
    var result = itl("@Entitlement.PeriodConstraint") + ": " + getPeriodDesc(objEnt.PeriodType) + " (";
    if (objEnt.PeriodCount != null)
      result += objEnt.PeriodCount + "/"; 
    result += objEnt.PeriodQty + ")";
    
    return result;
  }
  
  function getPeriodDesc(periodType) {
    switch (periodType) {
    <%for (LookupItem item : LkSN.PeriodType.getItems()) {%>
    case <%=item.getCode()%>: return itl("@Entitlement.MaxPer") + " <%=item.getHtmlDescription(pageBase.getLang())%>";  
    <%}%>
    }
    return "";
  }
  
  function getItemValidAfterGroupText(objEnt) {
    var result = null;
    if (getNull(objEnt.ValidAfterGroup) != null) 
      result = itl("@Entitlement.ValidAfterGroup") + ": " + objEnt.ValidAfterGroup;
    
    return result;
  }
  
  function getDayShortName(day) {
    <%pageContext.getOut().println("switch (day) {");
      String[] shortnames = DateFormatSymbols.getInstance(pageBase.getLocale()).getShortWeekdays(); 
      int start = Calendar.getInstance(pageBase.getLocale()).getFirstDayOfWeek(); 
      for (int i=start; i<start+7; i++) { 
        int value = ((i-1)%7)+1; 
        pageContext.getOut().println("case \"" + value + "\": return \"" + shortnames[value] + "\";");
      } 
      pageContext.getOut().println("}");%>
  }
  
  function getItemWeekDaysText(objEnt) {
    if (objEnt.WeekDays == null || objEnt.WeekDays.length == 0)
      return null;
    else {
      var names = [];
      for (var i=0; i<objEnt.WeekDays.length; i++)
        names.push(getDayShortName(objEnt.WeekDays[i]));
      return itl("@Entitlement.ActiveOnDays") + ": " + names.join(", ");
    }
  }
  
  function getItemPerfBasedDaysText(objEnt) {
    var match = (getNull(objEnt.PerfMatch) != null);
    var start = (getNull(objEnt.PerfStartDays) == null) ? null : objEnt.PerfStartDays;
    var exp = (getNull(objEnt.PerfExpDays) == null) ? null : objEnt.PerfExpDays;
    if (match)
      return itl("@Entitlement.PerfValidity") + ": " + itl("@Entitlement.PerfMatch");
    else if ((start == null) && (exp == null))
      return null;
    else {
      var result = "";

      if (start != null)
        result += " / " + itl("@Entitlement.PerfStartDaysShort") + " (" + start + ")"; 

      if (exp != null)
        result += " / " + itl("@Entitlement.PerfExpDaysShort") + " (" + exp + ")";
       
      return  itl("@Entitlement.PerfValidity") + ": " + result.substring(3, result.length);
    }
  }
  
  function getItemResourceBasedDaysText(objEnt) {
      var start = (getNull(objEnt.ResourceStartDays) == null) ? null : objEnt.ResourceStartDays;
      var exp = (getNull(objEnt.ResourceExpDays) == null) ? null : objEnt.ResourceExpDays;
      if ((start == null) && (exp == null))
        return null;
       else {
         var result = "";

         if (start != null)
           result += " / " + itl("@Entitlement.PerfStartDaysShort") + " (" + start + ")"; 

         if (exp != null)
           result += " / " + itl("@Entitlement.PerfExpDaysShort") + " (" + exp + ")";
         
         return  itl("@Entitlement.ResourceBasedValidity") + ": " + result.substring(3, result.length);
       }
    }
  
  function getItemTicket2MediaLinkText(objEnt) {
    return null;
  }
  
  function getItemRefundPercentageText(objEnt) {
    return null;
  }
  
  function getEventDesc(eventId) {
    if (eventId == null)
      return itl("@Event.AllEvents");
    
    if (eventId == ppuEventId)
      return itl("@Event.PPUEvents");
    
    for (var i=0; i<eventCache.length; i++)
      if (eventCache[i].EventId == eventId)
        return "[" + eventCache[i].EventCode + "] " + eventCache[i].EventName;
    return null;
  }
  
  function getProductDesc(productId) {
    for (var i=0; i<productCache.length; i++)
      if (productCache[i].ProductId == productId) {
        return "[" + productCache[i].ProductCode + "] " + productCache[i].ProductName;
      }
    return null;
  }
  
  function getTTRuleName(ttRuleId) {
    for (var i=0; i<ttruleCache.length; i++)
      if (ttruleCache[i].TimedTicketRuleId == ttRuleId) {
        return ttruleCache[i].RuleName;
      }
    return null;
  }
  
  function getCalendarName(calendarId) {
    for (var i=0; i<calendarCache.length; i++)
      if (calendarCache[i].CalendarId == calendarId) {
        return calendarCache[i].CalendarName;
      }
    return null;
  }

  function getRewardPointsName(rewardPointsId) {
    for (var i=0; i<rewardPointsCache.length; i++)
        if (rewardPointsCache[i].MembershipPointId == rewardPointsId) {
          return rewardPointsCache[i].MembershipPointName;
        }
      return null;
  }

  function findSubArray(itemType, objEnt) {
    switch (itemType) {
      case "itRewardPointsDeposit": return objEnt.PointsDepList;
    }
  }

  function getItemText(itemType, objEnt) {
    switch (itemType) {
      case "itEntry": return getItemEntryText(objEnt);
      case "itReentry": return getItemReentryText(objEnt);
      case "itExtraEntry": return getItemExtraEntryText(objEnt);
      case "itFlashAtAPT": return getItemFlashAtAPTText(objEnt);
      case "itApplyReentryAsEntry": return getItemApplyReentryAsEntryText(objEnt);
      case "itContinueOnInvalidReentry": return getItemContinueOnInvalidReentryText(objEnt);
      case "itStopOnInvalidCrossover": return getItemStopOnInvalidCrossoverText(objEnt);
      case "itAntipassBack": return getItemAntipassBackText(objEnt);
      case "itAntipassBackMin": return getItemAntipassBackMinText(objEnt);
      case "itAptSingleUseMin": return getItemAptSingleUseMinText(objEnt);
      case "itCrossover": return getItemCrossOverText(objEnt);
      case "itWalletInitialDeposit": return getItemWalletInitialDepositText(objEnt);
      case "itRewardPointsDeposit": return getItemRewardPointsDepositText(objEnt);
      case "itPPUEntryCharge": return getItemPPUEntryChargeText(objEnt);
      case "itPPUReentryCharge": return getItemPPUReentryChargeText(objEnt);
      case "itExpRule": return getItemExpRuleText(objEnt);
      case "itFirstUsageRule": return getItemFirstUsageRuleText(objEnt);
      case "itDateRange": return getItemDateRangeText(objEnt);
      case "itTimeRange": return getItemTimeRangeText(objEnt);
      case "itWeekDays": return getItemWeekDaysText(objEnt);
      case "itTicket2MediaLink": return getItemTicket2MediaLinkText(objEnt);
      case "itRefundPercentage": return getItemRefundPercentageText(objEnt);
      case "itIncProd": return getItemIncProdText(objEnt);
      case "itIncProdValue": return getItemIncProdValueText(objEnt);
      case "itTimedTicketRule": return getItemTTRuleText(objEnt);     
      case "itCalendar": return getItemCalendarText(objEnt);     
      case "itPerfBasedDays": return getItemPerfBasedDaysText(objEnt);
      case "itResourceBasedDays": return getItemResourceBasedDaysText(objEnt);
      case "itPassthrough": return getItemPassthroughText(objEnt);
      case "itPerfQty": return getItemPerfQtyText(objEnt);
      case "itCrossoverTimeRange": return getItemCrossoverTimeRangeText(objEnt);
      case "itSecUsageWaitDays": return getItemSecUsageWaitDaysText(objEnt);
      case "itPeriodConstraint": return getItemPeriodText(objEnt);
      case "itValidAfterGroup": return getItemValidAfterGroupText(objEnt);
    }
  }
  
  function refreshProperties(node) {
    var objEnt = getObjEnt(node);
    if (objEnt != null) {
      var nodeType = node.attr("data-nodetype");
      switch (nodeType) {
      case "ntEntitlement":
        var entType = node.attr("data-enttype");
        if (entType == "<%=LkSNEntitlementType.Group.getCode()%>") {
          var caption = itl("@Entitlement.Group");
          if (objEnt.GroupCode != null)
            caption = "[" + objEnt.GroupCode + "] " + caption;
          setNodeCaption(node, caption);
          setNodeIcon(node, encodeURI("[font-awesome]folder-open"));
        } 
        else if (entType == "<%=LkSNEntitlementType.Event.getCode()%>") {
          setNodeCaption(node, getEventDesc(objEnt.EventId));
          setNodeIcon(node, encodeURI("[font-awesome]masks-theater|ColorizeOrange"));
        }
        else if (entType == "<%=LkSNEntitlementType.ProductType.getCode()%>") {
          setNodeCaption(node, getProductDesc(objEnt.IncProductId));
          setNodeIcon(node, encodeURI("[font-awesome]tag|ColorizeGreen"));
        }
        $(node).css("font-weight", "bold");
        break;
      case "ntHeader":
        setNodeCaption(node, getHeaderText(node.attr("data-headertype")));
        setNodeIcon(node, encodeURI("[font-awesome]layer-group|ColorizeGray"));
        $(node).css("font-weight", "normal");
        break;
      case "ntItem":
        var itemType = node.attr("data-itemtype");
        setNodeCaption(node, getItemText(itemType, objEnt));
        setNodeIcon(node, encodeURI("[font-awesome]angle-right|ColorizeGray"));
        $(node).css("font-weight", "normal");
        break;
      }
    }
  }
  
  function refreshConstraintItems(node) {
    node = getValidityNode(node);
    var objEnt = getObjEnt(node);
    for (var i=0; i<itemTypes.length; i++) {
      var itemType = itemTypes[i];
      var subArray = findSubArray(itemType, objEnt);
      
      if (subArray) {
        var headerType = getHeaderType(itemType);
        var headerNode = findHeaderNode(objEnt, headerType);
        if (headerNode) 
          headerNode.find("> ul > li[data-itemtype='" + itemType + "']").remove();
          
        if (subArray.length > 0) {
          headerNode = getHeaderNode(node, objEnt, headerType);
          for (const subItem of subArray) {
            var item = addNode(headerNode, subItem, "ntItem");
            item.attr("data-itemtype", itemType);
            refreshProperties(item);
            enableDisable();
          }
        }
      }
      else {
        var s = getItemText(itemType, objEnt);
        var item = findItemNode(itemType, objEnt);
        if (s == null && item != null)
          item.remove();
        else if (s != null) {
          if (item != null) 
            refreshProperties(item);
          else
            item = addItemNode(node, objEnt, itemType);
        }
      }
    }
  }

  // return TTreeNode
  function getValidityNode(node) {
    while (node != null && node.length > 0 && node != $widget.find("ul#ent-tree")) {
      if (node.attr("data-nodetype") == "ntEntitlement")
        return node;
      node = node.parent();
    }
    return null;
  }

  // return TTreeNode
  function getGroupNode(node) {
    while (node != null && node.length > 0 && node != $widget.find("ul#ent-tree")) {
      var entType = node.attr("data-enttype");
      if (entType == "<%=LkSNEntitlementType.Group.getCode()%>")
        return node;
      node = node.parent();
    }
    return null;
  }

  // return TTreeNode
  function findItemNode(itemType, objEnt) {
    var elems = $widget.find("ul#ent-tree li[data-nodetype='ntItem'][data-itemType='" + itemType + "']");
    for (var i=0; i<elems.length; i++) {
      var elem = $(elems[i]);
      if (getObjEnt(elem) == objEnt) 
        return elem;
    }
    return null;
  }
  
  function getEntDesc(objEnt) {
    return "the caption";
  }
  
  function newObjEnt() {
    return {"EntList":[]};
  }
 
  function findNodeByObjEnt(objEnt) {
    var nodes = $widget.find("ul#ent-tree li");
    for (var i=0; i<nodes.length; i++) {
      var node = $(nodes[i]);
      if (node.data("ObjEnt") == objEnt)
        return node;
    }
    return null;
  }
  
  $widget.find("#edit-ent-btn").click(function(event) {
    var node = getSelectedNode();
    var entType = node.attr("data-enttype");
    if (entType == "<%=LkSNEntitlementType.Group.getCode()%>") {
      showEntDialog("ent-group-dialog", node.data("ObjEnt"), function() {
        refreshProperties(node);
      });      
    }
    else {
      var nodeType = node.attr("data-nodetype");
      if (nodeType == "ntItem") {
        switch (node.attr("data-itemtype")) {
          case "itEntry":
            $widget.find('#add-entry-menu').trigger('click');
            break;        
          case "itReentry":
            $widget.find('#add-reentry-menu').trigger('click');
            break;        
          case "itExtraEntry":
            $widget.find('#add-extraentry-menu').trigger('click');
            break;        
          case "itIncProd":
            $widget.find('#add-incprod-menu').trigger('click');
            break;        
          case "itIncProdValue":
            $widget.find('#add-incprodvalue-menu').trigger('click');
            break;    
          case "itAntipassBackMin":
            $widget.find('#add-antipassbackmin-menu').trigger('click');
            break;        
          case "itAptSingleUseMin":
            $widget.find('#add-aptsingleusemin-menu').trigger('click');
            break;        
          case "itCrossover":
            $widget.find('#crossover-menu').trigger('click');
            break;        
          case "itWalletInitialDeposit":
            $widget.find('#walletdeposit-menu').trigger('click');
            break;    
          case "itRewardPointsDeposit":
            $widget.find('#rewardpoints-deposit-menu').trigger('click');
            break;
          case "itPPUEntryCharge":
            $widget.find('#ppu-entry-charge-menu').trigger('click');
            break;        
          case "itPPUReentryCharge":
            $widget.find('#ppu-reentry-charge-menu').trigger('click');
            break;        
          case "itExpRule":
            $widget.find('#exprule-menu').trigger('click');
            break;        
          case "itCalendar":
            $widget.find('#calendar-menu').trigger('click');
            break;        
          case "itFirstUsageRule":
            $widget.find('#firstusage-rule-menu').trigger('click');
            break;        
          case "itDateRange":
            $widget.find('#daterange-menu').trigger('click');
            break;        
          case "itTimeRange":
            $widget.find('#timerange-menu').trigger('click');
            break;        
          case "itWeekDays":
            $widget.find('#weekdays-menu').trigger('click');
            break;        
          case "itAntipassBack":
            $widget.find('#require-exit-for-reentry-menu').trigger('click');
            break;        
          case "itFlashAtAPT":
            $widget.find('#flash-at-apt-menu').trigger('click');
            break;            
          case "itApplyReentryAsEntry":
            $widget.find('#apply-reentry-as-entry-menu').trigger('click');
            break;            
          case "itContinueOnInvalidReentry":
            $widget.find('#continue-on-invalid-reentry-menu').trigger('click');
            break;
          case "itStopOnInvalidCrossover":
            $widget.find('#stop-on-invalid-crossover-menu').trigger('click');
            break;
          case "itTimedTicketRule":
            $widget.find('#add-ttrule-menu').trigger('click');
            break;  
          case "itPerfBasedDays":
            $widget.find('#perfbaseddays-menu').trigger('click');
            break;
          case "itResourceBasedDays":
            $widget.find('#resourcebaseddays-menu').trigger('click');
            break;
          case "itPassthrough":
            $widget.find('#passthrough-menu').trigger('click');
            break;
          case "itPerfQty":
            $widget.find('#perfqty-menu').trigger('click');
            break;
          case "itCrossoverTimeRange":
            $widget.find('#crossover-timerange-menu').trigger('click');
            break;
          case "itSecUsageWaitDays":
            $widget.find('#secusage-waitdays-menu').trigger('click');
            break;
          case "itPeriodConstraint":
            $widget.find('#period-constraint-menu').trigger('click');
            break;
          case "itValidAfterGroup":
            $widget.find('#valid-after-group-menu').trigger('click');
            break;
        };
      };
    };
  });
  
  function dispatchEntitlementChange() {
    $(document).trigger("entitlement-change");
  }
    
  <%-- ADD GROUP --%>
  $widget.find("#add-group-menu").click(function(e) {
    var dummy = newObjEnt();
    showEntDialog("ent-group-dialog", dummy, function() {
      var objEnt = newObjEnt();
      objEnt.EntType = "<%=LkSNEntitlementType.Group.getCode()%>";
      objEnt.GroupCode = dummy.GroupCode;
      
      var parentNode = getValidityNode(getSelectedNode());
      getObjEnt(parentNode).EntList.push(objEnt);
      addEntNode(parentNode, objEnt, <%=LkSNEntitlementType.Group.getCode()%>, getEntDesc(objEnt));
      
      dispatchEntitlementChange();
    });
  });
  
  <%-- ADD EVENT --%>
  $widget.find("#add-event-menu").click(function(e) {
    showLookupDialog({
      EntityType: <%=LkSNEntityType.Event.getCode()%>,
      EventParams: {
        EventTypes: "<%=LkSNEventType.GenAdm.getCode()%>,<%=LkSNEventType.PerfEvent.getCode()%>,<%=LkSNEventType.DatedEvent.getCode()%>"
      },
      onPickup: function(item) {
        eventCache.push({
          EventId: item.ItemId,
          EventCode: item.ItemCode,
          EventName: item.ItemName
        });
        
        var objEnt = newObjEnt();
        objEnt.EntType = "<%=LkSNEntitlementType.Event.getCode()%>";
        objEnt.EventId = item.ItemId;

        var parentNode = getValidityNode(getSelectedNode());
        getObjEnt(parentNode).EntList.push(objEnt);
        addEntNode(parentNode, objEnt, <%=LkSNEntitlementType.Event.getCode()%>, getEntDesc(objEnt));
        
        dispatchEntitlementChange();
      }
    });
  });
  
  <%-- ADD ALL-EVENTS --%>
  $widget.find("#add-all-events-menu").click(function(e) {
    var objEnt = newObjEnt();
    objEnt.EntType = "<%=LkSNEntitlementType.Event.getCode()%>";
    objEnt.EventId = null;

    var parentNode = getValidityNode(getSelectedNode());
    getObjEnt(parentNode).EntList.push(objEnt);
    addEntNode(parentNode, objEnt, <%=LkSNEntitlementType.Event.getCode()%>, getEntDesc(objEnt));
    
    dispatchEntitlementChange();
  });
  
  <%-- ADD PPU-EVENTS --%>
  $widget.find("#add-ppu-events-menu").click(function(e) {
    var objEnt = newObjEnt();
    objEnt.EntType = "<%=LkSNEntitlementType.Event.getCode()%>";
    objEnt.EventId = ppuEventId;

    var parentNode = getValidityNode(getSelectedNode());
    getObjEnt(parentNode).EntList.push(objEnt);
    addEntNode(parentNode, objEnt, <%=LkSNEntitlementType.Event.getCode()%>, getEntDesc(objEnt));
    
    dispatchEntitlementChange();
  });
  
  <%-- ADD PRODUCT --%>
  $widget.find("#add-product-menu").click(function() {
    showLookupDialog({
      EntityType: <%=LkSNEntityType.ProductType.getCode()%>,
      onPickup: function(item) {
        var product = {
          ProductId: item.ItemId,
          ProductCode: item.ItemCode,
          ProductName: item.ItemName
        };
        productCache.push(product);
        
        var objEnt = newObjEnt();
        objEnt.EntType = "<%=LkSNEntitlementType.ProductType.getCode()%>";
        objEnt.IncProductId = product.ProductId;

        var parentNode = getValidityNode(getSelectedNode());
        getObjEnt(parentNode).EntList.push(objEnt);
        addEntNode(parentNode, objEnt, <%=LkSNEntitlementType.ProductType.getCode()%>, getEntDesc(objEnt));
        
        dispatchEntitlementChange();
      }
    });
  });

  var mapMenuDialog = {
    "#add-entry-menu":           "ent-entry-dialog",
    "#add-reentry-menu":         "ent-reentry-dialog",
    "#add-extraentry-menu":      "ent-override-dialog",
    "#add-incprod-menu":         "ent-incprod-dialog",
    "#add-incprodvalue-menu":    "ent-incprodvalue-dialog",
    "#add-ttrule-menu":          "ent-ttrule-dialog",
    "#calendar-menu":            "ent-calendar-dialog",
    "#add-antipassbackmin-menu": "ent-antipassbackmin-dialog",
    "#add-aptsingleusemin-menu": "ent-aptsingleusemin-dialog",
    "#crossover-menu":           "ent-crossover-rule-dialog",
    "#walletdeposit-menu":       "ent-walletinitialdeposit-dialog",
    "#rewardpoints-deposit-menu":"ent-rewardpointsdeposit-dialog",
    "#ppu-entry-charge-menu":    "ent-ppuentrycharge-dialog",
    "#ppu-reentry-charge-menu":  "ent-ppureentrycharge-dialog",
    "#exprule-menu":             "ent-exprule-dialog",
    "#passthrough-menu":         "ent-passthrough-dialog",
    "#firstusage-rule-menu":     "ent-firstusagerule-dialog",
    "#daterange-menu":           "ent-daterange-dialog",
    "#timerange-menu":           "ent-timerange-dialog",
    "#weekdays-menu":            "ent-weekdays-dialog",
    "#perfbaseddays-menu":       "ent-perfbaseddays-dialog",
    "#resourcebaseddays-menu":   "ent-resourcebaseddays-dialog",
    "#perfqty-menu":             "ent-perfqty-dialog",
    "#crossover-timerange-menu": "ent-crossover-timerange-dialog",
    "#secusage-waitdays-menu":   "ent-secusage-waitdays-dialog",
    "#period-constraint-menu":   "ent-period-constraint-dialog",
    "#valid-after-group-menu":   "ent-valid-after-group-dialog"
  };

  mapMenuFlag = {
    "#flash-at-apt-menu":                "FlashAtAPT", 
    "#apply-reentry-as-entry-menu":      "ApplyReentryAsEntry",
    "#continue-on-invalid-reentry-menu": "ContinueOnInvalidReentry",
    "#stop-on-invalid-crossover-menu":   "StopOnInvalidCrossover",
    "#require-exit-for-reentry-menu":    "AntiPassBack"
  };
  
  for (const [selector, dialogId] of Object.entries(mapMenuDialog)) {
    $widget.find(selector).click(function(e) {
      showEntDialog(dialogId, getObjEnt(getSelectedNode()), doAfterChange);
    });
  }
  
  for (const [selector, field] of Object.entries(mapMenuFlag)) {
    $widget.find(selector).click(function(e) {
      getObjEnt(getSelectedNode())[field] = "1";
      doAfterChange();
    });
  }
  
  function doAfterChange() {
    refreshConstraintItems(getValidityNode(getSelectedNode()));
    //loadPointsTree(objEntRoot);
    dispatchEntitlementChange();
  }
});

</script>    
