<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% int[] entityTypes = {LkSNEntityType.OrganizationAccount.getCode()}; %>

<v:page-form>

<v:tab-toolbar>
  <v:button caption="@Common.Search" fa="search" id="btn-search"/>
  
  <v:button-group>
    <v:button-group>
      <v:button caption="@Common.New" title="@Account.NewAccountHint" fa="plus" id="new-account-btn" dropdown="true" enabled="<%=rights.AccountORGs.getOverallCRUD().canCreate() || rights.AccountPRSs.getOverallCRUD().canCreate()%>"/>
  		<v:popup-menu bootstrap="true">
  		  <% String hrefNew = ConfigTag.getValue("site_url") + "/admin?page=account&id=new&ParentAccountId=" + pageBase.getId() + "&EntityType="; %>
  		  <% if (rights.AccountORGs.getOverallCRUD().canCreate()) { %>
  		    <% String hrefNewOrganization = hrefNew + LkSNEntityType.Organization.getCode(); %>
  		    <v:popup-item caption="@Account.NewOrganization" icon="account_org.png" href="<%=hrefNewOrganization%>"/>
  		  <% } %>
  		  <% if (rights.AccountPRSs.getOverallCRUD().canCreate()) { %>
  		    <% String hrefNewPerson = hrefNew + LkSNEntityType.Person.getCode(); %>
  		    <v:popup-item caption="@Account.NewPerson" icon="account_prs.png" href="<%=hrefNewPerson%>"/>
  		  <% } %>
  		</v:popup-menu>
    </v:button-group>
    
    <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" href="javascript:showAccountDeleteDialog()" enabled="<%=rights.AccountORGs.getOverallCRUD().canDelete() || rights.AccountPRSs.getOverallCRUD().canDelete()%>"/>
  </v:button-group>
  
  <v:pagebox gridId="account-grid"/>
</v:tab-toolbar>

<v:tab-content>
  <v:profile-recap>
    <v:widget caption="@Common.Filters">
      <v:widget-block>
        <v:input-text field="txtFullText" placeholder="@Common.FullSearch"/>
      </v:widget-block>
      <v:widget-block>
        <v:db-checkbox field="cbUsersOnly" caption="@Account.UsersOnly" value="true"/>
      </v:widget-block>
    </v:widget>
  </v:profile-recap>
  
  <v:profile-main>
    <% String params = "ParentAccountId=" + pageBase.getId() + "&EntityType=" + JvArray.arrayToString(entityTypes, ","); %>
    <v:async-grid id="account-grid" jsp="account/account_grid.jsp" params="<%=params%>"/>
  </v:profile-main>
  
</v:tab-content>

</v:page-form>

<script>
$(document).ready(function() {
  $("#btn-search").click(_search);
  $("#txtFullText").keypress(_searchOnEnter);

  function _search() {
    setGridUrlParam("#account-grid", "ParentAccountId", <%=JvString.jsString(pageBase.getId())%>);
    setGridUrlParam("#account-grid", "EntityType", <%=JvArray.arrayToString(entityTypes, ",")%>);
    setGridUrlParam("#account-grid", "FullText", $("#txtFullText").val());
    setGridUrlParam("#account-grid", "HasLogin", $("#cbUsersOnly").isChecked());
    changeGridPage("#account-grid", "first");
  }
  
  function _searchOnEnter() {
    if (event.keyCode == KEY_ENTER) {
      _search();
      return false;
    }
  }
});
</script>
