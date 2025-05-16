<%@page import="com.vgs.cl.json.JSONObject"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageUpload" scope="request"/>

<% 
String msg = JvString.getEmpty(pageBase.getDB().getString("select MsgRequest from tbUpload where UploadId=" + JvString.sqlStr(pageBase.getId()))); 
request.setAttribute("message", msg);
%>


<div class="tab-toolbar">
  <% String href = ConfigTag.getValue("site_url") + "/admin?page=upload&id=" + pageBase.getId() + "&action=downloadXML"; %>
  <v:button caption="@Common.Download" fa="download" href="<%=href%>" clazz="no-ajax" target="blank"/>
</div>

<div class="tab-content">
  <v:widget caption="Body">
    <v:widget-block>
       <jsp:include page="../common/text_format_widget.jsp"/>
    </v:widget-block>
  </v:widget>
</div>

