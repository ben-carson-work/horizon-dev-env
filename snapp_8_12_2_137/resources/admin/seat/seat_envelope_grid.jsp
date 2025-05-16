<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_SeatEnvelope.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_SeatEnvelope.class)
    .setPaging(pageBase.getQP(), QueryDef.recordPerPageDefault)
    .addSort(Sel.SeatEnvelopeName)
    .addSelect(
        Sel.IconName,
        Sel.SeatEnvelopeId,
        Sel.SeatEnvelopeCode,
        Sel.SeatEnvelopeName,
        Sel.SeatEnvelopeColor,
        Sel.ExclusiveUse,
        Sel.Extra,
        Sel.SwapHours,
        Sel.SwapSeatEnvelopeId,
        Sel.SwapSeatEnvelopeName,
        Sel.SeatEnvelopePriority);

JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<style>
.envelope-color {
  width: 24px;
  height: 24px;
  border: 1px solid rgba(0,0,0,0.25);
}
</style>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.SeatEnvelope%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="20%">
        <v:itl key="@Common.Options"/><br/>
        <v:itl key="@Common.Priority"/>
      </td>
      <td width="20%">
        <v:itl key="@Seat.AllotmentRelease"/>
      </td>
      <td width="40%">
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <td><v:grid-checkbox name="SeatEnvelopeId" dataset="ds" fieldname="SeatEnvelopeId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.SeatEnvelopeId).getString()%>" entityType="<%=LkSNEntityType.SeatEnvelope%>" clazz="list-title">
          <%=ds.getField(Sel.SeatEnvelopeName).getHtmlString()%>
        </snp:entity-link>
        <br/>
        <span class="list-subtitle"><%=ds.getField(Sel.SeatEnvelopeCode).getHtmlString()%></span>&nbsp;
      </td>
      <td>
        <div class="list-subtitle">
          <%
          List<String> options = new ArrayList<>();
          if (ds.getField(Sel.ExclusiveUse).getBoolean())
            options.add(pageBase.getLang().Seat.EnvelopeExclusiveUse.getHtmlText());
          if (ds.getField(Sel.Extra).getBoolean())
            options.add(pageBase.getLang().Seat.EnvelopeExtra.getHtmlText());
          if (options.isEmpty())
            options.add("&mdash;");
          %>
          <%=JvArray.arrayToString(options, ", ")%>
        </div>
        <div class="list-subtitle">
          <% if (ds.getField(Sel.SeatEnvelopePriority).isNull()) { %>
            &nbsp;
          <% } else { %>
            <%=ds.getField(Sel.SeatEnvelopePriority).getHtmlString()%>
          <% } %>
        </div>
      </td>
      <td>
        <% if (!ds.getField(Sel.SwapSeatEnvelopeId).isNull()) { %>
          <snp:entity-link entityId="<%=ds.getField(Sel.SwapSeatEnvelopeId).getString()%>" entityType="<%=LkSNEntityType.SeatEnvelope%>">
            <%=ds.getField(Sel.SwapSeatEnvelopeName).getHtmlString()%>
          </snp:entity-link>
          <br/>
          <span class="list-subtitle"><%=ds.getField(Sel.SwapHours).getHtmlString()%></span>&nbsp;
        <% } %>
      </td>
      <td align="right">
        <% String color = ds.getField(Sel.SeatEnvelopeColor).getHtmlString(); %>
        <div class="envelope-color" style="background-color:#<%=color%>"></div>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    