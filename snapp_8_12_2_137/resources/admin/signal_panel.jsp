<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSignalPanel" scope="request"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery/jquery-3.6.0.min.js"></script>
  
  <script>
    <% int idxPanel = Integer.parseInt(pageBase.getParameter("panel")); %>
    var panel = <%=pageBase.getBLDef().loadConfig().PanelList.getItem(idxPanel).getJSONString()%>;
    var idxFrame = 0;
    
    function showFrame(idx) {
      if (idx >= panel.FrameList.length)
        idx = 0;
      var frame = panel.FrameList[idx];
      $("#mainframe").attr("src", frame.FrameURL);
      
      frame.FrameSeconds = (frame.FrameSeconds) ? frame.FrameSeconds : 1;
      
      setTimeout(function() {showFrame(idx+1)}, frame.FrameSeconds*1000);
    }
    
    $(document).ready(function() {
      showFrame(0);
    });
  </script>
</head>

<body style="padding:0px; margin:0px; overflow:hidden">

<iframe id="mainframe" style="margin:0px;padding:0px;border:0px;width:100%;height:1080px">
</iframe>

</body>

</html>