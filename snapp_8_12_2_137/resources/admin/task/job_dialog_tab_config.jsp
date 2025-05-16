<%@page import="com.vgs.cl.json.*"%>
<%@page import="com.vgs.snapp.web.servlet.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.task.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.servlet.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="job" class="com.vgs.snapp.dataobject.task.DOJob" scope="request"/>

<v:tab-content>
  <v:grid>
    <thead>
      <tr>
        <td><v:itl key="@Common.Field"/></td>
        <td><v:itl key="@Common.Value"/></td>
      </tr>
    </thead>
    <tbody>
      <% for (DOParamValue field : job.ConfigFieldList) { %>
        <tr class="grid-row">
          <td class="list-title"><%=field.ParamName.getHtmlString()%></td>
          <td><%=field.ParamValue.getHtmlString()%></td>
        </tr>
      <% } %>
    </tbody>
  </v:grid>
</v:tab-content>
