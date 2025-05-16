<%@page import="com.vgs.web.library.BLBO_Repository"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
DOCmd_Repository.DOSearchRequest reqDO = new DOCmd_Repository.DOSearchRequest(); 
reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);
reqDO.EntityId.setString(pageBase.getNullParameter("EntityId"));

DOCmd_Repository.DOSearchAnswer ansDO = pageBase.getBL(BLBO_Repository.class).search(reqDO); 

String params = "canEdit=true";
if (!JvString.isSameString(pageBase.getEmptyParameter("canEdit"),""))
  params = "canEdit=" + pageBase.getParameter("canEdit");
%>

<script>

function showRepositoryDialog(repositoryId) {
  asyncDialog({
    url: BASE_URL + "admin?page=repository_widget&id=" + repositoryId
  });
}

</script>

<v:grid search="<%=ansDO%>" entityType="<%=LkSNEntityType.Repository%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="25%">
      <v:itl key="@Common.FileName"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="30%">
      <v:itl key="@Common.Template"/><br/>
      <v:itl key="@Common.Description"/>
    </td>
    <td width="10%">
      <v:itl key="@Common.ValidFrom"/><br/>
      <v:itl key="@Common.ValidTo"/>     
    </td>
    <td width="30%">
      <v:itl key="@Common.Tags"/><br/>
      <v:itl key="@Common.Flags"/>
    </td>
    <td align="right" width="5%">
      <v:itl key="@Common.Size"/>
    </td>
  </tr>
  <v:grid-row search="<%=ansDO%>">
    <% DORepositoryRef item = ansDO.getRecord(); %>
    <td><v:grid-checkbox name="cbRepositoryId" value="<%=item.RepositoryId.getString()%>"/></td>
    <td><v:grid-icon name="<%=item.IconName.getString()%>" repositoryId="<%=item.HasThumbnail.getBoolean() ? item.RepositoryId : null%>"/></td>
    <td>
      <snp:entity-link entityId="<%=item.RepositoryId%>" entityType="<%=LkSNEntityType.Repository%>" clazz="list-title" params="<%=params%>"><%=item.FileName.getHtmlString()%></snp:entity-link>
      <div class="list-subtitle"><%=item.RepositoryCode.getHtmlString()%></div>
    </td>
    <td>
      <div> 
        <% if (item.DocTemplateId.isNull()) { %>
          &mdash;
        <% } else { %>
          <snp:entity-link entityId="<%=item.DocTemplateId%>" entityType="<%=LkSNEntityType.DocTemplate%>"><%=item.DocTemplateName.getHtmlString()%></snp:entity-link>
        <% } %>
      </div>
      <div class="list-subtitle"><%=item.Description.getHtmlString()%>&nbsp;</div>
    </td>
    <td>
      <div class="list-subtitle"><%=item.ValidDateFrom.isNull() ? "&mdash;" : item.ValidDateFrom.formatHtml(pageBase.getShortDateFormat())%></div>
      <div class="list-subtitle"><%=item.ValidDateTo.isNull() ? "&mdash;" : item.ValidDateTo.formatHtml(pageBase.getShortDateFormat())%></div>
    </td>
    <td>
      <div class="list-subtitle"><%=item.TagNames.isNull() ? "&mdash;" : item.TagNames.getHtmlString()%></div>
      <div class="list-subtitle"><%=item.FlagDescs.isEmpty() ? "&mdash;" : item.FlagDescs.getHtmlString()%></div>
    </td>
    <td align="right" class="list-title"><%=item.SmoothSize.getHtmlString()%></td>
  </v:grid-row>
</v:grid>