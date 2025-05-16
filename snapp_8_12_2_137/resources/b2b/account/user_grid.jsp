<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
DOAccountSearchRequest reqDO = new DOAccountSearchRequest();
reqDO.SearchRecapRequest.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecapRequest.RecordPerPage.setInt(QueryDef.recordPerPageDefault);
reqDO.EntityTypes.addLookupItem(LkSNEntityType.Person);
reqDO.ParentAccountId.setString(pageBase.getSession().getOrgAccountId());
reqDO.PlatformType.setLkArray(LkSNLoginPlatformType.B2B);
reqDO.FullText.setString(pageBase.getNullParameter("FullText"));

DOAccountSearchAnswer ansDO = pageBase.getBL(BLBO_Account.class).searchAccount(reqDO);
%>

<v:grid search="<%=ansDO%>" entityType="<%=LkSNEntityType.Person%>">
  <input type="hidden" name="grid-url" value="<%=request.getRequestURI()%>?<%=request.getQueryString()%>" />
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="25%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Status"/>
      </td>
      <td width="75%">
        <v:itl key="@Common.UserName"/><br/>
        <v:itl key="@Common.SecurityRole" />
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row search="<%=ansDO%>">
      <% 
      DOAccountRef account = ansDO.getRecord();
      LookupItem commonStatus = account.CommonStatus.getLkValue();
      if (account.CommonStatus.isLookup(LkCommonStatus.Active) && !account.LoginStatus.isLookup(LkSNLoginStatus.Active))
        commonStatus = LkCommonStatus.Warn;
      %>
      <td style="<v:common-status-style status="<%=commonStatus%>"/>">
        <v:grid-checkbox name="AccountId" value="<%=account.AccountId%>"/>
      </td>
      <td>
        <v:grid-icon name="<%=account.IconName%>" repositoryId="<%=account.ProfilePictureId%>"/>
      </td>
      <td>
        <div class="list-title"><a href="<%=request.getRequestURI()%>?page=user&id=<%=account.AccountId.getHtmlString()%>"><v:label field="<%=account.AccountName%>"/></a></div>
        <div class="list-subtitle"><v:label field="<%=account.LoginStatus%>"/></div>
      </td>
      <td>
        <div><v:label field="<%=account.UserName%>" placeholder="-"/></div>
        <div class="list-subtitle"><v:label field="<%=account.RoleNames%>"/></div>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
