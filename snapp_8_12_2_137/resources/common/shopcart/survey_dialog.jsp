<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
LookupItem surveyType = LkSN.SurveyType.getItemByCode(pageBase.getParameter("SurveyType"));
String[] surveyIDs = JvArray.stringToArray(pageBase.getNullParameter("SurveyIDs"), ",");
String[] maskIDs = pageBase.getBL(BLBO_Survey.class).getMaskIDsBySurvey(surveyIDs);
%>

<v:dialog id="survey_dialog" title="@Common.SurveySetup" width="900" height="700" resizable="false">
  
  <div id="survey-mask-container"></div>

  <div class="toolbar-block">
    <div id="btn-stepnext" class="v-button hl-green"><v:itl key="@Common.Next"/></div>
    <div id="btn-stepback" class="v-button hl-green"><v:itl key="@Common.Back"/></div>
  </div>

<script>
var metaFields = {};

$(document).ready(function() {
  var dlg = $("#survey_dialog");
  
  dlg.find("#btn-stepnext").click(function() {
    doSaveSurvey(StepDir_Next)
  });
  dlg.find("#btn-stepback").click(function() {
    doSaveSurvey(StepDir_Back);
  });
  
  var metaData = (<%=surveyType.isLookup(LkSNSurveyType.Sale)%>) ? shopCart.SaleSurveyMetaDataList : shopCart.TransactionSurveyMetaDataList;
  if (metaData) {
    var reqDO = {
      Command: "EncodeMetaData",
      EncodeMetaData: {
        MetaDataList: metaData
      }
    };
    
    vgsService("MetaData", reqDO, false, function(ansDO) {
      metaFields = JSON.parse(ansDO.Answer.EncodeMetaData.MetaFieldsJSON);
    });
  }

  var urlo = "<%=pageBase.getContextURL()%>?page=maskedit_widget&MaskIDs=<%=JvArray.arrayToString(maskIDs, ",")%>&id=" + (shopCart.Reservation.SaleId || "");
  asyncLoad("#survey-mask-container", urlo);
});

function doSaveSurvey(stepDir) {
  var data = prepareMetaDataArray("#survey-mask-container");
  if (!(data)) 
    showMessage(<v:itl key="@Common.CheckRequiredFields" encode="JS"/>);
  else {
    if (<%=surveyType.isLookup(LkSNSurveyType.Sale)%>) 
      shopCart.SaleSurveyMetaDataList = data;
    else
      shopCart.TransactionSurveyMetaDataList = data;
    
    $("#survey_dialog").dialog("close");
    var step = "<%= surveyType.isLookup(LkSNSurveyType.Sale) ? "Step_SaleSurvey" : "Step_TransactionSurvey"%>";
    stepCallBack(step, stepDir);
  }
}
</script>

</v:dialog>