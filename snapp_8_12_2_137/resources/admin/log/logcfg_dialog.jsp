<%@page import="com.vgs.snapp.dataobject.DOLogConfig"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
DOLogConfig logConfig = BLBO_Log.getLogConfig();
request.setAttribute("logConfig", logConfig);
%>


<v:dialog id="logcfg_dialog" title="@Common.Logs" tabsView="true" width="1000" height="700" autofocus="false">

  <v:tab-group name="logcfg" main="true">

    <v:tab-item-embedded tab="main" caption="@Common.Profile" fa="circle-info" default="true">
      <jsp:include page="logcfg_dialog_tab_main.jsp"></jsp:include>
    </v:tab-item-embedded>

    <v:tab-item-embedded tab="config" caption="@Common.Settings" fa="gear">
      <jsp:include page="logcfg_dialog_tab_config.jsp"></jsp:include>
    </v:tab-item-embedded>

    <v:tab-item-embedded tab="tabs-history" caption="@Common.History" fa="history" include="<%=rights.History.getBoolean()%>">
      <jsp:include page="../common/page_tab_historydetail.jsp">
        <jsp:param name="id" value="<%=SnappUtils.encodeLookupPseudoId(LkSN.EntityType, LkSNEntityType.LogConfig)%>"/>
      </jsp:include>
    </v:tab-item-embedded>
    
  </v:tab-group>
  
  <script>
    $(document).ready(function() {
      var $dlg = $("#logcfg_dialog");
      var logcfg = <%=BLBO_Log.getLogConfig().getJSONString()%>;
      
      $dlg.on("snapp-dialog", function(event, params) {
        params.buttons = [
          dialogButton("@Common.Save", _save),
          dialogButton("@Common.Cancel", doCloseDialog)
        ]
      });
      
      $(document).trigger("logcfg-load", {"logcfg": logcfg});
      
      function _save() {
        var params = {"logcfg": logcfg};
        $(document).trigger("logcfg-save", params);

        snpAPI.cmd("Log", "SaveConfig", params.logcfg).then(ansDO => {
          triggerEntityChange(<%=LkSNEntityType.LogConfig.getCode()%>);
          $dlg.dialog("close");
        });
      }

    });
  </script>

</v:dialog>