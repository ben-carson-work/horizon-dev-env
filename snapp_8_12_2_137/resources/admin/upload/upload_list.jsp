<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageUploadList" scope="request"/>
<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<v:last-error/>

<script>

function search() {
  setGridUrlParam("#upload-grid", "FromDateTime", $("#FromDateTime-picker").getXMLDateTime());
  setGridUrlParam("#upload-grid", "ToDateTime", $("#ToDateTime-picker").getXMLDateTime(true));
  setGridUrlParam("#upload-grid", "UploadStatus", $("[name='UploadStatus']").getCheckedValues());
  setGridUrlParam("#upload-grid", "UploadType", $("[name='UploadType']").getCheckedValues());
  setGridUrlParam("#upload-grid", "WorkstationId", $("#WorkstationId").val());
  changeGridPage("#upload-grid", "first");
}

</script>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
      <v:pagebox gridId="upload-grid" />
    </div>
  
    <div class="tab-content">
      <div class="profile-pic-div">
        <v:widget caption="@Common.DateRange"><v:widget-block>
          <label for="FromDateTime"><v:itl key="@Common.From"/></label><br/>
          <v:input-text type="datetimepicker" field="FromDateTime" style="width:120px"/>
            
          <div class="filter-divider"></div>
            
          <label for="ToDateTime"><v:itl key="@Common.To"/></label><br/>
          <v:input-text type="datetimepicker" field="ToDateTime" style="width:120px"/>
        </v:widget-block></v:widget>
    
        <v:widget caption="@Common.Status"><v:widget-block>
        <% for (LookupItem item : LkSN.UploadStatus.getItems()) { %>
          <label><input type="checkbox" name="UploadStatus" value="<%=item.getCode()%>"/> <%=item.getDescription(pageBase.getLang())%></label><br/>
        <% } %>
        </v:widget-block></v:widget>
    
        <v:widget caption="@Common.Type"><v:widget-block>
        <% for (LookupItem item : LkSN.UploadType.getItems()) { %>
          <label><input type="checkbox" name="UploadType" value="<%=item.getCode()%>"/> <%=item.getDescription(pageBase.getLang())%></label><br/>
        <% } %>
        </v:widget-block></v:widget>
    
        <v:widget caption="@Common.Filters"><v:widget-block>
            <v:itl key="@Common.Workstation"/><br/>
            <snp:dyncombo auditLocationFilter="true" id="WorkstationId" entityType="<%=LkSNEntityType.Workstation%>"/>
        </v:widget-block></v:widget>
      </div>
    
      <div class="profile-cont-div">
        <v:async-grid id="upload-grid" jsp="upload/upload_grid.jsp" />
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>
    

<jsp:include page="/resources/common/footer.jsp"/>
