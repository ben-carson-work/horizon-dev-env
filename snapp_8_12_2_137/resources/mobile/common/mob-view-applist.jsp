<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<style>
#applist-container {
  list-style-type: none;
  padding: 3rem;
  margin: 0;
}

#applist-container .app-item {
  position: relative;
  height: 20rem;
  color: rgba(0,0,0,0.8);
  background-color: rgba(0,0,0,0.1);
  margin-bottom: 3rem;
  cursor: pointer;
  line-height: 20rem; 
  font-size: 10rem;
  text-align: center;
}

#applist-container .app-item:hover {
  background-color: var(--highlight-color);
  color: white;
}

#applist-container .app-item-icon {
  position: absolute;
  top: 0;
  bottom: 0; 
  left: 0;
  width: 20rem;
}

#applist-container .app-item-caption {
  position: absolute;
  bottom: 0;
  left: 20rem;
  right: 0;
  text-align: left;
}
</style>

<div id="applist-main">
  <div class="tab-header">
    <div class="tab-header-title">Select App</div>
  </div>

  <div class="tab-body">
    
    <div id="applist-container">
    </div>
    
    <div id="applist-templates" class="hidden">
      <div class="app-item">
        <div class="app-item-icon"></div>
        <div class="app-item-caption"></div>
      </div>
    </div>
  </div>
</div>



<script>
$(document).ready(function() {
  availableApps = (availableApps) ? availableApps : [];
  for (var i=0; i<availableApps.length; i++) {
    var app = availableApps[i];
    var $app = $("#applist-templates .app-item").clone().appendTo("#applist-container");
    $app.attr("data-appname", app.AppName);
    $app.find(".app-item-caption").text((app.Caption) ? app.Caption : app.AppName);
    if (app.IconName)
      $app.find(".app-item-icon").append("<i class='fa fa-" + app.IconName + "'></i>");
    
    $app.click(function() {
      var appName = $(this).attr("data-appname");
      setLocalStorage("AppName", appName);
      UIMob.showApp(appName);
    });
  }
});
</script>
