<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
boolean canEdit = rights.SettingsSecurityRoles.canUpdate();
BLBO_Role bl = pageBase.getBL(BLBO_Role.class);
DORole role = pageBase.isNewItem() ? bl.prepareNewRole(LkSN.RoleType.getItemByCode(pageBase.getParameter("Type"), LkSNRoleType.Operator)) : bl.loadRole(pageBase.getId());
String title = pageBase.isNewItem() ? pageBase.getLang().Common.SecurityRole.getText() : role.RoleName.getString();
title += " - " + role.RoleType.getHtmlLookupDesc(pageBase.getLang());
request.setAttribute("role", role);
%>

<v:dialog id="role_dialog" icon="role.png" tabsView="true" title="<%=title%>" width="900" height="700" autofocus="false">

<input type="hidden" id="role.RoleType" name="role.RoleType" value="<%=role.RoleType.getInt()%>"/>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="role-tab-profile" caption="@Common.Profile" default="true">
    <v:tab-toolbar include="<%=!pageBase.isNewItem()%>">
      <% String filter = "right"; 
         if (role.RoleType.isLookup(LkSNRoleType.B2BAgent))
           filter = "rightB2B"; %>
      <% String clickRight = "asyncDialogEasy('right/rights_dialog', 'Filter=" + filter + "&EntityType=" + LkSNEntityType.Role.getCode() + "&EntityId=" + role.RoleId.getHtmlString() + "&ReadOnly=" + !canEdit + "')"; %>
      <v:button caption="@Common.Rights" fa="key" onclick="<%=clickRight%>"/>
      <v:button id="btn-duplicate" caption="@Common.Duplicate" fa="clone"/>
      <% String hrefExport = ConfigTag.getValue("site_url") + "/admin?page=role_list&action=export&id=" + pageBase.getId(); %>
      <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" href="<%=hrefExport%>"/>
      <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Role%>" disableTriggerNotification="true" showBtnIfNoteEmpty="true"/>
    </v:tab-toolbar>
    
    <v:tab-content>
      <v:widget caption="@Common.General">
        <v:widget-block>
          <v:form-field caption="@Common.Code" mandatory="true">
            <v:input-text field="role.RoleCode" clazz="default-focus" enabled="<%=canEdit%>"/>
          </v:form-field>
          <v:form-field caption="@Common.Name" mandatory="true">
            <v:input-text field="role.RoleName" enabled="<%=canEdit%>"/>
          </v:form-field>
        </v:widget-block>
        
        <v:widget-block>
          <div><v:db-checkbox field="role.Active" caption="@Common.Active" value="true" enabled="<%=canEdit%>"/></div>
          <div><v:db-checkbox field="role.PreventInactiveUserBlock" caption="@Account.PreventInactiveUserBlock" hint="@Account.PreventInactiveUserBlockHint" value="true" enabled="<%=canEdit%>"/></div>
        </v:widget-block>
      </v:widget>
    </v:tab-content>
  </v:tab-item-embedded>
  
  <% if (!pageBase.isNewItem() && rights.History.getBoolean()) { %>
    <v:tab-item-embedded tab="tabs-history" caption="@Common.History">
      <jsp:include page="../common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>
  <% } %>
  
</v:tab-group>


<script>

$(document).ready(function() {
  $("#role_dialog .tabs").tabs();
  
  var dlg = $("#role_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      <% if (canEdit) { %>
        dialogButton("@Common.Save", _saveRole),
      <% } %>
      dialogButton("@Common.Cancel", doCloseDialog)
    ];
  });
  
  dlg.find("#btn-duplicate").click(_duplicate);

  function _saveRole() {
    checkRequired("#role_dialog", function() {
      snpAPI.cmd("Account", "SaveRole", {
        Role: {
          RoleId                  : <%=role.RoleId.isNull() ? "null" : "\"" + role.RoleId.getHtmlString() + "\""%>,
          RoleCode                : $("#role\\.RoleCode").val(),
          RoleName                : $("#role\\.RoleName").val(),
          RoleType                : $("#role\\.RoleType").val(),
          Active                  : $("#role\\.Active").isChecked(),
          PreventInactiveUserBlock: $("#role\\.PreventInactiveUserBlock").isChecked()
        }
      })
      .then(ansDO => {
        triggerEntityChange(<%=LkSNEntityType.Role.getCode()%>);
        dlg.dialog("close");
      });
    });
  }
  
  function _duplicate() {
    confirmDialog(null, function() {
      snpAPI.cmd("Account", "DuplicateRole", {
        RoleId: <%=role.RoleId.getJsString()%>
      })
      .then(ansDO => {
        var newRoleId = ansDO.NewRole.RoleId;

        triggerEntityChange(<%=LkSNEntityType.Role.getCode()%>);
        dlg.dialog("close");
        
        openEntityLink(<%=LkSNEntityType.Role.getCode()%>, newRoleId);
      });
    });
  }
});

</script>

</v:dialog>