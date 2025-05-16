<%@page import="java.util.*"%>
<%@page import="java.util.stream.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocTemplateList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
BLBO_DocTemplate.DocTemplateInfo info = (BLBO_DocTemplate.DocTemplateInfo)request.getAttribute("DocTemplateInfo"); 
boolean showLogs = pageBase.getMenu().getItem("log-log").isVisible() && info.docTemplateType.isLookup(LkSNDocTemplateType.StatReport);
String logParams = "DateFilter=true&EntityType=" + LkSNEntityType.DocTemplate.getCode() + "&DefaultLogLevels=" + JvArray.arrayToString(LookupManager.getIntArray(LkSNLogLevel.Fatal, LkSNLogLevel.Error, LkSNLogLevel.Warn, LkSNLogLevel.Info), ",");
%> 

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:tab-group name="tab" main="true">
  <v:tab-item tab="tabs-search" caption="@Common.Search" default="true" jsp="doctemplate_list_tab_search.jsp"/> 
  <v:tab-item tab="tabs-logs" caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" jsp="../log/log_tab_widget.jsp" params="<%=logParams%>" include="<%=showLogs%>"/>
</v:tab-group>


<jsp:include page="/resources/common/footer.jsp"/>
