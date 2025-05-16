<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccountList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
LookupItem entityType = LkSN.EntityType.findItemByCode(pageBase.getParameter("EntityType"));
if (entityType == null)
  entityType = LkSNEntityType.Organization;

FtCRUD rightLevel = pageBase.getBLDef().getAccountOverallRightCRUD(entityType);

List<DOMetaFieldGroup> mfgList = pageBase.getBL(BLBO_MetaData.class).findSearchMetaFieldGroupsByEntityType(entityType);

boolean importVisible = entityType.isLookup(LkSNEntityType.Organization, LkSNEntityType.Person, LkSNEntityType.AssociationMember);
%>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<v:last-error/>

<input type="hidden" id="EntityType" name="EntityType" value="<%=pageBase.getEmptyParameter("EntityType")%>"/>
<input type="hidden" id="CategoryId" name="CategoryId" value="<%=pageBase.getEmptyParameter("CategoryId")%>"/>

<script>
  var selectedCategoryId = "all";
  function search() {
    setGridUrlParam("#account-grid", "AccountCode", $("#AccountCode").val());
    setGridUrlParam("#account-grid", "EntityType", <%=pageBase.getEntityType().getCode()%>);
    setGridUrlParam("#account-grid", "FullText", $("#full-text-search").val());
    setGridUrlParam("#account-grid", "CategoryId", selectedCategoryId);
    setGridUrlParam("#account-grid", "PlatformType", $("[name='Platform']").getCheckedValues());
    setGridUrlParam("#account-grid", "AccountStatus", $("[name='AccountStatus']").val());
    
    $(".search-metafield-group").each(function(index, elem) {
    	var $input = $(elem);
   		setGridUrlParam("#account-grid", $input.attr("id"), $input.val());
    });
    
    changeGridPage("#account-grid", "first");
  }

  function categorySelected(categoryId) {
    selectedCategoryId = categoryId;
    search();
  }
  
  function searchOnEnter() {
    if (event.keyCode == KEY_ENTER) {
      search();
      return false;
    }
  }
</script>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" onclick="search()"/>
      <span class="divider"></span> 
      
      <div class="btn-group">
        <% String hrefNew = pageBase.getContextURL() + "?page=account&id=new&EntityType=" + pageBase.getEmptyParameter("EntityType"); %>
        <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>" bindGrid="account-grid" bindGridEmpty="true" enabled="<%=rightLevel.canCreate()%>"/>

        <% if (entityType.isLookup(LkSNEntityType.Organization)) { %>
        <% String hrefMultiEdit = "showMultiEditDialog(" + entityType.getCode() + ", '#account-grid', '[name=\\'cbEntityId\\']')"; %>
          <v:button caption="@Common.Edit" fa="pencil" onclick="<%=hrefMultiEdit%>" bindGrid="account-grid" enabled="<%=rightLevel.canUpdate()%>"/>
        <% } %>
        
        <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" onclick="showAccountDeleteDialog()" bindGrid="account-grid" enabled="<%=rightLevel.canDelete()%>"/>
      </div>
      
      <span class="divider"></span>

      
      <% if (pageBase.isVgsContext("BKO") && importVisible) { %>
        <% String clickImport = "asyncDialogEasy('account/account_import_dialog', 'EntityType=" + entityType.getCode() + "')"; %>
        <v:button caption="@Common.Import" fa="sign-in" onclick="<%=clickImport%>" enabled="<%=rightLevel.canCreate()%>"/>
      <% } %>
      
      <% if (rightLevel.canCreate() || rightLevel.canUpdate()) { %>
        <v:copy-paste-buttonset entityType="<%=entityType%>"/>
      <% } %>      
      
      <span class="divider"></span>
      <% String clickHistory="showHistoryLog(" + entityType.getCode() + ")";%>
      <v:button caption="@Common.History" fa="history" onclick="<%=clickHistory%>" enabled="<%=rights.History.getBoolean()%>"/>
      
      <v:pagebox gridId="account-grid"/>
    </div>
    
    <div class="tab-content">
      <div class="profile-pic-div">
        <div class="v-filter-container">
          <% if (entityType.isLookup(LkSNEntityType.Person)) { %>
            <v:widget>
              <v:widget-block>
                <div class="search-code-container">
                  <input type="text" id="AccountCode" class="form-control default-focus v-filter-code" placeholder="<v:itl key="@Common.Code"/>" onkeypress="searchOnEnter()"/>
                  <v:hint-handle hint="@Account.AccountCodeSearchHint"/>
                </div>
              </v:widget-block>
            </v:widget>
          <% } %>        
          
          <div class="v-filter-all-condition">
            <v:widget caption="@Common.Filters">
              <v:widget-block>
                <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" value="<%=pageBase.getEmptyParameter("FullText")%>" onkeypress="searchOnEnter()"/>
              </v:widget-block>
              <% if (entityType.isLookup(LkSNEntityType.Person, LkSNEntityType.Organization, LkSNEntityType.Association, LkSNEntityType.AssociationMember)) { %>
                <% if (entityType.isLookup(LkSNEntityType.Person)) { %>
    	            <v:widget-block>
    	            <% for (LookupItem platform : LkSN.LoginPlatformType.getItems()) { %>
    	              <v:db-checkbox field="Platform" caption="<%=platform.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(platform.getCode())%>"/><br/>
    	            <% } %>
                	</v:widget-block>
                <% } %>
                <v:widget-block>
                  <div><v:itl key="@Common.Status"/> </div>
                  <v:lk-combobox field="AccountStatus" lookup="<%=LkSN.AccountStatus%>" allowNull="false"/>
                </v:widget-block>
              <% } %>
            </v:widget>
            
            <% if (!mfgList.isEmpty()) { %>
	            <v:widget caption="@Common.SearchGroups">
	              <v:widget-block>
	              <% for (DOMetaFieldGroup mfg : mfgList) { %>
	                <% String fieldId = "MFG_" + mfg.MetaFieldGroupId.getString(); %>
	                <div class="filter-divider"></div>
	                <div><%=mfg.MetaFieldGroupName.getHtmlString()%></div>
	                <v:input-text field="<%=fieldId%>" clazz="search-metafield-group" onKeyPress="searchOnEnter()"/>
	              <% } %>  
	              </v:widget-block>
	            </v:widget>  
            <% } %>
            
            <v:widget caption="@Category.Categories" editHRef="<%=pageBase.getCategoryEditLink(entityType)%>">
              <v:widget-block>
                <snp:category-tree-widget entityType="<%=pageBase.getEntityType()%>"/>
              </v:widget-block>
            </v:widget>
          </div>
        </div>
      </div>
      
      <div class="profile-cont-div">
        <%String params = "EntityType=" + entityType.getCode() + "&AccountStatus=" + LkSNAccountStatus.Active.getCode()+ "&Masked=" + !rightLevel.canUpdate();%>
        <v:async-grid id="account-grid" jsp="account/account_grid.jsp" params="<%=params%>"/>
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>

<jsp:include page="/resources/common/footer.jsp"/>
