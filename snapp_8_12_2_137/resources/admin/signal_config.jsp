<%@page import="com.vgs.web.library.BLBO_Signal"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSignalConfig" scope="request"/>

<jsp:include page="../common/header.jsp"/>
<v:page-title-box/>

<style>

.signal-panel {
  margin-bottom: 10px;
}

.signal-panel input[type="text"] {
}

</style>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Setup" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Save" fa="save" onclick="doSave()"/>
      <v:button caption="@Common.Add" fa="plus" onclick="addPanel()"/>
    </div>
    
    <div class="tab-content">
      <div id="widget-template" class="v-hidden">
        <v:grid clazz="signal-panel">
          <thead>
            <tr>
              <td width="70%">URL <span class="url-hint"></span></td>
              <td width="15%">Duration (secs)</td>
              <td width="15%">Refresh (secs)</td>
              <td></td>
            </tr>
          </thead>
          <tbody class="body">
          </tbody>
          <tbody class="footer">
            <tr>
              <td colspan="100%">
                <v:button clazz="add-frame-button" caption="@Common.Add" fa="plus"/>
                <v:button clazz="del-panel-button" caption="@Common.Delete" fa="times"/>
                &nbsp;
                <a class="output" target="_new" style="float:right" href=""><br/>output link</a>
              </td>
            </tr>
          </tbody>
        </v:grid>
      </div>
      
      <table id="frame-template" class="v-hidden">
      <tbody>
        <tr class="frame">
          <td><input type="text" class="form-control" name="FrameURL"/></td>
          <td><input type="text" class="form-control" name="FrameSeconds"/></td>
          <td><input type="text" class="form-control" name="FrameRefreshSeconds"/></td>
          <td nowrap><v:button clazz="del-frame-button" fa="minus"/></td>
        </tr>
      </tbody>
      </table>
      
      <div id="panels-container">
      
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<script>

$(document).ready(function() {
  var config = <%=pageBase.getBLDef().loadConfig().getJSONString()%>;
  for (var i=0; i<config.PanelList.length; i++) 
    addPanel(config.PanelList[i], i);
});

function addPanel(panel, index) {
  index = isNaN(index) ? $("#panels-container .signal-panel").length : index;
  var divWidget = $("#widget-template table").clone().appendTo("#panels-container");
  
  if (panel) {
    for (var i=0; i<panel.FrameList.length; i++)
      addFrame(divWidget, panel.FrameList[i]);
  }

  divWidget.find("a.output").attr("href", "<v:config key="site_url"/>/admin?page=signal_panel&panel=" + index);
  
  divWidget.find(".add-frame-button").click(function() {
    addFrame(divWidget);
  });
  
  divWidget.find(".del-panel-button").click(function() {
    divWidget.remove();
  });
  
  divWidget.find(".url-hint").addClass("form-field-hint form-field-hint-title").attr("title", "For SnApp report build a URL with this syntax: " + BASE_URL + "/docproc?id={report id}&p_{param name}={param value}");
}

function addFrame(divWidget, frame) {
  var tbody = divWidget.closest("table.listcontainer").find("tbody.body");
  var tr = $($("#frame-template tbody").html()).appendTo(tbody);
  if (frame) {
    tr.find("[name='FrameSeconds']").val(frame.FrameSeconds);
    tr.find("[name='FrameRefreshSeconds']").val(frame.FrameRefreshSeconds);
    tr.find("[name='FrameURL']").val(frame.FrameURL);
  }
  
  tr.find(".del-frame-button").click(function() {
    $(this).closest("tr").remove();
  });
}

function doSave() {
  var reqDO = {
    Command: "SaveConfig",
    SaveConfig: {
      SignalConfig: {
        PanelList: []
      }
    }
  };
  
  var panels = $("#panels-container .signal-panel");
  for (var i=0; i<panels.length; i++) {
    var panelDO = {
      FrameList: []  
    };
    
    var frames = $(panels[i]).find("tr.frame");
    for (var k=0; k<frames.length; k++) {

      panelDO.FrameList.push({
        FrameSeconds: $(frames[k]).find("[name='FrameSeconds']").val(),
        FrameRefreshSeconds: $(frames[k]).find("[name='FrameRefreshSeconds']").val(),
        FrameURL: $(frames[k]).find("[name='FrameURL']").val()
      });
    }
    
    reqDO.SaveConfig.SignalConfig.PanelList.push(panelDO);
  }
  
  console.log(reqDO);
  vgsService("Signal", reqDO, false, function() {
    showMessage("<v:itl key="@Common.SaveSuccessMsg"/>");
  });
}

</script>
 
<jsp:include page="../common/footer.jsp"/>
