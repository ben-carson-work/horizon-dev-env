<%@page import="com.vgs.snapp.dataobject.DODB.tbLedgerRuleTemplate"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
BLBO_PagePath.EntityRecap recap = BLBO_PagePath.findEntityRecap(pageBase.getConnector(), LkSNEntityType.LedgerRuleTemplate, pageBase.getId());
String newCode = pageBase.getBL(BL_BO_Base.class).generateDuplicateCode(LkSNEntityType.LedgerRuleTemplate, "tbLedgerRuleTemplate", "LedgerRuleTemplateCode", recap.code, tbLedgerRuleTemplate.dummy().LedgerRuleTemplateCode.getSize());
String newName = pageBase.getBL(BL_BO_Base.class).generateDuplicateName(LkSNEntityType.LedgerRuleTemplate, "tbLedgerRuleTemplate", "LedgerRuleTemplateName", recap.name, tbLedgerRuleTemplate.dummy().LedgerRuleTemplateName.getSize());
%>

<v:dialog id="ledgerruletemplate_duplicate_dialog" title="@Common.Duplicate" width="800">

  <v:widget>
    <v:widget-block>
      <v:form-field caption="@Common.NewCode">
        <input type="text" id="NewCode" class="form-control" value="<%=JvString.escapeHtml(newCode)%>"/>
      </v:form-field>
      <v:form-field caption="@Common.NewName">
        <input type="text" id="NewName" class="form-control" value="<%=JvString.escapeHtml(newName)%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>

<script>

$(document).ready(function() {
  var $dlg = $("#ledgerruletemplate_duplicate_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: itl("@Common.Duplicate"),
        click: _onDuplicate
      },
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
    ];
  });
  
  function _onDuplicate() {
    var reqDO = {
      Command: "DuplicateLedgerRuleTemplate",
      DuplicateLedgerRuleTemplate: {
        LedgerRuleTemplateId: <%=JvString.jsString(pageBase.getId())%>,
        CandidateLedgerRuleTemplateCode: $dlg.find("#NewCode").val(),
        CandidateLedgerRuleTemplateName: $dlg.find("#NewName").val()
      }
    };
    
    showWaitGlass();
    vgsService("Ledger", reqDO, false, function(ansDO) {
      hideWaitGlass();
      window.location = getPageURL(<%=LkSNEntityType.LedgerRuleTemplate.getCode()%>, ansDO.Answer.DuplicateLedgerRuleTemplate.LedgerRuleTemplateId); 
    });
  }
});

</script>


</v:dialog>
