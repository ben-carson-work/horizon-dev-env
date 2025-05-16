<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageRoleList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% boolean canCreate = rights.SettingsSecurityRoles.canCreate(); %>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <v:tab-toolbar>
      <v:button id="btn-search" caption="@Common.Search" fa="search"/>
      <span class="divider"></span>

      <v:button-group>
        <v:button-group>
          <v:button caption="@Common.New" title="@Common.NewSecurityRole" fa="plus" dropdown="true" enabled="<%=canCreate%>"/>
          <% if (canCreate) { %>
            <v:popup-menu bootstrap="true">
              <v:popup-item caption="@Lookup.RoleType.Operator" href="javascript:asyncDialogEasy('account/role_dialog', 'id=new&Type=0')" />
              <v:popup-item caption="@Lookup.RoleType.B2BAgent" href="javascript:asyncDialogEasy('account/role_dialog', 'id=new&Type=1')" />
            </v:popup-menu>
          <% } %>
        </v:button-group>  
  
        <v:button id="btn-role-delete" caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" enabled="<%=rights.SettingsSecurityRoles.canDelete()%>"/>
      </v:button-group>
      
      <span class="divider"></span>
      <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.Role.getCode() + ")";%>
      <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
      <span class="divider"></span>
      <v:button id="btn-import-role" caption="@Common.Import" fa="sign-in" enabled="<%=canCreate%>"/>
      <v:pagebox gridId="role-grid"/>
    </v:tab-toolbar>
    
    <v:tab-content>
      <v:profile-recap>
        <v:widget>
          <v:widget-block>
            <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Common.Status">
          <v:widget-block>
            <div><v:db-checkbox field="cbFilterActive" value="true" caption="@Common.Active" checked="true"/></div>
            <div><v:db-checkbox field="cbFilterInactive" value="true" caption="@Common.Inactive"/></div>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Common.Type">
          <v:widget-block>
            <v:lk-checkbox field="RoleType" lookup="<%=LkSN.RoleType%>"/>
          </v:widget-block>
        </v:widget>
      </v:profile-recap>
      
      <v:profile-main>
        <v:async-grid id="role-grid" jsp="account/role_grid.jsp" params="IncludeActive=true"/>
      </v:profile-main>
    </v:tab-content>
  </v:tab-item-embedded>
</v:tab-group>

<script>
$(document).ready(function() {
  $("#btn-search").click(search);
  $("#btn-import-role").click(showImportDialog);
  $("#full-text-search").keypress(function(e) {
    if (e.keyCode == KEY_ENTER) {
      search();
      return false;
    }
  });

  $("#btn-role-delete").click(function() {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteRole",
        DeleteRole: {
          RoleIDs: $("[name='RoleId']").getCheckedValues()
        }
      };
      
      vgsService("Account", reqDO, null, function() {
        triggerEntityChange(<%=LkSNEntityType.Role.getCode()%>);
      });
    });
  });

  function search() {
    setGridUrlParam("#role-grid", "FullText", $("#full-text-search").val());
    setGridUrlParam("#role-grid", "IncludeActive", $("#cbFilterActive").isChecked());
    setGridUrlParam("#role-grid", "IncludeInactive", $("#cbFilterInactive").isChecked());
    setGridUrlParam("#role-grid", "RoleType", $("[name='RoleType']").getCheckedValues(), true);
  }

  function showImportDialog() {
    vgsImportDialog("<v:config key="site_url"/>/admin?page=role_list&action=import");
  }
});
</script>
 
<jsp:include page="/resources/common/footer.jsp"/>
