<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="entitlement_version_create_dialog" tabsView="true" title="@Entitlement.EntitlementVersion" width="450" autofocus="false">

  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="product_entitlement_version-tab-profile" caption="@Common.Profile" default="true">
      <div class="tab-content">
        <v:widget caption="@Common.General">
          <v:widget-block>
            <v:form-field caption="@Common.FromDate">
              <v:input-text type="datepicker" field="EncodeDateFrom" placeholder="@Common.Unlimited"/>
            </v:form-field>
            <v:form-field caption="@Common.ToDate">
              <v:input-text type="datepicker" field="EncodeDateTo" placeholder="@Common.Unlimited"/>
            </v:form-field>
          </v:widget-block>  
        </v:widget>
      </div>
    </v:tab-item-embedded>
     
  </v:tab-group>

</v:dialog>

<script>

$(document).ready(function() {
  var $dlg = $("#entitlement_version_create_dialog");
  $dlg.dialog({ 
    modal: true,
    close: function() {
      $dlg.remove();
    },
    buttons: {
      Save: {
      	text: itl("@Common.Save"),
      	click: saveEntitlementVersion
      },
      Cancel: {
      	text: itl("@Common.Cancel"),
      	click: doCloseDialog
      }
    }
  });
  
  $dlg.find("#EncodeDateFrom-picker").datepicker("setDate", new Date());
  $dlg.find("#EncodeDateTo-picker").datepicker("setDate", new Date());   
});


function saveEntitlementVersion() {
  var reqDO = {
    Command: "SaveEntitlementVersion",
    SaveEntitlementVersion: {
    	EntitlementVersion: {
        ProductId      : <%=JvString.jsString(pageBase.getId())%>,
        EncodeDateFrom : $("#EncodeDateFrom-picker").getXMLDate(),
        EncodeDateTo   : $("#EncodeDateTo-picker").getXMLDate()
    	}
    }
  }
  
  var $dlg = $("#entitlement_version_create_dialog");
  vgsService("Entitlement", reqDO, false, function(ansDO) {
    $dlg.dialog("close");
    triggerEntityChange(<%=LkSNEntityType.EntitlementVersion.getCode()%>, null);
  });
};
  

</script>