<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>

<script>
function search() {
  setGridUrlParam("#xpi-depositlog-grid-container", "FromDate", $("#FromDate-picker").getXMLDate(), false);
  setGridUrlParam("#xpi-depositlog-grid-container", "ToDate", $("#ToDate-picker").getXMLDate(), true);
}
</script>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" href="javascript:search()" />
  <v:pagebox gridId="xpi-depositlog-grid-container"/>
</div>

<div class="tab-content">
  <v:last-error/>
  
  <div id="main-container">
    <div id="filter-column" class="profile-pic-div">
      <v:widget caption="@Common.DateRange" icon="calendar.png"><v:widget-block>
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
      </v:widget-block></v:widget>
    </div>

    <div class="profile-cont-div">
      <% String params = "CrossPlatformId=" + account.CrossPlatform.CrossPlatformId.getString() + "&CrossPlatformURL=" + account.CrossPlatform.CrossPlatformURL.getString() + "&CrossPlatformRef=" + account.CrossPlatform.CrossPlatformRef.getString(); %>
      <v:async-grid id="xpi-depositlog-grid-container" jsp="account/account_xpi_depositlog_grid.jsp" params="<%=params%>" />
    </div>
  </div>

</div>

