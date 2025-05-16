<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SeatSector.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
String accessAreaId = pageBase.getNullParameter("AccessAreaId");
QueryDef qdef = new QueryDef(QryBO_SeatSector.class)
    .addSelect(
        Sel.IconName,
        Sel.CommonStatus,
        Sel.SeatSectorId,
        Sel.ParentSectorId,
        Sel.SeatSectorCode,
        Sel.SeatSectorName,
        Sel.SeatMapId,
        Sel.QuantityMax)
    .addFilter(Fil.AcAreaAccountId, pageBase.getNullParameter("AccessAreaId"))
    .addFilter(Fil.ParentSectorId, (String)null)
    .setPaging(pageBase.getQP(), QueryDef.recordPerPageDefault)
    .addSort(Sel.SeatSectorName);

JvDataSet ds = pageBase.execQuery(qdef);
%>

  <v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.SeatSector%>">
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td></td>
        <td width="20%">
          <v:itl key="@Common.Name"/><br/>
          <v:itl key="@Common.Type"/>
        </td>
        <td width="80%"><v:itl key="@Common.Quantity"/></td>
      </tr>
    </thead>
    <tbody>
      <% boolean seatmap = false; %>
      <v:grid-row dataset="<%=ds%>">
        <%
        LookupItem sectorType = LkSN.SeatSectorType.getItemByCode(ds.getField(Sel.SeatSectorType)); 
        String href = null;
        if (sectorType.isLookup(LkSNSeatSectorType.Capacity))
          href = "javascript:asyncDialogEasy('seat/seat_capacity_dialog', 'id=" + ds.getField(Sel.SeatSectorId).getHtmlString() + "&AccessAreaId=" + accessAreaId + "')";
        else if (sectorType.isLookup(LkSNSeatSectorType.Map))
          href = "javascript:asyncDialogEasy('seat/seat_map_dialog', 'id=" + ds.getField(Sel.SeatMapId).getHtmlString() + "&AccessAreaId=" + accessAreaId + "')";
        %>

        <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="SeatSectorId" dataset="<%=ds%>" fieldname="SeatSectorId"/></td>
        <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
        <td>
          <a href="<%=href%>" class="list-title"><%=ds.getField(Sel.SeatSectorName).getHtmlString()%></a><br/>
          <span class="list-subtitle"><%=sectorType.getHtmlDescription(pageBase.getLang())%></span>
        </td>
        <td><%=ds.getField(Sel.QuantityMax).getHtmlString()%></td>
      </v:grid-row>
    </tbody>
  </v:grid>
