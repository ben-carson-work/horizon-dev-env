<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Event.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>


<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Event.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.EventId);
qdef.addSelect(Sel.EventCode);
qdef.addSelect(Sel.EventName);
qdef.addSelect(Sel.EventType);
qdef.addSelect(Sel.EventStatus);
qdef.addSelect(Sel.OnSaleFrom);
qdef.addSelect(Sel.OnSaleTo);
qdef.addSelect(Sel.ProfilePictureId);
qdef.addSelect(Sel.ParentEntityType);
qdef.addSelect(Sel.AccountId);
qdef.addSelect(Sel.AccountDisplayName);
qdef.addSelect(Sel.CategoryRecursiveName);
qdef.addSelect(Sel.TagNames);
// Where
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if (pageBase.getNullParameter("AccountId") != null)
  qdef.addFilter(Fil.AccountId, pageBase.getNullParameter("AccountId"));

if ((pageBase.getNullParameter("CategoryId") != null) && !pageBase.isParameter("CategoryId", "all"))
  qdef.addFilter(Fil.CategoryId, pageBase.getNullParameter("CategoryId"));

if ((pageBase.getNullParameter("EventStatus") != null))
  qdef.addFilter(Fil.EventStatus, JvArray.stringToArray(pageBase.getNullParameter("EventStatus"), ","));

if ((pageBase.getNullParameter("EventType") != null))
  qdef.addFilter(Fil.EventType, JvArray.stringToArray(pageBase.getNullParameter("EventType"), ","));

if ((pageBase.getNullParameter("TagId") != null))
  qdef.addFilter(Fil.TagId, JvArray.stringToArray(pageBase.getNullParameter("TagId"), ","));

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(Sel.EventName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid id="event-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Event%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="15%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="25%">
      <v:itl key="@Common.Parent"/><br/>
      <v:itl key="@Category.Category"/>
    </td>
    <td width="25%">
      <v:itl key="@Common.Type"/><br/>
      <v:itl key="@Common.Tags"/>
    </td>
    <td width="35%" align="right">
      <v:itl key="@Common.Status"/><br/>
      <v:itl key="@Common.OnSaleFromTo"/>
    </td>
  </tr>
  <v:grid-row dataset="ds">
    <% LookupItem eventType = LkSN.EventType.getItemByCode(ds.getField(Sel.EventType)); %>
    <% LookupItem eventStatus = LkSN.EventStatus.getItemByCode(ds.getField(Sel.EventStatus)); %>
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="EventId" dataset="ds" fieldname="EventId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>" repositoryId="<%=ds.getField(Sel.ProfilePictureId).getString()%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.EventId)%>" entityType="<%=LkSNEntityType.Event%>" clazz="list-title">
        <%=ds.getField(Sel.EventName).getHtmlString()%>
      </snp:entity-link>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.EventCode).getHtmlString()%>&nbsp;</span>
    </td>
    <td>
      <% LookupItem parentEntityType = LkSN.EntityType.findItemByCode(ds.getField(Sel.ParentEntityType)); %>
      <% if (ds.getField(Sel.AccountId).isNull() || (parentEntityType == null)) { %>
        <span class="list-subtitle"><v:itl key="@Common.None"/></span>
      <% } else { %>
        <% String hrefParent = BLBO_PagePath.getUrl(pageBase, parentEntityType, ds.getField(Sel.AccountId).getString()); %>
        <a href="<%=hrefParent%>"><%=ds.getField(Sel.AccountDisplayName).getHtmlString()%></a> 
        <span class="list-subtitle">(<%=parentEntityType.getHtmlDescription(pageBase.getLang())%>)</span>
      <% } %>
      <br/>
      <span class="list-subtitle"><%=ds.getField(Sel.CategoryRecursiveName).getHtmlString()%>&nbsp;</span>
    </td>
    <td>
      <%=eventType.getHtmlDescription(pageBase.getLang())%><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.TagNames).getHtmlString()%></span>&nbsp;
    </td>
    <td align="right">
      <%=eventStatus.getHtmlDescription(pageBase.getLang())%><br/>
      <span class="list-subtitle">
        <% if (ds.getField(Sel.OnSaleFrom).isNull()) { %><v:itl key="@Common.Unlimited"/><% } else { %><%=ds.getField(Sel.OnSaleFrom).getHtmlString()%><% } %>
        /
        <% if (ds.getField(Sel.OnSaleTo).isNull()) { %><v:itl key="@Common.Unlimited"/><% } else { %><%=ds.getField(Sel.OnSaleTo).getHtmlString()%><% } %>
      </span> 
    </td>
  </v:grid-row>
</v:grid>
