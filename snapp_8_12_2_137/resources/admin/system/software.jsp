<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSoftware" scope="request"/>
<jsp:useBean id="license" class="com.vgs.snapp.dataobject.DOLicenseDef" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:tab-group name="tab" main="true">
  <v:tab-item caption="Software" fa="puzzle-piece" tab="softwareupdate" jsp="software_tab_software.jsp" default="true"/>
  <v:tab-item caption="@Common.Servers" tab="server" fa="server" jsp="software_tab_server.jsp"/>
  <v:tab-item caption="@ServerProfile.ServerProfiles" tab="serverprofiles" fa="layer-group" jsp="software_tab_serverprofiles.jsp" include="<%=rights.VGSSupport.getBoolean() || SnpLicense.ModSDK.isModuleActive(license)%>" />
</v:tab-group>

<jsp:include page="/resources/common/footer.jsp"/>