<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="pos_versions_dialog" title="POS Versions" width="500" height="600" autofocus="false">
  <v:async-grid id="posversions-grid" jsp="system/posversions_grid.jsp"/>
</v:dialog>