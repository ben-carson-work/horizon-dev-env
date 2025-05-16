<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@taglib uri="vgs-tags" prefix="v" %>
<%@taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProductFamilyList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% int[] defaultStatusFilter = LookupManager.getIntArray(LkSNProductStatus.Draft, LkSNProductStatus.OnSale, LkSNProductStatus.OnSale_Online, LkSNProductStatus.OnSale_Offline); %>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<v:last-error/>


<script>
  function search() {
    setGridUrlParam("#prodfamily-grid", "ProductFamilyStatus", $("[name='Status']").getCheckedValues());
    setGridUrlParam("#prodfamily-grid", "FullText", $("#full-text-search").val(), true);
  }

  function categorySelected(categoryId) {
    setGridUrlParam("#prodfamily-grid", "CategoryId", categoryId, true);
  }
  
  $(document).on("OnEntityChange", search);
</script>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
      <span class="divider"></span>
      <v:button caption="@Common.New" title="@Product.NewProductFamily" fa="plus" href="admin?page=prodfamily&id=new" enabled="<%=rights.ProductTypes.getOverallCRUD().canCreate()%>"/>
      <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" href="javascript:deleteProdFamilies()" enabled="<%=rights.ProductTypes.getOverallCRUD().canDelete()%>"/>
      <% if (rights.ProductTypes.getOverallCRUD().canCreate()) { %>
        <v:copy-paste-buttonset entityType="<%=LkSNEntityType.ProductFamily%>" />
      <% } %>
       <span class="divider"></span>
       <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.ProductFamily.getCode() + ")";%>
       <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/> 
      <v:pagebox gridId="prodfamily-grid"/>
    </div>
    
    <div class="tab-content">
      <div class="profile-pic-div">
        <div class="form-toolbar">
          <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" style="width:97%" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
          <script>
            $("#full-text-search").keypress(function(e) {
              if (e.keyCode == KEY_ENTER) {
                search();
                return false;
              }
            });
          </script>
        </div>
        
        <v:widget caption="@Common.Status">
          <v:widget-block>
          <% for (LookupItem status : LkSN.ProductStatus.getItems()) { %>
            <v:db-checkbox field="Status" caption="<%=status.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(status.getCode())%>" checked="<%=JvArray.contains(status.getCode(), defaultStatusFilter)%>" /><br/>
          <% } %>
          </v:widget-block>
        </v:widget>
    
        <v:widget caption="@Category.Categories" editHRef="<%=pageBase.getCategoryEditLink(LkSNEntityType.ProductFamily)%>">
          <v:widget-block>
            <snp:category-tree-widget entityType="<%=LkSNEntityType.ProductFamily%>"/>
          </v:widget-block>
        </v:widget>
      </div>
      
      <div class="profile-cont-div">
        <% String params = "ProductFamilyStatus=" + JvArray.arrayToString(defaultStatusFilter, ","); %>
        <v:async-grid id="prodfamily-grid" jsp="product/prodfamily/prodfamily_grid.jsp" params="<%=params%>"/>
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<script>
function deleteProdFamilies() {
  var ids = $("[name='ProductFamilyId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteProductFamily",
        DeleteProductFamily: {
          ProductFamilyIDs: ids
        }
      };
      
      vgsService("ProductFamily", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.ProductFamily.getCode()%>);
      });
    });  
  }
}
</script>

<jsp:include page="/resources/common/footer.jsp"/>
