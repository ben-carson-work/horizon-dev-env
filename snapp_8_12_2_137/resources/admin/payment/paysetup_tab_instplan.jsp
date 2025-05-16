<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePaymentSetup" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>


<div class="tab-toolbar">
  <v:button caption="@Common.New" fa="plus" onclick="asyncDialogEasy('installment/plan_dialog', 'id=new')" bindGrid="instplan-grid" bindGridEmpty="true" enabled="<%=rights.InstallmentPlans.canCreate()%>"/>
  <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" bindGrid="instplan-grid" onclick="doDeletePlans()" enabled="<%=rights.InstallmentPlans.canDelete()%>"/>
  <span class="divider"></span>
  <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="instplan-grid"  onclick="exportInstallmentPlans()"/>
  <v:pagebox gridId="instplan-grid"/>
</div>

<div class="tab-content">
  <v:async-grid id="instplan-grid" jsp="installment/plan_grid.jsp"/>
</div>


<script>
  function doDeletePlans() {
    var ids = $("[name='InstallmentPlanId']").getCheckedValues();
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeletePlan",
        DeletePlan: {
          InstallmentPlanIDs: ids
        }
      };     
      vgsService("Installment", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.InstallmentPlan.getCode()%>);
      });
    });
  }
  
  function showImportDialog() {
    asyncDialogEasy("installment/plan_snapp_import_dialog", "");
  }
        
  function exportInstallmentPlans() {
    var bean = getGridSelectionBean("#instplan-grid-table", "[name='InstallmentPlanId']");
    if (bean) 
      window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.InstallmentPlan.getCode()%> + &QueryBase64=" + bean.queryBase64;
  }
</script>

 
<jsp:include page="/resources/common/footer.jsp"/>
