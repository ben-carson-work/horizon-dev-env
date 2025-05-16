<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSiaeBoxList" scope="request"/>
<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<div class="mainlist-container">
  <div class="form-toolbar">
    <v:button id="del-btn" caption="@Common.Delete" fa="trash" href="javascript:doDelete()"/>
    <% String hrefNew = "javascript:asyncDialogEasy('siae/siae_box_dialog')"; %>
    <v:button id="new-btn" caption="@Common.New" fa="plus" href="<%=hrefNew%>"/>
    <v:pagebox gridId="box-grid"/>
  </div>
  
  <div>
    <v:last-error/>
    <v:async-grid id="box-grid" jsp="siae/siae_box_grid.jsp" />
  </div>
</div>
<script>
function doDelete() {
  var ids = $("[name='SiaeBoxId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteSiaeBoxes",
        DeleteSiaeBoxes: {
          Ids: ids
        }
      };
      
      vgsService("Siae", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.SiaeBox.getCode()%>);
      });
    });
  }
}
</script>
<jsp:include page="/resources/common/footer.jsp"/>