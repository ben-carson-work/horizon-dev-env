<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<v:tab-toolbar>
  <v:pagebox gridId="history-grid"/>
</v:tab-toolbar>

<v:tab-content>
  <% String params = "EntityId=" + request.getAttribute("LicenseeId"); %>
  <v:async-grid id="history-grid" jsp="common/history_detail_grid.jsp" params="<%=params%>"/>
</v:tab-content>

