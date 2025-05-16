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
<script src="<v:config key="site_url"/>/libraries/codemirror/mode/xml/xml.js"></script>
<script src="<v:config key="site_url"/>/libraries/codemirror/mode/javascript/javascript.js"></script>
<script src="<v:config key="site_url"/>/libraries/codemirror/mode/css/css.js"></script>
<script src="<v:config key="site_url"/>/libraries/codemirror/mode/vbscript/vbscript.js"></script>
<script src="<v:config key="site_url"/>/libraries/codemirror/mode/htmlmixed/htmlmixed.js"></script>

<style>
  #doctemplate-form .CodeMirror {
    border-bottom-left-radius: 4px;
    border-bottom-right-radius: 4px;
    height: 700px;
    <% if (!canEdit) { %>
      background: #f7f7f7;
    <% } %>
  }
</style>

<v:page-form id="doctemplate-form">

  <v:tab-toolbar>
    <v:button caption="@Common.Save" fa="save" href="javascript:doSave()"  enabled="<%=canEdit%>"/>
    <% if (doc.DocTemplateType.isLookup(LkSNDocTemplateType.StatReport)) { %>
      <span class="divider"></span>
      <v:button caption="@Common.Generate" fa="download" href="javascript:showExecutorDialog()"/>
    <% } %>
    <%if (doc.DocEditorType.isLookup(LkSNDocEditorType.Html)) %>
      <v:button id="btn-editor-html" caption="@DocTemplate.Preview" fa="browser" onclick="showPreview(this)" enabled="<%=canEdit%>"/>  
  </v:tab-toolbar>
  
  <v:tab-content style="padding:0px">
    <v:last-error/>
    <textarea class="CodeMirror"><%=JvString.replace(doc.DocData.getHtmlString(), "<br/>", "\n")%></textarea>
  </v:tab-content>
</v:page-form>

<script>
  var cmReport = null;
  
  $(document).ready(function() {
    cmReport = CodeMirror.fromTextArea($("textarea.CodeMirror")[0], {
      mode: "text/html",
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
    
    showWaitGlass();
    vgsService("DocTemplate", reqDO, false, function(ansDO) {
      hideWaitGlass();
      entitySaveNotification(<%=LkSNEntityType.DocTemplate.getCode()%>, <%=doc.DocTemplateId.getJsString()%>, "tab=template");
    });
  }
  
  function showPreview(btn) {
	  var $btn = $(btn);
	  var $tab = $btn.closest(".tab-content")
	  var instanceIdx = $tab.attr("data-InstanceName")

	  var $dlg = $("<div title='SnApp'/>").appendTo("body");
	  $dlg.html("<iframe style='border:none;position:absolute;top:0;left:0;width:100%;height:100%;'></frame>");
	  $dlg.dialog({
	    modal: true,
	    title: $tab.attr("data-langname"),
	    width: 800,
	    height: 600,
	    close: function() {
	      $dlg.remove();
	    }
	  });
	  
	  var $textArea = $(".CodeMirror");
	  var iframe = $dlg.find("iframe")[0];
	  var iFrameDoc = iframe.contentDocument || iframe.contentWindow.document;
	  iFrameDoc.write($textArea.val());
	  iFrameDoc.close();
	}  
</script>
