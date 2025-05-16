<%@page import="com.vgs.snapp.dataobject.DOEmailConfig"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<%@ taglib uri="snp-tags" prefix="snp"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_Notify" scope="request"/>

<script>
$(document).ready(function() {
  
  $("#btn-search").click(function() {
    setGridUrlParam("#notification-grid", "FromDateTime", $("#FromDateTime-picker").getXMLDateTime());
    setGridUrlParam("#notification-grid", "ToDateTime", $("#ToDateTime-picker").getXMLDateTime(true));
    setGridUrlParam("#notification-grid", "LocationId", $("#LocationId").val());
    setGridUrlParam("#notification-grid", "OpAreaId", $("#OpAreaId").val());
    setGridUrlParam("#notification-grid", "WorkstationId", $("#WorkstationId").val());
    changeGridPage("#notification-grid", "first");
  });

});
</script>

<v:tab-toolbar>
  <v:button caption="@Common.Search" fa="search" id="btn-search"/>
  <v:pagebox gridId="notification-grid"/>
</v:tab-toolbar>

<v:tab-content>
  <div class="profile-pic-div">
    <v:widget caption="@Common.DateRange">
      <v:widget-block>
        <v:itl key="@Common.From" />
        <br />
        <v:input-text type="datetimepicker" field="FromDateTime"
          style="width:120px" />
        <br />
        <v:itl key="@Common.To" />
        <br />
        <v:input-text type="datetimepicker" field="ToDateTime"
          style="width:120px" />
      </v:widget-block>
    </v:widget>
    <v:widget caption="@Common.Workstation">
      <v:widget-block>
        <v:itl key="@Account.Location"/><br/>
        <snp:dyncombo auditLocationFilter="true" id="LocationId" entityType="<%=LkSNEntityType.Location%>"/>
        
        <div class="filter-divider"></div>
        
        <v:itl key="@Account.OpArea"/><br/>
        <snp:dyncombo auditLocationFilter="true" id="OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" parentComboId="LocationId"/>
        
        <div class="filter-divider"></div>
        
        <v:itl key="@Common.Workstation"/><br/>
        <snp:dyncombo auditLocationFilter="true" id="WorkstationId" entityType="<%=LkSNEntityType.Workstation%>" parentComboId="OpAreaId"/>
      </v:widget-block>
    </v:widget>
  </div>
  
  <div class="profile-cont-div">
    <v:async-grid id="notification-grid" jsp="log/notify_log_grid.jsp" />
  </div>
</v:tab-content>