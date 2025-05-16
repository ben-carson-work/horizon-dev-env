<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProductList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
int[] defaultStatusFilter = LookupManager.getIntArray(LkSNProductStatus.Draft, LkSNProductStatus.OnSale, LkSNProductStatus.OnSale_Online, LkSNProductStatus.OnSale_Offline);
List<LookupItem> productTypes = LookupManager.getArray(LkSNProductType.System, LkSNProductType.Product, LkSNProductType.Package, LkSNProductType.Fee, LkSNProductType.Material, LkSNProductType.Presale, LkSNProductType.StaffCard, LkSNProductType.Membership);

boolean canCreate = pageBase.getRightCRUD().canCreate();
boolean canUpdate = pageBase.getRightCRUD().canUpdate();
boolean canDelete = pageBase.getRightCRUD().canDelete();
%>
    
<%!
private String buildNewProdHREF(LookupItem productType) {
  return ConfigTag.getValue("site_url") + "/admin?page=product&id=new&ProductType=" + productType.getCode();
}
%>


<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:last-error/>

<input type="hidden" id="CategoryId" name="CategoryId" value="<%=pageBase.getEmptyParameter("CategoryId")%>"/>

<script>
  var selCategoryId = <%=JvString.jsString(pageBase.getEmptyParameter("CategoryId"))%>;
  function search() {
    setGridUrlParam("#product-grid", "ProductStatus", $("[name='Status']").getCheckedValues());
    setGridUrlParam("#product-grid", "ProductType", $("[name='ProductType']").getCheckedValues());

    setGridUrlParam("#product-grid", "TagId", ($("#TagIDs").val() || ""));
    setGridUrlParam("#product-grid", "FullText", $("#full-text-search").val(), true);
  }

  function categorySelected(categoryId) {
    selCategoryId = categoryId;
    setGridUrlParam("#product-grid", "CategoryId", categoryId, true);
  }
  
  function showProductCreateWizard() {
    asyncDialogEasy("product/product_create_dialog", "CategoryId=" + selCategoryId);
  }
  
  function createSyncCrossProduct() {
		asyncDialogEasy("xpi/xpi_product_sync_create_dialog", "CategoryId=" + selCategoryId);
	}
</script>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>

      <span class="divider"></span>
      
      <v:button-group>
        <v:button-group>
          <v:button id="btn-newproducttype" caption="@Common.New" title="@Product.NewProductType" dropdown="true" fa="plus" bindGrid="product-grid" bindGridEmpty="true" enabled="<%=canCreate%>"/>
          <v:popup-menu bootstrap="true">
            <v:popup-item id="btn-newproducttype-wizard" caption="@Common.Wizard" fa="magic" href="javascript:showProductCreateWizard()"/>
            <% for (LookupItem productType : productTypes) { %>
              <v:popup-item id="<%=\"btn-newproducttype-\" + productType.getCode()%>" caption="<%=productType.getRawDescription()%>" icon="<%=BLBO_Product.getIconName(productType)%>" href="<%=buildNewProdHREF(productType)%>"/>
            <% } %>
            <v:popup-item caption="@XPI.CrossProduct" icon="crossplatform.png" href="javascript:createSyncCrossProduct()"/>
          </v:popup-menu>
        </v:button-group>

        <v:button caption="@Common.Edit" fa="pencil" title="@Product.ProductsMultiEdit" bindGrid="product-grid" onclick="showProductMultiEditDialog()" enabled="<%=canUpdate%>"/>
        <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" bindGrid="product-grid" onclick="deleteProducts()" enabled="<%=canDelete%>"/>
      </v:button-group>

      <% if (canCreate) { %>
        <v:copy-paste-buttonset entityType="<%=LkSNEntityType.ProductType%>" />
      <% } %>  

      <span class="divider"></span>

      <v:button-group>
        <v:button-group>
          <v:button caption="@Common.Import" fa="sign-in" dropdown="true" bindGrid="product-grid" bindGridEmpty="true"/>
          <v:popup-menu bootstrap="true">
            <v:popup-item caption="CSV file" fa="file-excel" onclick="showImportDialog(1)"/>
            <v:popup-item caption="SnApp" fa="file-archive" onclick="showImportDialog(2)"/>
          </v:popup-menu>
        </v:button-group>
        <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="product-grid"  onclick="exportProducts()"/>
      </v:button-group>
      
      <span class="divider"></span>
      <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.ProductType.getCode() + ")";%>
      <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
      <v:pagebox gridId="product-grid"/> 
    </div>
    
    <div class="tab-content">
      <div class="profile-pic-div">
                
        <v:widget caption="@Common.Search">
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
            
            <div class="filter-divider"></div>

            <v:itl key="@Common.Tags"/><br/>
            <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
            <v:multibox field="TagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName"/>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Common.Status">
          <v:widget-block>
          <% for (LookupItem status : LkSN.ProductStatus.getItems()) { %>
            <v:db-checkbox field="Status" caption="<%=status.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(status.getCode())%>" checked="<%=JvArray.contains(status.getCode(), defaultStatusFilter)%>" /><br/>
          <% } %>
          </v:widget-block>
        </v:widget>
    
        <v:widget caption="@Common.Type">
          <v:widget-block>
            <% for (LookupItem item : productTypes) { %>
              <div><v:db-checkbox field="ProductType" caption="<%=item.getRawDescription()%>" value="<%=item.getCode()%>" /></div>
            <% } %>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Category.Categories" editHRef="<%=pageBase.getCategoryEditLink(LkSNEntityType.ProductType)%>">
          <v:widget-block>
            <snp:category-tree-widget entityType="<%=LkSNEntityType.ProductType%>"/>
          </v:widget-block>
        </v:widget>
      </div>
      
      <div class="profile-cont-div">
        <% String params = "ProductStatus=" + JvArray.arrayToString(defaultStatusFilter, ","); %>
        <v:async-grid id="product-grid" jsp="product/product_grid.jsp" params="<%=params%>"/>
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<script>

function deleteProducts() {
  var ids = $("[name='ProductId']").getCheckedValues();
  if (ids == "")
    showMessage(itl("@Common.NoElementWasSelected"));
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteProducts",
        DeleteProducts: {
          ProductIDs: ids
        }
      };
      
      if ($("#prod-grid-table").hasClass("multipage-selected")) {
        reqDO.DeleteProducts.PerformanceIDs = null;            
        reqDO.DeleteProducts.QueryBase64 = $("#prod-grid-table").attr("data-QueryBase64");            
      }

      vgsService("Product", reqDO, false, function(ansDO) {
        showAsyncProcessDialog(ansDO.Answer.DeleteProducts.AsyncProcessId, function() {
          triggerEntityChange(<%=LkSNEntityType.ProductType.getCode()%>);
        });
      });
    });  
  }
}

function showImportDialog(type) {
	if (type==1)
    asyncDialogEasy("product/product_csv_import_dialog", "");
	else
		asyncDialogEasy("product/product_snapp_import_dialog", "");
}

function exportProducts() {
  var bean = getGridSelectionBean("#prod-grid-table", "[name='ProductId']");
  if (bean) 
    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.ProductType.getCode()%> + &QueryBase64=" + bean.queryBase64;
}


</script>


<jsp:include page="/resources/common/footer.jsp"/>
