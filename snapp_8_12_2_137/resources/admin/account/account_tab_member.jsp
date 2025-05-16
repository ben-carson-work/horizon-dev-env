<%@page import="com.vgs.web.library.BLBO_Account"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>

<%
int[] defaultMemberStatusFilter = LookupManager.getIntArray(LkSNAccountStatus.Active, LkSNAccountStatus.Blocked);
boolean canEdit = pageBase.getBL(BLBO_Account.class).canEditMember(pageBase.getId());
%>

<v:page-form>

<div class="tab-toolbar">
  <% String hrefNew = ConfigTag.getValue("site_url") + "/admin?page=account&id=new&ParentAccountId=" + pageBase.getId() + "&EntityType="; %>

  <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
  <span class="divider"></span>

  <% String hrefNewMember = hrefNew + LkSNEntityType.AssociationMember.getCode(); %>
  <v:button caption="@Common.New" fa="plus" title="@Account.NewMemberHint" href="<%=hrefNewMember%>" enabled="<%=canEdit%>"/>
  <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" href="javascript:showAccountDeleteDialog()" enabled="<%=canEdit%>"/>
  
  <span class="divider"></span>
  <% String hrefImport = "javascript:asyncDialogEasy('account/account_import_dialog', 'EntityType=" + LkSNEntityType.AssociationMember.getCode() + "&ParentAccountId=" + pageBase.getId() + "')"; %>
  
  <v:button caption="@Common.Import" fa="sign-in" href="<%=hrefImport%>" enabled="<%=canEdit%>"/>
  
  <v:pagebox gridId="account-grid"/>
</div>
 
<div class="tab-content">
  <div id="main-container">
    <div class="profile-pic-div">
	  <v:widget caption="@Common.Filters">
	    <v:widget-block>
	      <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
	      <script>
	        $("#full-text-search").keypress(function(e) {
	          if (e.keyCode == KEY_ENTER) {
	            search();
	            return false;
	          }
	        });
	      </script>
	    </v:widget-block>
	    <v:widget-block>
          <% for (LookupItem status : LkSN.AccountStatus.getItems()) { %>
            <v:db-checkbox field="AccountStatus" caption="<%=status.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(status.getCode())%>" checked="<%=JvArray.contains(status.getCode(), defaultMemberStatusFilter)%>"/><br/>
          <% } %>
        </v:widget-block>
	  </v:widget>
    </div>
	<v:last-error/>
	
    <% int[] entityTypes = {LkSNEntityType.AssociationMember.getCode()}; %>
    <% String params = "ParentAccountId=" + pageBase.getId() + "&EntityType=" + JvArray.arrayToString(entityTypes, ",") + "&AccountStatus=" + JvArray.arrayToString(defaultMemberStatusFilter, ",");%>
	<div class="profile-cont-div">
	  <v:async-grid id="account-grid" jsp="account/account_grid.jsp" params="<%=params%>"/>
    </div>
  </div>
</div>

</v:page-form>

<script>

  function search() {
    setGridUrlParam("#account-grid", "EntityType", <%=LkSNEntityType.AssociationMember.getCode()%>);
    setGridUrlParam("#account-grid", "FullText", $("#full-text-search").val());
    setGridUrlParam("#account-grid", "ParentAccountId", <%=JvString.jsString(pageBase.getId())%>);
    setGridUrlParam("#account-grid", "AccountStatus", $("[name='AccountStatus']").getCheckedValues(), true);
  }

</script>


