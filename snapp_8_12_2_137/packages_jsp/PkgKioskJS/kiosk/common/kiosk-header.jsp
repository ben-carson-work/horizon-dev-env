<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="ksk-tags" prefix="ksk" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<div class="kiosk-header">
  <h2 class="kiosk-header-licensee"><ksk:itl key="@Common.Header"/></h2>
  <h1 class="kiosk-header-title"></h1>
  <div class="kiosk-header-subtitle"></div>
</div>
  