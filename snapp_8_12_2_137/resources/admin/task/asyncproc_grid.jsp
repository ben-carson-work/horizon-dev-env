<%@page import="com.vgs.snapp.dataobject.DOAsyncProcessInfo"%>
<%@page import="com.vgs.snapp.library.AsyncProcessUtils"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_AsyncProcess.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<% 

PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");

List<String> validAbortAsyncProcess = AsyncProcessUtils.getValidAbortProcessClassAliasList();

QueryDef qdef = new QueryDef(QryBO_AsyncProcess.class);
// Select
qdef.addSelect(
    Sel.IconName,
    Sel.CommonStatus,
    Sel.AsyncProcessId,
    Sel.AsyncProcessName,
    Sel.AsyncProcessStatus,
    Sel.WorkstationId,
    Sel.WorkstationName,
    Sel.UserAccountId,
    Sel.UserAccountName,
    Sel.UserAccountEntityType,
    Sel.QuantityTot,
    Sel.QuantityPos,
    Sel.QuantitySkip,
    Sel.StartDateTime,
    Sel.EndDateTime,
    Sel.LogCount,
    Sel.AsyncProcLogCount);
// Where
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(Sel.StartDateTime, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.AsyncProcess%>">
  <thead>
    <tr>
      <td>&nbsp;</td>
      <td width="15%">
        <v:itl key="@Common.Type"/><br/>
        <v:itl key="@Common.Status"/>
      </td>
      <td width="5%">
      </td>
      <td width="20%">
        <v:itl key="@Common.Workstation"/><br/>
        <v:itl key="@Common.User"/>
      </td>
      <td width="20%">
        <v:itl key="@Common.DateTime"/><br/>
        <v:itl key="@Common.End"/>
      </td>
      <td width="10%">
        <v:itl key="@Common.Logs"/>
      </td>
      <td width="15%"></td>
      <td align="right" width="15%">
        Pos / Tot<br/>
        Skipped
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <% LookupItem status = LkSN.AsyncProcessStatus.getItemByCode(ds.getField(Sel.AsyncProcessStatus)); %>
      <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td>
        <%=ds.getField(Sel.AsyncProcessName).getHtmlString()%><br/>
        <span class="list-subtitle"><%=status.getHtmlDescription(pageBase.getLang())%></span>
      </td>
      <td>
        <% if ((status.isLookup(LkSNAsyncProcessStatus.Processing, LkSNAsyncProcessStatus.Waiting)) && validAbortAsyncProcess.contains(ds.getField(Sel.AsyncProcessName).getString())) { %> 
          <% String hRef = "javascript:doAbortProcess('" + ds.getField(Sel.AsyncProcessId).getString() + "')"; %>
          <v:button clazz="row-hover-visible" caption="@Common.Abort" fa="ban" href="<%=hRef%>"/>
        <% } %>
      </td>
      <td>
        <a class="entity-tooltip" data-EntityType="<%=LkSNEntityType.Workstation.getCode()%>" data-EntityId="<%=ds.getField(Sel.WorkstationId).getHtmlString()%>" href="<v:config key="site_url"/>/admin?page=workstation&id=<%=ds.getField(Sel.WorkstationId).getHtmlString()%>"><%=ds.getField(Sel.WorkstationName).getHtmlString()%></a><br/>
        <a class="entity-tooltip" data-EntityType="<%=ds.getField(Sel.UserAccountEntityType).getInt()%>" data-EntityId="<%=ds.getField(Sel.UserAccountId).getHtmlString()%>" href="<v:config key="site_url"/>/admin?page=account&id=<%=ds.getField(Sel.UserAccountId).getHtmlString()%>"><%=ds.getField(Sel.UserAccountName).getHtmlString()%></a>
      </td>
      <td>
        <snp:datetime timestamp="<%=ds.getField(Sel.StartDateTime)%>" format="shortdatetime" timezone="local"/><br/>
        <% if (ds.getField(Sel.EndDateTime).isNull()) { %>
          &nbsp;
        <% } else { %>
          <snp:datetime timestamp="<%=ds.getField(Sel.EndDateTime)%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
        <% } %>        
      </td>
      <td>
        <% if (ds.getField(Sel.LogCount).getInt() > 0) { %>
          <a href="javascript:asyncDialogEasy('log/loglist_dialog', 'EntityId=<%=ds.getField(Sel.AsyncProcessId).getHtmlString()%>')"><v:itl key="@Common.Logs"/></a>
        <% } else if (ds.getField(Sel.AsyncProcLogCount).getInt() > 0) { %>
          <a href="javascript:asyncDialogEasy('task/asyncproc_loglist_dialog', 'AsyncProcessId=<%=ds.getField(Sel.AsyncProcessId).getHtmlString()%>')"><v:itl key="@Common.Logs"/></a>
        <% } %>
      </td>
      <td>
        <% if (status.isLookup(LkSNAsyncProcessStatus.Processing)) { %> 
          <% int perc = Math.round(100f * ds.getField(Sel.QuantityPos).getFloat() / ds.getField(Sel.QuantityTot).getFloat()); %>
          <div class="progress" data-AsyncProcessId="<%=ds.getField(Sel.AsyncProcessId).getHtmlString()%>">
					  <div class="progress-bar progress-bar-success" style="width:<%=perc%>%;"><%=perc%>%</div>
					</div>
         <% } %>  
      </td>
      <td align="right">
        <span class="apq-pos"><%=ds.getField(Sel.QuantityPos).getInt()%></span> / <span class="apq-tot"><%=ds.getField(Sel.QuantityTot).getInt()%></span><br/>
        <span class="list-subtitle apq-skip"><%=ds.getField(Sel.QuantitySkip).getInt()%></span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>

<script>

function doRefreshBars() {
  var bars = $(".progress");
  for (var i=0; i<bars.length; i++) {
	  var asyncProcessId = $(bars[i]).attr("data-AsyncProcessId");
	  if (asyncProcessId) {
	    var reqDO = {
	      Command: "GetProcess",
	      GetProcess: {
	        AsyncProcessId: $(bars[i]).attr("data-AsyncProcessId")
	      }
	    };
	    
	    vgsService("AsyncProcess", reqDO, false, function(ansDO) {
	      ansDO = ansDO.Answer.GetProcess;
	      var bar = $("[data-AsyncProcessId='" + ansDO.AsyncProcessId + "']");
	      if (ansDO.AsyncProcessStatus != <%=LkSNAsyncProcessStatus.Processing.getCode()%>) { 
	        bar.remove();
	        if (ansDO.AsyncProcessStatus != <%=LkSNAsyncProcessStatus.Waiting.getCode()%>)
	          changeGridPage('#asyncproc-grid', 1);
	      }
	      else 
	      {
	        var perc = Math.round(100 * ansDO.QuantityPos / ansDO.QuantityTot);
	        bar.find(".progress-bar").css("width", perc+"%").text(perc+"%");
	        
	        var tr = bar.closest("tr");
	        tr.find(".apq-pos").html(formatAmount(ansDO.QuantityPos, 0));
	        tr.find(".apq-tot").html(formatAmount(ansDO.QuantityTot, 0));
	        tr.find(".apq-skip").html(formatAmount(ansDO.QuantitySkip, 0));
	        
	        setTimeout(doRefreshBars, 1000);
	      }
	    });
    }
  }
}

function doAbortProcess(id) {
	confirmDialog(null, function() {
	   var reqDO = {
	     Command: "AbortProcess",
	     AbortProcess: {
	   	  AsyncProcessIDs: id
	     }
	   };
	   showWaitGlass();
	   vgsService("AsyncProcess", reqDO, false, function(ansDO) {
	     hideWaitGlass();
	     changeGridPage('#asyncproc-grid', 1); 
	   });
	 });
}

$(document).ready(doRefreshBars);

</script>
