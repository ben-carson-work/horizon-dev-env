<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String clientId = pageBase.getParameter("clientId"); 
String loginURI = pageBase.getParameter("loginURI"); 
%>

<v:dialog id="google_login_dialog" title="GOOGLE" width="400" height="200">

  <script src="https://accounts.google.com/gsi/client" async="true" defer="defer"></script>

  <div style="display:flex; justify-content: center">
    <div id="g_id_onload"
      data-client_id="<%=clientId%>" 
      data-ux_mode="redirect"
      data-login_uri="<%=loginURI%>" 
      data-shape="pill"
      data-auto_prompt="false">
    </div>
    <div class="g_id_signin" data-type="standard"></div>
  </div>

</v:dialog>


