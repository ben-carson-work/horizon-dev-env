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

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSaleList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
  boolean canImportOrders = pageBase.getRights().BKO_ImportOrders.getBoolean();
  String defaultLocationId = null;
  if (!rights.AuditLocationFilter.isLookup(LkSNAuditLocationFilter.All)) 
    defaultLocationId = rights.MasterLocationId.isNull(pageBase.getSession().getLocationId()); 

  String defaultFromDateTime = (pageBase.getNullParameter("AccountId") == null) ? pageBase.getBrowserFiscalDate().getXMLDateTime() : null;
  String defaultToDateTime = (pageBase.getNullParameter("AccountId") == null) ? pageBase.getBrowserFiscalDate().addDays(1).addMins(-1).getXMLDateTime() : null;
  String rightSearchesMinDate = rights.SearchesMinDate.isNull() ? null : rights.SearchesMinDate.getDateTime().getXMLDate();  
  
  pageBase.setDefaultParameter("FromDateTime", defaultFromDateTime);
  pageBase.setDefaultParameter("ToDateTime", defaultToDateTime);
  
  List<DOMetaFieldGroup> mfgList = pageBase.getBL(BLBO_MetaData.class).findSearchMetaFieldGroupsByEntityType(LkSNEntityType.Sale);
%>

<v:tab-toolbar>
  <v:button id="search-btn" caption="@Common.Search" fa="search"/>
  <snp:btn-report docContext="<%=LkSNContextType.Account_Orders%>" caption="@DocTemplate.Reports" include="<%=pageBase.hasParameter(\"AccountId\")%>"/>
  <v:button id="btn-import-sale" caption="@Common.Import" fa="sign-in" enabled="<%=canImportOrders%>" include="<%=pageBase.isVgsContext(\"BKO\")%>"/>

  <v:pagebox gridId="sale-grid"/>
</v:tab-toolbar>

<v:tab-content>
  <v:profile-recap>
    <div class="v-filter-container">
      <v:widget>
        <v:widget-block>
          <div style="display:flex; justify-content:space-between; align-items:center;">
            <input type="text" id="SaleCode" class="form-control default-focus v-filter-code" placeholder="<v:itl key="@Common.Code"/>" value="<%=pageBase.getEmptyParameter("SaleCode")%>"/>
            <v:hint-handle hint="@Sale.SaleCodeSearchHint"/>
          </div>
        </v:widget-block>
      </v:widget>
  
      <div class="v-filter-all-condition">
        <v:widget caption="@Common.Search">
          <v:widget-block>
            <label for="FromDateTime"><v:itl key="@Common.From"/></label><br/>
            <v:input-text type="datetimepicker" field="FromDateTime" style="width:120px"/>
            
            <div class="filter-divider"></div>
            
            <label for="ToDateTime"><v:itl key="@Common.To"/></label><br/>
            <v:input-text type="datetimepicker" field="ToDateTime" style="width:120px"/>
            
            <div class="filter-divider"></div>
            
            <label for="FullSearch"><v:itl key="@Common.FullSearch"/></label>
            <input type="text" id="FullText" class="form-control" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
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
    
        <v:widget caption="@Common.Status">
          <v:widget-block>
            <v:lk-checkbox field="SaleCalcStatus" lookup="<%=LkSN.SaleCalcStatus%>"/>
          </v:widget-block>
          <v:widget-block>
            <v:db-checkbox field="cbOpenOrderBalance" value="true" caption="@Account.Credit.SearchOpenOrders" hint="@Account.Credit.SearchOpenOrdersHint"/>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Common.Flags">
          <v:widget-block clazz="order-flags-block">
            <div class="order-flags-column order-flags-include">
              <div class="order-flags-title"><v:itl key="@Common.Include"/></div>
              <div><label class="checkbox-label"><input type="checkbox" name="Flag_Approved"/> <v:itl key="@Reservation.Flag_Approved"/></label></div>
              <div><label class="checkbox-label"><input type="checkbox" name="Flag_Consignment"/> <v:itl key="@Reservation.Flag_Consigned"/></label></div>
              <div><label class="checkbox-label"><input type="checkbox" name="Flag_Paid"/> <v:itl key="@Reservation.Flag_Paid"/></label></div>
              <div><label class="checkbox-label"><input type="checkbox" name="Flag_Encoded"/> <v:itl key="@Reservation.Flag_Encoded"/></label></div>
              <div><label class="checkbox-label"><input type="checkbox" name="Flag_Printed"/> <v:itl key="@Reservation.Flag_Printed"/></label></div>
              <div><label class="checkbox-label"><input type="checkbox" name="Flag_Validated"/> <v:itl key="@Reservation.Flag_Validated"/></label></div>
              <div><label class="checkbox-label"><input type="checkbox" name="Flag_Completed"/> <v:itl key="@Reservation.Flag_Completed"/></label></div>
            </div>
            <div class="order-flags-column order-flags-exclude">
              <div class="order-flags-title"><v:itl key="@Common.Exclude"/></div>
              <div><label class="checkbox-label"><input type="checkbox" name="Flag_NotApproved"/> <v:itl key="@Reservation.Flag_Approved"/></label></div>
              <div><label class="checkbox-label"><input type="checkbox" name="Flag_NotConsignment"/> <v:itl key="@Reservation.Flag_Consigned"/></label></div>
              <div><label class="checkbox-label"><input type="checkbox" name="Flag_NotPaid"/> <v:itl key="@Reservation.Flag_Paid"/></label></div>
              <div><label class="checkbox-label"><input type="checkbox" name="Flag_NotEncoded"/> <v:itl key="@Reservation.Flag_Encoded"/></label></div>
              <div><label class="checkbox-label"><input type="checkbox" name="Flag_NotPrinted"/> <v:itl key="@Reservation.Flag_Printed"/></label></div>
              <div><label class="checkbox-label"><input type="checkbox" name="Flag_NotValidated"/> <v:itl key="@Reservation.Flag_Validated"/></label></div>
              <div><label class="checkbox-label"><input type="checkbox" name="Flag_NotCompleted"/> <v:itl key="@Reservation.Flag_Completed"/></label></div>
            </div>
          </v:widget-block>
        </v:widget>
        <v:widget caption="@Common.Filters">
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
            
            <div class="filter-divider"></div>
            
            <v:itl key="@Account.Association"/><br/>
            <snp:dyncombo id="AssociationAccountId" entityType="<%=LkSNEntityType.Association%>"/>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Common.Others">
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
  </v:profile-recap>
  
  <v:profile-main>
    <% 
      String params = "";
      if (pageBase.getParameter("AccountId") != null)
        params = "AccountId=" + pageBase.getParameter("AccountId");
      else if (pageBase.getParameter("MembershipAccountId") != null)
        params = "MembershipAccountId=" + pageBase.getParameter("MembershipAccountId") + "&FromDateTime=" + defaultFromDateTime + "&ToDateTime=" + defaultToDateTime;
      else
        params = "FromDateTime=" + defaultFromDateTime + "&ToDateTime=" + defaultToDateTime + ((defaultLocationId == null) ? "" : "&WksLocationId=" + defaultLocationId);
    %>
    
    <v:async-grid id="sale-grid" jsp="sale/sale_grid.jsp" params="<%=params%>" />
  </v:profile-main>
</v:tab-content>
    
<script>
$(document).ready(function() {
  $("#search-btn").click(search);
  $("#btn-import-sale").click(showImportDialog);
  $("#SaleCode, #FullText, #TotalAmountFrom, #TotalAmountTo, #PaidAmountFrom, #PaidAmountTo, .search-metafield-group").on("enterKeyPressed", search);

  function search() {
    try {
      setGridUrlParam("#sale-grid", "SaleCode", $("#SaleCode").val());
      setGridUrlParam("#sale-grid", "FullText", $("#FullText").val());
      setGridUrlParam("#sale-grid", "FromDateTime", $("#FromDateTime-picker").getXMLDateTime());
      setGridUrlParam("#sale-grid", "ToDateTime", $("#ToDateTime-picker").getXMLDateTime(true));
      setGridUrlParam("#sale-grid", "Flag_Approved", getIncludeFlagParam("Approved"));
      setGridUrlParam("#sale-grid", "Flag_Consignment", getIncludeFlagParam("Consignment"));
      setGridUrlParam("#sale-grid", "Flag_Paid", getIncludeFlagParam("Paid"));
      setGridUrlParam("#sale-grid", "Flag_Encoded", getIncludeFlagParam("Encoded"));
      setGridUrlParam("#sale-grid", "Flag_Printed", getIncludeFlagParam("Printed"));
      setGridUrlParam("#sale-grid", "Flag_Validated", getIncludeFlagParam("Validated"));
      setGridUrlParam("#sale-grid", "Flag_Completed", getIncludeFlagParam("Completed"));
      setGridUrlParam("#sale-grid", "Flag_NotApproved", getExcludeFlagParam("Approved"));
      setGridUrlParam("#sale-grid", "Flag_NotConsignment", getExcludeFlagParam("Consignment"));
      setGridUrlParam("#sale-grid", "Flag_NotPaid", getExcludeFlagParam("Paid"));
      setGridUrlParam("#sale-grid", "Flag_NotEncoded", getExcludeFlagParam("Encoded"));
      setGridUrlParam("#sale-grid", "Flag_NotPrinted", getExcludeFlagParam("Printed"));
      setGridUrlParam("#sale-grid", "Flag_NotValidated", getExcludeFlagParam("Validated"));
      setGridUrlParam("#sale-grid", "Flag_NotCompleted", getExcludeFlagParam("Completed"));
      setGridUrlParam("#sale-grid", "SaleCalcStatus", $("[name='SaleCalcStatus']").getCheckedValues());
      setGridUrlParam("#sale-grid", "OpenOrderBalance", $("#cbOpenOrderBalance").isChecked());
      setGridUrlParam("#ticket-grid", "TicketStatus", $("[name='Status']").getCheckedValues());
      setGridUrlParam("#sale-grid", "WksLocationId", $("#LocationId").val() || "");
      setGridUrlParam("#sale-grid", "OpAreaId", $("#OpAreaId").val() || "");
      setGridUrlParam("#sale-grid", "WorkstationId", $("#WorkstationId").val() || "");
      setGridUrlParam("#sale-grid", "UserAccountId", $("#UserAccountId").val() || "");
      setGridUrlParam("#sale-grid", "PaymentMethodId", $("#PaymentMethodId").val());
      setGridUrlParam("#sale-grid", "AssociationAccountId", $("#AssociationAccountId").val());
      setGridNumericParam("#sale-grid", "TotalAmountFrom", $("#TotalAmountFrom").val());
      setGridNumericParam("#sale-grid", "TotalAmountTo", $("#TotalAmountTo").val());
      setGridNumericParam("#sale-grid", "PaidAmountFrom", $("#PaidAmountFrom").val());
      setGridNumericParam("#sale-grid", "PaidAmountTo", $("#PaidAmountTo").val());
      
      $(".search-metafield-group").each(function(index, elem) {
          var $input = $(elem);
          setGridUrlParam("#sale-grid", $input.attr("id"), $input.val());
        });
      
      changeGridPage("#sale-grid", "first");
    }
    catch (err) {
      showMessage(err);
    }
  }
  
  function getIncludeFlagParam(paramName) {
    var include = $("input[name='Flag_" + paramName + "']").isChecked();
    if (include === true)
      return "true";
    return "";
  }
	    
  function getExcludeFlagParam(paramName) {
    var exclude = $("input[name='Flag_Not" + paramName + "']").isChecked();
    if (exclude === true)
      return "true";
    return "";
  }

  function showImportDialog() {
    asyncDialogEasy("sale/sale_import_dialog");
  }
});

function getDocExecParams() {
  return "p_AccountId=" + <%=JvString.jsString(pageBase.getParameter("AccountId"))%>;
}

</script>

<style>
  .order-flags-title {
    font-weight: bold;
    text-decoration: underline;
  }
  .order-flags-block {
    display: flex;
    justify-content: space-between;
  }
  .order-flags-column {
      flex-grow: 1;
  }
</style>