<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
BLBO_QueryRef_AccessPoint bl = pageBase.getBL(BLBO_QueryRef_AccessPoint.class);
DOCmd_Workstation.DORequest.DOSearchAptRequest reqDO = new DOCmd_Workstation.DORequest.DOSearchAptRequest();
DOCmd_Workstation.DOAnswer.DOSearchAptAnswer ansDO = pageBase.getBL(BLBO_Workstation.class).searchApt(reqDO);
%>

<v:dialog id="acm-select-apt-dialog" title="@AccessPoint.AccessPoint" width="800" height="600" autofocus="false">

  <v:grid>
    <v:grid-row search="<%=ansDO%>">
      <% DOAccessPointRef aptDO = ansDO.getRecord(); %>
      <td>
        <v:grid-icon name="<%=aptDO.IconName.getString()%>"/>
      </td>
      <td width="50%">
        <div><a href="javascript:ACM.addAccessPoint('<%=aptDO.AccessPointId.getString()%>')" class="list-title"><%=aptDO.AccessPointName.getHtmlString()%></a></div>
        <div class="list-subtitle"><%=aptDO.AccessPointCode.getHtmlString()%></div>
      </td>
      <td width="50%" align="right">
        <div><%=aptDO.LocationName.getHtmlString()%></div>
        <div class="list-subtitle"><%=aptDO.OpAreaName.getHtmlString()%></div>
      </td>
    </v:grid-row>
  </v:grid>

</v:dialog>
