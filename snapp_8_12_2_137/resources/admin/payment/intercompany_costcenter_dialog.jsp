<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
BLBO_IntercompanyCostCenter bl = pageBase.getBL(BLBO_IntercompanyCostCenter.class);
DOIntercompanyCostCenter costCenter = pageBase.isNewItem() ? bl.prepareNewIntercompanyCostCenter() : bl.loadIntercompanyCostCenter(pageBase.getId());
request.setAttribute("intercompanyCostCenter", costCenter);
%>


<% boolean canEdit = !pageBase.isParameter("ReadOnly", "true"); %>

<v:dialog id="intercompanyCostCenter-dialog" width="800" title="@Payment.IntercompanyCostCenter">

  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Code" mandatory="true">
        <v:input-text field="intercompanyCostCenter.IntercompanyCostCenterCode"/>
      </v:form-field>
      <v:form-field caption="@Common.Name" mandatory="true">
        <v:input-text field="intercompanyCostCenter.IntercompanyCostCenterName"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <div>
        <v:db-checkbox field="intercompanyCostCenter.Active" caption="@Common.Active" value="true" checked="<%= (pageBase.isNewItem()) ? true : false %>"/>
      </div>
    </v:widget-block>
  </v:widget>
  <v:widget caption="@DocTemplate.DocTemplate">
    <v:widget-block>
      <v:form-field caption="@DocTemplate.DocTemplate">
        <% JvDataSet dsPayDocTemplates = pageBase.getBL(BLBO_DocTemplate.class).getDocTemplateDS(new int[]{LkSNDocTemplateType.PaymentReceipt.getCode()}); %>
	    <v:combobox field="intercompanyCostCenter.DocTemplateId" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" lookupDataSet="<%=dsPayDocTemplates%>"/>
      </v:form-field>
      <v:form-field caption="">
        <v:db-checkbox field="intercompanyCostCenter.ForceReceipt" caption="@Payment.ForceReceipt" hint="@Payment.ForceReceiptHint" value="true"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  <v:widget caption="@Payment.PaymentMethodMasks">
    <v:widget-block>
      <v:form-field caption="@Payment.PaymentMethodMasks">
        <% JvDataSet dsMasks = pageBase.getBL(BLBO_Mask.class).getMaskDS(LkSNEntityType.Finance); %>
	    <v:multibox field="intercompanyCostCenter.MaskIDs" lookupDataSet="<%=dsMasks%>" idFieldName="MaskId" captionFieldName="MaskName"/>
	  </v:form-field>
    </v:widget-block>
  </v:widget>
  
<script>
$(document).ready(function() {
  var dlg = $("#intercompanyCostCenter-dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <% if (canEdit) { %>
      <v:itl key="@Common.Save" encode="JS"/>: doSave,
      <% } %>
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
});  

function doSaveintercompanyCostCenter() {
  var reqDO = {
    Command: "SaveIntercompanyCostCenter",
    SaveIntercompanyCostCenter: {
      IntercompanyCostCenter: {
        <% if (!pageBase.isNewItem()) { %>
    	    IntercompanyCostCenterId: <%=JvString.jsString(pageBase.getId())%>,	
        <% } %>
        IntercompanyCostCenterCode: $("#intercompanyCostCenter\\.IntercompanyCostCenterCode").val(),
        IntercompanyCostCenterName: $("#intercompanyCostCenter\\.IntercompanyCostCenterName").val(),
        Active: $("#intercompanyCostCenter\\.Active").isChecked(),
        MaskIDs: $("#intercompanyCostCenter\\.MaskIDs").getStringArray(),
        DocTemplateId: $("#intercompanyCostCenter\\.DocTemplateId").val(),
        ForceReceipt: $("#intercompanyCostCenter\\.ForceReceipt").isChecked()
      }
    }
  };
  vgsService("IntercompanyCostCenter", reqDO, false, function(ansDO) {
    triggerEntityChange(<%=LkSNEntityType.IntercompanyCostCenter.getCode()%>);
    $("#intercompanyCostCenter-dialog").dialog("close");
  });
}

function doSave() {
  checkRequired("#intercompanyCostCenter-dialog", function() {
    doSaveintercompanyCostCenter()}); 
}
</script>
</v:dialog>