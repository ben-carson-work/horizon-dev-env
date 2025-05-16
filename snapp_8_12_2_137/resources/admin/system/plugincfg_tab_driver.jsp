<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePluginConfig" scope="request"/>

<v:last-error/>
<v:page-form>
  <div class="tab-toolbar">
      <v:pagebox gridId="driver-grid"/>
  </div>

  <div class="tab-content">
    <v:async-grid id="driver-grid" jsp="plugin/driver_grid.jsp" />
  </div>
</v:page-form>