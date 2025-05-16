<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<script>
function search() {
  setGridUrlParam("#licensee-grid", "FullText", $("#txt-fulltext").val(), true);
}

function searchOnEnter() {
  if (event.keyCode == KEY_ENTER) {
    search();
    return false;
  }
}
</script>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="search" caption="@Common.Search" fa="search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="plus" onclick="search()"/>
      <v:button caption="@Common.New" fa="plus" href="admin?page=store_licensee&LicenseId=new"/>
      <v:pagebox gridId="licensee-grid"/>
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
        <v:async-grid id="licensee-grid" jsp="../../plugins/pkg-vgs-store/store_licensee_grid.jsp" />
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>

<jsp:include page="/resources/common/footer.jsp"/>
