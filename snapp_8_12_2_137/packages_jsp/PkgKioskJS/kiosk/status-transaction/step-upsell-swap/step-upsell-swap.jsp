<%@ taglib uri="ksk-tags" prefix="ksk" %>

<ksk:step-screen id="step-upsell-swap" stepCode="UPSELL-SWAP" controller="StepUpsellSwapController">
  
  <jsp:include page="../../common/kiosk-header.jsp"></jsp:include>
  
  <div class="upsell-item-list">
  </div>
  
  <div id="swap-templates" class="hidden">
    <div class="upsell-swap-item">
      <div class="upsell-swap-item-title"></div>
      <div class="upsell-swap-target-list"></div>
    </div>
    
    <div class="upsell-swap-target">
      <div class="upsell-swap-target-product">
        <span class="swap-target-unchecked"><i class="fa fa-square"></i></span>
        <span class="swap-target-checked"><i class="fa fa-square-check"></i></span>
        <span class="upsell-swap-target-product-name"></span>
      </div>
      <div class="upsell-swap-target-price"></div>
    </div>
  </div>

</ksk:step-screen>