<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageXPICrossPlatformList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
boolean canCreate = rights.SystemSetupCrossPlatform.canCreate(); 
boolean canDelete = rights.SystemSetupCrossPlatform.canDelete(); 
int[] defaultStatusFilter = LookupManager.getIntArray(LkSNCrossPlatformStatus.HandshakeRequested, LkSNCrossPlatformStatus.Enabled);
%>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:last-error/>

<script>
  function search() {
    setGridUrlParam("#xpi-crossplatform-grid", "CrossPlatformStatus", $("[name='CrossPlatformStatus']").getCheckedValues());
    setGridUrlParam("#xpi-crossplatform-grid", "CrossPlatformType", $("[name='CrossPlatformType']").getCheckedValues());
    setGridUrlParam("#xpi-crossplatform-grid", "FullText", $("#full-text-search").val(), true);
  }
</script>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" onclick="search()"/>
      <span class="divider"></span>
      <div class="btn-group">
        <% String hrefNew = pageBase.getContextURL() + "?page=account&id=new&EntityType=" + LkSNEntityType.CrossPlatform.getCode(); %>
        <v:button caption="@Common.New" fa="plus" bindGrid="xpi-crossplatform-grid" bindGridEmpty="true" href="<%=hrefNew%>" enabled="<%=canCreate%>"/>
        <v:button caption="@Common.Delete" fa="trash" bindGrid="xpi-crossplatform-grid" title="@Common.DeleteSelectedItems" onclick="doDeleteCrossPlatform()" enabled="<%=canDelete%>"/>
      </div> 
      <span class="divider"></span>
      <% String clickHistory = "showHistoryLog(" + LkSNEntityType.CrossPlatform.getCode() + ")";%>
      <v:button caption="@Common.History" fa="history" onclick="<%=clickHistory%>" enabled="<%=rights.History.getBoolean()%>"/> 
      <v:pagebox gridId="xpi-crossplatform-grid"/>
    </div>
    
    <div class="tab-content">
      <div class="profile-pic-div"> 
        <div class="form-toolbar">
          <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" style="width:97%" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
          <script>
            $("#full-text-search").keypress(function(e) {
              if (e.keyCode == KEY_ENTER) {
                search();
                return false;
              }
            });
          </script>
        </div>
        
        <v:widget caption="@Common.Type">
          <v:widget-block>
          <% for (LookupItem item : LkSN.CrossPlatformType.getItems()) { %>
            <label class="checkbox-label"><input type="checkbox" name="CrossPlatformType" value="<%=item.getCode()%>"/>&nbsp;<%=item.getHtmlDescription(pageBase.getLang())%></label><br/>
          <% } %>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Common.Status">
          <v:widget-block>
          <% for (LookupItem item : LkSN.CrossPlatformStatus.getItems()) { %>
            <% if (!item.isDeprecated()) { %>
              <v:db-checkbox field="CrossPlatformStatus" caption="<%=item.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(item.getCode())%>" legendColor="<%=LkSNCrossPlatformStatus.getStatusColor(item)%>" checked="<%=JvArray.contains(item.getCode(), defaultStatusFilter)%>" /><br/>
            <% } %>
          <% } %>
          </v:widget-block>
        </v:widget>
      </div>
      
      <div class="profile-cont-div">
        <% String params = "CrossPlatformStatus=" + JvArray.arrayToString(defaultStatusFilter, ","); %>
        <v:async-grid id="xpi-crossplatform-grid" jsp="xpi/xpi_crossplatform_grid.jsp" params="<%=params%>"/>
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<script>
function doDeleteCrossPlatform() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteAccount",
      DeleteAccount: {
        AccountIDs: $("[name='CrossPlatformId']").getCheckedValues(),
        AccountDeleteType: <%=LkSNAccountDeleteType.Skip.getCode()%>
      }
    };
    
    showWaitGlass();
    vgsService("Account", reqDO, false, function(ansDO) {
      hideWaitGlass();
      showAsyncProcessDialog(ansDO.Answer.DeleteAccount.AsyncProcessId);
    });
  });
}
</script>

<jsp:include page="/resources/common/footer.jsp"/>
