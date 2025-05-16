<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageGateCategoryList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:last-error/>

<script>
function search() {
  setGridUrlParam("#gatecategory-grid", "FullText", $("#search-text").val(), true);
}

function searchKeyPress() {
  if (event.keyCode == KEY_ENTER) {
    search();
    event.preventDefault(); 
  }
}
</script>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <input type="text" id="search-text" class="form-control default-focus" placeholder="<v:itl key="@Common.Search" />" onkeypress="searchKeyPress()" style="width:200px"/>
      <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
      <span class="divider"></span>
      <% 
        String hrefNew = "javascript:asyncDialogEasy('product/gatecategory/gatecategory_dialog', '" + "id=new" + "')"; 
      %>
      <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>" enabled="<%=rights.ProductTypes.getOverallCRUD().canCreate()%>"/>
      <v:button caption="@Common.Delete" fa="trash" href="javascript:doDelSelectedGateCategories()" enabled="<%=rights.ProductTypes.getOverallCRUD().canDelete()%>"/>
      <span class="divider"></span>
      <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
      <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="gatecategory-grid"  onclick="exportGateCategory()"/>
      <span class="divider"></span>
      <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.GateCategory.getCode() + ")";%>
      <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
  
    </div>
        
    <v:last-error/>

    <div class="tab-content">
      <v:async-grid id="gatecategory-grid" jsp="product/gatecategory/gatecategory_grid.jsp" />
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<script>
function doDelSelectedGateCategories() {
  var ids = $("[name='GateCategoryId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteGateCategories",
        DeleteGateCategories: {
      	  GateCategoryIDs: $("[name='GateCategoryId']").getCheckedValues()
        }
      };
      
      vgsService("GateCategory", reqDO, false, function(ansDO) {
        changeGridPage("#gatecategory-grid", 1);
      });
    });
  }
}

function showImportDialog() {
  asyncDialogEasy("product/gatecategory/gatecategory_snapp_import_dialog", "");
}
            
function exportGateCategory() {
  var bean = getGridSelectionBean("#gatecategory-grid-table", "[name='GateCategoryId']");
  if (bean) 
    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.GateCategory.getCode()%> + &QueryBase64=" + bean.queryBase64;
}
</script>

<jsp:include page="/resources/common/footer.jsp"/>
