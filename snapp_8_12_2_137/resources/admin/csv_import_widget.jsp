<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String asyncProcessClassAlias = JvUtils.getServletParameter(request, "AsyncProcessClassAlias");
boolean externalStart = JvString.isSameText("true", JvUtils.getServletParameter(request, "ExternalStart"));
%>

<div id="step-csv-preview">
  <div style="overflow:hidden;margin-bottom:10px;position:relative">
    <fieldset id="fs-field-separator"><legend><v:itl key="@Upload.FieldSeparator"/></legend>
      <div><label class="checkbox-label"><input type="radio" name="FieldSeparator" value="TAB"/> <v:itl key="@Common.Char_TAB"/></label></div>
      <div><label class="checkbox-label"><input type="radio" name="FieldSeparator" value=";"/> <v:itl key="@Common.Char_SemiColumn"/></label></div>
      <div><label class="checkbox-label"><input type="radio" name="FieldSeparator" value=","/> <v:itl key="@Common.Char_Comma"/></label></div>
      <div><label class="checkbox-label"><input type="radio" name="FieldSeparator" value=" "/> <v:itl key="@Common.Char_Space"/></label></div>
      <div><label class="checkbox-label"><input type="radio" name="FieldSeparator" value="|"/> <v:itl key="@Common.Char_Pipe"/></label></div>
    </fieldset>
  
    <div id="fs-progress">
      <% if (!externalStart) { %>
        <v:button id="btn-csv-import" caption="@Common.Start" onclick="doStartCsvImport()"/>
      <% } %>
    </div>
  </div>
  
  <div id="preview-grid-container">
    <table id="preview-grid" class="v-hidden">
      <thead></thead>
      <tbody></tbody>
    </table>
  </div>
</div>

<div id="step-csv-import" class="v-hidden">
  <div class="tabs">
    <ul>
      <li><a href="#import-tab-progress"><v:itl key="@Common.Progress"/></a></li>
      <li><a href="#import-tab-log"><v:itl key="@Common.Logs"/></a></li>
    </ul>
    <div id="import-tab-progress">
      <div class="tab-content">
        <div id="pb-import" class="progress-block">
          <div class="progressbar-status"><v:itl key="@Common.PleaseWait"/></div>
          <div class="progress"><div class="progress-bar progress-bar-snp-success"></div></div>
        </div>
        <div style="text-align:center;margin-top:20px"><v:button id="btn-csv-close" clazz="v-hidden" caption="@Common.Close"/></div>
      </div>
    </div>
    <div id="import-tab-log">
      <div class="tab-toolbar">
        <v:button id="btn-refresh" caption="@Common.Refresh" fa="sync-alt"/>
        <v:pagebox gridId="import-log-grid"/>
      </div>
      <div class="tab-content">
        <% String params = "EntityId=" + JvUtils.newSqlStrUUID(); %>
        <v:async-grid id="import-log-grid" jsp="log/log_grid.jsp" params="<%=params%>"></v:async-grid>
      </div>
    </div>
  </div>
</div>



<style>
  .progressbar-status {
    font-weight: bold;
  }
  
  .progress-block {
    margin-top: 20px;
    margin-bottom: 30px;
  }

  #step-preview {
    min-height: 100px;
  }
  
  #fs-field-separator {
    float: left;
    width: 160px;
    box-sizing: border-box;
  }
  
  #fs-progress {
    position: absolute;
    top: 0;
    left: 170px;
    bottom: 0;
    right: 0;
    box-sizing: border-box;
    text-align: center;
    padding-top: 45px;
  }
  
  #btn-csv-import,
  #btn-csv-close {
    min-width: 120px;
  }
  
  #preview-grid-container {
    height: 375px;
    overflow: auto;
    border: 1px solid #666666;
  }
  
  #preview-grid {
    width: 100%;
    border-spacing: 0;
  }
  
  #preview-grid td {
    border-right: 1px solid #666666;
    padding: 4px;
    font-family: monospace;
  }
  
  #preview-grid td:last-child {
    border-right: 0;
  }
  
  #preview-grid thead td {
    background-color: #dfdfdf;
    font-weight: bold;
  }
  
  #preview-grid tbody td {
    background-color: white;
  }
  
  #preview-grid tbody tr:nth-child(even) td {
    background-color: #f9f9f9;
  }
  
  #preview-grid .column-error {
    color: red;
  }
  
  #preview-grid .column-desc {
    font-style: italic;
  }
</style>


<script>

$(document).ready(function() {
  $("#step-csv-import .tabs").tabs({
    activate: function(event, ui) {
      if (ui.newTab.index() == 0)
        refreshImportLogs();
    }
  });

  function refreshImportLogs() {
    changeGridPage("#import-log-grid", 1);
  }
  
  $("#import-tab-log #btn-refresh, [href='#import-tab-log']").click(refreshImportLogs);
});

var repositoryId = null;
$("[name='FieldSeparator'][value='<%=rights.CSVSeparator.getEmptyString()%>']").prop("checked", "checked");
$("[name='FieldSeparator']").click(doUpdateCsvPreview);

function doCsvImport(repoId) {
  repositoryId = repoId;
  doUpdateCsvPreview();
}

function getFieldSeparator() {
  var result = $("[name='FieldSeparator']:checked").val();
  if (result == "TAB")
    result = "\t";
  return result;
}

function doUpdateCsvPreview() {
  $("#step-csv-preview").addClass("spinner32-bg");

  var reqDO = {
    Command: "CsvImportPreview",
    CsvImportPreview: {
      RepositoryId: repositoryId,
      AsyncProcessClassAlias: <%=JvString.jsString(asyncProcessClassAlias)%>,
      FieldSeparator: getFieldSeparator()
    }
  };
  
  vgsService("AsyncProcess", reqDO, false, function(ansDO) {
    var preview = ansDO.Answer.CsvImportPreview.Preview;
    $("#btn-csv-import").setEnabled(preview.Accept === true);
    
    var thead = $("#preview-grid thead"); 
    thead.empty();
    if ((preview) && (preview.ColumnList)) {
      var tr = $("<tr/>").appendTo(thead); 
      for (var i=0; i<preview.ColumnList.length; i++) {
        var col = preview.ColumnList[i];
        var td = $("<td nowrap/>").appendTo(tr);
        var divName = $("<div class='column-name'/>").appendTo(td);
        var divDesc = $("<div class='column-desc'/>").appendTo(td);
        divName.text(col.ColumnName);
        divDesc.text(col.Description);
        if (!col.Accept)
          divName.addClass("column-error");
      }
    }
    
    var tbody = $("#preview-grid tbody"); 
    tbody.empty();
    if ((preview) && (preview.RecordList)) {
      for (var i=0; i<preview.RecordList.length; i++) {
        var rec = preview.RecordList[i];
        var tr = $("<tr/>").appendTo(tbody);
        if (rec.FieldList) {
          for (var k=0; k<rec.FieldList.length; k++) {
            var field = rec.FieldList[k];
            var td = $("<td nowrap/>").appendTo(tr);
            td.text(field.FieldValue);
          }
        }
      }
    }
    
    $("#step-csv-preview").removeClass("spinner32-bg");
    $("#preview-grid").removeClass("v-hidden");
  });
}

function doCsvGetProcess(asyncProcessId, progressCallback, finishCallBack) {
  setTimeout(function() {
    var reqDO = {
      Command: "GetProcess",
      GetProcess: {
        AsyncProcessId: asyncProcessId
      }
    };
    
    vgsService("AsyncProcess", reqDO, false, function(ansDO) {
      var proc = ansDO.Answer.GetProcess;
      var sSkip = "";
      if (proc.QuantitySkip != 0) 
        sSkip = " - skipped " + proc.QuantitySkip;
      
      var pbar = $("#pb-import");
      pbar.find(".progressbar-status").text(proc.PercComplete + "% completed (" + proc.QuantityPos + " / " + proc.QuantityTot + sSkip + ")");
      pbar.find(".progress-bar").css("width", proc.PercComplete+"%");
      
      if (progressCallback)
        progressCallback(proc);
      
      if ((proc.AsyncProcessStatus != <%=LkSNAsyncProcessStatus.Finished.getCode()%>) && 
          (proc.AsyncProcessStatus != <%=LkSNAsyncProcessStatus.Aborted.getCode()%>)) {
        doCsvGetProcess(asyncProcessId, progressCallback, finishCallBack);
      }
      else if (finishCallBack)
        finishCallBack(proc);
    });
  }, 1000);
}

function doStartCsvImport(progressCallback) {
  if ($("#btn-csv-import").isEnabled()) {
    $("#step-csv-preview").addClass("v-hidden");
    $("#step-csv-import").removeClass("v-hidden");
    
    var reqDO = {
      Command: "CsvImport",
      CsvImport: {
        RepositoryId: repositoryId,
        AsyncProcessClassAlias: <%=JvString.jsString(asyncProcessClassAlias)%>,
        FieldSeparator: getFieldSeparator(),
        Params: functionExists("getImportParams") ? getImportParams() : null
      } 
    };
    
    vgsService("AsyncProcess", reqDO, false, function(ansDO) {
      var asyncProcessId = ansDO.Answer.CsvImport.AsyncProcessId;
      setGridUrlParam("#import-log-grid", "EntityId", asyncProcessId, false);
      doCsvGetProcess(asyncProcessId, progressCallback, function(proc) {
        if (functionExists("csvImportCallback"))
          csvImportCallback(proc);
        $("#btn-csv-close").removeClass("v-hidden");
      });
    });
  }
}

$("#btn-csv-close").click(function() {
  $(this).closest(".ui-dialog-content").dialog("close");
  if (functionExists("csvImportButtonClose"))
    csvImportButtonClose();
});

</script>
