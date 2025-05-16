<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>

<script>
//# sourceURL=mob-adm-tab-attendance-js.jsp

$(document).on("tabchange", function(event, data) {
  if (data.newTabCode == "attendance") {
    var attendanceBody = $("#attendance-main-tab-content .tab-body");
    attendanceBody.addClass("waiting");
    
    var dtFrom = new Date();
    var dtTo = new Date();
    dtFrom.setMinutes(dtFrom.getMinutes() - 30);
    dtTo.setHours(dtTo.getHours() + 10);
    
    var reqDO = {
      Command: "Search",
      Search: {
        AccessPointId: apt.AccessPointId,
        PerformingFromDateTime: dateToXML(dtFrom),
        PerformingToDateTime: dateToXML(dtTo),
        PagePos: 1,
        RecordPerPage: 10
      }
    };
    
    vgsService("Performance", reqDO, true, function(ansDO) {
      attendanceBody.removeClass("waiting").empty();
      var errorMsg = getVgsServiceError(ansDO);
      if (isUnauthorizedAnswer(ansDO))
        doLogout();
      else if (errorMsg != null)
        attendanceBody.text(errorMsg);
      else {
        var list = [];
        if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.Search) && (ansDO.Answer.Search.PerformanceList))
          list = ansDO.Answer.Search.PerformanceList;
        
        for (var i=0; i<list.length; i++) {
          var perf = list[i];
          var div = $("#attendance-item-template").clone().appendTo(attendanceBody);
          div.find(".attendance-item-pic").css("background-image", "url(<v:config key="site_url"/>/repository?type=small&id=" + perf.EventProfilePictureId + ")");
          div.find(".attendance-item-event").text(perf.EventName);
          div.find(".attendance-item-time").text(perf.DateTimeFrom.substring(11, 16));

          var qty = perf.QuantityRedeemed;
          if (perf.QuantityMax == 0) 
            div.find(".attendance-item-pbout").addClass("hidden");
          else {
            var perc = (perf.QuantityRedeemed / perf.QuantityMax) * 100;
            div.find(".attendance-item-pbin").css("width", perc+"%");
            qty += " / " + perf.QuantityMax;
          }
          div.find(".attendance-item-quantity").text(qty);
          
          var now = new Date();
          if ((now >= xmlToDate(perf.AdmDateTimeFrom)) && (now <= xmlToDate(perf.AdmDateTimeTo)))
            div.addClass("status-open");
          else if ((now >= xmlToDate(perf.DateTimeFrom)) && (now <= xmlToDate(perf.DateTimeTo)))
            div.addClass("status-busy");
        }
      }
    });
  }
});

</script>