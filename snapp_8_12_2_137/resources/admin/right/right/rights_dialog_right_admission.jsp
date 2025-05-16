<%@page import="com.vgs.snapp.exception.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="rgt-tags" prefix="rgt" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rightsEnt" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightsDef" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightsUI" class="com.vgs.snapp.dataobject.DORightDialogUI" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<rgt:menu-content id="rights-menu-admission">
  <rgt:section>
    <rgt:bool rightType="<%=LkSNRightType.AllowManualEnrollOnInvalidBioEnrollmen%>"/>
    <rgt:bool rightType="<%=LkSNRightType.AllowManualReEnrollOnFailedBioCheck%>"/>
    <rgt:multi rightType="<%=LkSNRightType.PermittedOverrides%>"/>
    <rgt:bool rightType="<%=LkSNRightType.ChangeAPTGate%>"/>
  </rgt:section>
</rgt:menu-content>
