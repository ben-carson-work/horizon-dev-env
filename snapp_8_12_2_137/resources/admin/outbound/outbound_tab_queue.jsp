<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.snapp.web.queue.outbound.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
  PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
  String defaultFromDateTime = pageBase.getBrowserFiscalDate().getXMLDateTime();
  String defaultToDateTime = pageBase.getBrowserFiscalDate().addDays(1).addMins(-1).getXMLDateTime();
  pageBase.setDefaultParameter("FromDateTime", defaultFromDateTime);
  pageBase.setDefaultParameter("ToDateTime", defaultToDateTime);
%>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" id="search-outboundqueue"/>
  <div class="btn-group">
    <v:button id="status-btn" caption="@Common.Actions" clazz="disabled" fa="flag" dropdown="true"/>
    <v:popup-menu bootstrap="true">
        <% 
          String hrefRetry = "javascript:asyncDialogEasy('log/retrymessage_dialog')"; 
          String hrefResolved = "javascript:asyncDialogEasy('log/markasresolvedmessage_dialog')";
        %>
        <v:popup-item caption="@Outbound.MarkAsResolved" href="<%=hrefResolved%>"/>
        <v:popup-item caption="@Common.Retry" href="<%=hrefRetry%>"/>
    </v:popup-menu>
  </div>
  <v:pagebox gridId="outboundqueue-grid" />
</div>

<div class="tab-content"> 
  <div class="profile-pic-div">
    <v:widget caption="@Common.DateRange">
      <v:widget-block>
        <v:itl key="@Common.From" />
        <br />
        <v:input-text type="datetimepicker" field="FromDateTime"
          style="width:120px" />
        <br />
        <v:itl key="@Common.To" />
        <br />
        <v:input-text type="datetimepicker" field="ToDateTime"
          style="width:120px" />
      </v:widget-block>
      <v:widget-block>
        <% for (LookupItem item : LkSN.OutboundQueueStatus.getItems()) { %>
          <% String color = ((LkSNOutboundQueueStatus.OutboundQueueStatusItem)item).hexColor; %>
          <div><v:db-checkbox field="AnswerCommonStatus" value="<%=item.getCode()%>" caption="<%=item.getRawDescription()%>" legendColor="<%=color%>"/>  </div>
        <% } %>
      </v:widget-block>
      <v:widget-block>
      <% for(LookupItem item : LkSN.OutboundMessagePriority.getItems()) { %>
        <label>
          <input type="checkbox" name="AnswerCommonPriority" value="<%=item.getCode()%>"/>
          <%=item.getDescription()%>
        </label>
        <br />
      <% } %>
      </v:widget-block>     
    </v:widget>
    <v:widget caption="@Outbound.OutboundMessage">
      <v:widget-block>
        <v:combobox field="OutboundMessageCode" lookupDataSet="<%=pageBase.getBL(BLBO_Outbound.class).getOutboundMessagesDS()%>" captionFieldName="OutboundMessageName" idFieldName="OutboundMessageCode"/>
      </v:widget-block>  
    </v:widget>
  </div>
  
  <div class="profile-cont-div">
    <% String params = "FromDateTime=" + defaultFromDateTime + "&ToDateTime=" + defaultToDateTime + "&RootElement=true"; %>
    <v:async-grid id="outboundqueue-grid" jsp="outbound/outboundqueue_grid.jsp" params="<%=params%>"/>
  </div>
</div>

<script>

$(document).ready(function() {
  
  $(document).on("cbListClicked", enableDisable);
  
  function enableDisable() {
    var empty = ($("#outboundqueue-grid [name='OutboundQueueId']").getCheckedValues() == "");
    $("#status-btn").setClass("disabled", empty || (<%=!pageBase.getRights().QueueInstance.getBoolean()%> && <%=pageBase.getRights().ExternalQueue.getBoolean()%>));
  }
  
  function search() {
	var dateFrom = $("#FromDateTime-picker").datepicker("getDate");
	var dateTo = $("#ToDateTime-picker").datepicker("getDate");

	if (checkMaxDateRange(dateFrom, dateTo, <%=rights.SearchesMaxDateRange.getInt()%>)) {
      setGridUrlParam("#outboundqueue-grid", "FromDateTime", $("#FromDateTime-picker").getXMLDateTime());
      setGridUrlParam("#outboundqueue-grid", "ToDateTime", $("#ToDateTime-picker").getXMLDateTime(true));
      setGridUrlParam("#outboundqueue-grid", "AnswerCommonStatus", $("[name='AnswerCommonStatus']").getCheckedValues());
      setGridUrlParam("#outboundqueue-grid", "AnswerCommonPriority", $("[name='AnswerCommonPriority']").getCheckedValues());
      setGridUrlParam("#outboundqueue-grid", "OutboundMessageCode", $('#OutboundMessageCode').val());

      changeGridPage("#outboundqueue-grid", "first");
	}
  }
  
  $("#search-outboundqueue").click(search);
  
});

</script>