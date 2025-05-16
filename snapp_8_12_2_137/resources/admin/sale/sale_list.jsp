<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSaleList" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:page-form>
  <input type="hidden" id="CategoryId" name="CategoryId" value="<%=pageBase.getEmptyParameter("CategoryId")%>"/>

  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
      <jsp:include page="sale_list_widget.jsp"/>
    </v:tab-item-embedded>
  </v:tab-group>
</v:page-form>

<jsp:include page="/resources/common/footer.jsp"/>