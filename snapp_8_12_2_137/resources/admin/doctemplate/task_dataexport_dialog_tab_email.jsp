<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.snapp.web.common.page.PageCommonWidget"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>
<jsp:useBean id="cfgemail" class="com.vgs.snapp.dataobject.DODocTemplateEmail" scope="request"/>

<div class="tab-content">
  <div id="doctemplate-email-editor"><jsp:include page="email_editor.jsp"></jsp:include></div>
</div>

<script>
$(document).ready(function() {
  var $editor = $("#doctemplate-email-editor");
  $editor.emailEditor({
    "template": <%=cfgemail.getJSONString()%>,
    "readOnly": <%=false%>,
    "defaultLangISO": <%=JvString.jsString(pageBase.getLangISO())%>
  });

  $(document).von($editor, "task-dataexport-save", function(event, params) {
    params.config.EmailConfig = $editor.emailEditorData();
  });
});
</script>