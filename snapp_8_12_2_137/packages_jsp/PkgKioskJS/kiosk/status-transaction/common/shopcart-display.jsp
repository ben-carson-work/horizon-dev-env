<%@ taglib uri="ksk-tags" prefix="ksk" %>
<div id="shopcart-display" class="emptycart" data-controller="ShopcartDisplayController">
  <div class="shopcart-display-header">
    <div class="shopcart-display-title">
      <ksk:itl key="@Common.ShopCartEmpty" clazz="show-when-empty"/>
      <span class="hide-when-empty"><ksk:itl key="@Common.Items"/>: <span class="shopcart-display-totalquantity"></span></span>
    </div>
    <div class="shopcart-display-amounts hide-when-empty">
      <ksk:itl key="@Common.Tax"/> <span class="shopcart-display-tax"></span>
      &nbsp;&nbsp;
      <ksk:itl key="@Common.Total"/> <span class="shopcart-display-total"></span>
    </div>
  </div>
  <div class="shopcart-display-footer">
    <button id="btn-back" class="btn btn-lg btn-danger" type="button"></button>
    <button id="btn-next" class="btn btn-lg btn-success" type="button"></button>
  </div>
</div>