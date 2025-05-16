<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocTemplate" scope="request"/>
<jsp:useBean id="doc" class="com.vgs.web.dataobject.DOUI_DocTemplate" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canEdit = rights.VGSSupport.getBoolean() || (doc.SystemCode.isNull() && pageBase.getBLDef().getDocRightCRUD(doc).canUpdate()); 
%>

<script src="<v:config key="site_url"/>/libraries/codemirror/lib/codemirror.js"></script>
<link rel="stylesheet" href="<v:config key="site_url"/>/libraries/codemirror/lib/codemirror.css"/>
<script src="<v:config key="site_url"/>/libraries/codemirror/mode/sql/sql.js"></script>

<style>
  .doctemplate_report_tab_datasource {
    padding: 0px; 
    background-color: #f9f9f9;
    border-bottom-left-radius: 4px;
    border-bottom-right-radius: 4px;
  }
  
  .doctemplate_report_tab_datasource .editor-container {
    margin-left: 145px;
    height: 700px;
  }

  .doctemplate_report_tab_datasource .CodeMirror {
    border-bottom-right-radius: 4px;
    border-left: 1px #aaaaaa solid;
    height: 700px;
    <% if (!canEdit) { %>
      background: #f7f7f7;
    <% } %>
  }
  
  .doctemplate_report_tab_datasource .CodeMirror-gutter {
    box-shadow: 0 0 rgba(0,0,0,0) inset, 0 0 rgba(0,0,0,0) inset, 0 0 rgba(0,0,0,0) inset, 2px -2px 3px rgba(0,0,0,0.1) inset;
  }
  
  .doctemplate_report_tab_datasource ul.datasource {
    float: left;
    width: 145px;
    margin: 0px;
    padding: 0px;
    list-style-type: none;
    height: 700px;
  }
  
  .doctemplate_report_tab_datasource ul.datasource li {
    line-height: 30px;
    font-family: sans-serif;
    font-size: 12px;
    font-weight: bold;
    position: relative;
  }
  
  .doctemplate_report_tab_datasource ul.datasource li.add {
    text-align: center;
  }
  
  .doctemplate_report_tab_datasource ul.datasource li.ds {
    padding-left: 8px;
    border-bottom: 1px #e0e0e0 solid;
    cursor: pointer;
  }
  
  .doctemplate_report_tab_datasource ul.datasource li.ds:hover {
    background-color: #ececec;
  }
  
  .doctemplate_report_tab_datasource ul.datasource li.ds.selected {
    background-color: #cbcbcb;
  }
  
  .doctemplate_report_tab_datasource ul.datasource li.ds .fa {
    position: absolute;
    top: 7px;
    visibility: hidden;
  }
  
  .doctemplate_report_tab_datasource ul.datasource li.ds .del {
    right: 7px;
  }
  
  .doctemplate_report_tab_datasource ul.datasource li.ds .edit {
    right: 30px;
  }
  
  .doctemplate_report_tab_datasource ul.datasource li.ds:hover .fa {
    visibility: visible;
  }

  .doctemplate_report_tab_datasource .CodeMirror {
    border: 1px solid var(--tab-border-color);
  }
 
  .doctemplate_report_tab_datasource .ui-resizable-s {
    height: 12px;
    background-color: var(--pagetitle-bg-color);
    border-top: 1px solid var(--tab-border-color);
  }
  
</style>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" href="javascript:doSave()" enabled="<%=canEdit%>"/>
  <% if (doc.DocTemplateType.isLookup(LkSNDocTemplateType.StatReport)) { %>
    <span class="divider"></span>
    <v:button caption="@Common.Generate" fa="download" href="javascript:showExecutorDialog()"/>
  <% } %>
</div>

<div class="doctemplate_report_tab_datasource">
  <ul class="datasource">
    <li class="add">
    <% if (canEdit) { %>
      <a href="javascript:showEditDialog()"><v:itl key="@DocTemplate.NewDataSource"/></a>
    <% } %>
    </li>
  </ul>
  <div id="editor-container"></div>
</div>

<script>

var cmDataSource = null;
var liSelected = null;

$(document).ready(function() {
  cmDataSource = CodeMirror($("#editor-container")[0], {
    mode: "text/x-mysql",
    lineNumbers: true,
    readOnly: <%=!canEdit%>
  });

  $(".CodeMirror").resizable({
    handles: "s"
  });

  selectDataSource($("ul.datasource li.ds")[0]);
});

function flushEditor() {
  if (liSelected != null) 
    liSelected.data("sql", cmDataSource.getValue());
}

function selectDataSource(li) {
  flushEditor();

  if (liSelected != null) 
    liSelected.removeClass("selected");
  
  liSelected = $(li);

  if (liSelected != null) {
    cmDataSource.setValue(liSelected.data("sql"));
    cmDataSource.clearHistory();
    liSelected.addClass("selected");
    cmDataSource.focus();
  }
}

function addDataSource(name, sql) {
  var li = $("<li class='ds'/>");
  li.data("sql", sql);
  
  $("<span class='name'/>").appendTo(li).html(name);
  
  <% if (canEdit) { %>
    $("<i class='edit fa fa-lg fa-pencil'></i>").appendTo(li).click(function() {
      showEditDialog(li);
    });
    
    $("<i class='del fa fa-lg fa-trash'></i>").appendTo(li).click(function() {
      confirmDialog(null, function() {
        li.remove();
      });
    });
  <% } %>
  
  li.click(function() {
    selectDataSource(this);
  });
  
  $("ul.datasource .add").before(li);
  
  return li;
}

<%
QueryDef qdef = new QueryDef(QryBO_DocTemplate.class);
// Select
qdef.addSelect(QryBO_DocTemplate.Sel.DocTemplateName);
qdef.addSelect(QryBO_DocTemplate.Sel.DocData);
// Filter
qdef.addFilter(QryBO_DocTemplate.Fil.ParentTemplateId, pageBase.getId());
qdef.addFilter(QryBO_DocTemplate.Fil.DocTemplateType, LkSNDocTemplateType.DataSource.getCode());
// Sort
qdef.addSort(QryBO_DocTemplate.Sel.DocTemplateName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);

if (ds.isEmpty()) {
  %>addDataSource("<v:itl key="@Common.Default" encode="UTF-8"/>", "");<%
}

while (!ds.isEof()) {
  String name = ds.getField(QryBO_DocTemplate.Sel.DocTemplateName).getJsString();
  String sql = ds.getField(QryBO_DocTemplate.Sel.DocData).getJsString();
  %>
  addDataSource(<%=name%>, <%=sql%>);
  <%
  ds.next();
}
%>

function showEditDialog(li) {
  var dlg = $("<div title='<v:itl key="@Common.Rename"/>'/>");
  var txt = $("<input type='text' style='width:94%' placeholder='<v:itl key="@Common.Name"/>'/>").appendTo(dlg);
  
  if (li != null)
    txt.val(li.find(".name").html());
  
  function doOK() {
    dlg.dialog("close");
    if (li == null) {
      li = addDataSource(txt.val(), "");
      selectDataSource(li);
    }
    else
      li.find(".name").html(txt.val());
  }
  
  dlg.dialog({
    modal: true,
    width: 250,
    height: 140,
    close: function() {
      dlg.remove();
    },
    buttons: {
      <v:itl key="@Common.Ok" encode="JS"/>: doOK, 
      <v:itl key="@Common.Cancel" encode="JS"/>: function() {
        dlg.dialog("close");
      }
    }
  }).keypress(function() {
    if (event.keyCode == KEY_ENTER) doOK();
  });
}

function doSave() {
  var reqDO = {
    Command: "SaveDataSources",
    SaveDataSources: {
      DocTemplateId: <%=doc.DocTemplateId.getJsString()%>,
      DataSourceList: []
    }
  };
  
  flushEditor();
  var lis = $("ul.datasource li.ds");
  for (var i=0; i<lis.length; i++) {
    var ds = {
      Name: $(lis[i]).find(".name").html(),
      SQL: $(lis[i]).data("sql")
    };
    reqDO.SaveDataSources.DataSourceList.push(ds);
  }
  
  function showBigMessage(msg) {
    var dlg = $("<div title='SnApp'/>");
    dlg.append("<span class='ui-helper-hidden-accessible'><input type='text'/></span>");
    msg = msg.replace(/\n/g, '<br>').replace(/\s/g, '&nbsp;');
    dlg.append(msg);
    var init = {
      modal: true,
      close: function() {
        dlg.remove();
      },
      buttons: {
        Ok: doCloseDialog
      },
      width: 900,
      height: 600
    };
    dlg.dialog(init);
  }
  
  showWaitGlass();
  vgsService("DocTemplate", reqDO, false, function(ansDO) {
    hideWaitGlass();
    if (ansDO.Answer && ansDO.Answer.SaveDataSources.ErrorMsg)
      showBigMessage(ansDO.Answer.SaveDataSources.ErrorMsg);
    else
      showMessage(<v:itl key="@Common.SaveSuccessMsg" encode="JS"/>, function() {
        window.location.reload();
      });
  });
}

</script>
