<%@page import="com.sun.mail.imap.protocol.Status"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
String extMediaBatchId = pageBase.getId();
String accountId = pageBase.getEmptyParameter("accountId");
%>
<v:dialog id="extmedia_batch_dialog" title="@ExtMediaBatch.ImportExtMediaBatch" width="800" height="600" autofocus="false">

<snp:dyncombo field="hiddenCombo" clazz="class-mediagroup hidden" entityType="<%=LkSNEntityType.ExtMediaGroup%>" allowNull="false"/>
  
<div class="wizard">

    <div class="wizard-step wizard-step-importExtProductCode">
      <div class="wizard-step-title"><v:itl key="@ExtMediaBatch.StatusWizard_ProductCode"/></div>
      <div class="wizard-step-content">
        <v:widget>
         <v:widget-block>
           <v:alert-box type="info" title="@Common.Info" style="margin-top:10px">
             <v:itl key="@ExtMediaBatch.ImportStatusWizard_Line1"/>
           </v:alert-box>
          </v:widget-block>
        </v:widget>
      </div>
    </div>
        
    <div class="wizard-step wizard-step-mediagroupAssociation">
      <div class="wizard-step-title"><v:itl key="@ExtMediaBatch.StatusWizard_MediaGroup"/></div>
      <div class="wizard-step-content">
        <v:widget>
          <v:widget-block>
            <div id="step-plu-mediagoup">
              <v:grid id="plu-mediagroup-grid">
                <thead>
                  <tr>
                    <td width="50%"><v:itl key="@ExtMediaBatch.ExtProductName"/></td>
                    <td width="50%"><v:itl key="@Product.ExtMediaGroup"/></td>
                  </tr>
                </thead>
                <tbody>
                </tbody>
              </v:grid>
            </div>
          </v:widget-block>
        </v:widget>
      </div>
    </div>

    <div class="wizard-step wizard-step-confirmExtMediaCode">
      <div class="wizard-step-title"><v:itl key="@ExtMediaBatch.StatusWizard_Confirm"/></div>
      <div class="wizard-step-content">
        <v:widget caption="Confirm ">
          <v:widget-block>
            <v:form-field caption="@ExtMediaBatch.ExtMediaBatchCodeExt2" hint="@ExtMediaBatch.ExtMediaBatchCodeExt2Hint">
            <v:input-text type="text" field="ExtMediaBatchCodeExt2" />
            </v:form-field>
          </v:widget-block>
        </v:widget>
      </div>
    </div>
    
<script>

$(document).ready(function() {
  var $dlg = $("#extmedia_batch_dialog");
  var $wizard = $dlg.find(".wizard");
  var $stepRefNum = $dlg.find(".wizard-step-confirmExtMediaCode");
 
  $dlg.on("snapp-dialog", function(event, params) {
    params.open = _enableDisable;
    params.buttons = [
      {
        id: "btn-continue",
        text: itl("@Common.Continue"),
        click: _nextStep
      },
      {
        id: "btn-confirm",
        text: itl("@Common.Confirm"),
        click: _confirm
      },
      {
        id: "btn-start",
        text: itl("@Common.Start"),
        click: _startImport
      },
      {
        text: itl("@Common.Close"),
        click: doCloseDialog
      }
    ]; 
  });
  
  $wizard.vWizard({
    onStepChanged: _enableDisable
  });

  function _nextStep() {
    if($wizard.find(".wizard-step-mediagroupAssociation").is(".active")){
      _startAssociation();
    }else
      $wizard.vWizard("next");
  }
  
  function _enableDisable() {
    var stepProductCode = $wizard.find(".wizard-step-importExtProductCode").is(".active");
    var last = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length") - 1);
    var $buttonPane = $dlg.siblings(".ui-dialog-buttonpane");
    $buttonPane.find("#btn-start").setClass("hidden", !stepProductCode);
    $buttonPane.find("#btn-continue").setClass("hidden", (last || stepProductCode));
    $buttonPane.find("#btn-confirm").setClass("hidden", (!last || stepProductCode));
  }
 
  function _confirm() {
    showWaitGlass();
    var reqDO = {
      Command: "ImportExtMediaBatchMediaCodes",
      ImportExtMediaBatchMediaCodes: {
        ExtMediaBatchId: "<%=extMediaBatchId%>",
        ExtMediaBatchCodeExt2: $dlg.find("[name='ExtMediaBatchCodeExt2']").val()
      }
    };
      
    vgsService("ExternalMedia", reqDO, false, function(ansDO) {
      hideWaitGlass(); 
      window.location.reload();
    });
  }
  
  function _startAssociation(){
    showWaitGlass();
     var reqDO = {
        Command: "AddExtMediaGroupToExtProductType",
        AddExtMediaGroupToExtProductType: {
          ExtProductTypeList:[]
        } 
      };
      var ExtProductTypeList = []; 
      $("div[name='mediaGroupCombo']").each(function() {
        var ExtProductTypeId = $(this).attr("id");
        var ExtMediaGroupId = $(this).val();
        var ExtProductType= {}
        ExtProductType["ExtProductTypeId"] = ExtProductTypeId;
        ExtProductType ["ExtMediaGroupId"] = ExtMediaGroupId;
        reqDO.AddExtMediaGroupToExtProductType.ExtProductTypeList.push(ExtProductType);
     });
         
    vgsService("ExternalMedia", reqDO, false, function(ansDO) {
      hideWaitGlass(); 
      $wizard.vWizard("next");
    }); 
  }
  
  function _startImport() {
    showWaitGlass();
    var reqDO = {
        Command: "ImportExtMediaBatchProducts",
        ImportExtMediaBatchProducts: {
          ExtMediaBatchId: '<%=extMediaBatchId%>',
          AccountId: '<%=accountId%>'
        } 
      };
    
    vgsService("ExternalMedia", reqDO, false, function(ansDO) {
      _createProductGridRows(ansDO.Answer.ImportExtMediaBatchProducts.ExtProductTypeList)
      hideWaitGlass(); 
      _nextStep();
    });
  }
  
  function _createProductGridRows(productList){
    var $tbody = $("#plu-mediagroup-grid tbody");
    var $divCombo = $("div[name='hiddenCombo']");
    for(var i = 0; i < productList.length; i++) {
      var $tr = $("<tr class='grid-row' />");
      $tr.append("<td><span class='title'>" + productList[i].ExtProductName + "</span></td>");
      var $combo = $divCombo.clone().removeClass("hidden");
      
      if (productList[i].ExtMediaGroupId){
        $combo.val(productList[i].ExtMediaGroupId);
      }

      $combo.attr("id", productList[i].ExtProductTypeId);
      $combo.attr("name", "mediaGroupCombo");
      var $td = $("<td/>").append($combo);
      $td.appendTo($tr);
      
      $tr.appendTo($tbody);
    }
  }
});  
  
</script>
</v:dialog>
