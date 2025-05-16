<%@page import="com.vgs.snapp.dataobject.DOServer.DOServerParam"%>
<%@page import="com.vgs.web.library.BLBO_Server"%>
<%@page import="com.vgs.snapp.dataobject.DOServer"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
String idString = pageBase.getParameter("serverId");
int id = Integer.parseInt(idString);

boolean masked = !rights.VGSSupport.getBoolean();
DOServer server = pageBase.getBL(BLBO_Server.class).getServer(id, masked);
%>

<div class="tab-content">
  <v:widget caption="@Common.Parameters">
    <v:widget-block>
    <% for (DOServerParam param: server.SystemParamList) {%>
      <v:form-field caption="<%=param.ParamName.getHtmlString() %>">
        <input type="text" readonly="readonly" class="form-control" value="<%=param.ParamValue.getHtmlString() %>" />
      </v:form-field>
    <% }%>
    </v:widget-block>
  </v:widget>
</div>