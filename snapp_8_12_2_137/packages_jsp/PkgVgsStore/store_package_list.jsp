<%@page import="com.vgs.snapp.lookup.LkSNModuleType"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<script>
function search() {
  setGridUrlParam("#package-grid", "FullText", $("#txt-fulltext").val(), true);
}

function searchOnEnter() {
  if (event.keyCode == KEY_ENTER) {
    search();
    return false;
  }
}
</script>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" onclick="search();"/>
  <v:pagebox gridId="package-grid"/>
</div>
    
<div class="tab-content">
  <div class="profile-pic-div">
    <v:widget caption="@Common.Search">
      <v:widget-block>
        <input type="text" id="txt-fulltext" class="form-control default-focus" placeholder="Search..." onkeydown="searchOnEnter()"/>
      </v:widget-block>
    </v:widget>
  </div>
      
  <div class="profile-cont-div">
    <% String params = "ModuleType=" + LkSNModuleType.PKG.getCode(); %>
    <v:async-grid id="package-grid" jsp="../../plugins/pkg-vgs-store/store_module_grid.jsp" params="<%=params%>"/>
  </div>
</div>

<jsp:include page="/resources/common/footer.jsp"/>