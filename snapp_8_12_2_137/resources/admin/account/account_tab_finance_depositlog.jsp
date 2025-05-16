<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>


<script>

function search() {
  setGridUrlParam("#depositlog-grid-container", "FromDate", $("#FromDate-picker").getXMLDate(), false);
  setGridUrlParam("#depositlog-grid-container", "ToDate", $("#ToDate-picker").getXMLDate(), true);
}

</script>


<v:tab-toolbar>
  <v:button caption="@Common.Search" fa="search" href="javascript:search()" />
  <v:pagebox gridId="depositlog-grid-container"/>
</v:tab-toolbar>


<v:tab-content>
  
  <v:profile-recap id="filter-column">
    <v:widget caption="@Common.DateRange" icon="calendar.png">
      <v:widget-block>
        <table style="width:100%">
          <tr>
            <td>
              &nbsp;<v:itl key="@Common.From"/><br/>
              <v:input-text type="datepicker" field="FromDate" style="width:105px"/>
            </td>
            <td>&nbsp;</td>
            <td>
              &nbsp;<v:itl key="@Common.To"/><br/>
              <v:input-text type="datepicker" field="ToDate" style="width:105px"/>
            </td>
          </tr>
        </table>
      </v:widget-block>
    </v:widget>
  </v:profile-recap>

  <v:profile-main>
    <% String params = "AccountId=" + pageBase.getId(); %>
    <v:async-grid id="depositlog-grid-container" jsp="account/account_depositlog_grid.jsp" params="<%=params%>" />
  </v:profile-main>

</v:tab-content>

