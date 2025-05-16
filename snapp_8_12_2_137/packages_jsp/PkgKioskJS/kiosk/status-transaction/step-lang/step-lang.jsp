<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ taglib uri="ksk-tags" prefix="ksk" %>
<jsp:useBean id="kiosk" class="com.vgs.snapp.dataobject.DOKioskUI" scope="request"/>

<ksk:step-screen id="step-lang" clazz="vert-flex" stepCode="LANG" controller="StepLangController">
  
  <jsp:include page="../../common/kiosk-header.jsp"></jsp:include>
  
  <ksk:center-pane>
    <div id="lang-list"></div>
  </ksk:center-pane>
  
  <div id="lang-templates" class="hidden">
    <ksk:pane-item clazz="btn-lang" caption="CAPTION" icon="DUMMY"/>
  </div>

</ksk:step-screen>