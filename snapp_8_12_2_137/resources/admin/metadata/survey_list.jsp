<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMaskSetup" scope="request"/>

<div class="tab-toolbar">
  <input type="text" id="search-text" class="form-control default-focus" placeholder="<v:itl key="@Common.Search" />" onkeypress="searchKeyPress()" style="width:200px"/>
  <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
  <span class="divider"></span>
  <% String hrefNew = "javascript:asyncDialogEasy('metadata/survey_dialog', 'id=new')"; %>
  <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>"/>
  <v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" href="javascript:deleteSurveys()"/>

  <v:pagebox gridId="survey-grid"/>
</div>

<div class="tab-content">
	<div id="main-container">
	  <v:async-grid id="survey-grid" jsp="metadata/survey_grid.jsp" />
	</div>
</div>

<script>
function search() {
  setGridUrlParam("#survey-grid", "FullText", $("#search-text").val(), true);
}

function searchKeyPress() {
  if (event.keyCode == KEY_ENTER) {
    search();
  }
}
  
function deleteSurveys() {
  var ids = $("[name='SurveyId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteSurvey",
        DeleteSurvey: {
          SurveyIDs: ids
        }
      };
      
      vgsService("Survey", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.Survey.getCode()%>);
      });
    });
  }
  
}
</script>
