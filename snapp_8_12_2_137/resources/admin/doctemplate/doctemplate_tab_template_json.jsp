<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocTemplate" scope="request"/>
<jsp:useBean id="doc" class="com.vgs.web.dataobject.DOUI_DocTemplate" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% boolean canEdit = rights.VGSSupport.getBoolean() || (doc.SystemCode.isNull() && pageBase.getBLDef().getDocRightCRUD(doc).canUpdate()); %>

<script src="<v:config key="site_url"/>/libraries/codemirror/lib/codemirror.js"></script>
<link rel="stylesheet" href="<v:config key="site_url"/>/libraries/codemirror/lib/codemirror.css"/>
<script src="<v:config key="site_url"/>/libraries/codemirror/mode/javascript/javascript.js"></script>

<style>
  .doctemplate_report_tab_main .CodeMirror {
    border-bottom-left-radius: 4px;
    border-bottom-right-radius: 4px;
    height: 700px;
    <% if (!canEdit) { %>
      background: #f7f7f7;
    <% } %>
  }
</style>

<div class="doctemplate_report_tab_main">

  <div class="tab-toolbar">
    <v:button caption="@Common.Save" fa="save" href="javascript:doSave()" enabled="<%=canEdit%>"/>
    <% if (!pageBase.isNewItem() && doc.DocTemplateType.isLookup(LkSNDocTemplateType.StatReport)) { %>
      <span class="divider"></span>
      <v:button caption="@Common.Generate" fa="download" href="javascript:showExecutorDialog()" target="_new"/>
    <% } %>
  </div>
  
  <div class="tab-content" style="padding:0px">
    <v:last-error/>
    <textarea class="CodeMirror"><%=doc.DocData.getEmptyString()%></textarea>
  </div>
</div>

<script>
	var cmReport = null;
	
	$(document).ready(function() {
	  cmReport = CodeMirror.fromTextArea($("textarea.CodeMirror")[0], {
	    mode: {
	      name: "javascript", 
	      json: true
	    },
	    matchBrackets: true,
	    lineNumbers: true,
	    smartIndent: false,
	    readOnly: <%=!canEdit%>
	  });
	});

  function doSave() {
    var reqDO = {
      Command: "SaveDocData",
      SaveDocData: {
        DocTemplateId: <%=doc.DocTemplateId.getJsString()%>,
        DocData: cmReport.getValue()
      }
    };
    
    vgsService("DocTemplate", reqDO, false, function(ansDO) {
      showMessage(<v:itl key="@Common.SaveSuccessMsg" encode="JS"/>, function() {
        window.location.reload();
      });
    });
  }
</script>
