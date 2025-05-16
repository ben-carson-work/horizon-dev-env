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

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
LookupItem transactionType = LkSN.TransactionType.getItemByCode(request.getParameter("TransactionType"));
String[] transactionSurveyIDs = pageBase.getBL(BLBO_Survey.class).getShopCartSurvey(transactionType).tranSurveyIDs;
String[] maskIDs = pageBase.getBL(BLBO_Survey.class).getMaskIDsBySurvey(transactionSurveyIDs);
%>

<% if ((maskIDs.length > 0)) { %>
  <v:wizard-step id="wizard-step-survey" title="@Common.Survey">
    <div class="survey-container"></div>
  
    <script>
    //# sourceURL=wizard_step_survey.jsp
    
    $(document).ready(function() {
      const $step = $("#wizard-step-survey");
      const $wizard = $step.closest(".wizard");
      const maskIDs = <%=JvString.jsString(JvArray.arrayToString(maskIDs, ","))%>;
      var metaDataList = [];
      
      window.metaFields = {};
      asyncLoad($step.find(".survey-container"), addTrailingSlash(BASE_URL) + "admin?page=maskedit_widget&MaskIDs=" + maskIDs);
  
      $step.vWizard("step-validate", function(callback) {
        metaDataList = prepareMetaDataArray($step);
        checkRequired($step, function() {
          var reqDO = {
            Command: "ValidateMetaData",
            ValidateMetaData: {
              EntityType: <%=LkSNEntityType.Transaction.getCode()%>,
              MetaDataList: metaDataList
            }
          };
          
          showWaitGlass();
          vgsService("MetaData", reqDO, false, function(ansDO) {
            hideWaitGlass();
            callback();
          });
        });
      });
      
      $(document).von($step, "wizard-transaction-fillrequest", function(event, transactionDO) {
        transactionDO.TransactionSurveyMetaDataList = metaDataList;
        transactionDO.TransactionMaskList = []
      
        if (maskIDs.length > 0) {
          $(maskIDs.split(",")).each(function(index, elem) {
            transactionDO.TransactionMaskList.push({"MaskId":elem});
          });
        }
      });
    });
    
    </script>
      
  </v:wizard-step>
<% } %>
