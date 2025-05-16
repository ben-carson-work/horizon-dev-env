<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_Notify" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<div class="tab-toolbar">

  <v:button caption="@Common.Search" fa="search" onclick="javascript:search()"/>
  <span class="divider"></span>

  <div class="btn-group">
    <div class="btn-group">
      <v:button caption="@Common.New" fa="plus" dropdown="true" bindGrid="notifyrule-grid" bindGridEmpty="true"/>
      <v:popup-menu bootstrap="true">
        <% for (LookupItem notifyRuleType : LkSNNotifyRuleType.getVisibleRuleTypes()) { %>
          <%String href = "asyncDialogEasy('log/notifyrule_dialog', 'id=new&notifyRuleType=" + notifyRuleType.getCode() + "')"; %>
          <v:popup-item caption="<%=notifyRuleType.getRawDescription()%>" onclick="<%=href %>"/>
        <% } %>
      </v:popup-menu>
    </div>
    <v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" onclick="doDeleteNotifyRules()" bindGrid="notifyrule-grid"/>
  </div>
  
  <span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.NotifyRule.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
</div>
<div class="tab-content">
  <div id="main-container">
    <div class="profile-pic-div">
      <div class="form-toolbar">
        <input type="text" id="FullText" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" onkeypress="searchKeyPress()"/>
      </div>
      <v:widget caption="@Common.Type">
        <v:widget-block>
          <% for (LookupItem item : LkSNNotifyRuleType.getVisibleRuleTypes()) { %>
            <label><input type="checkbox" name="NotifyRuleType" value="<%=item.getCode()%>"/> <%=item.getDescription(pageBase.getLang())%></label><br/>
          <% } %>
        </v:widget-block>
      </v:widget>
    </div>
    
    <div class="profile-cont-div">
      <v:async-grid id="notifyrule-grid" jsp="log/notify_grid.jsp" />
    </div>
  </div>
</div>

<script>
function doDeleteNotifyRules() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteNotifyRules",
      DeleteNotifyRules: {
        NotifyRuleIDs: $("[name='NotifyRuleId']").getCheckedValues()
      }
    };
    
    vgsService("Notify", reqDO, false, function(ansDO) {
      changeGridPage("#notifyrule-grid", 1);
    });
  });
}

function search() {
  setGridUrlParam("#notifyrule-grid", "FullText", $("#FullText").val());
  setGridUrlParam("#notifyrule-grid", "NotifyRuleType", $("[name='NotifyRuleType']").getCheckedValues());
  changeGridPage("#notifyrule-grid", 1);
}

function searchKeyPress() {
  if (event.keyCode == KEY_ENTER) {
    search();
    event.preventDefault(); 
  }
} 
</script>