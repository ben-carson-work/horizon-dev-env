<%@page import="com.vgs.snapp.library.SnappUtils"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocTemplate" scope="request"/>
<jsp:useBean id="doc" class="com.vgs.web.dataobject.DOUI_DocTemplate" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canEdit = rights.VGSSupport.getBoolean() || (doc.SystemCode.isNull() && pageBase.getBLDef().getDocRightCRUD(doc).canUpdate());
DODocTemplateEmail email = pageBase.getBLDef().getDocTemplateEmail(doc); 
%>

<div class="tab-toolbar">
  <v:button id="btn-save-email" caption="@Common.Save" fa="save" enabled="<%=canEdit%>"/>
</div>

<div class="tab-content">
  <div id="doctemplate-email-editor"><jsp:include page="email_editor.jsp"></jsp:include></div>
</div>


<script>

$(document).ready(function() {
  $("#btn-save-email").click(_saveEmail);
  
  var $editor = $("#doctemplate-email-editor");
  $editor.emailEditor({
    "template": <%=email.getJSONString()%>,
    "readOnly": <%=!canEdit%>,
    "defaultLangISO": <%=JvString.jsString(pageBase.getLangISO())%>
  });
  
  function _saveEmail() {
    snpAPI
      .cmd("DocTemplate", "SaveDocData", {
        DocTemplateId: <%=doc.DocTemplateId.getJsString()%>,
        DocData: JSON.stringify($editor.emailEditorData())
      })
      .then(() => {
        entitySaveNotification(<%=LkSNEntityType.DocTemplate.getCode()%>, <%=doc.DocTemplateId.getJsString()%>, "tab=template");
      });
  }
});

</script>
