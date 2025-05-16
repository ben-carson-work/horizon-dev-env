<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="apt" class="com.vgs.snapp.dataobject.DOAccessPointRef" scope="request"/>
<% PageMobileSales pageBase = (PageMobileSales)request.getAttribute("pageBase"); %>

<script type="text/javascript" id="info-js.jsp" >

$(document).ready(function() {
  
  $("#pref-item-logout").click(function() {
    var title = <v:itl key="@Common.User" encode="JS"/>;
    var msg = <%=JvString.jsString(pageBase.getSession().getUserDesc())%>;
    var buttons = [<v:itl key="@Common.Logout" encode="JS"/>, <v:itl key="@Common.Cancel" encode="JS"/>];
    showMobileQueryDialog2(title, msg, buttons, function(index) {
      if (index == 0) {
        doLogout();
      }
      return true;
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
	  showMobileQueryDialog2(title, msg, buttons, getDialogFunction());
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

  $("#pref-item-gate").click(function() {
    var options = [];
    
    <% JvDataSet ds = pageBase.getBL(BLBO_Account.class).getOpAreaDS(pageBase.getSession().getLocationId()); %>
    <v:ds-loop dataset="<%=ds%>">
      options.push({"ItemId":<%=ds.getField("AccountId").getJsString()%>, "ItemCaption":<%=ds.getField("DisplayName").getJsString()%>});
    </v:ds-loop>
    
    showPrefSingleList(this, options, function(item, callback) {
      showWaitGlass();
      
      var reqDO = {
        Command: "ChangeOperatingArea",
        ChangeOperatingArea: {
          WorkstationId: <%=apt.AccessPointId.getJsString()%>,
          OperatingAreaId: item.attr("data-ItemId")
        }
      };
      vgsService("Workstation", reqDO, true, function(ansDO) {
        hideWaitGlass();
        var errorMsg = getVgsServiceError(ansDO);
        if (errorMsg == null)
          callback(item);
        else
          showMobileQueryDialog2("SnApp", errorMsg, [<v:itl key="@Common.Ok" encode="JS"/>]);
      });
    });
  });  
  $("#pref-item-synchronize").click(function() {
    mainactivity(mainactivity_step.doInit);
  });
});


</script>