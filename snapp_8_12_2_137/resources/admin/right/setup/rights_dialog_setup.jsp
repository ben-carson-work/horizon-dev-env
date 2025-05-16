<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%> 
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="rgt-tags" prefix="rgt" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rightsEnt" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightsDef" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightsUI" class="com.vgs.snapp.dataobject.DORightDialogUI" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>


<rgt:menu>
  <li class="rights-menu-search"><input type="text" class="txt-search form-control" placeholder="<v:itl key="@Common.Search"/>" onkeyup="rightsSearch()"/></li>

  <rgt:menu-item contentId="rights-menu-localization"   fa="calendar"          color="gray"  caption="@Common.Localization"/>
  <% if (!pageBase.isParameter("WksType", LkSNWorkstationType.APT.getCode())) { %>
    <rgt:menu-item contentId="rights-menu-custdisplay"  fa="link"              color="gray"  caption="@Right.CustomLinks"/>
    <rgt:menu-item contentId="rights-menu-notify"       fa="envelope"          color="blue"  caption="@Common.Notifications"/>
  <% } %>
  
  <rgt:menu-divider/>
  
  <rgt:menu-item contentId="rights-menu-ui"             fa="eye"               color="green" caption="@Right.UI"/>
  <% if (rightsEnt.EntityType.isLookup(rightsUI.WksEntities.getLkArray())) { %>
    <rgt:menu-item contentId="rights-menu-shortcuts"    fa="keyboard"          color="gray"  caption="@Right.FunctionShortcuts"/>
  <% } %>
  <rgt:menu-item contentId="rights-menu-finance"        fa="dollar-sign"       color="blue"  caption="@Right.Finance"/>
  <rgt:menu-item contentId="rights-menu-crm"            fa="user"              color="blue"  caption="@Account.Accounts"/>
  <rgt:menu-item contentId="rights-menu-doctemplate"    fa="print"             color="gray"  caption="@DocTemplate.DocTemplates"/>
  
  <rgt:menu-divider/>
  
  <rgt:menu-item contentId="rights-menu-security"       fa="lock"             color="green"  caption="@Account.Security"/>
  <rgt:menu-item contentId="rights-menu-admission"      fa="barcode-scan"     color="green"  caption="@Common.Admission"/>
  <rgt:menu-item contentId="rights-menu-kiosk"          fa="computer-classic" color="green"  caption="@Lookup.WorkstationType.KSK"/>
  <rgt:menu-item contentId="rights-menu-advanced"       fa="cog"              color="gray"   caption="@Common.Advanced"/>
</rgt:menu>



<rgt:menu-body>
  <jsp:include page="rights_dialog_setup_localization.jsp"></jsp:include>
  <jsp:include page="rights_dialog_setup_shortcut.jsp"></jsp:include>
  <jsp:include page="rights_dialog_setup_custdisplay.jsp"></jsp:include>
  <jsp:include page="rights_dialog_setup_notify.jsp"></jsp:include>
  <jsp:include page="rights_dialog_setup_ui.jsp"></jsp:include>
  <jsp:include page="rights_dialog_setup_crm.jsp"></jsp:include>
  <jsp:include page="rights_dialog_setup_finance.jsp"></jsp:include>
  <jsp:include page="rights_dialog_setup_doctemplate.jsp"></jsp:include>
  <jsp:include page="rights_dialog_setup_security.jsp"></jsp:include>
  <jsp:include page="rights_dialog_setup_admission.jsp"></jsp:include>
  <jsp:include page="rights_dialog_setup_kiosk.jsp"></jsp:include>
  <jsp:include page="rights_dialog_setup_advanced.jsp"></jsp:include>
</rgt:menu-body>