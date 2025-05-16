<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProductFamilyList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:page-form>
<div class="tab-toolbar">
  <% String hrefNewProductFamily = ConfigTag.getValue("site_url") + "/admin?page=prodfamily&id=new&ParentEntityId=" + pageBase.getParameter("ParentEntityId") + "&ParentEntityType=" + pageBase.getParameter("ParentEntityType");%>
  <v:button caption="@Common.New" title="@Product.NewProductFamily" fa="plus" href="<%=hrefNewProductFamily%>" enabled="<%=rights.ProductTypes.getOverallCRUD().canCreate()%>"/>
  <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" href="javascript:deleteProdFamilies()" enabled="<%=rights.ProductTypes.getOverallCRUD().canDelete()%>"/>
  <v:pagebox gridId="prodfamily-grid"/>
</div>
    
<div class="tab-content">
  <v:last-error/>
  <% String params = "ParentEntityType=" + pageBase.getParameter("ParentEntityType") + "&ParentEntityId=" + pageBase.getParameter("ParentEntityId"); %>
    <v:async-grid id="prodfamily-grid" jsp="product/prodfamily/prodfamily_grid.jsp" params="<%=params%>"/>
</div>
</v:page-form>

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
        window.location.reload();
        triggerEntityChange(<%=LkSNEntityType.ProductFamily.getCode()%>);
      });
    });  
  }
}
</script>
