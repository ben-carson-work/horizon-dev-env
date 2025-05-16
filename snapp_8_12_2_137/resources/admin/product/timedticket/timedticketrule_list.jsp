<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTimedTicketRuleList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:input-text type="hidden" field="NewTimedTicketRuleId"/>

<v:last-error/>

<script>
function search() {
  setGridUrlParam("#timed-ticket-rule-grid", "FullText", $("#search-text").val(), true);
}

function searchKeyPress() {
  if (event.keyCode == KEY_ENTER) {
    search();
    event.preventDefault(); 
  }
}
</script>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <input type="text" id="search-text" class="form-control default-focus" placeholder="<v:itl key="@Common.Search" />" onkeypress="searchKeyPress()" style="width:200px"/>
      <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
      <span class="divider"></span>
      <% 
        String pnew = "id=new";
        if (pageBase.hasParameter("TimedTicketRuleId"))
          pnew += "&TimedTicketRuleId=" + pageBase.getParameter("TimedTicketRuleId");
        String hrefNew = "javascript:asyncDialogEasy('product/timedticket/timedticketrule_dialog', '" + pnew + "')"; 
      %>
      <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>" enabled="<%=rights.ProductTypes.getOverallCRUD().canCreate()%>"/>
      <v:button caption="@Common.Delete" fa="trash" href="javascript:doDelSelectedRules()" enabled="<%=rights.ProductTypes.getOverallCRUD().canDelete()%>"/>
    
      <v:pagebox gridId="timed-ticket-rule-grid"/>
    </div>
        
    <v:last-error/>

    <div class="tab-content">
      <v:async-grid id="timed-ticket-rule-grid" jsp="product/timedticket/timedticketrule_grid.jsp" />
    </div>
  </v:tab-item-embedded>
</v:tab-group>    


<script>
function doDelSelectedRules() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteTimedTicketRule",
      DeleteTimedTicketRule: {
    	  TimedTicketRuleIDs: $("[name='TimedTicketRuleId']").getCheckedValues()
      }
    };
    
    vgsService("Product", reqDO, false, function(ansDO) {
      changeGridPage("#timed-ticket-rule-grid", 1);
    });
  });
}
</script>

<jsp:include page="/resources/common/footer.jsp"/>
