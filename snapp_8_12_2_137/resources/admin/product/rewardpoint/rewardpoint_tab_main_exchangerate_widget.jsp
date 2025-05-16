<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageRewardPoint" scope="request"/>
<jsp:useBean id="rewardPoint" class="com.vgs.snapp.dataobject.DORewardPoint" scope="request"/>

<% boolean canEdit = JvString.isSameString(request.getParameter("Editable"), "true"); %>

<v:widget-block>
  <v:grid id="rewardpoint-exchangerate-grid-inner">
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="60%"><v:itl key="@Currency.ExchangeRate"/></td>
        <td width="40%"><v:itl key="@Common.Calendar"/></td>
<%--         TEMPORARY DISABLED until we fix a problem with cloning date pickers - Valid from and valid to were not even requested by the client --%>        
<%--         <td width="10%"><v:itl key="@Common.ValidFrom"/></td> --%>
<%--         <td width="10%"><v:itl key="@Common.ValidTo"/></td> --%>
        <td class="grid-sort-column"></td>
      </tr>
    </thead>
    <tbody id="tbody-rewardpoint-exchangerate">
      <tr class="grid-row rewardpoint-exchangerate-template hidden">
        <td><v:grid-checkbox/></td>
        <td><v:input-text field="ExchangeRate" clazz="rewardpoint-exchangerate-field" enabled="<%=canEdit%>"/></td>
        <td><snp:dyncombo field="ExchangeRateCalendarId" clazz="rewardpoint-exchangerate-field" entityType="<%=LkSNEntityType.Calendar%>" enabled="<%=canEdit%>"/></td>
<%--         TEMPORARY DISABLED until we fix a problem with cloning date pickers - Valid from and valid to were not even requested by the client --%>
<%--         <td><v:input-text field="ExchangeRateValidDateFrom" clazz="rewardpoint-exchangerate-field" type="datepicker" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/></td> --%>
<%--         <td><v:input-text field="ExchangeRateValidDateTo" clazz="rewardpoint-exchangerate-field" type="datepicker" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/></td> --%>
        <td><span class="grid-move-handle"></span></td>
      </tr>
    </tbody>
    <tbody>
      <tr>
        <td colspan="100%">
          <v:button id="btn-rewardpoint-exchangerate-add" caption="@Common.Add" fa="plus" enabled="<%=canEdit%>"/>
          <v:button id="btn-rewardpoint-exchangerate-del" caption="@Common.Remove" fa="minus" enabled="<%=canEdit%>"/>
        </td>
      </tr>
    </tbody>
  </v:grid>
  
</v:widget-block>      

<script>
$(document).ready(function() {

	$("#rewardpoint-exchangerate-grid-inner tbody").sortable({
	    handle: ".grid-move-handle",
	    helper: fixHelper,
	    stop: function(event, ui) {
	    }
	  });
	
	var $tbody = $("#tbody-rewardpoint-exchangerate");
  var $rewardPoint = $tbody.find(".rewardpoint-exchangerate-template").removeClass("hidden").remove();
  $("#btn-rewardpoint-exchangerate-add").click(() => $rewardPoint.clone().appendTo($tbody));
  $("#btn-rewardpoint-exchangerate-del").click(() => $tbody.removeCheckedRows());
  
  $tbody.docToGrid({
	  "doc": <%=rewardPoint.ExchangeRateList.getJSONString()%>,
	  "template": $rewardPoint,
	  "fieldSelector": ".rewardpoint-exchangerate-field"
	});
  
  $(document).von($tbody, "rewardpoint-save", function(event, params) {
	  params.MembershipPoint.ExchangeRateList = $tbody.find("tr").gridToDoc({
	    "fieldSelector": ".rewardpoint-exchangerate-field"
	  });
	});
  
});
</script>
