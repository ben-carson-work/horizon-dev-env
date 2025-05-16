<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAttributeList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>


<%
boolean canCreate = pageBase.getRightCRUD().canCreate();
boolean canDelete = pageBase.getRightCRUD().canDelete();
%>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<v:last-error/>

<script>

function search() {
  setGridUrlParam("#attribute-grid", "FullText", $("#search-text").val(), true);
}

function searchKeyPress() {
  if (event.keyCode == KEY_ENTER) {
    search();
    event.preventDefault(); 
  }
}

function doDeleteAttributes() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteAttribute",
      DeleteAttribute: {
        AttributeIDs: $("[name='AttributeId']").getCheckedValues()
      }
    };
    
    vgsService("Product", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.Attribute.getCode()%>);
    });
  });
}

function showImportDialog() {
  asyncDialogEasy("attribute/attribute_snapp_import_dialog", "");
}
          
function exportAttribute() {
  var bean = getGridSelectionBean("#attribute-grid-table", "[name='AttributeId']");
  if (bean) 
    window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.Attribute.getCode()%> + &QueryBase64=" + bean.queryBase64;
}

</script>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <input type="text" id="search-text" class="form-control default-focus" placeholder="<v:itl key="@Common.Search" />" onkeypress="searchKeyPress()" style="width:200px"/>
      <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>

      <span class="divider"></span>

      <v:button-group>
        <v:button caption="@Common.New" title="@Product.NewAttribute" fa="plus" href="javascript:asyncDialogEasy('attribute/attribute_dialog', 'id=new')" enabled="<%=canCreate%>"/>
        <v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" href="javascript:doDeleteAttributes()" enabled="<%=canDelete%>"/>
      </v:button-group>
      <% if (canDelete) { %>
        <v:copy-paste-buttonset entityType="<%=LkSNEntityType.Attribute%>"/>
      <% } %>

      <v:button-group>
        <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
        <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="attribute-grid" onclick="exportAttribute()"/>
      </v:button-group>

      <v:button caption="@Common.History" fa="history" onclick="<%=\"showHistoryLog(\" + LkSNEntityType.Attribute.getCode() + \")\"%>" enabled="<%=rights.History.getBoolean()%>"/> 
      <v:pagebox gridId="attribute-grid"/>
    </div>

    <div class="tab-content">
      <v:async-grid id="attribute-grid" jsp="attribute/attribute_grid.jsp" />
    </div>
  </v:tab-item-embedded>
</v:tab-group>
    

 
<jsp:include page="/resources/common/footer.jsp"/>
