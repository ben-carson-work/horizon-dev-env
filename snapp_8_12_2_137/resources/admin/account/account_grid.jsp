<%@page import="com.vgs.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="/resources/common/error/grid_error.jspf"%>
<%@taglib uri="vgs-tags" prefix="v" %>
<%@taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
// TODO: This should be removed and, in case there is no entity type, the proper display-grid should be calculculated row-by-row like done in POS
if (pageBase.getNullParameter("EntityType") == null)
  throw new RuntimeException("Missing mandatory account_grid parameter: EntityType");

boolean masked = Boolean.parseBoolean(JvUtils.coalesce(pageBase.getNullParameter("Masked"), "false"));

DOAccount parentAccount = null;
int[] entityTypes = JvArray.stringToIntArray(pageBase.getNullParameter("EntityType"), ",");
LookupItem entityType = LkSN.EntityType.getItemByCode(entityTypes[0]);

String parentAccountId = pageBase.getNullParameter("ParentAccountId"); //used for association member
if (parentAccountId != null)
  parentAccount = pageBase.getBL(BLBO_Account.class).loadAccount(parentAccountId);

String gridId = SnappUtils.findGridIdFromConfiguration(rights, (parentAccount == null) ? null : SnappUtils.getAccountRef(parentAccount), entityType);
DOGrid grid = new DOGrid();
if (gridId != null)
  grid = pageBase.getBL(BLBO_Grid.class).loadGrid(gridId);
else
  grid = SnappUtils.getDefaultGrid(entityType);

if (entityType.isLookup(LkSNEntityType.OrganizationAccount)) {  //pseudoentity 
  entityType = LkSNEntityType.Person;
  entityTypes = new int[] {LkSNEntityType.Person.getCode(), LkSNEntityType.Organization.getCode()};
}

DOTableDef tableDefDO = new DOTableDef();
tableDefDO.setJSONString(grid.GridData.getString());

DOAccountSearchRequest reqDO = new DOAccountSearchRequest();  
// Paging
reqDO.SearchRecapRequest.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecapRequest.RecordPerPage.setInt(QueryDef.recordPerPageDefault);

// Where
reqDO.EntityTypes.setArray(entityTypes);

String accountCode = pageBase.getNullParameter("AccountCode");
if (accountCode != null) 
  reqDO.AccountCode.setString(accountCode);
else {
  if (pageBase.getNullParameter("FullText") != null)
    reqDO.FullText.setString(pageBase.getNullParameter("FullText"));

  if (pageBase.getNullParameter("CategoryId") != null && !pageBase.getNullParameter("CategoryId").equals("all"))
    reqDO.CategoryBranchId.setString(pageBase.getNullParameter("CategoryId"));

  if (pageBase.getNullParameter("ParentAccountId") != null)
    reqDO.ParentAccountId.setString(pageBase.getNullParameter("ParentAccountId"));

  if (pageBase.getNullParameter("AccountStatus") != null)
    reqDO.AccountStatus.setArray(JvArray.stringToIntArray(pageBase.getNullParameter("AccountStatus"), ","));

  if (pageBase.getNullParameter("ResourceTypeId") != null)
    reqDO.ResourceTypeId.setString(pageBase.getNullParameter("ResourceTypeId"));

  if (pageBase.getNullParameter("PlatformType") != null)
    reqDO.PlatformType.setArray(JvArray.stringToIntArray(pageBase.getNullParameter("PlatformType"), ","));

  if (pageBase.getNullParameter("ProductId") != null)
    reqDO.ProductId.setString(pageBase.getNullParameter("ProductId"));

  if (pageBase.getNullParameter("PerformanceId") != null)
    reqDO.TicketPerformance.PerformanceId.setString(pageBase.getNullParameter("PerformanceId"));

  if (pageBase.isParameter("HasLogin", "true"))
    reqDO.HasLogin.setBoolean(true);
  
   DOSearchGroupContainer mfg = SnappUtils.encodeSearchGroupContainerByParams(request);
   if (mfg != null) 
     reqDO.SearchFieldGroupList.assign(mfg.SearchFieldGroupList);
}

// Sort
reqDO.SearchRecapRequest.addSortField("DisplayName", false);

// Exec
DOAccountSearchAnswer ansDO = new DOAccountSearchAnswer();  
pageBase.getBL(BLBO_Account.class).searchAccount(reqDO, ansDO);
%>

<snp:tabledef-grid entityType="<%=entityType%>" tableDef="<%=tableDefDO%>" search="<%=ansDO%>" masked="<%=masked%>"></snp:tabledef-grid>

<div id="account_delete_dialog" class="v-hidden">
  <v:alert-box type="warning"><v:itl key="@Account.ConfirmDelete"/></v:alert-box>
  <div>
    <v:form-field caption="@Account.AccountDeleteOptions" mandatory="true">
      <% List<LookupItem> hideAccountDeleteTypes = entityType.isLookup(LkSNEntityType.Organization, LkSNEntityType.Person, LkSNEntityType.Resource, LkSNEntityType.Association, LkSNEntityType.AssociationMember) ? null : LookupManager.getArray(LkSNAccountDeleteType.HardDelete); %>
      <v:lk-combobox field="AccountDeleteType" lookup="<%=LkSN.AccountDeleteType%>" hideItems="<%=hideAccountDeleteTypes%>" allowNull="false"/>
    </v:form-field>
  </div>
</div>


<script>//# sourceURL=account_grid.jsp 

$(document).ready(function(){
  refreshPageBoxes();
});

function showAccountDeleteDialog() {
  var ids = $("[name='cbEntityId']").getCheckedValues();
  if (ids == "")
    showMessage(itl("@Common.NoElementWasSelected"));
  else {
    var dlg = $("#account_delete_dialog");
    dlg.dialog({
      title: itl("@Common.Confirm"),
      width: 480,
      modal: true,
      buttons: [
        dialogButton("@Common.Confirm", _doConfirm),
        dialogButton("@Common.Cancel", doCloseDialog)
      ] 
    });
    
    function _doConfirm() {
      var reqDO = {
        Command: "DeleteAccount",
        DeleteAccount: {
          AccountIDs: ids,
          AccountDeleteType: $("#AccountDeleteType").val()
        }
      };
      
      var grid = $("#account-grid").children(".grid-content");
      if (grid.hasClass("multipage-selected")) {
        reqDO.DeleteAccount.AccountIDs = null;            
        reqDO.DeleteAccount.QueryBase64 = grid.attr("data-QueryBase64");
      }
      
      dlg.dialog("close");
      vgsService("Account", reqDO, false, function(ansDO) {
        showAsyncProcessDialog(ansDO.Answer.DeleteAccount.AsyncProcessId);
      });
    }
  }
}
</script>
