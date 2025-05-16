<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageExtMediaGroupList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:last-error/>

<script>
function search() {
  setGridUrlParam("#extmediagroup_grid", "FullText", $("#search-text").val(), true);
}

function searchKeyPress() {
  if (event.keyCode == KEY_ENTER) {
    search();
    event.preventDefault(); 
  }
}
</script>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <input type="text" id="search-text" class="form-control default-focus" placeholder="<v:itl key="@Common.Search" />" onkeypress="searchKeyPress()" style="width:200px"/>
      <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
      <span class="divider"></span>
      <% 
        String hrefNew = "javascript:asyncDialogEasy('doctemplate/extmediagroup_dialog', '" + "id=new" + "')"; 
      %>
      <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>"/>
      <v:button caption="@Common.Delete" fa="trash" href="javascript:doDelSelectedExtMediaGroup()"/>
       <span class="divider"></span>
       <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.ExtMediaCode.getCode() + ")";%>
       <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
       <v:pagebox gridId="extmediagroup_grid"/>
    </div>
        
    <v:last-error/>

    <div class="tab-content">
      <v:async-grid id="extmediagroup_grid" jsp="doctemplate/extmediagroup_grid.jsp" />
    </div>
  </v:tab-item-embedded>
</v:tab-group>

<script>
function doDelSelectedExtMediaGroup() {
  var ids = $("[name='ExtMediaGroupId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else{
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteExtMediaGroup",
        DeleteExtMediaGroup: {
          ExtMediaGroupIDs: ids
        }
      };
        
      vgsService("ExternalMedia", reqDO, false, function(ansDO) {
        changeGridPage("#extmediagroup_grid", 1);
      });
    });
  }
}
</script>

<jsp:include page="/resources/common/footer.jsp"/>
