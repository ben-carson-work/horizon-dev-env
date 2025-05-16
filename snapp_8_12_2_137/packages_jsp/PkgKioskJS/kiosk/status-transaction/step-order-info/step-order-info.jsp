<%@ taglib uri="ksk-tags" prefix="ksk" %>

<ksk:step-screen id="step-order-info" clazz="vert-flex" stepCode="ORDER-INFO" controller="StepOrderInfoController">
  
  <jsp:include page="../../common/kiosk-header.jsp"></jsp:include>

  <div id="recap-body">
    <div id="order-items"></div>
  </div>  
  
  <div id="order-templates" class="hidden">
    <jsp:include page="order-item.jsp"></jsp:include>
  </div>
  
</ksk:step-screen>