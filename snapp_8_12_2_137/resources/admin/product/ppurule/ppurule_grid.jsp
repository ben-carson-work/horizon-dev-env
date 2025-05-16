<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_PPURule.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_PPURule.class)
    .addFilter(Fil.GenericOnly, "true")
    .addSort(Sel.PriorityOrder)
    .setPaging(pageBase.getQP(), QueryDef.recordPerPageDefault)
    .addSelect(
        Sel.IconName,
        Sel.CommonStatus,
        Sel.PPURuleId,
        Sel.MembershipPointId,
        Sel.MembershipPointCode,
        Sel.MembershipPointName,
        Sel.MembershipPointValue,
        Sel.LocationId,
        Sel.LocationName,
        Sel.OpAreaId,
        Sel.OpAreaName,
        Sel.AccessPointId,
        Sel.AccessPointName,
        Sel.EventNames,
        Sel.ProductTagNames,
        Sel.CalendarId,
        Sel.CalendarName,
        Sel.ValidDateFrom,
        Sel.ValidDateTo,
        Sel.ValidTimeFrom,
        Sel.ValidTimeTo,
        Sel.Active);

//Filter
if (pageBase.getNullParameter("MembershipPointId") != null)
  qdef.addFilter(Fil.MembershipPointId, pageBase.getNullParameter("MembershipPointId"));

if (pageBase.getNullParameter("PPURuleStatus") != null)
  qdef.addFilter(Fil.Active, JvArray.stringToArray(pageBase.getNullParameter("PPURuleStatus"), ","));

if (pageBase.getNullParameter("LocationId") != null)
  qdef.addFilter(Fil.LocationId, pageBase.getNullParameter("LocationId"));

if (pageBase.getNullParameter("OpAreaId") != null)
  qdef.addFilter(Fil.OpAreaId, pageBase.getNullParameter("OpAreaId"));

if (pageBase.getNullParameter("AccessPointId") != null)
  qdef.addFilter(Fil.AccessPointId, pageBase.getNullParameter("AccessPointId"));

if (pageBase.getNullParameter("EventIDs") != null)
  qdef.addFilter(Fil.EventIDs, JvArray.stringToArray(pageBase.getNullParameter("EventIDs"), ","));

if (pageBase.getNullParameter("ProductTagIDs") != null)
  qdef.addFilter(Fil.ProductTagIDs, JvArray.stringToArray(pageBase.getNullParameter("ProductTagIDs"), ","));

JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.RewardPointRule%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Account.Location"/> &raquo; <v:itl key="@Account.OpArea"/> 
        <br/>
        <v:itl key="@AccessPoint.AccessPoint"/>
      </td>
      <td width="20%">
        <v:itl key="@Event.Events"/>
        <br/>
        <v:itl key="@Product.ProductTypes"/>
      </td>
      <td width="20%">
        <v:itl key="@Common.Calendar"/>
      </td>
      <td width="20%">
        <v:itl key="@Common.DateRange"/>
        <br/>
        <v:itl key="@Common.TimeRange"/>
      </td>
      <td width="20%" align="right">
        <v:itl key="@Product.MembershipPoint"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="PPURuleId" dataset="ds" fieldname="PPURuleId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td nowrap>
        <snp:entity-link entityId="<%=ds.getField(Sel.PPURuleId).getString()%>" entityType="<%=LkSNEntityType.RewardPointRule%>" entityTooltip="false" clazz="list-title">
          # <%=ds.getField(Sel.PriorityOrder).getHtmlString()%>
        </snp:entity-link>
      </td>
      <td>
        <% if (ds.getField(Sel.LocationId).isNull()) { %>
          <span class="list-subtitle"><v:itl key="@Common.All"/></span>
        <% } else { %>
          <snp:entity-link entityId="<%=ds.getField(Sel.LocationId).getString()%>" entityType="<%=LkSNEntityType.Location%>">
            <%=ds.getField(Sel.LocationName).getHtmlString()%>
          </snp:entity-link>
          
          <% if (!ds.getField(Sel.OpAreaId).isNull()) { %>
            &raquo;
            <snp:entity-link entityId="<%=ds.getField(Sel.OpAreaId).getString()%>" entityType="<%=LkSNEntityType.OperatingArea%>">
              <%=ds.getField(Sel.OpAreaName).getHtmlString()%>
            </snp:entity-link>
          <% } %>
        <% } %>
        <br/>
        <% if (ds.getField(Sel.AccessPointId).isNull()) { %>
          <span class="list-subtitle"><v:itl key="@Common.All"/></span>
        <% } else { %>
          <snp:entity-link entityId="<%=ds.getField(Sel.AccessPointId).getString()%>" entityType="<%=LkSNEntityType.AccessPoint%>">
            <%=ds.getField(Sel.AccessPointName).getHtmlString()%>
          </snp:entity-link>
        <% } %>
      </td>
      <td>
        <span class="list-subtitle">
          <% if (ds.getField(Sel.EventNames).isNull()) { %>
            <v:itl key="@Common.All"/>
          <% } else { %>
            <%=ds.getField(Sel.EventNames).getHtmlString()%>
          <% } %>
          <br/>
          <% if (ds.getField(Sel.ProductTagNames).isNull()) { %>
            <v:itl key="@Common.All"/>
          <% } else { %>
            <%=ds.getField(Sel.ProductTagNames).getHtmlString()%>
          <% } %>
        </span>
      </td>
      <td>
        <% if (ds.getField(Sel.CalendarId).isNull()) { %>
          <span class="list-subtitle"><v:itl key="@Common.Always"/></span>
        <% } else { %>
          <snp:entity-link entityId="<%=ds.getField(Sel.CalendarId).getString()%>" entityType="<%=LkSNEntityType.Calendar%>">
            <%=ds.getField(Sel.CalendarName).getHtmlString()%>
          </snp:entity-link>
        <% } %>
      </td>
      <td>
        <span class="list-subtitle">
          <% if (ds.getField(Sel.ValidDateFrom).isNull() && ds.getField(Sel.ValidDateTo).isNull()) { %>
            <v:itl key="@Common.AnyDate"/>
          <% } else { %>
            <% if (!ds.getField(Sel.ValidDateFrom).isNull()) { %>
              <v:itl key="@Common.From"/> <%=pageBase.format(ds.getField(Sel.ValidDateFrom), pageBase.getShortDateFormat()) %>
            <% } %>
            <% if (!ds.getField(Sel.ValidDateTo).isNull()) { %>
              <v:itl key="@Common.To"/> <%=pageBase.format(ds.getField(Sel.ValidDateTo), pageBase.getShortDateFormat()) %>
            <% } %>
          <% } %>
          <br/>
          <% if (ds.getField(Sel.ValidTimeFrom).isNull() && ds.getField(Sel.ValidTimeTo).isNull()) { %>
            <v:itl key="@Common.AnyTime"/>
          <% } else { %>
            <% if (!ds.getField(Sel.ValidTimeFrom).isNull()) { %>
              <v:itl key="@Common.From"/> <%=pageBase.format(ds.getField(Sel.ValidTimeFrom), pageBase.getShortTimeFormat()) %>
            <% } %>
            <% if (!ds.getField(Sel.ValidTimeTo).isNull()) { %>
              <v:itl key="@Common.To"/> <%=pageBase.format(ds.getField(Sel.ValidTimeTo), pageBase.getShortTimeFormat()) %>
            <% } %>
          <% } %>
        </span>
      </td>
      <td align="right">
        <snp:entity-link entityId="<%=ds.getField(Sel.MembershipPointId).getString()%>" entityType="<%=LkSNEntityType.RewardPoint%>"><%=ds.getField(Sel.MembershipPointName).getHtmlString()%></snp:entity-link><br/>
        <% if (ds.getField(Sel.MembershipPointId).isSameString(BLBO_DBInfo.getSystemPointId_Wallet())) { %>
          <%=pageBase.formatCurrHtml(ds.getField(Sel.MembershipPointValue))%>
        <% } else { %>
          <%=ds.getField(Sel.MembershipPointValue).getHtmlString()%>
        <% } %>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>