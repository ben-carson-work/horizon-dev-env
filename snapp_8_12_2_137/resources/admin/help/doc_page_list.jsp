<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.annotation.*"%>
<%@page import="java.lang.annotation.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocPageList" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-content">

      <v:grid>
        <thead>
          <tr>
            <td>Class</td>
            <td>Alias</td>
            <td>Contexts</td>
          </tr>
        </thead>
        <tbody>
        <% 
        List<Class<? extends PageBase<?>>> list = PageManager.getPageClasses();
        for (Class<?> pageClass : list) {
          VgsPage a = pageClass.getAnnotation(VgsPage.class);
          String[] contexts = a.contexts();
          %>
          <tr>
            <td><%=JvString.escapeHtml(pageClass.getName())%></td>
            <td><%=JvString.escapeHtml(a.pageName())%></td>
            <td><%=JvString.escapeHtml(JvArray.arrayToString(contexts, ", "))%></td>
          </tr>
          <%
        }
        %>
        </tbody>
      </v:grid>
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<jsp:include page="/resources/common/footer.jsp"/>
