<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_DocketDevice.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:dialog id="simrotations_dialog" title="@AccessPoint.SimulateRotations"  width="500">

<script>
  $(document).ready(function(){
    var $dlg = $("#simrotations_dialog");
    $dlg.on("snapp-dialog", function(event, params) {
      params.buttons = [
        {
          text: itl("@Common.Save"),
          click: doSave,
        }, 
        {
          text: itl("@Common.Cancel"),
          click: doCloseDialog
        }                     
      ];
    });

    function doSave() {
      var quantity = strToIntDef($dlg.find("#RotQuantity").val(), 1);

      var qtyEntry = 0;
      var qtyExit = 0;
      if ($dlg.find("[name='SimType']:checked").val() == "entry")
        qtyEntry += quantity;
      else
        qtyExit += quantity;
      
      var reqDO = {
        Command: "UpdateConsRotation",
        UpdateConsRotation: {
          AddToExisting: true,
          ManualInput: true,
          ConsRotationList: [{
            DateTime: $dlg.find("#RotDateTime-picker").getXMLDateTime(),
            AccessPointId: <%=JvString.jsString(pageBase.getId())%>,
            QtyEntry: qtyEntry,
            QtyExit: qtyExit,
            QtyEntryControlled: qtyEntry,
            QtyExitControlled: qtyExit
          }]
        }
      };
      
      console.log(reqDO);

      showWaitGlass();
      vgsService("Consolidate", reqDO, false, function(ansDO) {
        hideWaitGlass();
        $dlg.dialog("close");
      });
     }
  });
</script>

  <div style="padding:10px; padding-top:0">
    <i class="fa fa-info-circle"></i>
    <i><v:itl key="@AccessPoint.SimulateRotationsHint"/></i>
  </div>

  <v:widget>
    <v:widget-block>
        <label class="checkbox-label"><input type="radio" name="SimType" value="entry" checked="checked">&nbsp;<v:itl key="@Lookup.TicketUsageType.Entry"/></label>
        &nbsp;&nbsp;&nbsp;
        <label class="checkbox-label"><input type="radio" name="SimType" value="exit">&nbsp;<v:itl key="@Lookup.TicketUsageType.Exit"/></label>
    </v:widget-block>

    <v:widget-block>
      <v:form-field caption="@Common.Quantity">
        <v:input-text field="RotQuantity" placeholder="1"/>
      </v:form-field>
      <v:form-field caption="@Common.DateTime">
        <v:input-text field="RotDateTime" type="datetimepicker" placeholder="@Common.Now"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  
</v:dialog>