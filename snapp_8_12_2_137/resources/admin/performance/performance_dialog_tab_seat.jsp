<%@page import="com.vgs.vcl.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="perf" class="com.vgs.snapp.dataobject.DOPerformance" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean readOnly = pageBase.isParameter("readonly", "true");%>

<div class="tab-toolbar">
  <v:button caption="@Common.Refresh" fa="sync" onclick="doReloadSeatPerformanceWidget()"/>
</div>
<div id="perf-seat-tab" class="tab-content"></div>

<script>
function doReloadSeatPerformanceWidget() {
  asyncLoad("#perf-seat-tab", BASE_URL + "/admin?page=widget&jsp=seat/seat_performance_widget&PerformanceId=<%=pageBase.getId()%>&readonly=<%=readOnly%>");
}
doReloadSeatPerformanceWidget();

var dlgEntityChangeHandler = function(event, bean) {
  if (bean.EntityType == <%=LkSNEntityType.Performance.getCode()%>)
    doReloadSeatPerformanceWidget();
};
$(document).on('OnEntityChange', dlgEntityChangeHandler);
$('#perf-seat-tab').on('remove', function() {
  $(document).off('OnEntityChange', dlgEntityChangeHandler);
});
</script>