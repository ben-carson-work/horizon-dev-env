<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.web.page.PageRepositoryPickupWidget"/>
<jsp:useBean id="ds" class="com.vgs.cl.JvDataSet" scope="request" />

<% if (ds.isEmpty()) { %>
  <div style="text-align:center;margin-top:190px;">
    <v:itl key="@Repository.RepositoryIsEmpty"/>.
    <a id="upload-link" href="#" style="font-weight:bold;color:#21759b;text-decoration:underline"><v:itl key="@Common.UploadFile"/></a>
  </div>
<% } else { %>
  <div style="overflow:hidden">
  <v:ds-loop dataset="<%=ds%>">
      <div id="<%=ds.getField(QryBO_Repository.Sel.RepositoryId).getEmptyString()%>" class="thumb-container">
        <div class="thumb-content" style="background-image:url('<v:config key="site_url"/>/repository?id=<%=ds.getField(QryBO_Repository.Sel.RepositoryId).getEmptyString()%>&type=small')">
          <div class="thumb-name"><%=ds.getField(QryBO_Repository.Sel.FileName).getHtmlString()%></div>
        </div>
      </div>
  </v:ds-loop>
  </div>
    <div style="margin-top:20px"><a id="upload-link" href="#" style="font-weight:bold;color:#21759b;text-decoration:underline"><v:itl key="@Common.UploadFile"/></a></div>
<% } %> 

<script>
  function closeDialog(sender) {
    $(sender).closest(".ui-dialog-content").dialog("close");
  }
  
  $("a#upload-link").click(function() {
    closeDialog(this);
    showUploadDialog(<%=pageBase.getEmptyParameter("UploadEntityType")%>, <%=JvString.jsString(pageBase.getNullParameter("UploadEntityId"))%>, true);
  });
  
  $(".thumb-container").click(function() {
    closeDialog(this);
    repositoryPickupCallback($(this).attr("id"));
  });
</script>

