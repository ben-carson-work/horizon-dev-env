<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.snapp.web.queue.outbound.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" id="search-outboundoffline"/>
  <v:pagebox gridId="outboundoffline-grid" />
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
        <label>
          <input type="checkbox" name="AnswerCommonStatus" value="<%=LkSNOutboundOfflineStatus.Waiting.getCode()%>"/>
          <span class="snp-inline-legend" style="background-color:var(--base-gray-color)"></span>
          <%=LkSNOutboundOfflineStatus.Waiting.getDescription()%>
        </label>
        <br />
        
        <label>
          <input type="checkbox" name="AnswerCommonStatus" value="<%=LkSNOutboundOfflineStatus.Working.getCode()%>"/>
          <span class="snp-inline-legend" style="background-color:var(--base-orange-color)"></span>
          <%=LkSNOutboundOfflineStatus.Working.getDescription()%>
        </label>
        <br />
        <label>
          <input type="checkbox" name="AnswerCommonStatus" value="<%=LkSNOutboundOfflineStatus.Succeeded.getCode()%>"/>
          <span class="snp-inline-legend" style="background-color:var(--base-green-color)"></span>
          <%=LkSNOutboundOfflineStatus.Succeeded.getDescription()%>
        </label>
        <br />
        <label>
          <input type="checkbox" name="AnswerCommonStatus" value="<%=LkSNOutboundOfflineStatus.Failed.getCode()%>"/>
          <span class="snp-inline-legend" style="background-color:var(--base-purple-color)"></span>
          <%=LkSNOutboundOfflineStatus.Failed.getDescription()%>
        </label>
        <br />
      </v:widget-block>    
    </v:widget>
  </div>
  
  <div class="profile-cont-div">
    <v:async-grid id="outboundoffline-grid" jsp="outbound/outboundoffline_grid.jsp" params="RootElement=true"/>
  </div>
</div>

<script>

$(document).ready(function() {
  
  $(document).on("cbListClicked", enableDisable);
  
  function enableDisable() {
    var empty = ($("#outboundoffline-grid [name='OutboundOfflineId']").getCheckedValues() == "");
    $("#status-btn").setClass("disabled", empty);
  }
  
  function search() {
    setGridUrlParam("#outboundoffline-grid", "FromDateTime", $("#FromDateTime-picker").getXMLDateTime());
    setGridUrlParam("#outboundoffline-grid", "ToDateTime", $("#ToDateTime-picker").getXMLDateTime(true));
    setGridUrlParam("#outboundoffline-grid", "AnswerCommonStatus", $("[name='AnswerCommonStatus']").getCheckedValues());

    changeGridPage("#outboundoffline-grid", "first");
  }
  
  $("#search-outboundoffline").click(search);
  
});
</script>