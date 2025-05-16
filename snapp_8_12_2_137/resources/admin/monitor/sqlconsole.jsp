<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.bko.page.PageBO_SqlConsole" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<script src="<v:config key="site_url"/>/libraries/codemirror/lib/codemirror.js"></script>
<link rel="stylesheet" href="<v:config key="site_url"/>/libraries/codemirror/lib/codemirror.css"/>
<script src="<v:config key="site_url"/>/libraries/codemirror/mode/sql/sql.js"></script>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Profile" default="true">
    <div class="tab-toolbar">
      <v:button fa="bolt" caption="Execute" onclick="doExecute()"/>
    </div>
    
    <div id="main-container" class="tab-content">
      <div id="editor-container"></div>
      <div id="result-container"></div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<style>
  .CodeMirror {
    border: 1px solid var(--tab-border-color);
  }
  
  .ui-resizable-s {
    height: 12px;
    background-color: var(--pagetitle-bg-color);
    border-top: 1px solid var(--tab-border-color);
  }
  
  #result-container {
    min-height: 100px;
    margin-top: 10px;
  }
</style>

<script>

var cmDataSource = null;
$(document).ready(function() {
  cmDataSource = CodeMirror($("#editor-container")[0], {
    mode: "text/x-mysql",
    lineNumbers: true
  });

  $(".CodeMirror").resizable({
    handles: "s"
  });
});

function doExecute() {
  var cont = $("#result-container");
  cont.empty().append("<p style='text-align:center;opacity:0.5'><i class='fa fa-circle-notch fa-spin fa-3x fa-fw'></i></p>");
  
  var sql = cmDataSource.getSelection();
  if (sql == "")
	  sql = cmDataSource.getValue();
  
  $.ajax({
	  "url": BASE_URL + "/admin?page=sqlconsole&action=execute&ts=" + (new Date()).getTime(), 
    "type": "POST",
    "data": "sql=" + encodeURIComponent(sql),
	  "success": function(result) {
      cont.html(result);
    }
  });
}

$(document).keydown(function(event) {
	var KEY_F5 = 116;
	if ((event.keyCode == KEY_F5) && !event.ctrlKey) {
    event.preventDefault();
	  event.stopPropagation();
	  doExecute();
	}
});

</script>

<jsp:include page="/resources/common/footer.jsp"/>
