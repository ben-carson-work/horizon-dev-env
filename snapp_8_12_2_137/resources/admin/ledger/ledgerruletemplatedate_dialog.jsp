<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String isCreating = pageBase.getParameter("new");
String templateId = pageBase.getParameter("LedgerRuleTemplateId");
String templateDateId = pageBase.getParameter("LedgerRuleTemplateDateId");
DOLedgerRuleTemplate template = pageBase.getBL(BLBO_LedgerRule.class).loadLedgerRuleTemplate(templateId); // TODO: Cache
DOLedgerRuleTemplateDate templateDate = template.LedgerRuleTemplateDateList.findFirst(it -> it.LedgerRuleTemplateDateId.isSameString(templateDateId));
if (templateDate == null) {
  templateDate = new DOLedgerRuleTemplateDate();
  templateDate.ValidDateFrom.setDateTime(pageBase.getBrowserFiscalDate());
}
request.setAttribute("templateDate", templateDate);
%>

<v:dialog id="ledgerrule_templatedate_dialog" title="@Ledger.TemplateDate" width="300" autofocus="false">
  <v:form-field caption="@Common.FromDate">
    <v:input-text type="datepicker" field="templateDate.ValidDateFrom" placeholder="@Common.Unlimited"/>
  </v:form-field>
  
  <v:form-field caption="@Common.ToDate" >
    <v:input-text type="datepicker" field="templateDate.ValidDateTo" placeholder="@Common.Unlimited"/>
  </v:form-field>
  
  <div id="ledgerruletemplatedate-duplicate-check-container">
		 <v:db-checkbox 
		 	caption="@Ledger.DuplicateLedgerTemplateDateRules"
		 	hint="@Ledger.DuplicateLedgerTemplateDateRulesHint" 
		 	field="template-date-check"
		 	value="true"
		 	checked="true"
		 />
  </div>
  
  <script>
    $(document).ready(function() {
    	var dlg = $("#ledgerrule_templatedate_dialog");
    	var checkLedgerRuleTemplateDatekDuplicate = true;
    	const isCreating = <%=isCreating%>;
    	
    	if (!isCreating){
    		$("#ledgerruletemplatedate-duplicate-check-container").css('display', 'none');
    	}
    	else{
    		const found = $("#template-date-check");
    		if(found.length>0){
	    		$("#ledgerruletemplatedate-duplicate-check-container").click(()=>{
					console.log(found[0].checked);
					checkLedgerRuleTemplateDatekDuplicate = !checkLedgerRuleTemplateDatekDuplicate;
				});
			}
		}
    		
    	
    	dlg.on("snapp-dialog", function(event, params) {
    	  params.buttons = [
    	    {
    	      id: "btn-confirm",
    	      text: itl("@Common.Confirm"),
    	      click: doSaveOrDuplicate
    	    },
    	    {
    	      text: itl("@Common.Close"),
    	      click: doTemplateDateCancel
    	    },
    	  ]
    	});
   	  
      function doSaveOrDuplicate(){
        if (!isCreating)
          doTemplateDateOK();
    	else {
    	  const duplicateCheckboxFound = $("#template-date-check");
    	  if (duplicateCheckboxFound.length > 0) {
		    const duplicateCheckbox = duplicateCheckboxFound[0];
		    if (duplicateCheckbox.checked===true)
			  doTemplateDuplicate();
			else
	          doTemplateDateOK();	
		  }
		}
	  }
    	
      function doTemplateDateOK() {
        snpAPI.cmd("Ledger", "SaveTemplateDate", {
            LedgerRuleTemplateDate: {
              LedgerRuleTemplateId: <%=template.LedgerRuleTemplateId.getJsString()%>,
              // When creating a new TemplateDate do not assign LedgerRuleTemplateDateId or it will attempt to update.
              LedgerRuleTemplateDateId: isCreating ? null : <%=templateDate.LedgerRuleTemplateDateId.getJsString()%>,
              ValidDateFrom: $("#templateDate\\.ValidDateFrom-picker").getXMLDate(),
              ValidDateTo: $("#templateDate\\.ValidDateTo-picker").getXMLDate()
            }
          })
          .then(ansDO => {
				entitySaveNotification(<%=LkSNEntityType.LedgerRuleTemplate.getCode()%>, <%=template.LedgerRuleTemplateId.getJsString()%>, "tab=rules&tab_date=" + ansDO.LedgerRuleTemplateDateId);
    	        dlg.dialog("close");
          });
    	}
      
      function doTemplateDuplicate() {
		  const ledgerRuleTemplateDateId = <%=templateDate.LedgerRuleTemplateDateId.getJsString()%>
		  // If templateDate.LedgerRuleTemplateDateId is null when creating,
		  // retrieves TemplateDateId from GET params instead.
		  if (!ledgerRuleTemplateDateId)
		  	ledgerRuleTemplateDateId = new URLSearchParams(window.location.search).get('tab_date');
		  
          snpAPI.cmd("Ledger", "DuplicateTemplateDate", {
        	   LedgerRuleTemplateDateId: ledgerRuleTemplateDateId,
               ValidDateFrom: $("#templateDate\\.ValidDateFrom-picker").getXMLDate(),
               ValidDateTo: $("#templateDate\\.ValidDateTo-picker").getXMLDate()
            })
            .then(ansDO => {
          	    entitySaveNotification(<%=LkSNEntityType.LedgerRuleTemplate.getCode()%>, <%=template.LedgerRuleTemplateId.getJsString()%>, "tab=rules&tab_date=" + ansDO.LedgerRuleTemplateDateId);
      	        dlg.dialog("close");
            });
      	}
      
      function doTemplateDateCancel() {
    	  dlg.dialog("close");
    	}
    });
  </script>
</v:dialog>
  
