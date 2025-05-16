<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageLedgerAccountList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
boolean canEdit = rights.SettingsLedgerAccounts.canUpdate(); 
String chartOfAccountId = SnappUtils.encodeLookupPseudoId(LkSN.EntityType, LkSNEntityType.LedgerAccount);

JvDateTime fiscalDate = pageBase.getBrowserFiscalDate();
String defaultFromDate = JvDateTime.encodeDate(fiscalDate.getYear(), 1, 1).getXMLDate();
String defaultToDate = fiscalDate.getXMLDate();
List<LookupItem> defaultStatusFilter = LookupManager.getArray(LkSNLedgerAccountStatus.Active);

pageBase.setDefaultParameter("FromDate", defaultFromDate);
pageBase.setDefaultParameter("ToDate", defaultToDate);
%>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<script>

function search() {
  setGridUrlParam("#ledgeraccount-grid", "FromDate", $("#FromDate-picker").getXMLDate());
  setGridUrlParam("#ledgeraccount-grid", "ToDate", $("#ToDate-picker").getXMLDate());
  setGridUrlParam("#ledgeraccount-grid", "LedgerAccountStatus", $("[name='Status']").getCheckedValues(), true);
}

<% if (canEdit) { %>
function doDelLedgerAccounts() {
    var ids = $("[name='LedgerAccountId']").getCheckedValues();
    if (ids) {
      confirmDialog(null, function() {
        var reqDO = {
          Command: "DeleteLedgerAccount",
          DeleteLedgerAccount: {
            LedgerAccountIDs: ids
          }
        };
        
        vgsService("Ledger", reqDO, false, function(ansDO) {
          changeGridPage("#ledgeraccount-grid", 1);
        });
      });
    }
  }
<% } %> 

</script>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Dashboard" default="true">
    <v:tab-toolbar>
      <v:button caption="@Common.Search" fa="search" onclick="search()" />

      <v:button-group>
        <v:button caption="@Ledger.Regenerate" title="@Ledger.RegenerateHint" fa="sigma" href="javascript:asyncDialogEasy('ledger/ledger_regenerate_dialog')"/>
        <snp:btn-report docContext="<%=LkSNContextType.Dashboard_COA%>"/>
      </v:button-group>
      
      <% if (canEdit) { %>
        <span class="divider"></span>
        
        <v:button-group>
          <% String hrefNew = "javascript:asyncDialogEasy('ledger/ledgeraccount_dialog', 'id=new')"; %>
          <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>" enabled="<%=canEdit%>"/>
          <% String hrefDel = "javascript:doDelLedgerAccounts()"; %>
          <v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" href="<%=hrefDel%>" enabled="<%=canEdit%>"/>
        </v:button-group>
        
        <span class="divider"></span>
        <% if (pageBase.isVgsContext("BKO")) { %>
            <v:button caption="@Common.Import" fa="sign-in" href="javascript:asyncDialogEasy('ledger/ledgeraccount_import_dialog')" enabled="<%=canEdit%>"/>
        <% } %>
      <% } %>
      <span class="divider"></span>
      <% String hRef="javascript:asyncDialogEasy('common/history_detail_dialog', 'id="+ chartOfAccountId +"')";%>
      <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/> 
      
      <v:pagebox gridId="ledgeraccount-grid"/>   
    </v:tab-toolbar>
    
    <v:tab-content>
      <v:profile-recap>
        <v:widget caption="@Common.DateRange">
          <v:widget-block>
            <table style="width:100%">
              <tr>
                <td>
                  &nbsp;<v:itl key="@Common.From"/><br/>
                  <v:input-text type="datepicker" field="FromDate"/>
                </td>
                <td>&nbsp;</td>
                <td>
                  &nbsp;<v:itl key="@Common.To"/><br/>
                  <v:input-text type="datepicker" field="ToDate"/>
                </td>
              </tr>
            </table>
          </v:widget-block>
        </v:widget>

        <v:widget caption="@Common.Status">
          <v:widget-block>
            <v:lk-checkbox field="Status" lookup="<%=LkSN.LedgerAccountStatus%>" defaultValue="<%=defaultStatusFilter%>"/>
          </v:widget-block>
        </v:widget>
      </v:profile-recap>
      
      <v:profile-main>
        <% String params = "FromDate=" + defaultFromDate + "&ToDate=" + defaultToDate + "&LedgerAccountStatus=" + JvArray.arrayToString(LookupManager.getIntArray(defaultStatusFilter), ","); %>
        <v:async-grid id="ledgeraccount-grid" jsp="ledger/ledgeraccount_grid.jsp" params="<%=params%>"/>
      </v:profile-main>
    </v:tab-content>
  </v:tab-item-embedded>
</v:tab-group>
 
<jsp:include page="/resources/common/footer.jsp"/>
