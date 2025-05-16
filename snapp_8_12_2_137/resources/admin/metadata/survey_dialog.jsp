<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
BLBO_Survey bl = pageBase.getBL(BLBO_Survey.class);
DOSurvey survey = pageBase.isNewItem() ? bl.prepareNewSurvey() : bl.loadSurvey(pageBase.getId());
request.setAttribute("survey", survey);
boolean canEdit = rights.SettingsCustomForms.getBoolean();

request.setAttribute("EntityRight_CanEdit", canEdit);
request.setAttribute("EntityRight_RightList", survey.RightList);
request.setAttribute("EntityRight_EntityTypes", new LookupItem[] {LkSNEntityType.Workstation, LkSNEntityType.ProductType, LkSNEntityType.PromoRule, LkSNEntityType.Tag_ProductType});
request.setAttribute("EntityRight_ShowRightLevelAutofill", false);
request.setAttribute("EntityRight_ShowRightLevelEdit", false);
request.setAttribute("EntityRight_ShowRightLevelDelete", false);
%>

<v:dialog id="survey_dialog" tabsView="true" title="@Common.Survey" width="800" height="600" autofocus="false">

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
    <jsp:include page="survey_dialog_tab_main.jsp"/>
  </v:tab-item-embedded>

  <v:tab-item-embedded tab="tabs-right" caption="@Common.Rights">
    <jsp:include page="../common/page_tab_rights.jsp"/>
  </v:tab-item-embedded>
</v:tab-group>


<script>
$(document).ready(function() {
  var dlg = $("#survey_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <% if (canEdit) { %>
        <v:itl key="@Common.Save" encode="JS"/>: doSaveSurvey,
      <% } %>
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
});

function doSaveSurvey() {
  var orderOwnerCategoryIDs = $("#surveySalRules\\.OrderOwnerCategoryIDs").getStringArray();
    
  var reqDO = {
    Command: "SaveSurvey",
    SaveSurvey: {
      Survey: {
        SurveyId: <%=survey.SurveyId.getJsString()%>,
        SurveyCode: $("#survey\\.SurveyCode").val(),
        SurveyName: $("#survey\\.SurveyName").val(),
        SurveyType: $("#survey\\.SurveyType").val(),
        Frequency: $("#survey\\.Frequency").val(),
        Enabled: $("#survey\\.Enabled").isChecked(),
        MaskIDs: $("#survey\\.MaskIDs").getStringArray(),
        RightList: [],
        SaleRules: {
          SaleType: $("#surveySalRules\\.SaleType").val(),
          OrderOwnerCategoryIDs: orderOwnerCategoryIDs,
          TaxExempt: $("#surveySalRules\\.TaxExempt").val()=="" ? null : $("#surveySalRules\\.TaxExempt").val()
        },
        TransactionRules: {
          TransactionTypes: $("#surveyTrnRules\\.TransactionTypes").getStringArray(),
          TaxExempt: $("#surveyTrnRules\\.TaxExempt").val()=="" ? null : $("#surveyTrnRules\\.TaxExempt").val(),
          AttachToSale: $("#surveyTrnRules\\.AttachToSale").isChecked()
        }
      }
    }
  };
  
  var rows = $("#entityright-grid tbody tr").not(".group");
  for (var i=0; i<rows.length;  i++) {
    reqDO.SaveSurvey.Survey.RightList.push({
      UsrEntityType: $(rows[i]).attr("data-EntityType"),  
      UsrEntityId: $(rows[i]).attr("data-EntityId"),
      RightLevel: <%=LkSNRightLevel.Read.getCode()%>
    });
  }

  vgsService("Survey", reqDO, false, function(ansDO) {
    triggerEntityChange(<%=LkSNEntityType.Survey.getCode()%>);
    $("#survey_dialog").dialog("close");
  });
}
</script>

</v:dialog>