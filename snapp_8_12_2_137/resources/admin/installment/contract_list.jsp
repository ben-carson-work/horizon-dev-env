<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_InstallmentContractList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
  boolean canReschedulePayments = rights.ReschedulePayments.getBoolean();
  int[] defaultStatusFilter = LookupManager.getIntArray(LkSNInstallmentContractStatus.Active, LkSNInstallmentContractStatus.ManuallyBlocked, LkSNInstallmentContractStatus.AutomaticallyBlocked); 

  String defaultCreateFromToDate = pageBase.getBrowserFiscalDate().getXMLDate();
  pageBase.setDefaultParameter("CreateDateFrom", defaultCreateFromToDate);
  pageBase.setDefaultParameter("CreateDateTo", defaultCreateFromToDate);
%>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<v:last-error/>

<script>
  function search() {
    var code = $("#Code").val();
	
    if ((code != "") || checkDateRange()) {
      setGridUrlParam("#instcontr-grid", "Code", code);
      setGridUrlParam("#instcontr-grid", "CreateDateFrom", $("#CreateDateFrom-picker").getXMLDate());
      setGridUrlParam("#instcontr-grid", "CreateDateTo", $("#CreateDateTo-picker").getXMLDate());
      setGridUrlParam("#instcontr-grid", "BlockDateFrom", $("#BlockDateFrom-picker").getXMLDate());
      setGridUrlParam("#instcontr-grid", "BlockDateTo", $("#BlockDateTo-picker").getXMLDate());
      setGridUrlParam("#instcontr-grid", "InstallmentContractStatus", $("[name='InstallmentContractStatus']").getCheckedValues());
      setGridUrlParam("#instcontr-grid", "AccountId", $("#AccountId").val());
      changeGridPage("#instcontr-grid", "first");
    }
  }
  
  function checkDateRange() {
    var dateCreateFrom = $("#CreateDateFrom-picker").datepicker("getDate");
    var dateCreateTo = $("#CreateDateTo-picker").datepicker("getDate");
    var dateBlockFrom = $("#BlockDateFrom-picker").datepicker("getDate");
    var dateBlockTo = $("#BlockDateTo-picker").datepicker("getDate");
    var result = true;
    
    if ((dateCreateFrom==null) && (dateCreateTo==null) && (dateBlockFrom==null) && (dateBlockTo==null)) {
  	  showMessage(itl("@Common.MaxSearchesDateRangeExceeded", <%=rights.SearchesMaxDateRange.getInt()%>));
  	  result = false;
    }
    else {
      if (dateCreateFrom != null)
        result = checkMaxDateRange(dateCreateFrom, dateCreateTo, <%=rights.SearchesMaxDateRange.getInt()%>);
      if (dateBlockFrom != null)
        result = checkMaxDateRange(dateBlockFrom, dateBlockTo, <%=rights.SearchesMaxDateRange.getInt()%>);
    }
    return result;
  }
</script>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" onclick="search()" />
      
      <v:button caption="@Installment.ReschedulePayments" title="@Installment.ReschedulePaymentsHint" fa="calendar" onclick="showReschedulePaymentsDialog()" enabled="<%=canReschedulePayments%>"/>
      
      <span class="divider"></span>
      <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.InstallmentContract.getCode() + ")";%>
      <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/> 
      <v:pagebox gridId="instcontr-grid"/>
    </div>

    <div class="tab-content">
      <div class="profile-pic-div">
        <div class="v-filter-container">
          <v:widget>
            <v:widget-block>
              <v:itl key="@Common.Code"/> <v:hint-handle hint="@Installment.CodeSearchHint"/><br/>
              <input type="text" id="Code" class="form-control default-focus v-filter-code" onkeypress="if (event.keyCode == KEY_ENTER) {search();return false;}"/>
            </v:widget-block>
          </v:widget>
      
          <div class="v-filter-all-condition">
            <v:widget caption="@Common.Filters">
              <v:widget-block>
                <table style="width:100%">
                  <tr>
                    <td>
                      &nbsp;<v:itl key="@Installment.FromCreateDate"/><br/>
                      <v:input-text type="datepicker" field="CreateDateFrom"/>
                    </td>
                    <td>&nbsp;</td>
                    <td>
                      &nbsp;<v:itl key="@Common.To"/><br/>
                      <v:input-text type="datepicker" field="CreateDateTo"/>
                    </td>
                  </tr>
                </table>
              </v:widget-block>
 
              <v:widget-block>
                <table style="width:100%">
                  <tr>
                    <td>
                      &nbsp;<v:itl key="@Installment.FromBlockDate"/><br/>
                      <v:input-text type="datepicker" field="BlockDateFrom"/>
                    </td>
                    <td>&nbsp;</td>
                    <td>
                      &nbsp;<v:itl key="@Common.To"/><br/>
                      <v:input-text type="datepicker" field="BlockDateTo"/>
                    </td>
                  </tr>
                </table>
              </v:widget-block>

              <v:widget-block>
                <v:itl key="@Installment.Payor"/><br/>
                <snp:dyncombo id="AccountId" entityType="<%=LkSNEntityType.Person%>"/>
              </v:widget-block>
            </v:widget>
        
            <v:widget caption="@Common.Status">
              <v:widget-block>
              <% for (LookupItem status : LkSN.InstallmentContractStatus.getItems()) { %>
                <v:db-checkbox field="InstallmentContractStatus" caption="<%=status.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(status.getCode())%>" checked="<%=JvArray.contains(status.getCode(), defaultStatusFilter)%>" /><br/>
              <% } %>
              </v:widget-block>
            </v:widget>
          </div>
        </div>
        
      </div>
      
      <div class="profile-cont-div">
        <% String params = "CreateDateFrom=" + defaultCreateFromToDate + "&CreateDateTo=" + defaultCreateFromToDate + "&MultiPage=true" + "&InstallmentContractStatus=" + JvArray.arrayToString(defaultStatusFilter, ",");%>
        <v:async-grid id="instcontr-grid" jsp="installment/contract_grid.jsp" params="<%=params%>"/>
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>


 
<jsp:include page="/resources/common/footer.jsp"/>
