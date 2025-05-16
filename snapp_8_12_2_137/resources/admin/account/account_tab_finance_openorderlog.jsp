<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>


<v:tab-toolbar>
  <v:button id="btn-search" caption="@Common.Search" fa="search" />
  <v:pagebox gridId="openorderlog-grid-container"/>
</v:tab-toolbar>


<v:tab-content>
  
  <v:profile-recap>
    <v:widget caption="@Common.DateRange">
      <v:widget-block>
        <label for="FromDate"><v:itl key="@Common.From"/></label><br/>
        <v:input-text type="datepicker" field="FromDate"/>
                
        <div class="filter-divider"></div>
                
        <label for="ToDate"><v:itl key="@Common.To"/></label><br/>
        <v:input-text type="datepicker" field="ToDate"/>
      </v:widget-block>
    </v:widget>
  </v:profile-recap>

  <v:profile-main>
    <% String params = "AccountId=" + pageBase.getId(); %>
    <v:async-grid id="openorderlog-grid-container" jsp="account/account_openorderlog_grid.jsp" params="<%=params%>" />
  </v:profile-main>

</v:tab-content>

<script>
$(document).ready(function() {
  $("#btn-search").click(search);
  
  function search() {
    setGridUrlParam("#openorderlog-grid-container", "FromDate", $("#FromDate-picker").getXMLDate(), false);
    setGridUrlParam("#openorderlog-grid-container", "ToDate", $("#ToDate-picker").getXMLDate(), true);
  }
});

</script>

