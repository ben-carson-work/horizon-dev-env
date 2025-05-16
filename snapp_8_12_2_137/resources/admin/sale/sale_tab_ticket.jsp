<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSale" scope="request"/>

<div class="tab-toolbar">
  <v:button id="search-btn" caption="@Common.Search" fa="search" onclick="search()"/> 
  <v:button id="tckUpdBtn" caption="@Common.Edit" fa="edit" bindGrid="ticket-grid" bindGridEmpty="false" onclick="ticketUpdate()"/>
  <v:pagebox gridId="ticket-grid"/>
</div>

<div class="tab-content">
  <div class="profile-pic-div">
    <div class="v-filter-container">
       <v:widget>
        <v:widget-block>
          <div style="display:flex; justify-content:space-between; align-items:center;">
            <input type="text" id="TicketCode" class="form-control default-focus v-filter-code" placeholder="<v:itl key="@Common.Code"/>" onkeypress="if (event.keyCode == KEY_ENTER) {search();return false;}"/>     
           </div>
        </v:widget-block>
      </v:widget>
    
     <div class="v-filter-all-condition">
       <v:widget caption="@Common.Filters">
         <v:widget-block>
           <v:itl key="@Product.ProductType"/><br/>
           <snp:dyncombo id="ProductId" entityType="<%=LkSNEntityType.ProductType%>" auditLocationFilter="true"/>      
         </v:widget-block>
       </v:widget>  
       <v:widget caption="@Common.Status">
         <v:widget-block>
           <v:db-checkbox field="Status" caption="@Lookup.TicketStatusGroup.Active" value="<%=LkSNTicketStatusGroup.Active.getCode()%>" /><br/>
           <v:db-checkbox field="Status" caption="@Lookup.TicketStatusGroup.Blocked" value="<%=LkSNTicketStatusGroup.Blocked.getCode()%>" /><br/>
           <v:db-checkbox field="Status" caption="@Lookup.TicketStatusGroup.Invalid" value="<%=LkSNTicketStatusGroup.Invalid.getCode()%>" />
         </v:widget-block>
       </v:widget>
     </div>
    </div>
  </div>
  
  <div class="profile-cont-div">
  <% String params = "SaleId=" + pageBase.getId(); %>
  <v:async-grid id="ticket-grid" jsp="portfolio/ticket_grid.jsp" params="<%=params%>"/>
  </div>
  
  <v:last-error/>
</div>

<script>
function ticketUpdate () {
	var ids = $("[name='TicketId']").getCheckedValues();
	var queryBase64 = null;
	var ticketUpdateSteps = <%=JvString.jsString(JvArray.arrayToString(LookupManager.getIntArray(LkSNTicketUpdateStep.Status, LkSNTicketUpdateStep.Validity), ","))%>;
	if (ids == "")
	  showMessage(itl("@Common.NoElementWasSelected"));
	else if ($("#ticket-grid-inner").hasClass("multipage-selected")) {
	  ids = "";            
	  queryBase64 = $("#ticket-grid-inner").attr("data-QueryBase64"); 
	}
	asyncDialogEasy('portfolio/ticket_update_dialog', 'ticketIDs=' + ids + '&TicketUpdateSteps=' + ticketUpdateSteps + '&multiEdit=true', {"QueryBase64": queryBase64});
}

function search() {
  setGridUrlParam("#ticket-grid", "TicketCode", $("#TicketCode").val());
  setGridUrlParam("#ticket-grid", "ProductId", $("#ProductId").val() || "");
  setGridUrlParam("#ticket-grid", "TicketStatus", $("[name='Status']").getCheckedValues());
  changeGridPage("#ticket-grid", "first");
}
</script>

