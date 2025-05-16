<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Workstation.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_Workstation.class)
    .setPaging(pageBase.getQP(), QueryDef.recordPerPageDefault)
    .addSort(Sel.LocationDisplayName)
    .addSort(Sel.OpAreaDisplayName)
    .addSort(Sel.WorkstationName)
    .addSelect(
        Sel.IconName,
        Sel.CommonStatus,
        Sel.WorkstationId,
        Sel.WorkstationType,
        Sel.WorkstationCode,
        Sel.WorkstationName,
        Sel.WorkstationURI,
        Sel.LocationAccountId,
        Sel.LocationDisplayName,
        Sel.OpAreaAccountId,
        Sel.OpAreaDisplayName,
        Sel.CategoryRecursiveName,
        Sel.StationSerial,
        Sel.LoggedUserAccountId,
        Sel.LoggedUserAccountName,
        Sel.LastClientActivity,
        Sel.LastClientVersion,
        Sel.LastClientIPAddress,
        Sel.Offline);

// Where
if (pageBase.getNullParameter("WorkstationType") != null)
  qdef.addFilter(Fil.WorkstationType, JvArray.stringToArray(pageBase.getNullParameter("WorkstationType"), ","));
else
  qdef.addFilter(Fil.WorkstationType, LookupManager.getIntArray(LkSNWorkstationType.getWorkstationTypes()));

if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if ((pageBase.getNullParameter("CategoryId") != null) && !pageBase.isParameter("CategoryId", "all"))
  qdef.addFilter(Fil.CategoryId, pageBase.getNullParameter("CategoryId"));

if (pageBase.getNullParameter("LocationAccountId") != null)
  qdef.addFilter(Fil.LocationAccountId, pageBase.getNullParameter("LocationAccountId"));

if (pageBase.getNullParameter("OpAreaAccountId") != null)
  qdef.addFilter(Fil.OpAreaAccountId, pageBase.getNullParameter("OpAreaAccountId"));

if (pageBase.getNullParameter("WorkstationStatus") != null)
  qdef.addFilter(Fil.WorkstationStatus, JvArray.stringToArray(pageBase.getNullParameter("WorkstationStatus"), ","));

// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Workstation%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td>#</td>
    <td width="15%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="20%">
      <v:itl key="@Account.Location"/> &raquo; <v:itl key="@Account.OpArea"/><br/>
      <v:itl key="@Category.Category"/>
    </td>
    <td width="35%">
      <v:itl key="@Common.DistributionChannel"/><br/>
      <v:itl key="@Common.WorkstationURI"/>
    </td>
    <td width="15%">
      <v:itl key="@Common.LoggedUser"/><br/>
      <v:itl key="@System.LastActivity"/><br/>
    </td>
    <td width="15%">
      <v:itl key="@System.ClientVersion"/><br/>
      <v:itl key="@Common.IPAddress"/>
    </td>
  </tr>    
  <v:grid-row dataset="ds">
    <% LookupItem wksType = LkSN.WorkstationType.getItemByCode(ds.getField(Sel.WorkstationType)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="WorkstationId" dataset="ds" fieldname="WorkstationId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td><%=ds.getField(Sel.StationSerial).getHtmlString()%></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.WorkstationId).getString()%>" entityType="<%=LkSNEntityType.Workstation%>" clazz="list-title"><%=ds.getField(Sel.WorkstationName).getHtmlString()%></snp:entity-link><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.WorkstationCode).getHtmlString()%></span>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.LocationAccountId).getString()%>" entityType="<%=LkSNEntityType.Location%>"><%=ds.getField(Sel.LocationDisplayName).getHtmlString()%></snp:entity-link>
      &raquo;
      <snp:entity-link entityId="<%=ds.getField(Sel.OpAreaAccountId).getString()%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=ds.getField(Sel.OpAreaDisplayName).getHtmlString()%></snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.CategoryRecursiveName).getHtmlString()%></span>&nbsp;
    </td>
    <td>
      <%=wksType.getHtmlDescription(pageBase.getLang())%><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.WorkstationURI).getHtmlString()%></span>&nbsp;
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.LoggedUserAccountId).getString()%>" entityType="<%=LkSNEntityType.Person%>"><%=ds.getField(Sel.LoggedUserAccountName).getHtmlString()%></snp:entity-link><br/>
      <span class="list-subtitle"><snp:datetime timestamp="<%=ds.getField(Sel.LastClientActivity)%>" format="shortdatetime" timezone="local"/></span>
    </td>
    <td>
      <%=ds.getField(Sel.LastClientVersion).getHtmlString()%><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.LastClientIPAddress).getHtmlString()%></span>
    </td>
  </v:grid-row>
</v:grid>

<script>

function deleteWorkstations() {
  var ids = $("[name='WorkstationId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
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

function createNewWorkstation(workstationType, locationId, opAreaId, categoryId) {
  if (locationId)
    _createNewWorkstation();
  else {
    showLookupDialog({
      EntityType: <%=LkSNEntityType.Location.getCode()%>,
      onPickup: function(item) {
        locationId = item.ItemId;
        _createNewWorkstation();
      }
    });
  }

  function _createNewWorkstation() {
    var params = ["WorkstationType=" + workstationType, "LocationId=" + locationId];
    if (opAreaId)
      params.push("OperatingAreaId=" + opAreaId);
    if (categoryId)
      params.push("CategoryId=" + categoryId);

    var wizTypes = [<%=JvArray.arrayToString(LookupManager.getIntArray(LkSNWorkstationType.getWizardWorkstationTypes()), ",")%>];
    if (wizTypes.indexOf(parseInt(workstationType)) < 0) {
      window.location = "<%=pageBase.getContextURL()%>?page=workstation&id=new&" + params.join("&");
    }
    else
      asyncDialogEasy("workstation/workstation_create_dialog", params.join("&"));
  }
}
</script>
