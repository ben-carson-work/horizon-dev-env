<%@page import="com.vgs.snapp.dataobject.DOServerProfileRef"%>
<%@page import="com.vgs.snapp.search.dataobject.DOServerProfileSearchAnswer"%>
<%@page import="com.vgs.web.library.BLBO_ServerProfile"%>
<%@page import="com.vgs.snapp.search.dataobject.DOServerProfileSearchRequest"%>
<%@page import="com.vgs.web.library.BLBO_DBInfo"%>
<%@page import="com.vgs.cl.document.JvFieldNode"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_ServerProfile.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
DOServerProfileSearchRequest reqDO = new DOServerProfileSearchRequest();  

// Paging
reqDO.SearchRecapRequest.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecapRequest.RecordPerPage.setInt(QueryDef.recordPerPageDefault);

// Exec
DOServerProfileSearchAnswer ansDO = new DOServerProfileSearchAnswer();  
pageBase.getBL(BLBO_ServerProfile.class).searchServerProfile(reqDO, ansDO);
%>

<v:grid search="<%=ansDO%>" entityType="<%=LkSNEntityType.ServerProfile%>">
  <tr class="header">
    <td><v:grid-checkbox header="true" multipage="true"/></td>
    <td width="100%">
      <v:itl key="@Common.Name"/><br>
      <v:itl key="@Common.Code"/>
    </td>
  </tr>
  <v:grid-row search="<%=ansDO%>">
    <% DOServerProfileRef spDO = ansDO.getRecord();%>
    <td>
      <v:grid-checkbox value="<%=spDO.ServerProfileId.getString()%>" fieldname="<%=spDO.ServerProfileId.getNodeName()%>" name="ServerProfileId"/>
    </td>
    <td>
      <snp:entity-link entityId="<%=spDO.ServerProfileId%>" entityType="<%=LkSNEntityType.ServerProfile%>" clazz="list-title">
        <%=spDO.ServerProfileName.getHtmlString()%>
      </snp:entity-link><br />
      <span class="list-subtitle"><%=spDO.ServerProfileCode.getHtmlString()%></span>
    </td>
  </v:grid-row>
</v:grid>