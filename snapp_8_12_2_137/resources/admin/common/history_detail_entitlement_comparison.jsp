<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageHistoryDetailEntitlementComparison" scope="request"/>

<style>
.flex-container { 
  display: flex;
}

.flex-child {
  flex: 1;
}  

.flex-child:first-child {
  margin-right: 20px;
} 

iframe {
  margin:0;
  padding:0;
  border:0;
  overflow:hidden;
  width:100%;
}
</style>

<%
  String historyDetailId = pageBase.getParameter("historylog_detail_id");
%>

<%!
private String createEntitlementURL(String historyLogDetailId, boolean oldValue) {
  return "admin?page=history_detail_entitlement&historylog_detail_id=" + historyLogDetailId + "&old_value=" + oldValue;
}
%>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-form id="history-detail-entitlement-comparison-form">

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Entitlement.EntitlementsComparison" default="true" icon="ticket.png">
    <div class="tab-content">
      <div class="flex-container">
        <div class="flex-child old">
          <v:widget caption="@Common.OriginalValue">
            <iframe 
              id='old-frame'
              src="<%=createEntitlementURL(historyDetailId, true)%>">
            </iframe>
          </v:widget>
        </div>
        <div class="flex-child new">
          <v:widget caption="@Common.NewValue">
            <iframe
              id='new-frame' 
              src="<%=createEntitlementURL(historyDetailId, false)%>">
            </iframe>
          </v:widget>
        </div>
      </div>
    </div>
  </v:tab-item-embedded>  
</v:tab-group>
                                                                                                                                                                                                                     
</v:page-form>                      
<jsp:include page="/resources/common/footer.jsp"/>                               

<script>
$(document).ready(function() {
  _initFrame($("#old-frame"));
  _initFrame($("#new-frame"));
  
  function _initFrame($frame) {
	  $frame.bind("load", function() {
	    $frame.contents().find("#entitlement-widget").click(function() { 
	    	_resizeFrame($frame);
	    });
      _resizeFrame($frame);
	  });
  }
  
  function _resizeFrame($frame) {
	  //each frame size is calculated when the entitlement-widget has been fully initialized. The synchronization is made by the triggered event "click"  
    $frame.css("height", ($frame[0].contentWindow.document.body.scrollHeight + 10) + "px"); 
  }
});

</script>


