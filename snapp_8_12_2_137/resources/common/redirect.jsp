<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.PageBO_Base"%>
<%
  PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
  String requestedURL = (String)request.getAttribute("requestedURL");
  if (JvString.getNull(requestedURL) == null)
    requestedURL = pageBase.getContextURL();
  
%>
<jsp:include page="error/header.jspf">
  <jsp:param name="title" value="Redirect" />
</jsp:include>
<script>
  window.location.replace("<%=requestedURL%>");
  if (window.opener)
    window.opener.postMessage({ eventName: 'loginSuccessFull'}, window.location.origin);
</script>
  <div class="title">Redirect</div>
  <div class="message">
    <p>You are being redirected to a different page.</p>
    <p>Please wait.</p>
  </div>
<jsp:include page="error/footer.jspf"/>