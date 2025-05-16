<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMedia" scope="request"/>

<% 
String flatMetaData = pageBase.getNullParameter("FlatMetaData");
String params = "&id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Media.getCode();
if (flatMetaData != null)
  params = params + "&FlatMetaData=" + flatMetaData;
else
  params = params + "&FlatMetaData=false";
%>

<v:page-form>

<v:tab-content>
  <div id="maskedit-container"></div>
</v:tab-content>

<script>
var metaFields = <%=pageBase.getBL(BLBO_MetaData.class).encodeItems(LkSNEntityType.Media, pageBase.getId())%>;
asyncLoad("#maskedit-container", addTrailingSlash(BASE_URL) + "admin?page=maskedit_widget<%=params%>");
</script>

</v:page-form>
