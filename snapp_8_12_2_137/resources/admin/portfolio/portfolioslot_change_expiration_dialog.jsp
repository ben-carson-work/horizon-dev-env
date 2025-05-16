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
String portfolioId = pageBase.getEmptyParameter("PortfolioId");
String membershipPointId = pageBase.getEmptyParameter("MembershipPointId");
String expireDate = pageBase.getEmptyParameter("ExpireDate");
String portfolioSlotBalanceSerial = pageBase.getEmptyParameter("PortfolioSlotBalanceSerial");
String ticketId = pageBase.getEmptyParameter("TicketId");
%>

<v:dialog id="portfolioslot_change_expiration_dialog" title="@Portfolio.ChangeExpiration" width="800" height="600" autofocus="false">

  <style>
    #portfolioslot_change_expiration_dialog .status-label {
      display: block;
    }
  </style>

  <div class="wizard">
    <div class="wizard-step">
      <div class="wizard-step-title"><v:itl key="@Common.Validity"/></div>
      <div class="wizard-step-content">
        <v:widget>
          <v:widget-block>
            <v:form-field id="exp-date" caption="@Common.Expiration">
              <v:input-text type="datepicker" field="expirationDate" placeholder="@Common.Unlimited"/>
            </v:form-field>  
          </v:widget-block>
        </v:widget>
      </div>
    </div>
    
    <div class="wizard-step">
      <div class="wizard-step-title"><v:itl key="@Common.Notes"/></div>
      <div class="wizard-step-content">
        <v:input-txtarea field="Note" rows="16"/>
          <v:widget>
            <v:widget-block>
              <v:db-checkbox field="NoteHighlighted" value="true" caption="@Common.Highlighted"/>
            </v:widget-block>
          </v:widget>
      </div>
    </div>
  </div>

<script>

$(document).ready(function() {
  var $dlg = $("#portfolioslot_change_expiration_dialog");
  var $wizard = $dlg.find(".wizard");

  $dlg.on("snapp-dialog", function(event, params) {
    params.open = _enableDisable;
    params.buttons = [
    	dialogButton("@Common.Back", _previousStep, "btn-back"),
      dialogButton("@Common.Continue", _nextStep, "btn-continue"),
      dialogButton("@Common.Confirm", _confirm, "btn-confirm"),
      dialogButton("@Common.Close", doCloseDialog)
    ]
  });
  
  $wizard.vWizard({
    onStepChanged: _enableDisable
  });
  
  function _enableDisable() {
    var last = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length") - 1);
    var $buttonPane = $dlg.siblings(".ui-dialog-buttonpane");
    $buttonPane.find("#btn-continue").setClass("hidden", last);
    $buttonPane.find("#btn-back").setClass("hidden", !last);
    $buttonPane.find("#btn-confirm").setClass("hidden", !last);
  }
  
  function _nextStep() {
	  if (<%=JvString.jsString(expireDate)%> === $("#expirationDate-picker").getXMLDate()) {
	      showIconMessage("warning", itl("@Portfolio.SameExpireDateError"), function() {
      });
	  }
	  else
      $wizard.vWizard("next");
  }
  
  function _previousStep() {
	  $wizard.vWizard("prior");
	}
  
  function _confirm() {
	  let noteType = $dlg.find("#NoteHighlighted").isChecked() ? <%=LkSNNoteType.Highlighted.getCode()%> : <%=LkSNNoteType.Standard.getCode()%>;
	  let ticketId = <%=JvString.jsString(ticketId)%>;

    confirmDialog(null, function() {
        var reqDO = {           
              Command: 'WalletExpirationChange',
              WalletExpirationChange: {
	            	  ExpireDate: $("#expirationDate-picker").getXMLDate(),
	                Portfolio: {
	                	  PortfolioId: <%=JvString.jsString(portfolioId)%>
	                },
	                MembershipPoint: {
	                	  MembershipPointId: <%=JvString.jsString(membershipPointId)%>,
	                },
	                PortfolioSlotBalanceSerial: <%=portfolioSlotBalanceSerial%>,
	                Ticket: {
	                      TicketId: ticketId,
	                },
		              Transaction: {
		            	   Note: $dlg.find("#Note").val(),
		            	   NoteType: noteType,
		              }
	            }
        }
        
        showWaitGlass();
        vgsService("Portfolio", reqDO, false, function(ansDO) {
          hideWaitGlass(); 
          window.location.reload();
        });
        
    });
  };
  
});
   
</script>

</v:dialog>


