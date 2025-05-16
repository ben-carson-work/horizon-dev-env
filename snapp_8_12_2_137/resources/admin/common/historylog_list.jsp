<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageHistoryLogList" scope="request"/>

<% 
int[] defaultStatusFilter = LookupManager.getIntArray(LkSNHistoryLogType.Create, LkSNHistoryLogType.Update, LkSNHistoryLogType.LastUpdate, LkSNHistoryLogType.Delete); 
%>


<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:last-error/>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" onclick="search()"/>
      <v:pagebox gridId="historylog-grid"/>
    </div>
      
    <div class="tab-content">
      <div class="profile-pic-div">
        <v:widget caption="@Common.DateRange">
          <v:widget-block>
            <v:itl key="@Common.From"/><br/>
            <v:input-text type="datetimepicker" field="FromDateTime" style="width:120px"/>
            <br/>
            <v:itl key="@Common.To"/><br/>
            <v:input-text type="datetimepicker" field="ToDateTime" style="width:120px"/>
          </v:widget-block>
        </v:widget>
    
        <v:widget caption="@Common.Type">
          <v:widget-block>
            <v:lk-combobox field="EntityType" lookup="<%=LkSN.EntityType%>" alphaSort="true"/>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Common.User">
          <v:widget-block>
            <snp:dyncombo field="UserAccountId" entityType="<%=LkSNEntityType.User%>"/>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Common.Workstation">
          <v:widget-block>
            <v:itl key="@Account.Location"/><br/>
            <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>"/>
            
            <div class="filter-divider"></div>
            
            <v:itl key="@Account.OpArea"/><br/>
            <snp:dyncombo id="OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" parentComboId="LocationId"/>
            
            <div class="filter-divider"></div>
            
            <v:itl key="@Common.Workstation"/><br/>
            <snp:dyncombo id="WorkstationId" entityType="<%=LkSNEntityType.Workstation%>" parentComboId="OpAreaId"/>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Common.Status">
          <v:widget-block>
          <% for (LookupItem status : LkSN.HistoryLogType.getItems()) { %>
            <v:db-checkbox field="Status" caption="<%=status.getDescription()%>" value="<%=String.valueOf(status.getCode())%>" checked="<%=JvArray.contains(status.getCode(), defaultStatusFilter)%>" /><br/>
          <% } %>
          </v:widget-block>
        </v:widget>
        
      </div>
      
      <div class="profile-cont-div">
        <% String params = "EntityType=" + pageBase.getEmptyParameter("EntityType"); %>
        <v:async-grid id="historylog-grid" jsp="common/historylog_grid.jsp" params="<%=params%>"/>
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<script>


function search() {
  setGridUrlParam("#historylog-grid", "LocationId", ($("#LocationId").getComboIndex() <= 0) ? "" : $("#LocationId").val());
  setGridUrlParam("#historylog-grid", "OpAreaId", ($("#OpAreaId").getComboIndex() <= 0) ? "" : $("#OpAreaId").val());
  setGridUrlParam("#historylog-grid", "WorkstationId", ($("#WorkstationId").getComboIndex() <= 0) ? "" : $("#WorkstationId").val());
  setGridUrlParam("#historylog-grid", "FromDateTime", $("#FromDateTime-picker").getXMLDateTime());
  setGridUrlParam("#historylog-grid", "ToDateTime", $("#ToDateTime-picker").getXMLDateTime(true));
  setGridUrlParam("#historylog-grid", "EntityType", $("#EntityType").val());
  setGridUrlParam("#historylog-grid", "HistoryLogType", $("[name='Status']").getCheckedValues());
  setGridUrlParam("#historylog-grid", "UserAccountId", $("#UserAccountId").val(), true);
}
 
</script>


<jsp:include page="/resources/common/footer.jsp"/>
