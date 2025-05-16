<%@page import="java.util.List"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTransactionList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String defaultLocationId = null;
if (!rights.AuditLocationFilter.isLookup(LkSNAuditLocationFilter.All)) 
  defaultLocationId = rights.MasterLocationId.isNull(pageBase.getSession().getLocationId()); 

String defaultFromDateTime = pageBase.getBrowserFiscalDate().getXMLDateTime();
String defaultToDateTime = pageBase.getBrowserFiscalDate().addDays(1).addMins(-1).getXMLDateTime();
String rightSearchesMinDate = rights.SearchesMinDate.isNull() ? null : rights.SearchesMinDate.getDateTime().getXMLDate();

pageBase.setDefaultParameter("FromDateTime", defaultFromDateTime);
pageBase.setDefaultParameter("ToDateTime", defaultToDateTime);

List<DOMetaFieldGroup> mfgList = pageBase.getBL(BLBO_MetaData.class).findSearchMetaFieldGroupsByEntityType(LkSNEntityType.Transaction);
%>

<div class="tab-toolbar">
  <v:button id="search-btn" caption="@Common.Search" fa="search"/>
  
  <v:pagebox gridId="transaction-grid"/>
</div>

<div class="tab-content">
  <div class="profile-pic-div">
    <div class="v-filter-container">
      <v:widget>
        <v:widget-block>
          <div class="search-code-container">
            <input type="text" id="TransactionCode" class="form-control default-focus v-filter-code" placeholder="<v:itl key="@Common.Code"/>"/>
            <v:hint-handle hint="@Common.TransactionCodeSearchHint"/>
          </div>
        </v:widget-block>
      </v:widget>
    
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
            <input type="text" id="FullText" class="form-control" placeholder="<v:itl key="@Common.FullSearch"/>"/>
          </v:widget-block>
            
          <v:widget-block>
            <v:itl key="@Account.Location"/><br/>
            <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>" auditLocationFilter="true"/>
            
            <div class="filter-divider"></div>
            
            <v:itl key="@Account.OpArea"/><br/>
            <snp:dyncombo id="OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" auditLocationFilter="true" parentComboId="LocationId"/>
            
            <div class="filter-divider"></div>
            
            <v:itl key="@Common.Workstation"/><br/>
            <snp:dyncombo id="WorkstationId" entityType="<%=LkSNEntityType.Workstation%>" auditLocationFilter="true" parentComboId="OpAreaId"/>
          </v:widget-block>
    
          <v:widget-block>
            <v:itl key="@Common.User"/><br/>
            <snp:dyncombo id="UserAccountId" entityType="<%=LkSNEntityType.User%>"/>
          </v:widget-block>
    
          <v:widget-block>
            <label for="SupervisedOnly"><input type="checkbox" id="SupervisedOnly" value="true"/> <v:itl key="@Sale.SupervisedTransactions"/></label>
          </v:widget-block>
        </v:widget>
        
        <% if (!mfgList.isEmpty()) { %>
          <v:widget caption="@Common.SearchGroups">
            <v:widget-block>
            <% for (DOMetaFieldGroup mfg : mfgList) { %>
              <% String fieldId = "MFG_" + mfg.MetaFieldGroupId.getString(); %>
              <div class="filter-divider"></div>
              <div><%=mfg.MetaFieldGroupName.getHtmlString()%></div>
              <v:input-text field="<%=fieldId%>" clazz="search-metafield-group"/>
            <% } %>  
            </v:widget-block>
          </v:widget>  
        <% } %>
         
        <v:widget caption="@Common.Others">
          <v:widget-block>
            <div>
              <div><v:itl key="@Common.TransactionType"/></div>
              <div><v:lk-combobox field="TransactionType" lookup="<%=LkSN.TransactionType%>"/></div>
            </div>
            <div class="filter-divider"></div>
            <div>
              <div><v:itl key="@Common.Warning"/></div>
              <div><v:lk-multibox field="TransactionWarns" lookup="<%=LkSN.TransactionWarn%>"/></div>
            </div>
          </v:widget-block>
          <v:widget-block>
            <v:itl key="@Payment.PaymentMethod"/><br/>
            <snp:dyncombo id="PaymentMethodId" entityType="<%=LkSNEntityType.PaymentMethod%>"/>
            
            <div class="filter-divider"></div>
            <table style="width:100%">
             <tr>
               <td>
                 &nbsp;<v:itl key="@Reservation.TotalAmountFrom"/><br/>
                 <input type="text" id="TotalAmountFrom" class="form-control"/>
               </td>
               <td>&nbsp;</td>
               <td>
                 &nbsp;<v:itl key="@Common.To"/><br/>
                 <input type="text" id="TotalAmountTo" class="form-control"/>
               </td>
             </tr>
           </table>
           <div class="filter-divider"></div>
           <table style="width:100%">
             <tr>
               <td>
                 &nbsp;<v:itl key="@Reservation.PaidAmountFrom"/><br/>
                 <input type="text" id="PaidAmountFrom" class="form-control"/>
               </td>
               <td>&nbsp;</td>
               <td>
                 &nbsp;<v:itl key="@Common.To"/><br/>
                 <input type="text" id="PaidAmountTo" class="form-control"/>
               </td>
             </tr>
           </table>
          </v:widget-block>
        </v:widget>
      </div>
    </div>
  </div>
  
  <div class="profile-cont-div">
    <% 
     String params = "";
     if (pageBase.getParameter("AccountId") != null)
       params = "AccountId=" + pageBase.getParameter("AccountId") + "&FromDateTime=" + defaultFromDateTime + "&ToDateTime=" + defaultToDateTime+ ((defaultLocationId == null) ? "" : "&LocationId=" + defaultLocationId);
     else if (pageBase.getParameter("MembershipAccountId") != null)
       params = "MembershipAccountId=" + pageBase.getParameter("MembershipAccountId") + "&FromDateTime=" + defaultFromDateTime + "&ToDateTime=" + defaultToDateTime+ ((defaultLocationId == null) ? "" : "&LocationId=" + defaultLocationId);
     else
       params = "FromDateTime=" + defaultFromDateTime + "&ToDateTime=" + defaultToDateTime + ((defaultLocationId == null) ? "" : "&LocationId=" + defaultLocationId);
    %>
    
    <v:async-grid id="transaction-grid" jsp="transaction/transaction_grid.jsp" params="<%=params%>"/>
  </div>
</div>

<script>
$(document).ready(function() {
  $("#search-btn").click(search);

  function search() {
    try {
  	  setGridUrlParam("#transaction-grid", "TransactionCode", $("#TransactionCode").val());
  	  setGridUrlParam("#transaction-grid", "FullText", $("#FullText").val());
  	  setGridUrlParam("#transaction-grid", "FromDateTime", $("#FromDateTime-picker").getXMLDateTime());
  	  setGridUrlParam("#transaction-grid", "ToDateTime", $("#ToDateTime-picker").getXMLDateTime(true));
  	  setGridUrlParam("#transaction-grid", "LocationId", $("#LocationId").val() || "");
  	  setGridUrlParam("#transaction-grid", "OpAreaId", $("#OpAreaId").val() || "");
  	  setGridUrlParam("#transaction-grid", "WorkstationId", $("#WorkstationId").val() || "");
  	  setGridUrlParam("#transaction-grid", "UserAccountId", $("#UserAccountId").val() || "");
  	  setGridUrlParam("#transaction-grid", "SupervisedOnly", $("#SupervisedOnly:checked").val());
  	  setGridUrlParam("#transaction-grid", "TransactionWarnStatus", $("[name='TransactionWarns']").val().join(","));
  	  setGridUrlParam("#transaction-grid", "TransactionType", $("#TransactionType").val());
  	  setGridUrlParam("#transaction-grid", "PaymentMethodId", $("#PaymentMethodId").val());
  	  setGridNumericParam("#transaction-grid", "TotalAmountFrom", $("#TotalAmountFrom").val());
  	  setGridNumericParam("#transaction-grid", "TotalAmountTo", $("#TotalAmountTo").val());
  	  setGridNumericParam("#transaction-grid", "PaidAmountFrom", $("#PaidAmountFrom").val());
  	  setGridNumericParam("#transaction-grid", "PaidAmountTo", $("#PaidAmountTo").val());
  	  
	  	$(".search-metafield-group").each(function(index, elem) {
	        var $input = $(elem);
	        setGridUrlParam("#transaction-grid", $input.attr("id"), $input.val());
	      });
  	       
      changeGridPage("#transaction-grid", "first");
  	}
    catch (err) {
      showMessage(err);
    }
  }
	
  function searchOnEnter() {
    if (event.keyCode == KEY_ENTER) {
  	  search();
  	  return false;
  	}
  }
	
  $("#TransactionCode").keypress(searchOnEnter);
  $("#FullText").keypress(searchOnEnter);
  $("#TotalAmountFrom").keypress(searchOnEnter);
  $("#TotalAmountTo").keypress(searchOnEnter);
  $("#PaidAmountFrom").keypress(searchOnEnter);
  $("#PaidAmountTo").keypress(searchOnEnter);
  $(".search-metafield-group").each(function(index, elem) {
      var $input = $(elem);
      $input.keypress(searchOnEnter);
    });

});
</script>
   