<%@ taglib uri="ksk-tags" prefix="ksk" %>

<ksk:step-screen id="step-change-performance" stepCode="CHANGE-PERFORMANCE" controller="StepChangePerformanceController">
  
  <jsp:include page="../../common/kiosk-header.jsp"></jsp:include>
  
  <div id="change-performance-container">
    <div id="change-performance-item-list">
    </div>
    <div class="event-body-performances"></div>
  </div>

  <div id="change-performance-templates" class="hidden">
    <div class="change-performance-item btn">
      <div class="change-performance-body">
        <div class="icon-container">
          <i class="fa fa-calendar-days"></i>
        </div>
        <div class="text-container">
          <div class="event-title fw-bold fs-4"></div>
          <div class="original-performance">
            <div class="change-performance-datetime"></div>
          </div>
          <div class="hint-msg"></div>
          <div class="target-performance">
            <div class="change-performance-datetime"></div>
          </div>
        </div>
      </div>
    </div>
  </div>

</ksk:step-screen>