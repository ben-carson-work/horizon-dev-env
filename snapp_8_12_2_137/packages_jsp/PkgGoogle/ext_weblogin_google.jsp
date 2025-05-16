<%@page import="com.vgs.snapp.web.gencache.SrvBO_Cache_SystemPlugin"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.cl.JvUtils"%>
<%
String loginURI = (String)request.getAttribute("g_login_uri"); 
String clientId = (String)request.getAttribute("g_client_id"); 
%> 
<!DOCTYPE html>
<html>
  <head>
    <script src="https://accounts.google.com/gsi/client" async="true" defer="defer"></script>
  </head>
  <body>
    <div id="g_id_onload"
      data-client_id="<%=clientId%>" 
      data-ux_mode="redirect"
      data-login_uri="<%=loginURI %>" 
      data-shape="pill"
      data-auto_prompt="false">
    </div>
    <div class="g_id_signin" data-type="standard"></div>
  </body>
</html>
