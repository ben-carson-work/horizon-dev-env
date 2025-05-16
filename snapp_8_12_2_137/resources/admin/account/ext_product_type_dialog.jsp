<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>

<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String extProductTypeId = pageBase.getId(); 
boolean isNew = (extProductTypeId == null) || extProductTypeId.isEmpty();
BLBO_ExtProductType bl = pageBase.getBL(BLBO_ExtProductType.class);
DOExtProductType extProductType = pageBase.isNewItem() ? new DOExtProductType() : bl.loadExtProductType(extProductTypeId); 
request.setAttribute("extProductType", extProductType);
%>
<v:dialog id="ext-product-type-dialog" width="500" height="300" title="@Media.ExtProductType">
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@ExtMediaBatch.ExtProductName" mandatory="true">
        <v:input-text enabled="false" field="extProductType.ExtProductName" />
      </v:form-field>
      <v:form-field caption="@Product.ExtMediaGroup" mandatory="true">
        <v:combobox field="extProductType.ExtMediaGroupId" lookupDataSet="<%=pageBase.getBL(BLBO_ExtMediaGroup.class).getExtMediaGroupDS()%>" idFieldName="ExtMediaGroupId" captionFieldName="ExtMediaGroupName" allowNull="false"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  
<script>
$(document).ready(function() {
  var $dlg = $("#ext-product-type-dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
        {
          id: "btn-save",
          text: itl("@Common.Save"),
          click: _doSaveExtProductType
        },
        {
          text: itl("@Common.Close"),
          click: doCloseDialog
        }
      ]; 
    });
  
  $dlg.keypress(function() {
    if (event.keyCode == KEY_ENTER)
      _doSaveExtProductType();
  });
  
  function _doSaveExtProductType() {
    showWaitGlass();
    var reqDO = {
       Command: "AddExtMediaGroupToExtProductType",
       AddExtMediaGroupToExtProductType: {
         ExtProductTypeList:[]
       } 
      };

    var extProductType = {
      ExtProductTypeId: "<%=extProductTypeId%>",  
      ExtMediaGroupId: $("[name='extProductType.ExtMediaGroupId']").find(":selected").val()
    }
    reqDO.AddExtMediaGroupToExtProductType.ExtProductTypeList.push(extProductType);
        
    vgsService("ExternalMedia", reqDO, false, function(ansDO) {
      hideWaitGlass(); 
      window.location.reload();
    }); 
  }
  
});


</script>
</v:dialog>

