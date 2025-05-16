<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>


<v:dialog id="apicfg_dialog" title="@System.ApiTracing" tabsView="true" width="800" height="600" autofocus="false">

  <v:tab-group name="apicfg" main="true">

    <v:tab-item-embedded tab="main" caption="@Common.Profile" fa="circle-info" default="true">
      <jsp:include page="apicfg_dialog_tab_main.jsp"></jsp:include>
    </v:tab-item-embedded>

    <v:tab-item-embedded tab="tabs-history" caption="@Common.History" fa="history" include="<%=rights.History.getBoolean()%>">
      <jsp:include page="../common/page_tab_historydetail.jsp">
        <jsp:param name="id" value="<%=SnappUtils.encodeLookupPseudoId(LkSN.EntityType, LkSNEntityType.ApiTraceConfig)%>"/>
      </jsp:include>
    </v:tab-item-embedded>
    
  </v:tab-group>
  
  <script>
    $(document).ready(function() {
      var $dlg = $("#apicfg_dialog");
      var apicfg = <%=BLBO_ApiLog.getApiLogConfig().getJSONString()%>;
      
      $dlg.on("snapp-dialog", function(event, params) {
        params.buttons = [
          dialogButton("@Common.Save", _save),
          dialogButton("@Common.Cancel", doCloseDialog)
        ]
      });
      
      $(document).trigger("apicfg-load", {"apicfg": apicfg});
      
      function _save() {
          var params = {"apicfg": apicfg}
          $(document).trigger("apicfg-save", params);
          
       	// Check if any field is not empty
       	let isSaveable = params.apicfg.WriteItemList.every( item => item.LogInternal || item.Log4J);
  	   
  	    if (isSaveable)
  	        snpAPI.cmd("Log", "SaveApiLogConfig", {"ApiLogConfig":params.apicfg}).then(ansDO => {
  	          triggerEntityChange(<%=LkSNEntityType.ApiTraceConfig.getCode()%>);
  	          $dlg.dialog("close");
  	        });
  	    else 
  	    	showMessage("Please select your logging option to continue.");
        }

    });
  </script>

</v:dialog>