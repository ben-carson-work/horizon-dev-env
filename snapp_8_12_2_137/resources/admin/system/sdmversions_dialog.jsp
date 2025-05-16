<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="sdm_versions_dialog" title="SDM Versions" width="500" height="600" autofocus="false">
  <v:async-grid id="sdmversions-grid" jsp="system/sdmversions_grid.jsp"/>
</v:dialog>