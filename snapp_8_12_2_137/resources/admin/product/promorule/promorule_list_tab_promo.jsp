<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePromoRuleList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% int[] defaultStatusFilter = LookupManager.getIntArray(LkSNProductStatus.Draft, LkSNProductStatus.OnSale, LkSNProductStatus.OnSale_Online, LkSNProductStatus.OnSale_Offline); %>
<% boolean canCreate = rights.PromotionRules.canCreate(); %>

<input type="hidden" id="CategoryId" name="CategoryId" value="<%=pageBase.getEmptyParameter("CategoryId")%>"/>

<script>
  function search() {
    setGridUrlParam("#promorule-grid", "ProductStatus", $("[name='Status']").getCheckedValues());
    setGridUrlParam("#promorule-grid", "PromoRuleType", $("[name='PromoRuleType']").getCheckedValues());
    setGridUrlParam("#promorule-grid", "PromoSelectionType", $("[name='PromoSelectionType']").getCheckedValues());
    setGridUrlParam("#promorule-grid", "PromoActionTarget", $("[name='PromoActionTarget']").getCheckedValues());

    setGridUrlParam("#promorule-grid", "TagId", ($("#TagIDs").val() || ""));
    setGridUrlParam("#promorule-grid", "FullText", $("#full-text-search").val(), true);
  }

  function categorySelected(categoryId) {
    setGridUrlParam("#promorule-grid", "CategoryId", categoryId, true);
  }
   
  function deletePromos() {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeletePromos",
        DeletePromos: {
          ProductIDs: $("#promorule-grid [name='ProductId']").getCheckedValues(),
          AllOrFail: false
        }
      };
      
      vgsService("Product", reqDO, false, function(ansDO) {
        changeGridPage("#promorule-grid", 1);
        showMessage(
            itl("@Common.MultiEditDeleted") + ": " + ansDO.Answer.DeletePromos.DeletedCount + "\n" +
            itl("@Common.MultiEditSkipped") + ": " + ansDO.Answer.DeletePromos.SkippedCount);
      });
    });    
  }
  
  
</script>


<v:tab-toolbar>
  <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
  <span class="divider"></span>
  
  <div class="btn-group">
    <div class="btn-group">
      <v:button caption="@Common.New" title="@Product.NewProductType" fa="plus" dropdown="true" enabled="<%=canCreate%>"/>
      <% if (canCreate) { %>
      <v:popup-menu bootstrap="true">
        <% for (LookupItem promoRuleType : LkSN.PromoRuleType.getItems()) { %>
          <% String href = ConfigTag.getValue("site_url") + "/admin?page=promorule&id=new&PromoRuleType=" + promoRuleType.getCode(); %>
          <v:popup-item caption="<%=promoRuleType.getRawDescription()%>" href="<%=href%>" />
        <% } %>
      </v:popup-menu>
      <% } %>
    </div>

    <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" bindGrid="promorule-grid" onclick="deletePromos()" enabled="<%=rights.PromotionRules.canDelete()%>"/>
    <v:button caption="@Common.Edit" fa="pencil" title="@Product.ProductsMultiEdit" bindGrid="promorule-grid" onclick="showPromoMultiEditDialog()" enabled="<%=rights.PromotionRules.canUpdate()%>"/>
  </div>

  <span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.PromoRule.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
  <v:pagebox gridId="promorule-grid"/>
</v:tab-toolbar>

<v:tab-content>
  <v:profile-recap>
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
        <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.PromoRule); %>
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
      <% for (LookupItem item : LkSN.PromoRuleType.getItems()) { %>
        <v:db-checkbox field="PromoRuleType" caption="<%=item.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(item.getCode())%>" /><br/>
      <% } %>
      </v:widget-block>
    </v:widget>
    <v:widget caption="@Product.PromoSelection">
      <v:widget-block>
      <% for (LookupItem item : LkSN.PromoSelectionType.getItems()) { %>
        <v:db-checkbox field="PromoSelectionType" caption="<%=item.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(item.getCode())%>" /><br/>
      <% } %>
      </v:widget-block>
    </v:widget>
    <v:widget caption="@Product.PromoActionTarget">
      <v:widget-block>
      <% for (LookupItem item : LkSN.PromoActionTarget.getItems()) { %>
        <v:db-checkbox field="PromoActionTarget" caption="<%=item.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(item.getCode())%>" /><br/>
      <% } %>
      </v:widget-block>
    </v:widget>
    
    <v:widget caption="@Category.Categories" editHRef="<%=pageBase.getCategoryEditLink(LkSNEntityType.PromoRule)%>">
      <v:widget-block>
        <snp:category-tree-widget entityType="<%=LkSNEntityType.PromoRule%>"/>
      </v:widget-block>
    </v:widget> 
  </v:profile-recap>
  
  <v:profile-main>
    <% String params = "ProductStatus=" + JvArray.arrayToString(defaultStatusFilter, ","); %>
    <v:async-grid id="promorule-grid" jsp="product/promorule/promorule_grid.jsp" params="<%=params%>"/>
  </v:profile-main>
</v:tab-content>


<jsp:include page="/resources/common/footer.jsp"/>
