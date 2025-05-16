<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="swupd_versions_dialog" title="@Common.SoftwareUpdate" width="950" height="720" autofocus="false">
  <v:async-grid id="versions-grid" jsp="monitor/versions_grid.jsp"/>
</v:dialog>