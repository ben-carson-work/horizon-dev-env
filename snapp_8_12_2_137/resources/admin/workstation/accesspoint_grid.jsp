<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Workstation.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_Workstation.class);
// Select
qdef.addSelect(
    Sel.IconName,
    Sel.WorkstationId,
    Sel.WorkstationType,
    Sel.WorkstationCode,
    Sel.WorkstationName,
    Sel.LocationAccountId,
    Sel.LocationDisplayName,
    Sel.OpAreaAccountId,
    Sel.OpAreaDisplayName,
    Sel.CategoryRecursiveName,
    Sel.AptControllerWorkstationId,
    Sel.AptControllerWorkstationName,
    Sel.AptCounterMode,
    Sel.AptEntryControl,
    Sel.AptExitControl,
    Sel.AptReentryControl,
    Sel.AptEntryCount,
    Sel.AptExitCount,
    Sel.AptHardwareCode,
    Sel.AptAccessAreaNames,
    Sel.AptTagIDs,
    Sel.AptTagNames);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
if (pageBase.getNullParameter("MonitorWorkstationId") != null) {
  qdef.addFilter(Fil.MonitorWorkstationId, pageBase.getNullParameter("MonitorWorkstationId"));
  qdef.addSort(Sel.MoniteredAccessPointPriorityOrder);
}
else {
  qdef.addSort(Sel.LocationDisplayName);
  qdef.addSort(Sel.OpAreaDisplayName);
  qdef.addSort(Sel.WorkstationName);
}
// Where
qdef.addFilter(Fil.WorkstationType, LkSNWorkstationType.APT.getCode());

if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if ((pageBase.getNullParameter("CategoryId") != null) && !pageBase.isParameter("CategoryId", "all"))
  qdef.addFilter(Fil.CategoryId, pageBase.getNullParameter("CategoryId"));

if (pageBase.getNullParameter("LocationAccountId") != null)
  qdef.addFilter(Fil.LocationAccountId, pageBase.getNullParameter("LocationAccountId"));

if (pageBase.getNullParameter("OpAreaAccountId") != null)
  qdef.addFilter(Fil.OpAreaAccountId, pageBase.getNullParameter("OpAreaAccountId"));

if (pageBase.getNullParameter("AptControllerWorkstationId") != null)
  qdef.addFilter(Fil.AptControllerWorkstationId, pageBase.getNullParameter("AptControllerWorkstationId"));

if ((pageBase.getNullParameter("TagId") != null))
  qdef.addFilter(Fil.AptTagId, JvArray.stringToArray(pageBase.getNullParameter("TagId"), ","));

// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>


<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Workstation%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="15%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="20%">
      <v:itl key="@Account.Location"/> &raquo; <v:itl key="@Account.OpArea"/><br/>
      <v:itl key="@Category.Category"/>
    </td>
    <td width="25%">
      <v:itl key="@AccessPoint.Controller"/><br/>
      <v:itl key="@Account.AccessAreas"/>
    </td>
    <td width="65%">
      <v:itl key="@Common.Tags"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <td><v:grid-checkbox name="WorkstationId" dataset="ds" fieldname="WorkstationId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <a href="<v:config key="site_url"/>/admin?page=workstation&id=<%=ds.getField(Sel.WorkstationId).getHtmlString()%>" class="list-title"><%=ds.getField(Sel.WorkstationName).getHtmlString()%></a><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.WorkstationCode).getHtmlString()%></span>
    </td>
    <td>
      <a href="<v:config key="site_url"/>/admin?page=account&id=<%=ds.getField(Sel.LocationAccountId).getEmptyString()%>"><%=ds.getField(Sel.LocationDisplayName).getHtmlString()%></a> &raquo;
      <a href="<v:config key="site_url"/>/admin?page=account&id=<%=ds.getField(Sel.OpAreaAccountId).getEmptyString()%>"><%=ds.getField(Sel.OpAreaDisplayName).getHtmlString()%></a><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.CategoryRecursiveName).getHtmlString()%></span>&nbsp;
    </td>
    <td>
      <% if (ds.getField(Sel.AptControllerWorkstationId).isNull()) { %>
        -
      <% } else { %>
        <a href="<v:config key="site_url"/>/admin?page=workstation&id=<%=ds.getField(Sel.AptControllerWorkstationId).getHtmlString()%>"><%=ds.getField(Sel.AptControllerWorkstationName).getHtmlString()%></a>
      <% } %>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.AptAccessAreaNames).getHtmlString()%>&nbsp;</span>
    </td>
    <td>
      <span class="list-subtitle"><%=ds.getField(Sel.AptTagNames).getHtmlString()%></span>&nbsp;
    </td>
  </v:grid-row>
</v:grid>

<script>

function showAptMultiEditDialog() {
  var AptIDs = $("[name='WorkstationId']").getCheckedValues();
  if (AptIDs.length == 0)
    showMessage(itl("@Common.NoElementWasSelected"));
  else {
    var dlg = $("<div title='<v:itl key="@AccessPoint.AptMultiEdit"/>'/>").appendTo("body");
    asyncLoad(dlg, "<v:config key="site_url"/>/admin?page=accesspoint_multiedit_dlg");

    dlg.dialog({
      modal: true,
      width: 500,
      height: 600,
      close: function() {
        dlg.remove();
      },
      buttons: {
        "<v:itl key="@Common.Ok"/>": function() {
          dlg.dialog("close");

          var reqDO = {
            Command: "MultiEdit",
            MultiEdit: {
              WorkstationIDs: $("[name='WorkstationId']:checked").map(function () {return this.value;}).get().join(","),
              CategoryId: dlg.find("[name='CategoryId']").val(),
              AptControllerWorkstationId: dlg.find("[name='AptControllerWorkstationId']").val(),
              RemoveControllerWks: dlg.find("[name='RemoveControllerWks']").is(':checked'),
              AptEntryControl: dlg.find("[name='AptEntryControl']").val(),
              AptExitControl: dlg.find("[name='AptExitControl']").val(),
              AptReentryControl: dlg.find("[name='AptReentryControl']").val(),
              AptRewardingPoints: dlg.find("[name='AptRewardingPoints']").val(),
              AptDoubleReadDelay: dlg.find("[name='AptDoubleReadDelay']").val(),
              AptCounterMode: dlg.find("[name='AptCounterMode']").val(),
              QueueControl: dlg.find("[name='QueueControl']").is(':checked')
            }
          };
          
          if (dlg.find("[name='Tags']").isChecked()) {
            reqDO.MultiEdit.AptTagOperation = dlg.find("[name='TagOperation']:checked").val();
            reqDO.MultiEdit.AptTagIDs = dlg.find("[name='AptTagIDs']").getStringArray();
          }
          
          vgsService("Workstation", reqDO, false, function(ansDO) {
            var msg =
              "<v:itl key='@Common.MultiEditModified'/>: " + coalesce([ansDO.Answer.MultiEdit.ModifiedCount, 0]) +
              "\n<v:itl key='@Common.MultiEditSkipped'/>: " + coalesce([ansDO.Answer.MultiEdit.SkippedCount, 0]);
              
            if (ansDO.Answer.LastError)
              msg += "<br/>LastError: " + ansDO.Answer.LastError; 
   
            triggerEntityChange(<%=LkSNEntityType.Workstation.getCode()%>);
            
            showMessage(msg);
          });
        },
        "<v:itl key="@Common.Cancel"/>": function() {
          $(this).dialog("close");
        }
      }
    });
  }
}

function deleteWorkstations() {
  var ids = $("[name='WorkstationId']").getCheckedValues();
  if (ids == "")
    showMessage(itl("@Common.NoElementWasSelected"));
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteWorkstation",
        DeleteWorkstation: {
          WorkstationIDs: ids
        }
      };

      showWaitGlass();
      vgsService("Workstation", reqDO, false, function(ansDO) {
        hideWaitGlass();
        triggerEntityChange(<%=LkSNEntityType.Workstation.getCode()%>);
      });
    });  
  }
}


</script>


