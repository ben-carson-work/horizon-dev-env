<%@page import="com.vgs.cl.JvArray"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<script>
function search() {
  setGridUrlParam("#metafieldgroup-grid", "FullText", $("#search-text").val(), true);
}

function searchKeyPress() {
  if (event.keyCode == KEY_ENTER) {
    search();
  }
}
</script>

<div class="tab-toolbar">
  <input type="text" id="search-text" class="form-control default-focus" placeholder="<v:itl key="@Common.Search" />" onkeypress="searchKeyPress()" style="width:200px"/>
  <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
  <span class="divider"></span>
  <v:button caption="@Common.New" fa="plus" href="javascript:asyncDialogEasy('metadata/metafieldgroup_dialog', 'id=new')"/>
  <v:button caption="@Common.Delete" fa="trash" href="javascript:doDeleteMetaFieldGroups()"/>
  <v:pagebox gridId="metafieldgroup-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
  <v:async-grid id="metafieldgroup-grid" jsp="metadata/metafieldgroup_grid.jsp" />
</div>

<script>

function doDeleteMetaFieldGroups() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteMetaFieldGroups",
      DeleteMetaFieldGroups: {
        MetaFieldGroupList: [] 
      }
    };
    
    
    var metaFieldGroupIDs = $("[name='MetaFieldGroupId']").getCheckedValues().split(",");
    console.log(metaFieldGroupIDs);
    for(var i=0; i < metaFieldGroupIDs.length; i++) {
      reqDO.DeleteMetaFieldGroups.MetaFieldGroupList.push({
            MetaFieldGroupId: metaFieldGroupIDs[i]
      });
    }
    
    vgsService("MetaData", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.MetaFieldGroup.getCode()%>);
    });
  });
}

</script>

