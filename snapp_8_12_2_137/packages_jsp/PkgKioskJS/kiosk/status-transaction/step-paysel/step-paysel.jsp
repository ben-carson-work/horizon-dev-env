<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ taglib uri="ksk-tags" prefix="ksk" %>

<jsp:useBean id="kiosk" class="com.vgs.snapp.dataobject.DOKioskUI" scope="request"/>

<ksk:step-screen id="step-paysel" clazz="vert-flex" stepCode="PAYSEL" controller="StepPaySelController">
  
  <jsp:include page="../../common/kiosk-header.jsp"></jsp:include>
  
  <ksk:center-pane>
    <div id="payment-list"></div>
    
    <ksk:pane-hint caption="@StepPaysel.PayselHint"/>
  </ksk:center-pane>
  
  <div id="paysel-templates" class="hidden">
    <ksk:pane-item clazz="btn-pay" caption="CAPTION" fa="DUMMY"/>
  </div>

</ksk:step-screen>