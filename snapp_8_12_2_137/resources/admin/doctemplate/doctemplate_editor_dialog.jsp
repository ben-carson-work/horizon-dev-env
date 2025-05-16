<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
BLBO_DocTemplate bl = pageBase.getBL(BLBO_DocTemplate.class);
DOEnt_DocTemplate template = bl.getEntDocTemplate(pageBase.getId());
DODocTemplate doc = template.DocTemplate;
String data = doc.DocData.getJsString();

String json = "{}";
if (data != null && !data.isEmpty()) {
  boolean oldTemplate = data.indexOf("DOTicketPrintTemplate") != -1;
  if (!oldTemplate) {
    json = data;
  }
}
%>

<v:dialog id="doctemplate_editor_dialog" title="Report editor" showTitlebar="false">
  <jsp:include page="doctemplate_editor_dialog_css.jsp"/>
  <jsp:include page="doctemplate_editor_cm_mode_js.jsp"/>
  <jsp:include page="doctemplate_editor_cm_lint_js.jsp"/>
  <jsp:include page="doctemplate_editor_cm_css.jsp"/>
  <jsp:include page="doctemplate_editor_cm_js.jsp"/>
  
  <script>
    // Attributes should be initialized before doctemplate_editor_dialog_js is loaded
    doctemplate.editor.lightMode = <%=doc.DocTemplateType.isLookup(LkSNDocEditorType.MediaSNP, LkSNDocEditorType.VoucherSNP)%>;

    var attrs = {
      DOPdfDoc: {},
      DOBand: {},
      DOPdfComp: {}
    };
    
    <%
    DOPdfDoc doPdfDoc = new DOPdfDoc();
    DOPdfDoc.DOBand doBand = new DOPdfDoc.DOBand();
    DOPdfComp doComp = new DOPdfComp();
    %>
    <% for (JvFieldNode field: doPdfDoc.getChildFields()) { %>
      attrs.DOPdfDoc['<%=field.getNodeName()%>'] = '<%=field.getClass().getSimpleName()%>';
    <% } %>
    <% for (JvFieldNode field: doBand.getChildFields()) { %>
      attrs.DOBand['<%=field.getNodeName()%>'] = '<%=field.getClass().getSimpleName()%>';
    <% } %>
    <% for (JvFieldNode field: doComp.getChildFields()) { %>
      attrs.DOPdfComp['<%=field.getNodeName()%>'] = '<%=field.getClass().getSimpleName()%>';
    <% } %>
    doctemplate.editor.attributes = attrs;
  </script>
  
  <jsp:include page="doctemplate_editor_dialog_js.jsp"/>
    
  <script>
    var doc = <%=doc.getJSONString()%>;
    
    var pictureMetaFields = [];
    
    <% 
    List<DOMetaFieldRef> metaFieldList = pageBase.getBL(BLBO_MetaData.class).findMetaFieldRefByFieldDataType(LkSNMetaFieldDataType.Picture);
    for (DOMetaFieldRef mf : metaFieldList) {
    %>
        var itm = {
          name: "<%= mf.MetaFieldName %>",
          code: "<%= mf.MetaFieldCode %>"
        };
        pictureMetaFields.push(itm);
    <%
      }
    %>
    doctemplate.editor.fillImageCombobox(doc.RepositoryList, pictureMetaFields);
    var json = <%=json%>;
    doctemplate.editor.importJson(json);
    var dlg = $("#doctemplate_editor_dialog");
    dlg.on("snapp-dialog", function(event, params) {
      params.dialogClass = "doctemplate_editor_dialog_class";
      params.closeOnEscape = false;
    });
    
    var data = <%=bl.getTemplateVariables(pageBase.getId()).getJSONString()%>;
    doctemplate.editor.parseDataSources(doc.DataSourceList);
    doctemplate.editor.initIndexVariablesDialog(data.Variables);
    doctemplate.editor.hierarchy = doctemplate.editor.variablesToHierarchy(data.Variables, false);
    doctemplate.editor.variables = data.Variables;
    doctemplate.editor.parseDataSourceVariables(data.DataSources);
    doctemplate.editor.metaDataFields = doctemplate.editor.parseMetaDataFields(data.MetaDataVariables);
    doctemplate.editor.codeAliasTypes = doctemplate.editor.parseCodeAliasTypes(data.CodeAliasVariables);
    
  </script>
  
  
  <div class="snp-workspace">
    <div class="snp-toolbar">
      <v:button id="btn-save" caption="@Common.Save" fa="save" title="Save" />
      <div class="btn-group snp-mode-btns">
        <v:button id="btn-view-design" clazz="btn-editor-view active" fa="ruler-triangle" title="Design" />
        <v:button id="btn-view-preview" clazz="btn-editor-view" fa="eye" title="Preview" />
        <v:button id="btn-view-source" clazz="btn-editor-view" fa="code" title="@Common.Source" />
      </div>
      <div class="design-mode-only">
        <span class="divider"></span>
        <div class="btn-group">
          <v:button id="btn-undo" fa="undo" title="Undo (CTRL+Z)" />
          <v:button id="btn-redo" fa="repeat" title="Redo (CTRL+Y)" />
        </div>
        <span class="divider"></span>
        
        <div class="btn-group band-buttonset">
          <v:button id="btn-add-band-type" caption="Band" fa="plus" dropdown="true"/>
          <v:popup-menu bootstrap="true">
            <v:popup-item id="btn-addband-title"       clazz="btn-addband"                    caption="Title"/>
            <v:popup-item id="btn-addband-pageheader"  clazz="btn-addband"                    caption="Page header"/>
            <v:popup-item id="btn-addband-pagefooter"  clazz="btn-addband"                    caption="Page footer"/>
	          <v:popup-item id="btn-addband-groupheader" clazz="btn-addband btn-addband-detail" caption="Group header"/>
	          <v:popup-item id="btn-addband-groupfooter" clazz="btn-addband btn-addband-detail" caption="Group footer"/>
	          <v:popup-item id="btn-addband-detail"      clazz="btn-addband btn-addband-detail" caption="Detail" title="Add detail band (B)" />
	        </v:popup-menu>
        </div>
        
        <div class="btn-group">
          <v:button id="btn-add-comp-type" caption="Component" fa="plus" dropdown="true"/>
				  <v:popup-menu bootstrap="true">
				    <v:popup-item id="btn-add-component"     fa="text"        caption="Text" />
				    <v:popup-item id="btn-add-image"         fa="image"       caption="Image" />
				    <v:popup-item id="btn-add-barcode"       fa="barcode-alt" caption="Barcode" />
				    <v:popup-item id="btn-add-sub-component" fa="draw-square" caption="Sub Comp" />
				  </v:popup-menu>
        </div>
  
        <v:button id="btn-remove" fa="trash" title="Delete (DEL)" />
        <span class="divider"></span>
        <div class="btn-group text-buttonset">
          <v:button id="btn-bold" fa="bold" title="Bold (CTRL+B)" />
          <v:button id="btn-italic" fa="italic" title="Italic (CTRL+I)" />
          <v:button id="btn-align-left" clazz="align-group" fa="align-left" title="Align left" />
          <v:button id="btn-align-center" clazz="align-group" fa="align-center" title="Align center" />
          <v:button id="btn-align-right" clazz="align-group" fa="align-right" title="Align right" />
        </div>
        <span class="snp-divider"></span>
        <div id="zoom">
          <span>100%</span>
          <div></div>
        </div>
      </div>
      <div id="btn-close-dialog"><i class="fa fa-times"></i></div>
    </div>
    
    <div id="view-design" class="snp-editor-view view-active">
      <div class="snp-properties">
        <div class="snp-template-title"><%=doc.DocTemplateName.getHtmlString()%></div>

        <v:tab-group name="properties">
          <v:tab-item-embedded tab="tab-inspector" caption="Inspector" default="true">
            <jsp:include page="doctemplate_editor_dialog_prop_inspector.jsp"></jsp:include>
          </v:tab-item-embedded>
          
          <v:tab-item-embedded tab="tab-variable" caption="Variables">
            <div id="variables-spinner" class="snp-spinner"><i class="fa fa-circle-notch fa-spin"></i></div>
            <div id="variable-tree"></div>
          </v:tab-item-embedded>
          
          <v:tab-item-embedded tab="tab-preview" caption="Preview">
            <jsp:include page="doctemplate_editor_dialog_prop_preview.jsp"></jsp:include>
          </v:tab-item-embedded>
        </v:tab-group>
      </div>
      
      <div class="snp-design-content">
        <div class="snp-ruler snp-ruler-h"><div id="ruler-h" class="snp-relative"></div></div>
        <div class="snp-ruler snp-ruler-v"><div id="ruler-v" class="snp-relative"></div></div>
        <div class="snp-canvas">
          <div class="snp-page-container">
            <div id="page">
              <div class="snp-title">Page</div>
              <div class="snp-body">
            </div>
          </div>
          </div>
        </div>
      </div>
    </div>

    <div id="view-preview" class="snp-editor-view">
      <iframe id="preview_iframe" name="preview_iframe" src="" class="snp-pdf-preview"></iframe>
    </div>

    <div id="view-source" class="snp-editor-view">
      <textarea id="source-textarea"></textarea>
    </div>
  </div>
  
  <div class="hidden">
    <div id="cm-text-editor-dialog" title="Edit text">
      <textarea id="cm-comp-textarea">
      </textarea>
    </div>
  
    <div id="index-vars-dialog" title="Choose index variables">
      <div>
        <div id="index-vars"></div>
        <div class="ivd-buttons">
          <button id="move-var">&gt;</button>
          <button id="remove-var">&lt;</button>
          <button id="remove-all-vars">&lt;&lt;</button>
        </div>
        <div class="ivd-result">
          <select multiple="multiple" id="index-vars-result">
          </select>
        </div>
      </div>
    </div>
    
    <div id="insert-media-code-dialog" title="Insert media code" style="display: none;">
      <form>
        <label>
          Media code: <input type="text" id="dlg-media-code-input" name="media-code" class="form-control" required="required" placeholder="Please fill this field" />
        </label>
      </form>
    </div>
  </div>
</v:dialog>