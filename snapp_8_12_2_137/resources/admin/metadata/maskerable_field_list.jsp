<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageBase<?> pageBase = (PageBase<?>)request.getAttribute("pageBase"); %>

<v:page-form page="maskerable_field_list">

<div class="tab-toolbar">
  <v:button caption="@Common.New" fa="plus" href="javascript:asyncDialogEasy('metadata/maskerable_field_dialog', 'id=new')"/>
  <v:button caption="@Common.Delete" fa="trash" href="javascript:doDeleteMaskerableFields()"/>
  <v:pagebox gridId="maskerable-field-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
  
  <v:async-grid id="maskerable-field-grid" jsp="metadata/maskerable_field_grid.jsp" />
</div>

<script>

function doDeleteMaskerableFields() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteFieldMasking",
      DeleteFieldMasking: {
        FieldIDs: $("[name='FieldId']").getCheckedValues()
      }
    };
    
    vgsService("MetaData", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.FieldMaskingRule.getCode()%>);
    });
  });
}

</script>

</v:page-form>