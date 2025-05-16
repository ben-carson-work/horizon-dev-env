<%@page import="com.vgs.snapp.library.AsyncProcessUtils"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="product-csv-import-dialog" title="@Product.ImportProductTypesHint" width="950" height="750" autofocus="false">
  <div id="step-input">
    <v:widget caption="@Common.Parameters">
      <v:widget-block clazz="params-box">
        <v:form-field caption="@Common.Status">
          <v:lk-combobox field="ProductStatus" lookup="<%=LkSN.ProductStatus%>"/>
        </v:form-field>
        <v:form-field caption="@Category.Category" id="DefaultCategoryId">
          <v:combobox field="CategoryId" lookupDataSet="<%=pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.ProductType)%>" idFieldName="CategoryId" captionFieldName="AshedCategoryName" allowNull="true"/>
        </v:form-field>
        <v:form-field caption="@SaleChannel.SaleChannels">
          <v:multibox 
              name="SaleChannels"
              lookupDataSet="<%=pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS((LookupItem)null)%>"
              idFieldName="SaleChannelId" 
              captionFieldName="SaleChannelName"/>
        </v:form-field>
        <v:form-field caption="@Performance.PerformanceTypes">
          <v:multibox 
              field="PerformanceTypes"
              lookupDataSet="<%=pageBase.getBL(BLBO_PerformanceType.class).getDS(new String[0])%>"
              idFieldName="PerformanceTypeId" 
              captionFieldName="PerformanceTypeName"/>
        </v:form-field>
      </v:widget-block>
      <v:widget-block>
        <jsp:include page="../repository/file_upload_widget.jsp"/> 
      </v:widget-block>
    </v:widget>    
    <jsp:include page="../csv_import_alert_box.jsp"/>    
  </div>

  <div id="step-preview" class="step-item v-hidden">
    <jsp:include page="../csv_import_widget.jsp">
      <jsp:param name="AsyncProcessClassAlias" value="<%=AsyncProcessUtils.CLASS_ALIAS_IMPORT_PRODUCT_TYPE%>"/>
    </jsp:include>
  </div>

</v:dialog>

<script>

$(document).ready(function() {
  var id = $("#category-tree li.selected").attr("data-id");
  if (id != "all")
    $("#product-csv-import-dialog [name='CategoryId']").val(id);
});

function getImportParams() {
  return {
    ProductType: {
      DefaultStatus: $("#product-csv-import-dialog [name='ProductStatus']").val(),
      DefaultCategoryId: $("#product-csv-import-dialog [name='CategoryId']").val(),
      SaleChannelIDs: $("#product-csv-import-dialog [name='SaleChannels']").selectize()[0].selectize.getValue(),
      PerformanceTypeIDs: $("#product-csv-import-dialog [name='PerformanceTypes']").selectize()[0].selectize.getValue()
    }
  }
}

function doUploadFinish(obj) {
  $("#step-input").addClass("v-hidden");
  $("#step-preview").removeClass("v-hidden");
  doCsvImport(obj.RepositoryId);
}

function csvImportCallback(proc) {
  triggerEntityChange(<%=LkSNEntityType.ProductType.getCode()%>);
}

</script>