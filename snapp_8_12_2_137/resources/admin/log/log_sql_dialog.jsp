<%@page import="com.vgs.web.dataobject.DODocLogSql"%>
<%@page import="com.vgs.snapp.dataobject.DOLogDataBase"%>
<%@page import="com.vgs.cl.database.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Log.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageLogDataDialog" scope="request"/>
<jsp:useBean id="logInfo" class="com.vgs.snapp.dataobject.DOLogInfo" scope="request"/>

<% DODocLogSql logSQL = pageBase.getDocLocSql(logInfo); %>

<% if (logSQL != null) { %>
  <v:widget caption="Calling function">
    <v:widget-block>
      Class name<span class="recap-value"><%=logSQL.STClassName.getHtmlString()%></span><br/>
      Method name<span class="recap-value"><%=logSQL.STMethodName.getHtmlString()%></span><br/>
      Line number<span class="recap-value"><%=logSQL.STLineNumber.getHtmlString()%></span><br/>
    </v:widget-block>
  </v:widget>

  <v:widget caption="SQL">
    <v:widget-block>
      <pre><%=logSQL.Sql.getHtmlString()%></pre>
    </v:widget-block>
  </v:widget>

  <v:widget caption="Parameters">
    <v:widget-block>
    <% for (DODocLogSql.DOParam param : logSQL.ParamList.getItems()) { %>
      <%=param.ParamName.getHtmlString()%><span class="recap-value"><%=param.ParamValue.getHtmlString()%></span><br/>
    <% } %>
    </v:widget-block>
  </v:widget>
  
  <v:widget icon="chart.png" caption="Statistics">
    <v:widget-block>
      Duration<span class="recap-value"><%=JvDateUtils.getSmoothTime(logInfo.DurationMS.getInt())%></span><br/>
    </v:widget-block>
    <v:widget-block>
      Count<span class="recap-value"><%=logSQL.QueryCount.getInt()%></span><br/>
      Min<span class="recap-value"><%=JvDateUtils.getSmoothTime(logSQL.QueryMin.getInt())%></span><br/>
      Avg<span class="recap-value"><%=JvDateUtils.getSmoothTime(logSQL.QueryAvg.getInt())%></span><br/>
      Max<span class="recap-value"><%=JvDateUtils.getSmoothTime(logSQL.QueryMax.getInt())%></span><br/>
    </v:widget-block>
  </v:widget>
  
<% } %>
