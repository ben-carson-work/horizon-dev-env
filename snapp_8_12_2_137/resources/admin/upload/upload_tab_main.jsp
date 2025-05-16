<%@page import="com.vgs.web.library.BLBO_PagePath"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageUpload" scope="request"/>
<jsp:useBean id="ds" class="com.vgs.cl.JvDataSet" scope="request"/>

<v:ds-loop dataset="<%=ds%>"></v:ds-loop> <%-- WORKAROUND TO REMOVE RESOURCE LEAK WARNING --%>

<% LookupItem uploadStatus = LkSN.UploadStatus.getItemByCode(ds.getField(QryBO_Upload.Sel.UploadStatus)); %>

<% if (pageBase.getRights().SuperUser.getBoolean() && uploadStatus.isLookup(LkSNUploadStatus.Failed)) { %>
  <div class="tab-toolbar">
    <v:button caption="@Common.Retry" fa="repeat" href="javascript:doRetry()"/>
  </div>

  <script>
    function doRetry() {
      var reqDO = {
        Command: "Retry",
        Retry: {
          UploadId: <%=JvString.jsString(pageBase.getId())%>
        }
      };
      
      vgsService("Upload", reqDO, false, function() {
        window.location.reload();
      });
    }  
  </script>
<% } %>

<div class="tab-content">
  <v:last-error />
  <v:widget caption="@Common.General" >
    <v:widget-block>
      <v:form-field caption="@Common.DateTime">
        <snp:datetime clazz="list-title" timestamp="<%=ds.getField(QryBO_Upload.Sel.RequestDateTime)%>" timezone="local" format="longdatetime" showMillisHint="true"/>
      </v:form-field>
      <v:form-field caption="@Common.Status">
        <span class="list-title"><%=ds.getField(QryBO_Upload.Sel.UploadStatusDesc).getHtmlString()%></span>
      </v:form-field>
      <% BLBO_PagePath.EntityRecap entityRecap = BLBO_PagePath.findEntityRecap(pageBase.getConnector(), ds.getField(QryBO_Upload.Sel.EntityType).getInt(), ds.getField(QryBO_Upload.Sel.EntityId).getString()); %>
      <% if (entityRecap != null) { %>
      <v:form-field caption="@Common.Reference">
        <a class="list-title" href="<%=entityRecap.url%>"><%=JvString.escapeHtml(entityRecap.name)%></a>
      </v:form-field>
      <% } %>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Common.Workstation">
        <div class="list-title">
          <snp:entity-link entityId="<%=ds.getField(QryBO_Upload.Sel.LocationId)%>" entityType="<%=LkSNEntityType.Location%>">
            <%=ds.getField(QryBO_Upload.Sel.LocationName).getHtmlString()%>
          </snp:entity-link>
          &raquo;
          <snp:entity-link entityId="<%=ds.getField(QryBO_Upload.Sel.OpAreaId)%>" entityType="<%=LkSNEntityType.OperatingArea%>">
            <%=ds.getField(QryBO_Upload.Sel.OpAreaName).getHtmlString()%>
          </snp:entity-link>
          &raquo;
          <snp:entity-link entityId="<%=ds.getField(QryBO_Upload.Sel.WorkstationId)%>" entityType="<%=LkSNEntityType.Workstation%>">
            <%=ds.getField(QryBO_Upload.Sel.WorkstationName).getHtmlString()%>
          </snp:entity-link>
        </div>
      </v:form-field>
      <v:form-field caption="@Upload.StartDateTime">
        <snp:datetime clazz="list-title" timestamp="<%=ds.getField(QryBO_Upload.Sel.StartDateTime)%>" timezone="local" format="longdatetime" showMillisHint="true"/>
      </v:form-field>
      <v:form-field caption="@Upload.ProcessingTime">
        <span class="list-title"><%=JvDateUtils.getSmoothTime(ds.getField(QryBO_Upload.Sel.ProcessMS).getInt())%></span>
      </v:form-field>
      <v:form-field caption="@Upload.QueueTime">
        <span class="list-title"><%=JvDateUtils.getSmoothTime(ds.getField(QryBO_Upload.Sel.QueueMS).getInt())%></span>
      </v:form-field>
      <v:form-field caption="@Upload.RequestSize">
        <span class="list-title"><%=JvString.getSmoothSize(ds.getField(QryBO_Upload.Sel.MsgRequestSize).getLong())%></span>
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>