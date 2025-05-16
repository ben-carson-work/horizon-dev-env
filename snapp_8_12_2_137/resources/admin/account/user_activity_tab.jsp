<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
  String defaultFromToDate = pageBase.getBrowserFiscalDate().getXMLDate();
  pageBase.setDefaultParameter("FromDate", defaultFromToDate);
  pageBase.setDefaultParameter("ToDate", defaultFromToDate);
%>


<script>
  function search() {
  	var dateFrom = $("#FromDate-picker").datepicker("getDate");
  	var dateTo = $("#ToDate-picker").datepicker("getDate");
  	
    if (checkMaxDateRange(dateFrom, dateTo, <%=rights.SearchesMaxDateRange.getInt()%>)) {
      setGridUrlParam("#user-activity-grid", "FromDate", $("#FromDate-picker").getXMLDate());
      setGridUrlParam("#user-activity-grid", "ToDate", $("#ToDate-picker").getXMLDate());
      changeGridPage("#user-activity-grid", "first");
    }
  }
</script>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" href="javascript:search()" />

  <v:pagebox gridId="user-activity-grid"/>
</div>

<div id="main-container" class="tab-content">
  <v:last-error/>

  <div class="profile-pic-div">
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
  </div>
  
  <div class="profile-cont-div">
   <%
     String  params = "";
     LookupItem entityType = null;
     if (pageBase.getNullParameter("EntityType") != null)
       entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType"));
     
     if (entityType != null && entityType.isLookup(LkSNEntityType.Person))
      params += "UserAccountId=" + pageBase.getId();
     else if (entityType != null && entityType.isLookup(LkSNEntityType.Workstation))
       params += "WorkstationId=" + pageBase.getId();
    
     params += "&FromDate=" + defaultFromToDate + "&ToDate=" + defaultFromToDate;
    %>
    <v:async-grid id="user-activity-grid" jsp="account/user_activity_grid.jsp" params="<%=params%>" /> 
  </div>
</div>
