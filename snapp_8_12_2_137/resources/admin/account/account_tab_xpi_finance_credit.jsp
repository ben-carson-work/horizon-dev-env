<%@page import="com.vgs.snapp.dataobject.DOCredit"%>
<%@page import="com.vgs.cl.document.FtList"%>
<%@page import="com.vgs.snapp.web.xpi.WsXPI"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>
<% 
int[] defaultStatusFilter = new int[] {LkSNCreditStatus.Opened.getCode(), LkSNCreditStatus.Invoiced.getCode()};

%>


<script>

function search() {
  setGridUrlParam("#xpi-credit-grid-container", "CreditStatus", $("input[name='CreditStatus']:checked").map(function () {return this.value;}).get().join(","), false);
  setGridUrlParam("#xpi-credit-grid-container", "FromDate", $("#FromDate-picker").getXMLDate(), false);
  setGridUrlParam("#xpi-credit-grid-container", "ToDate", $("#ToDate-picker").getXMLDate(), false);
  setGridUrlParam("#xpi-credit-grid-container", "FromDueDate", $("#FromDueDate-picker").getXMLDate(), false);
  setGridUrlParam("#xpi-credit-grid-container", "ToDueDate", $("#ToDueDate-picker").getXMLDate(), false);
  changeGridPage("#xpi-credit-grid-container", "first");
}
</script>


<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" href="javascript:search()" />
  <v:pagebox gridId="xpi-credit-grid-container"/>
</div>

<v:page-form page="account_tab_xpi_finance_credit">

<div class="tab-content">
  <v:last-error/>
  
  <div id="main-container">
    <div id="filter-column" class="profile-pic-div">
      <v:widget caption="@Common.Status"><v:widget-block>
      <% for (LookupItem status : LkSN.CreditStatus.getItems()) { %>
        <v:db-checkbox field="CreditStatus" caption="<%=status.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(status.getCode())%>" checked="<%=JvArray.contains(status.getCode(), defaultStatusFilter)%>" /><br/>
      <% } %>
      </v:widget-block></v:widget>

      <v:widget caption="@Common.DateRange" icon="calendar.png">
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

      <v:widget caption="@Account.Credit.DueDate" icon="calendar.png">
        <v:widget-block>
          <table style="width:100%">
            <tr>
              <td>
                &nbsp;<v:itl key="@Common.From"/><br/>
                <v:input-text type="datepicker" field="FromDueDate"/>
              </td>
              <td>&nbsp;</td>
              <td>
                &nbsp;<v:itl key="@Common.To"/><br/>
                <v:input-text type="datepicker" field="ToDueDate"/>
              </td>
            </tr>
          </table>
        </v:widget-block>
      </v:widget>
    </div>

    <div class="profile-cont-div">
      <% String params = "CrossPlatformId=" + account.CrossPlatform.CrossPlatformId.getString() + "&CrossPlatformURL=" + account.CrossPlatform.CrossPlatformURL.getString() + "&CrossPlatformRef=" + account.CrossPlatform.CrossPlatformRef.getString() + "&CreditStatus=" + JvArray.arrayToString(defaultStatusFilter, ","); %>
      <v:async-grid id="xpi-credit-grid-container" jsp="account/xpi_credit_grid.jsp" params="<%=params%>" />
    </div>
  </div>

</div>

</v:page-form>