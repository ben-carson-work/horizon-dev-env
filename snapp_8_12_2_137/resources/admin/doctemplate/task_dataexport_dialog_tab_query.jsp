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
<jsp:useBean id="cfg" class="com.vgs.snapp.dataobject.task.DOTask_DataExport" scope="request"/>

<script src="<v:config key="site_url"/>/libraries/codemirror/lib/codemirror.js"></script>
<link rel="stylesheet" href="<v:config key="site_url"/>/libraries/codemirror/lib/codemirror.css"/>
<script src="<v:config key="site_url"/>/libraries/codemirror/mode/sql/sql.js"></script>

<div class="tab-content">
  <div id="dataexport-query-editor"><textarea></textarea></div>
</div>

<style>
#dataexport-query-editor .CodeMirror {
  border: 1px solid var(--border-color);
  height: 530px;
}
</style>

<script>
$(document).ready(function() {
  var cm = null;
  var $editor = $("#dataexport-query-editor");
  var $textarea = $editor.find("textarea");
  $textarea.val(<%=cfg.Query.getJsString()%>);

  visibilityObserver($editor, function() {
    if (!$editor.is(".editor-initialized")) {
      cm = CodeMirror.fromTextArea($textarea[0], {
        mode: "text/x-mysql",
        lineNumbers: true,
        readOnly: false
      });
      
      $editor.addClass("editor-initialized");
    }
  });

  
  $(document).von($editor, "task-dataexport-save", function(event, params) {
    if ($("#cbQuery").isChecked()) {
      params.config.Query = (cm != null) ? cm.getDoc().getValue() : $textarea.val();
      if (getNull(params.config.Query) == null)
        params.config.Query = "select * from MyTable";
    }
    else
      params.config.Query = null;
  });
});
</script>