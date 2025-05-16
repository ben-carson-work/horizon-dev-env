<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Message.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Message.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.MessageId);
qdef.addSelect(Sel.ForcePopupDialog);
qdef.addSelect(Sel.MessageName);
qdef.addSelect(Sel.DateTimeFrom);
qdef.addSelect(Sel.DateTimeTo);
qdef.addSelect(Sel.CreateDateTime);
qdef.addSelect(Sel.CreateAccountId);
qdef.addSelect(Sel.CreateAccountName);
qdef.addSelect(Sel.MessageName);
qdef.addSelect(Sel.CategoryId);
qdef.addSelect(Sel.CategoryRecursiveName);

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Filter
qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));
if ((pageBase.getNullParameter("CategoryId") != null) && !pageBase.isParameter("CategoryId", "all"))
  qdef.addFilter(Fil.CategoryId, pageBase.getNullParameter("CategoryId"));
// Sort
qdef.addSort(Sel.DateTimeFrom, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Message%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Options"/>
      </td>
      <td width="20%">
        <v:itl key="@Category.Category"/>
      </td>
      <td width="20%">
        <v:itl key="@Common.From"/><br/>
        <v:itl key="@Common.To"/>
      </td>
      <td width="40%">
        <v:itl key="@Common.CreatedBy"/><br/>
        <v:itl key="@Common.DateTime"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="MessageId" dataset="ds" fieldname="MessageId"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.MessageId).getString()%>" entityType="<%=LkSNEntityType.Message%>" clazz="list-title">
          <%=ds.getField(Sel.MessageName).getHtmlString()%>
        </snp:entity-link>
        <br/>
        <span class="list-subtitle">
          <% if (ds.getField(Sel.ForcePopupDialog).getBoolean()) { %>
            <v:itl key="@Common.MessageForcePopupDialog"/>
          <% } else { %>
            -
          <% } %>
        </span>&nbsp;
      </td>
      <td>
        <span class="list-subtitle"><%=ds.getField(Sel.CategoryRecursiveName).getHtmlString()%>&nbsp;</span>
      </td>
      <td>
        <snp:datetime timestamp="<%=ds.getField(Sel.DateTimeFrom)%>" format="shortdatetime" timezone="location" convert="false"/><br/>
        <% if (ds.getField(Sel.DateTimeTo).isNull()) { %>
          <span class="list-subtitle"><v:itl key="@Common.Unlimited"/></span>
        <% } else { %>
          <snp:datetime timestamp="<%=ds.getField(Sel.DateTimeTo)%>" format="shortdatetime" timezone="location" convert="false" clazz="list-subtitle"/>
        <% } %>
      </td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.CreateAccountId)%>" entityType="<%=LkSNEntityType.Person%>">
          <%=ds.getField(Sel.CreateAccountName).getHtmlString()%>
        </snp:entity-link>
        <br/>
        <snp:datetime timestamp="<%=ds.getField(Sel.CreateDateTime)%>" timezone="local" format="shortdatetime" clazz="list-subtitle"/>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    