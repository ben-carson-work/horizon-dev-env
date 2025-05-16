<%@ taglib uri="ksk-tags" prefix="ksk" %>

<ksk:step-screen id="step-recap" clazz="vert-flex" stepCode="RECAP" controller="StepRecapController">
  
  <jsp:include page="../../common/kiosk-header.jsp"></jsp:include>

  <div id="recap-body">
    <div id="recap-items"></div>
    <div id="addon-container">
      <h3 id="addon-title"><ksk:itl key="@StepRecap.AddonHint"/></h3>
      <div id="addon-items"></div>
    </div>
  </div>  
  
  <div id="recap-templates" class="hidden">
    <jsp:include page="recap-item.jsp"></jsp:include>
  </div>
  
</ksk:step-screen>