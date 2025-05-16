<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageOpentabList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String defaultLocationId = null;
if (!rights.AuditLocationFilter.isLookup(LkSNAuditLocationFilter.All)) 
  defaultLocationId = rights.MasterLocationId.isNull(pageBase.getSession().getLocationId()); 

String defaultFromDateTime = pageBase.getBrowserFiscalDate().getXMLDateTime();
String defaultToDateTime = pageBase.getBrowserFiscalDate().addDays(1).addMins(-1).getXMLDateTime();

pageBase.setDefaultParameter("FromDateTime", defaultFromDateTime);
pageBase.setDefaultParameter("ToDateTime", defaultToDateTime); 

%>

<div class="tab-toolbar">
  <v:button id="search-btn" caption="@Common.Search" fa="search"/>
  
  <v:pagebox gridId="opentab-grid"/>
</div>

<div class="tab-content">
  <div class="profile-pic-div">
    <div class="v-filter-container">

      <div class="v-filter-all-condition">
				<v:widget caption="@Common.DateRange">
					<v:widget-block>
            <label for="FromDateTime"><v:itl key="@Common.From"/></label><br/>
            <v:input-text type="datetimepicker" field="FromDateTime" style="width:120px"/>
              
            <div class="filter-divider"></div>
              
            <label for="ToDateTime"><v:itl key="@Common.To"/></label><br/>
            <v:input-text type="datetimepicker" field="ToDateTime" style="width:120px"/>
          </v:widget-block> 
        </v:widget>
    
        <v:widget caption="@Common.Filters">
          <v:widget-block>
            
            <v:itl key="@Account.Location"/><br/>
            <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>" auditLocationFilter="true"/>
            
            <div class="filter-divider"></div>
            
            <v:itl key="@Account.OpArea"/><br/>
            <snp:dyncombo id="OpAreaAccountId" entityType="<%=LkSNEntityType.OperatingArea%>" auditLocationFilter="true" parentComboId="LocationId"/>
            
            <div class="filter-divider"></div>
            
            <v:itl key="@Common.Workstation"/><br/>
            <snp:dyncombo id="WorkstationId" entityType="<%=LkSNEntityType.Workstation%>" auditLocationFilter="true" parentComboId="OpAreaAccountId"/>
          </v:widget-block>
    
          <v:widget-block>
            <v:itl key="@OpenTab.Waiter"/><br/>
            <snp:dyncombo id="WaiterId" entityType="<%=LkSNEntityType.Waiter%>"/>
          </v:widget-block>

        </v:widget>
          
         <v:widget caption="@Common.Others">
           <v:widget-block>
             <v:itl key="@Common.Status"/><br/>
             <v:lk-combobox field="SaleTabStatus" lookup="<%=LkSN.OpentabStatus%>"/>
           </v:widget-block>           
					 <v:widget-block>
             <v:itl key="@OpenTab.TableStatus"/><br/>
             <v:lk-combobox field="TableStatus" lookup="<%=LkSN.TableStatus%>"/>
           </v:widget-block>
         </v:widget>
      </div>
    </div>
  </div>
  
  <div class="profile-cont-div">
	  <% 
	  	String params = "FromDateTime=" + defaultFromDateTime + "&ToDateTime=" + defaultToDateTime + ((defaultLocationId == null) ? "" : "&LocationId=" + defaultLocationId);
		%>
    <v:async-grid id="opentab-grid" jsp="opentab/opentab_grid.jsp" params="<%=params%>"/>
  </div>
</div>
<script>
$(document).ready(function() {
  $("#search-btn").click(search);
  
  function search() {
    try {
      var dateFrom = $("#FromDateTime-picker").datepicker('getDate');
  	  var dateTo = $("#ToDateTime-picker").datepicker('getDate');
  	  
  	  if (checkMaxDateRange(dateFrom, dateTo, <%=rights.SearchesMaxDateRange.getInt()%>)) {
  	    setGridUrlParam("#opentab-grid", "FullText", $("#FullText").val());
   	    setGridUrlParam("#opentab-grid", "FromDateTime", $("#FromDateTime-picker").getXMLDateTime());
  	    setGridUrlParam("#opentab-grid", "ToDateTime", $("#ToDateTime-picker").getXMLDateTime(true));
  	    setGridUrlParam("#opentab-grid", "LocationId", $("#LocationId").val() || "");
  	    setGridUrlParam("#opentab-grid", "OpAreaAccountId", $("#OpAreaAccountId").val() || "");
  	    setGridUrlParam("#opentab-grid", "WorkstationId", $("#WorkstationId").val() || "");
  	    setGridUrlParam("#opentab-grid", "WaiterId", $("#WaiterId").val() || "");
  	    setGridUrlParam("#opentab-grid", "SaleTabStatus", $("#SaleTabStatus").val());
  	    setGridUrlParam("#opentab-grid", "TableStatus", $("#TableStatus").val());
  	    
        changeGridPage("#opentab-grid", "first");
      }
  	}
    catch (err) {
      showMessage(err);
    }
  }

});
</script>