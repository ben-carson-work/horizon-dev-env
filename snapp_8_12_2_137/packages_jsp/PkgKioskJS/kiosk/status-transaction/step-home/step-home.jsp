<%@ taglib uri="ksk-tags" prefix="ksk" %>

<ksk:step-screen id="step-home" clazz="vert-flex" stepCode="HOME" controller="StepHomeController">
  
  <jsp:include page="../../common/kiosk-header.jsp"></jsp:include>
  
<%-- 
  <ksk:center-pane>
    <ksk:pane-item id="btn-purchase" caption="@StepHome.TrnPurchaseTicket" fa="basket-shopping"/>
    <ksk:pane-item id="btn-order-pickup" caption="@StepHome.TrnOrderPickup" fa="check-to-slot"/>
    <ksk:pane-item id="btn-wallet-topup" caption="@StepHome.TrnWalletTopup" fa="dollar"/>
    
    <ksk:pane-hint caption="@StepHome.TrnHint"/>
  </ksk:center-pane>
--%>
  
  <ksk:center-pane>
    <div class="kiosk-pane-content">
      <div id="service-list"></div>
      <ksk:pane-hint caption="@StepHome.TrnHint"/>
    </div>
    <div class="spinner-container"></div>
  </ksk:center-pane>
  
  <div id="home-templates" class="hidden">
    <ksk:pane-item clazz="btn-service" caption="CAPTION" fa="DUMMY"/>
  </div>

</ksk:step-screen>