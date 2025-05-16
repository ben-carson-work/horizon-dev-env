<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSiaeLocationList" scope="request"/>
<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<%
BLBO_Siae bl = pageBase.getBLDef();
%>

<div class="mainlist-container">
  <jsp:include page="/resources/admin/siae/siae_alert.jsp" />
  <snp:list-tab caption="@Common.Search" fa="search"/>
  <div class="profile-pic-div">
    <div class="form-toolbar">
      <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
      <script>
        $("#full-text-search").keypress(function(e) {
          if (e.keyCode == KEY_ENTER) {
            search();
            return false;
          }
        });
      </script>
    </div>
  </div>
  
  <div class="profile-cont-div">
    <div class="form-toolbar">
      <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
      <span class="divider"></span>
      <v:button id="del-btn" caption="@Common.Delete" fa="trash" enabled="<%=bl.isSiaeEnabled() %>" href="javascript:doDelete()"/>
    <v:pagebox gridId="location-grid"/>
    </div>
  
    <div>
      <v:last-error/>
      <v:async-grid id="location-grid" jsp="siae/location_grid.jsp" />
    </div>
  </div>
</div>
<script>
function doDelete() {
  var ids = $("[name='LocationId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteLocations",
        DeleteLocations: {
          Ids: ids
        }
      };
      
      vgsService("Siae", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.SiaeLocation.getCode()%>);
      });
    });
  }
 }
 
function search() {
  setGridUrlParam("#location-grid", "FullText", $("#full-text-search").val(), true);
}

</script>
<jsp:include page="/resources/common/footer.jsp"/>