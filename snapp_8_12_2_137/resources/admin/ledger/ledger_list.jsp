<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageLedgerList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>


<%
String defaultFromToDate = pageBase.getBrowserFiscalDate().getXMLDate();
pageBase.setDefaultParameter("FromDate", defaultFromToDate);
pageBase.setDefaultParameter("ToDate", defaultFromToDate);

QueryDef qdef = new QueryDef(QryBO_LedgerAccount.class);
// Select
qdef.addSelect(QryBO_LedgerAccount.Sel.LedgerAccountId);
qdef.addSelect(QryBO_LedgerAccount.Sel.LedgerAccountCode);
qdef.addSelect(QryBO_LedgerAccount.Sel.LedgerAccountName);
// Sort
qdef.addSort(QryBO_LedgerAccount.Sel.LedgerAccountCode);
// Exec
JvDataSet dsLedgerAccount = pageBase.execQuery(qdef);
%>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>


<script>

function search() {
  var groupEntityCode = $("#GroupEntityCode").val();
  var dateFrom = $("#FromDate-picker").datepicker("getDate");
  var dateTo = $("#ToDate-picker").datepicker("getDate");

  if (groupEntityCode!="" || checkMaxDateRange(dateFrom, dateTo, <%=rights.SearchesMaxDateRange.getInt()%>)) {
    setGridUrlParam("#ledger-grid", "GroupEntityCode", groupEntityCode);
    setGridUrlParam("#ledger-grid", "ApplyAllCondition", $("#ApplyAllCondition").isChecked());
    setGridUrlParam("#ledger-grid", "FromFiscalDate", $("#FromDate-picker").getXMLDate());
    setGridUrlParam("#ledger-grid", "ToFiscalDate", $("#ToDate-picker").getXMLDate());
    setGridUrlParam("#ledger-grid", "TriggerType", $("#TriggerType").val());
    setGridUrlParam("#ledger-grid", "LocationAccountId", $("#LocationAccountId").val());
    setGridUrlParam("#ledger-grid", "LedgerAccountId", $("#LedgerAccountId").val(), true);
  }
}

function searchOnEnterKey() {
  if (event.keyCode == KEY_ENTER) {
    search();
    return false;
  }
}
</script>

<%  boolean canLedgerManualEntry = rights.LedgerManualEntry.isLookup(LkSNRightLedgerManualEntry.OnlyGoodTickets, LkSNRightLedgerManualEntry.AllTickets); %>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
      <span class="divider"></span>
  
      <v:button caption="@Ledger.ManualEntry" fa="pencil" href="javascript:asyncDialogEasy('ledger/ledgermanual_dialog')" enabled="<%=canLedgerManualEntry%>"/>

<%--  Deprecated function #8657 --%>     
<%--  <v:button caption="@Ledger.Regenerate" fa="sync-alt" href="javascript:showRegenerateDlg()" enabled="<%=rights.LedgerRegenerate.getBoolean()%>"/> --%>
      
      <v:pagebox gridId="ledger-grid"/>
    </div>

    <div class="tab-content">
      <div class="profile-pic-div">
        <div class="v-filter-container">
          <v:widget>
            <v:widget-block>
              <div class="filter-label"><v:itl key="@Ledger.Referral"/></div>
              <input type="text" id="GroupEntityCode" class="form-control default-focus v-filter-code" placeholder="<v:itl key="T:0000.0.000000.0 or P:0000.0.000000.0"/>" onkeypress="searchOnEnterKey()"/>
              
              <div class="v-filter-applyall"><v:db-checkbox field="ApplyAllCondition" value="true" caption="@Common.FilterApplyAllConditions"/></div>
            </v:widget-block>
          </v:widget>
          
          <div class="v-filter-all-condition">
            <v:widget caption="@Common.Filters">
              <v:widget-block>
                <table style="width:100%">
                  <tr>
                    <td>
                      <div class="filter-label"><v:itl key="@Common.From"/></div>
                      <v:input-text type="datepicker" field="FromDate"/>
                    </td>
                    <td>&nbsp;</td>
                    <td>
                      <div class="filter-label"><v:itl key="@Common.To"/></div>
                      <v:input-text type="datepicker" field="ToDate"/>
                    </td>
                  </tr>
                </table>
              </v:widget-block>
              <v:widget-block>
                <div class="filter-label"><v:itl key="@Ledger.LedgerAccount"/></div>
                <v:combobox lookupDataSet="<%=dsLedgerAccount%>" field="LedgerAccountId" idFieldName="LedgerAccountId" captionFieldName="LedgerAccountName" codeFieldName="LedgerAccountCode" allowNull="true"/>
                <div class="filter-label"><v:itl key="@Account.Location"/></div>
                <v:combobox field="LocationAccountId" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS(true)%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
              </v:widget-block>
            </v:widget>
            <v:widget caption="@Ledger.TriggerType">
              <v:widget-block>
                <v:lk-combobox field="TriggerType" lookup="<%=LkSN.LedgerType%>"/>
              </v:widget-block>
            </v:widget>
          </div>
        </div>
      </div>
      
      <div class="profile-cont-div">
        <% String params = "FromFiscalDate=" + defaultFromToDate + "&ToFiscalDate=" + defaultFromToDate; %>
        <v:async-grid id="ledger-grid" jsp="ledger/ledger_grid.jsp" params="<%=params%>" />
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>

<div id="regenerate-dlg" class="v-hidden"><span class="ui-helper-hidden-accessible"><input type="text"/></span>
  <v:widget caption="@Common.Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
    <v:widget-block>
      <v:form-field caption="@Common.FromDate"><v:input-text type="datepicker" field="RegenerateFromDate"/></v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox field="RunNowCheckBox" caption="@Common.RunNow" value="true" checked="true"/>
      <v:form-field id="schedule-date-row" caption="@Common.Date"><v:input-text type="datepicker" field="ScheduleDate"/></v:form-field>
      <v:form-field id="schedule-time-row" caption="@Common.Time"><v:input-text type="timepicker" field="ScheduleTime"/></v:form-field>
      <v:form-field id="schedule-email-row" caption="@Common.EmailAddress"><v:input-text field="ReportEmailAddress"/></v:form-field>
    </v:widget-block>
  </v:widget>
</div>

<script>

/* Deprecated function #8657
function showRegenerateDlg() {
  var dlg = $("#regenerate-dlg");
  dlg.dialog({
    title: <v:itl key="@Ledger.Regenerate" encode="JS"/>,
    modal: true,
    width: 500,
    buttons: {
      <v:itl key="@Common.Ok" encode="JS"/>: function() {
        var reqDO = {
          Command: "RegenerateLedger",
          RegenerateLedger: {
            FromDate: $("#RegenerateFromDate-picker").getXMLDate(),
            
//            ToDate: $("#RegenerateToDate-picker").getXMLDate(),
            ProductTag: $("#ProductTag").val(),
//
            ScheduleDateTime: $("#RunNowCheckBox").isChecked() ? null : $("#ScheduleDate-picker").getXMLDate() + "T" + $("#ScheduleTime").getXMLTime(),
            ReportEmailAddress: $("#ReportEmailAddress").val()
          }
        };
        
        vgsService("Ledger", reqDO, false, function(ansDO) {
          dlg.dialog("close");
          if ($("#RunNowCheckBox").isChecked())
            showAsyncProcessDialog(ansDO.Answer.RegenerateLedger.AsyncProcessId, null, true);
          else
            showMessage("Process scheduled");
        });
      },
      <v:itl key="@Common.Cancel" encode="JS"/>: function() {
        dlg.dialog("close");
      }
    }
  });
  refreshRunNowRows();
}
*/

function refreshRunNowRows() {
  var runnow = $("#RunNowCheckBox").isChecked();
  $("#schedule-date-row").setClass("v-hidden", runnow);
  $("#schedule-time-row").setClass("v-hidden", runnow);
  $("#schedule-email-row").setClass("v-hidden", runnow);
}

$("#RunNowCheckBox").click(refreshRunNowRows);

</script>
 
<jsp:include page="/resources/common/footer.jsp"/>
