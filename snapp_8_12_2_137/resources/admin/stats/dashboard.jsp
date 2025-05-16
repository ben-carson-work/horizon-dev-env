<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<v:last-error/>
<snp:db-update-warn/>

<style>

.widget-table {
  width: 100%;
  border-spacing:0;
  border-collapse:collapse;
}

.widget-table td.widget-column {
  padding-bottom: 100px;
  vertical-align: top;
}

.widget-table .postbox {
  margin-bottom: 10px;
  margin-right: 10px;
}

.widget-table .postbox, 
.widget-table .postbox .widget-block {
  overflow: visible;
}

.widget-table .postbox h3 {
  cursor: move;
}

.widget-table .postbox h3 .widget-icon {
  float: right;
  width: 20px;
  height: 20px;
  margin-left: 2px;
  visibility: hidden;
  position: relative;
  top: -2px;
  right: -5px;
  background-repeat: no-repeat;
  background-position: center center;
  cursor: pointer;
}

.widget-table .postbox h3:hover .widget-icon {
  visibility: visible;
  opacity: 0.3;
}

.widget-table .postbox h3 .widget-icon:hover {
  visibility: visible;
  opacity: 1;
}

.dashboard-placeholder {
  background-color: #fafafa;
  border: 1px #bbbbbb dashed;
  margin-bottom: 10px;
  margin-right: 10px;
  border-radius: 2px;
}

</style>

<div class="form-toolbar">
  <v:button fa="save" caption="@Common.Save" href="javascript:doSave()"/>
  <v:button fa="plus" caption="@Common.Add" href="javascript:doAdd()"/>

  <div style="float:right">
    Layout&nbsp;
    <v:lk-combobox field="DashboardLayout" lookup="<%=LkSN.DashboardLayout%>" allowNull="false"/>
  </div>
</div>

<table class="widget-table"><tr class="widget-row"></tr></table>

<div id="widget-template" class="v-hidden">
  <v:widget><v:widget-block></v:widget-block></v:widget>
</div>

<div id="widget-setup-dialog" title="Widget Setup" class="v-hidden">
  <v:widget icon="profile.png" caption="@Common.Profile">
    <v:widget-block>
      <table class="form-table">
        <tr>
          <th><label for="WidgetName"><v:itl key="@Common.Name"/></label></th>
          <td><input type="text" id="WidgetName" /></td>
        </tr>
        <tr>
          <th><label for="RefreshSeconds">Refresh seconds</label></th>
          <td><input type="text" id="RefreshSeconds" /></td>
        </tr>
      </table>
    </v:widget-block>
  </v:widget>
</div>

<script>

function initTable() {
  $(".widget-table td").sortable({
    connectWith: ".widget-table td",
    placeholder: "dashboard-placeholder",
    handle: "h3",
    start: function(e, ui) {
      ui.placeholder.height(ui.helper.outerHeight());
    }
  });
  $(".widget-table").disableSelection();
}

function getLayoutDef(layout) {
  switch (parseInt(layout)) {
  case <%=LkSNDashboardLayout.C1.getCode()%>:
    return {
      cols: 1,
      w1: "100%"
    };
  case <%=LkSNDashboardLayout.C2_50_50.getCode()%>:
    return {
      cols: 2,
      w1: "50%",
      w2: "50%"
    };
  case <%=LkSNDashboardLayout.C2_25_75.getCode()%>:
    return {
      cols: 2,
      w1: "25%",
      w2: "75%"
    };
  case <%=LkSNDashboardLayout.C2_75_25.getCode()%>:
    return {
      cols: 2,
      w1: "75%",
      w2: "25%"
    };
  case <%=LkSNDashboardLayout.C3_33_34_33.getCode()%>:
    return {
      cols: 3,
      w1: "33%",
      w2: "34%",
      w3: "33%"
    };
  case <%=LkSNDashboardLayout.C3_25_50_25.getCode()%>:
    return {
      cols: 3,
      w1: "25%",
      w2: "50%",
      w3: "25%"
    };
  case <%=LkSNDashboardLayout.C4.getCode()%>:
    return {
      cols: 4,
      w1: "25%",
      w2: "25%",
      w3: "25%",
      w4: "25%"
    };
  }
}

function renderLayout() {
  var layoutDef = getLayoutDef($("#DashboardLayout").val());
  
  var tds = $(".widget-table td.widget-column");
  if (tds.length > layoutDef.cols) {
    for (var i=layoutDef.cols; i<tds.length; i++) {
      var td = $(tds[i]);
      td.find(".postbox").appendTo(tds[layoutDef.cols - 1]);
      td.remove();
    }
  }
  else if (tds.length < layoutDef.cols) {
    for (var i=tds.length; i<layoutDef.cols; i++) {
      $("<td class='widget-column' width='25%'/>").appendTo(".widget-table tr.widget-row");
    }
  }
  
  tds = $(".widget-table td.widget-column");
  if (tds.length > 0)
    $(tds[0]).css("width", layoutDef.w1);
  if (tds.length > 1)
    $(tds[1]).css("width", layoutDef.w2);
  if (tds.length > 2)
    $(tds[2]).css("width", layoutDef.w3);
  if (tds.length > 3)
    $(tds[3]).css("width", layoutDef.w4);
  
  initTable();
}

$("#DashboardLayout").change(renderLayout);

function doSave() {
  var reqDO = {
    Command: "SaveDashboard",
    SaveDashboard: {
      AccountId: "<%=pageBase.getSession().getUserAccountId()%>",
      Dashboard: {
        Layout: $("#DashboardLayout").val(),
        WidgetList: []
      }
    }
  };
  
  var tds = $(".widget-table td.widget-column");
  for (var i=0; i<tds.length; i++) {
    var td = $(tds[i]);
    var elems = td.find(".postbox");
    for (var k=0; k<elems.length; k++) {
      var widget = $(elems[k]).data("widget");
      widget.Column = i;
      reqDO.SaveDashboard.Dashboard.WidgetList.push(widget);
    }
  }
  
  vgsService("Account", reqDO, false, function() {
    showMessage("saved");
  });
}

function doAdd() {
  asyncDialogEasy("dashboard_addwidget_dialog");
}

function doPickupWidget(widget) {
  var tds = $(".widget-table td.widget-column");
  widget.Column = Math.min(tds.length-1, (widget.Column) ? widget.Column : 0);
  var td = $(tds[widget.Column]);
  
  var divWidget = $($("#widget-template").html()).appendTo(td);
  var divContent = divWidget.find(".widget-block");
  divWidget.find("h3").html(widget.WidgetName);
  divWidget.data("widget", widget);
  
  $("<span class='widget-icon fa fa-times'></span>").appendTo(divWidget.find("h3")).click(function() {
    if (confirmDialog())
      divWidget.remove();
  });
  
  $("<span class='widget-icon fa fa-cog''></span>").appendTo(divWidget.find("h3")).click(function() {
    widgetSetup(widget);
  });
  
  asyncLoad(divContent, "<v:config key="site_url"/>/admin?page=dashboard_widget&id=" + widget.DocTemplateId);
}

function widgetSetup(widget) {
  $("#WidgetName").val(widget.WidgetName);
  $("#RefreshSeconds").val(widget.RefreshSeconds);
  
  var dlg = $("#widget-setup-dialog");
  dlg.dialog({
    modal: true,
    width: 500,
    height: 300,
    buttons: {
      "<v:itl key="@Common.Save"/>": function() {
        widget.WidgetName = $("#WidgetName").val();
        widget.RefreshSeconds = parseInt($("#RefreshSeconds").val());
        widget.RefreshSeconds = isNaN(widget.RefreshSeconds) ? 10: widget.RefreshSeconds;
        dlg.dialog("close");
      },
      "<v:itl key="@Common.Cancel"/>": function() {
        dlg.dialog("close");
      }
    }
  });
}

$(document).ready(function() {
  alert(<%=pageBase.getSession().getUserAccountId()%>);
  var dashboard = <%=pageBase.getBL(BLBO_Right.class).loadDashboard(pageBase.getSession().getUserAccountId()).getJSONString()%>;
  $("#DashboardLayout").val(dashboard.Layout);
  renderLayout();
  for (var i=0; i<dashboard.WidgetList.length; i++) 
    doPickupWidget(dashboard.WidgetList[i]);
});

</script>

 
<jsp:include page="/resources/common/footer.jsp"/>

