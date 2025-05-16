<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<script>

$(document).ready(function() {
	var canChangeGate = <%=rights.ChangeAPTGate.getBoolean()%>; 
 
  $("#pref-item-logout").click(function() {
    var title = <v:itl key="@Common.User" encode="JS"/>;
    var msg = <%=JvString.jsString(pageBase.getSession().getUserDesc())%>;
    var buttons = [<v:itl key="@Common.Logout" encode="JS"/>, <v:itl key="@Common.Cancel" encode="JS"/>];
    showMobileQueryDialog(title, msg, buttons, function(index) {
      if (index == 0) 
        doLogout();
    });
  });
 
  $("#pref-item-workstation").click(function() {
    let msg = <%=JvString.jsString(pageBase.getSession().getWorkstationCode())%>;
  	let title = <v:itl key="@Common.WorkstationCode" encode="JS"/>;
    let buttons = [];
	 	<%if (pageBase.getRights().UnregisterMobile.getBoolean()) {%>
	    	title = <v:itl key="@Common.ResetLicense" encode="JS"/>;
	    	buttons.push(<v:itl key="@Common.Reset" encode="JS"/>);
	 	<%}%>
    buttons.push(<v:itl key="@Common.Cancel" encode="JS"/>);
    showMobileQueryDialog(title, msg, buttons, getDialogFunction());
	});
  
  function getDialogFunction() {
	<%if (pageBase.getRights().UnregisterMobile.getBoolean()) {%>
	  	return function(index) {
	  		if (index == 0) {
		      doLogout();
		      localStorage.clear();
		      sendCommand("Unregister");
	  		}
	      return true;
	  	}	
	<%} else {%>
		return function() { return true; };
	<%}%>
  }

  if (canChangeGate) { 
	  $("#pref-item-gate").addClass("pref-item-arrow");
    $("#pref-item-gate").click(function() {
      var options = [];
      
      <% JvDataSet ds = pageBase.getBL(BLBO_Account.class).getGateDS(pageBase.getSession().getLocationId()); %>
      <v:ds-loop dataset="<%=ds%>">
        options.push({"ItemId":<%=ds.getField("AccountId").getJsString()%>, "ItemCaption":<%=ds.getField("DisplayName").getJsString()%>});
      </v:ds-loop>
      
      showPrefSingleList(this, options, function($item, callback) {
        showWaitGlass();
        
        var reqDO = {
          Command: "ChangeOperatingArea",
          ChangeOperatingArea: {
            WorkstationId: apt.AccessPointId,
            OperatingAreaId: $item.attr("data-ItemId")
          }
        };
        vgsService("Workstation", reqDO, true, function(ansDO) {
          hideWaitGlass();
          var errorMsg = getVgsServiceError(ansDO);
          if (errorMsg == null) {
            callback($item);
            $(".info-currentgate").text($item.attr("data-ItemCaption"));
          }
          else
            showMobileQueryDialog("SnApp", errorMsg, [itl("@Common.Ok")]);
        });
      });
    });
  } 
});


</script>