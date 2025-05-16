<%@page import="com.vgs.web.dataobject.DODocLogSql"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
  String sort = "Count(*)";
  if (pageBase.isParameter("type", "avg"))
    sort = "Avg(DurationMS)";
  else if (pageBase.isParameter("type", "max"))
    sort = "Max(DurationMS)";

  JvDataSet dsSqlMostUsed = pageBase.getDB().executeQuery(
  "select top 50" + JvString.CRLF +
  "  LogHash," + JvString.CRLF +
  "  Count(*) as Cnt," + JvString.CRLF +
  "  Min(DurationMS) as Min," + JvString.CRLF +
  "  Avg(DurationMS) as Avg," + JvString.CRLF +
  "  Max(DurationMS) as Max" + JvString.CRLF +
  "from tbLog" + JvString.CRLF +
  "where LogDataType=" + LkSNLogDataType.Sql.getCode() + JvString.CRLF +
  "group by LogHash" + JvString.CRLF +
  "order by " + sort + " desc");
  request.setAttribute("dsSqlMostUsed", dsSqlMostUsed);
%>
<% String pagetitle = pageBase.isParameter("type", "avg")?"Highest average":pageBase.isParameter("type", "max")?"Highest peaks":"Most used queries"; %>
<v:dialog id="engstats_query" title="<%=pagetitle%>" width="850" height="700" autofocus="false">
    <v:grid>
      <thead>
        <tr>
          <td>Query</td>
          <td align="right">Cnt</td>
          <td align="right">Min</td>
          <td align="right">Avg</td>
          <td align="right">Max</td>
        </tr>
      </thead>
      <tbody>
        <v:grid-row dataset="dsSqlMostUsed">
          <% 
          JvDataSet dsLogData = pageBase.getDB().executeQuery("select top 1 LogData, LogText from tbLog where LogHash=" + dsSqlMostUsed.getField("LogHash").getSqlString());
          String text = dsLogData.getField("LogText").getString();
          if (text == null) {
            FtBlob logData = (FtBlob)dsLogData.getField("LogData"); 
            text = JvString.unzip(logData.getBytes());
          }
          DODocLogSql logSQL = new DODocLogSql();
          logSQL.setJSONString(text);
          %>
          <td style="word-break:break-all"><%=logSQL.Sql.getHtmlString()%></td>
          <td align="right"><%=dsSqlMostUsed.getField("Cnt").getInt()%></td>
          <td align="right"><%=JvDateUtils.getSmoothTime(dsSqlMostUsed.getField("Min").getInt())%></td>
          <td align="right"><%=JvDateUtils.getSmoothTime(dsSqlMostUsed.getField("Avg").getInt())%></td>
          <td align="right"><%=JvDateUtils.getSmoothTime(dsSqlMostUsed.getField("Max").getInt())%></td>
        </v:grid-row>
      </tbody>
    </v:grid>
</v:dialog>