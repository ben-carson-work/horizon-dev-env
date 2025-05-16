<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageCatalogList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button-group>
        <% String hrefNew = ConfigTag.getValue("site_url") + "/admin?page=catalog&id=new"; %>
        <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>" clazz="no-ajax" bindGrid="catalog-grid" bindGridEmpty="true" enabled="<%=rights.Catalogs.canCreate()%>"/>
        <v:button caption="@Common.Delete" fa="trash" onclick="deleteCatalogs()" bindGrid="catalog-grid" enabled="<%=rights.Catalogs.canDelete()%>"/>
      </v:button-group>
      
      <v:button caption="@Common.Import" fa="sign-in" bindGrid="catalog-grid" bindGridEmpty="true" onclick="showImportDialog()"/>
      
      <span class="divider"></span>
      <% String clickHistory="showHistoryLog(" + LkSNEntityType.Catalog.getCode() + ")";%>
      <v:button caption="@Common.History" fa="history" onclick="<%=clickHistory%>" bindGrid="catalog-grid" bindGridEmpty="true" enabled="<%=rights.History.getBoolean()%>"/>
      
      <v:pagebox gridId="catalog-grid"/>
    </div>
    
    <div class="tab-content">
      <div class="profile-pic-div">
                
        <v:widget caption="@Common.Search">
          <v:widget-block>
            <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" onkeypress="searchKeyPress()"/>
          </v:widget-block>
        </v:widget>

        <v:widget caption="@Category.Categories" editHRef="<%=pageBase.getCategoryEditLink(LkSNEntityType.Catalog)%>">
          <v:widget-block>
            <snp:category-tree-widget entityType="<%=LkSNEntityType.Catalog%>"/>
          </v:widget-block>
        </v:widget>
      </div>
      
      <div class="profile-cont-div">
        <v:async-grid id="catalog-grid" jsp="product/catalog/catalog_grid.jsp" />
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<script>

var selCategoryId = <%=JvString.jsString(pageBase.getEmptyParameter("CategoryId"))%>;
function search() {
  setGridUrlParam("#catalog-grid", "FullText", $("#full-text-search").val(), true);
}

function categorySelected(categoryId) {
  selCategoryId = categoryId;
  setGridUrlParam("#catalog-grid", "CategoryId", categoryId, true);
}

function searchKeyPress() {
  if (event.keyCode == KEY_ENTER) {
    search();
    event.preventDefault(); 
  }
}

function deleteCatalogs() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DelNode",
      DelNode: {
        CatalogIDs: $("[name='CatalogId']").getCheckedValues()
      }
    };
    
    showWaitGlass();
    vgsService("Catalog", reqDO, false, function(ansDO) {
      hideWaitGlass();
      triggerEntityChange(<%=LkSNEntityType.Catalog.getCode()%>);
    });
  });
}

function showImportDialog() {
  vgsImportDialog(BASE_URL + "/admin?page=catalog&action=import");
}
</script>

<jsp:include page="/resources/common/footer.jsp"/>
