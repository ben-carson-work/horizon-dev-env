<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String saleId = pageBase.getEmptyParameter("SaleId");

LookupItem saleStatus = LkSN.SaleStatus.getItemByCode(JvString.strToIntDef(pageBase.getEmptyParameter("SaleStatus"), 0));
boolean blocked = ((saleStatus.getCode() > LkSNSaleStatus.BlockLimitStart) && (saleStatus.getCode() < LkSNSaleStatus.BlockLimitEnd)) || saleStatus.isLookup(LkSNSaleStatus.WaitingForPayment);

boolean canCreateNoteType = LkSNHighlightedNoteRightLevel.Create.check(rights.HighlightedNote);
%>

<v:dialog id="sale_change_status_dialog" title="@Common.ChangeStatus" width="800" height="600" autofocus="false">

  <style>
    #sale_change_status_dialog .status-label {
      display: block;
    }
  </style>

  <div class="wizard">
    <% if (!blocked) { %>
    <div class="wizard-step">
      <div class="wizard-step-title"><v:itl key="@Common.Status"/></div>
      <div class="wizard-step-content">
        <v:widget>
          <v:widget-block>
            <% for (LookupItem item : LkSN.SaleStatus.getItems()) { %>
              <% if ((item.getCode() > LkSNSaleStatus.BlockLimitStart) && (item.getCode() < LkSNSaleStatus.BlockLimitEnd)) { %>
                <label class="checkbox-label status-label">
                  <input type="radio" name="SaleStatus" value="<%=item.getCode()%>"/> 
                  <%=item.getHtmlDescription(pageBase.getLang())%>
                </label>
              <% } %>
            <% } %>
          </v:widget-block>
        </v:widget>
      </div>
    </div>
    <% } %>
    
    <div class="wizard-step">
      <div class="wizard-step-title"><v:itl key="@Common.Notes"/></div>
      <div class="wizard-step-content">
        <v:input-txtarea field="Note" rows="16"/>
        <% if (canCreateNoteType) { %>
          <v:widget>
            <v:widget-block>
              <v:db-checkbox field="NoteHighlighted" value="true" caption="@Common.Highlighted"/>
            </v:widget-block>
          </v:widget>
        <% } %>
      </div>
    </div>
  </div>

<script>

$(document).ready(function() {
  var $dlg = $("#sale_change_status_dialog");
  var $wizard = $dlg.find(".wizard");
  var saleId = <%=JvString.jsString(saleId)%>;

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
        text: itl("@Common.Close"),
        click: doCloseDialog
      }
    ]; 
  });
  
  
  $wizard.vWizard({
    onStepChanged: _enableDisable
  });
  
  $dlg.find("[name='SaleStatus']").first().setChecked(true);
  
  function _enableDisable() {
    var last = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length") - 1);
    var $buttonPane = $dlg.siblings(".ui-dialog-buttonpane");
    $buttonPane.find("#btn-continue").setClass("hidden", last);
    $buttonPane.find("#btn-confirm").setClass("hidden", !last);
  }
  
  function _nextStep() {
    $wizard.vWizard("next");
  }
  
  function _confirm() {
    confirmDialog(null, function() {
    	var blocked = <%=blocked%>;
    	var noteType = $dlg.find("#NoteHighlighted").isChecked() ? <%=LkSNNoteType.Highlighted.getCode()%> : <%=LkSNNoteType.Standard.getCode()%>;

    	if (blocked) {
    		var reqDO = {    				
    		      Command: "UnblockOrder",
    		      UnblockOrder: {
    		    	  Body: {
    		    		  Transaction: {
    		    			  Note: $dlg.find("#Note").val(),
  		    		      NoteType: noteType,
    		    		  }
    		    	  },
    		        OrderList: [
    		    	    {
   		    	    		SaleId: <%=JvString.jsString(saleId)%>
    		          }
    		    	  ]
    		      }
   		      };
    	}
    	else {
    		var reqDO = {           
              Command: "BlockOrder",
              BlockOrder: {
                Body: {
                  SaleStatus: $dlg.find("[name='SaleStatus']:checked").val(),
                  Transaction: {
                    Note: $dlg.find("#Note").val(),
                    NoteType: noteType,
                  }
                },
                OrderList: [
                  {
                    SaleId: <%=JvString.jsString(saleId)%>
                  }
                ]
              }
            };
    	}

    	showWaitGlass();
      vgsService("Sale", reqDO, false, function(ansDO) {
        hideWaitGlass(); 
        window.location.reload();
      });
 
    });
  }
  
});
   
</script>

</v:dialog>


