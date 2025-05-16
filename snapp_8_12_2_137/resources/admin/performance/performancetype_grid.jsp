<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_PerformanceType.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

  
<%
QueryDef qdef = new QueryDef(QryBO_PerformanceType.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.PerformanceTypeId);
qdef.addSelect(Sel.PerformanceTypeCode);
qdef.addSelect(Sel.PerformanceTypeName);
qdef.addSelect(Sel.PerformanceTypeColor);
qdef.addSelect(Sel.ValidFrom);
qdef.addSelect(Sel.ValidTo);
qdef.addSelect(Sel.ParentEntityType);
qdef.addSelect(Sel.ParentEntityId);
qdef.addSelect(Sel.ParentEntityName);
qdef.addSelect(Sel.PriceActionType);
qdef.addSelect(Sel.PriceValueType);
qdef.addSelect(Sel.PriceValue);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Where
if (pageBase.getNullParameter("ParentEntityId") != null)
  qdef.addFilter(Fil.ParentEntityId, pageBase.getNullParameter("ParentEntityId"));
// Sort
qdef.addSort(Sel.PerformanceTypeName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>  
  
<style>
.ptype-color {
  width: 24px;
  height: 24px;
  border: 1px solid rgba(0,0,0,0.25);
}
</style>
<v:grid id="perftype-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.PerformanceType%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="20%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="20%">
      <v:itl key="@Common.Parent"/>
    </td>
    <td width="20%">
      <v:itl key="@Common.Validity"/>
    </td>
    <td width="40%" align="right">
      <v:itl key="@Product.PriceRule"/>
    </td>
    <td>&nbsp;</td>
  </tr>
  <v:grid-row dataset="ds">
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="perfType.PerformanceTypeId" dataset="ds" fieldname="PerformanceTypeId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <a href="admin?page=performancetype&id=<%=ds.getField(Sel.PerformanceTypeId).getHtmlString()%>" class="list-title" title="<v:itl key="@Common.Edit"/> &ldquo;<%=ds.getField(QryBO_PerformanceType.Sel.PerformanceTypeName).getEmptyString()%>&rdquo;"><%=ds.getField(QryBO_PerformanceType.Sel.PerformanceTypeName).getEmptyString()%></a><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.PerformanceTypeCode).getHtmlString()%></span>
    </td>
    <td>
      <% if (!ds.getField(Sel.ParentEntityId).isNull()) { %>
        <% String hrefParent = BLBO_PagePath.getUrl(pageBase, ds.getField(Sel.ParentEntityType).getInt(), ds.getField(Sel.ParentEntityId).getString()); %>
        <a href="<%=hrefParent%>"><%=ds.getField(Sel.ParentEntityName).getHtmlString()%></a>&nbsp;<br/>
        <span class="list-subtitle"><%=LkSN.EntityType.findItemDescriptionHtml(ds.getField(Sel.ParentEntityType).getInt(), pageBase.getLang())%>&nbsp;</span>
      <% } %>
    </td>
    <td>
      <%
        JvDateTime validFrom = ds.getField(Sel.ValidFrom).getDateTime();
      %>
      <%
        JvDateTime validTo = ds.getField(Sel.ValidTo).getDateTime();
      %>
      <% if ((validFrom == null) && (validTo == null)) { %>
        <span class="list-subtitle"><v:itl key="@Common.Unlimited"/></span>
      <% } else { %>
        <% if (validFrom != null) { %>
          <v:itl key="@Common.From"/> <%=pageBase.format(validFrom, pageBase.getShortDateFormat())%>
        <% } %>
        <% if (validTo != null) { %>
          <v:itl key="@Common.To"/> <%=pageBase.format(validTo, pageBase.getShortDateFormat())%>
        <% } %>
      <% } %>
    </td>
    <td align="right">
      <% int actionType = ds.getField(Sel.PriceActionType).getInt(); %>
      <% int valueType = ds.getField(Sel.PriceValueType).getInt(); %>
      <% if (actionType == LkSNPriceActionType.NotSellable.getCode()) { %>
        <span class="list-subtitle"><v:itl key="@Common.None"/></span>
      <% } else { %>
        <%=BLBO_PriceRule.getActionSymbol(actionType)%> <%=ds.getField(Sel.PriceValue).getHtmlString()%><%=BLBO_PriceRule.getValueSymbol(valueType)%>
      <% } %>
    </td>
    <td>
      <% String color = ds.getField(Sel.PerformanceTypeColor).getHtmlString(); %>
      <div class="ptype-color" style="background-color:#<%=color%>"></div>
    </td>
  </v:grid-row>
</v:grid>

<script>
function deleteSeatEnvelopes() {
  var ids = $("[name='SeatEnvelopeId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteEnvelope",
        DeleteEnvelope: {
          SeatEnvelopeIDs: ids
        }
      };
      
      vgsService("Seat", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.SeatEnvelope.getCode()%>);
      });
    });
  }
}
</script>
 