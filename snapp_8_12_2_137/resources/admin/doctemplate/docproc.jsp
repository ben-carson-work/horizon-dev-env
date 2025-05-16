<%@page import="com.vgs.cl.*"%>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocProcessor" scope="request"/>
<!DOCTYPE html>
<html>
 
<head>
  <title><%=JvString.escapeHtml(JvMultiLang.translate(pageBase.getLang(), pageBase.getPageTitle()))%></title>
  <style>
    iframe {
      border: none;
      position: fixed;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
    }
  </style>
</head>

<body>

<iframe src="<%=pageBase.getParameter("DocProcServletURL")%>" >

</iframe>

</body>

</html>