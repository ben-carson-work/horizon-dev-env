<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocTemplate" scope="request"/>
<jsp:useBean id="doc" class="com.vgs.web.dataobject.DOUI_DocTemplate" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% boolean canEdit = pageBase.getBLDef().getDocRightCRUD(doc).canUpdate(); %>

<div class="tab-toolbar">
  <v:button fa="save" caption="@Common.Save" onclick="saveDescriptions()" enabled="<%=canEdit%>"/>
</div>

<jsp:include page="/resources/admin/common/richdesc_widget_container.jsp"></jsp:include>

<script>
function saveDescriptions() {
  var reqDO = {
    Command: "SaveReportProps",
    SaveReportProps: {
      CategoryId: <%=doc.CategoryId.getJsString()%>,
      DocTemplateId: <%=doc.DocTemplateId.getJsString()%>,
      DocTemplateName: <%=doc.DocTemplateName.getJsString()%>,
      DocTemplateCode: <%=doc.DocTemplateCode.getJsString()%>,
      RichDescList: convertRichDescWidgetList($(".rich-desc-widget").richdesc_getTransList())
    }
  };   
  
  showWaitGlass();
  vgsService("DocTemplate", reqDO, false, function(ansDO) {
    hideWaitGlass();
    entitySaveNotification(<%=LkSNEntityType.DocTemplate.getCode()%>, ansDO.Answer.SaveReportProps.DocTemplateId, "tab=description");
  });
}
</script>

