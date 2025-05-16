<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocTemplate" scope="request"/>
<jsp:useBean id="doc" class="com.vgs.web.dataobject.DOUI_DocTemplate" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean isSiae = BLBO_DBInfo.isSiae() && doc.DocTemplateType.isLookup(LkSNDocTemplateType.Media);
boolean canEdit = rights.VGSSupport.getBoolean() || (doc.SystemCode.isNull() && pageBase.getBLDef().getDocRightCRUD(doc).canUpdate());
BLBO_DocTemplate bl = pageBase.getBLDef();
%>

<script src="<v:config key="site_url"/>/libraries/codemirror/lib/codemirror.js"></script>
<jsp:include page="doctemplate_editor_cm_mode_js.jsp"/>
<jsp:include page="doctemplate_editor_cm_lint_js.jsp"/>
<jsp:include page="doctemplate_editor_cm_css.jsp"/>
<jsp:include page="doctemplate_editor_cm_js.jsp"/>

<link rel="stylesheet" href="<v:config key="site_url"/>/libraries/codemirror/lib/codemirror.css"/>

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
    <% if (isSiae && rights.FiscalSystemView.getBoolean()) { %>
    <v:button caption="@Common.Save" fa="save" href="javascript:doSaveAndCheck()" enabled="<%=canEdit%>"/>
    <% } else { %>
    <v:button caption="@Common.Save" fa="save" href="javascript:doSave()" enabled="<%=canEdit%>"/>
    <% } %>
    <% if (!pageBase.isNewItem() && doc.DocTemplateType.isLookup(LkSNDocTemplateType.StatReport)) { %>
      <span class="divider"></span>
      <v:button caption="@Common.Generate" fa="download" href="javascript:showExecutorDialog()" />
    <% } %>
  </div>
  
  <div class="tab-content" style="padding:0px">
    <v:last-error/>
    <textarea class="CodeMirror"><%=doc.DocData.getEmptyString()%></textarea>
  </div>
</div>

<script>
  var cmReport = null;
  var data = <%=bl.getTemplateVariables(pageBase.getId()).getJSONString()%>;
  
  $(document).ready(function() {
    doctemplate.editor.hierarchy = doctemplate.editor.variablesToHierarchy(data.Variables, false);
    doctemplate.editor.metaDataFields = doctemplate.editor.parseMetaDataFields(data.MetaDataVariables);
    doctemplate.editor.parseDataSourceVariables(data.DataSources);
    
    cmReport = CodeMirror.fromTextArea($("textarea.CodeMirror")[0], {
      matchBrackets: true,
      lineNumbers: true,
      smartIndent: false,
      readOnly: <%=!canEdit%>,
      mode: 'vgslang',
      extraKeys: {"Ctrl-Space": "autocomplete"},
      autoCloseBrackets: true,
      gutters: ["CodeMirror-lint-markers"],
      lint: true
    });
    doctemplate.editor.initCodeMirror(cmReport);
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
      entitySaveNotification(<%=LkSNEntityType.DocTemplate.getCode()%>, ansDO.Answer.SaveDocData.DocTemplateId);
    });
  }
  
<% if (isSiae && rights.FiscalSystemView.getBoolean()) { %>
  function doSaveAndCheck() {
    var required = ['Ticket.Siae.CFSistema', 'Ticket.Siae.CodiceSistema', 
                    'Ticket.Siae.CodiceCarta', 'Ticket.Siae.ProgressivoCarta', 'Ticket.Siae.Sigillo', 
                    'Ticket.Siae.DataOraEmissione', 'Ticket.Performance.EventName', 'Ticket.Performance.AdmLocationName', 
                    'Ticket.Performance.PerformanceDateTime', 'Ticket.Siae.TipoGenere', 'Ticket.ProductPrice', 
                    'Ticket.Siae.TipoTitolo', 'Ticket.Siae.OrdinePosto', 'Ticket.MediaCode',
                    'Ticket.Siae.CFOrganizzatore', 'Ticket.Siae.PrezzoTitolo', 'Ticket.Siae.PrezzoPrevendita'];
    var missed = '';
    var content = cmReport.getValue();
    for (var i = 0; i < required.length; ++i) {
      var field = '@{0}'.format(required[i]);
      if (content.indexOf(field) === -1) {
        if (missed !== '') {
          missed += ', ';
        }
        missed += field;
      }
    }
    if (missed !== '') {
      confirmDialog('Sul supporto devono essere presenti i campi: {0}. <br />Ignorare e salvare?'.format(missed), function() {
        doSave();
      });
    } else {
      doSave();
    }
  };
<% } %>
</script>
