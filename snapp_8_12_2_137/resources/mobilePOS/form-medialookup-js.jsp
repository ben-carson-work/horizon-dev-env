<%@page import="com.vgs.snapp.lookup.LkSNDateFormat"%>
<%@page import="com.vgs.snapp.lookup.LkSNTicketStatus"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="apt" class="com.vgs.snapp.dataobject.DOAccessPointRef" scope="request"/>
<% PageMobileSales pageBase = (PageMobileSales)request.getAttribute("pageBase"); %>

<script type="text/javascript" id="form-medialookup-js.jsp" >

$(document).ready(function() {
  
  $("#tab-header-redeem-manual input").keydown(function(e) {
    if (event.keyCode == KEY_ENTER) {
      var mediaCode = $(this).val();
      
      $(this).val("");
      doMediaLookup(mediaCode);
      setTimeout(function() {$("input").blur()}, 200);
      event.stopPropagation();
    } 
  });
});

function initLookupMedia() {
  $('#lookupContainer').html('');
  $('#mainHeaderBack').addClass('hidden');
}
function doMediaLookup(mediaCode, ticketId) {
  initLookupMedia();

  $('#lookupContainer').html('');
   var newDiv = $("#frm-medialookup-template").clone().appendTo('#lookupContainer');
//   mobileSlide(redeemActiveContent, newDiv, "R2L", redeemContentSlideCallback);
  
  var reqDO = {
    Command: "Search",
    Search: {
      MediaCode: mediaCode,
      DefaultTicketId: (ticketId) ? ticketId : null
    }
  };
  
  vgsService("Media", reqDO, true, function(ansDO) {
    
  
    //newDiv.find(".tab-body").removeClass("waiting");
    
    var errorMsg = getVgsServiceError(ansDO);
    if (errorMsg != null)
      newDiv.text(errorMsg);
    else {
      var list = [];
      if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.Search) && (ansDO.Answer.Search.MediaList))
        list = ansDO.Answer.Search.MediaList;
      
      if (list.length == 0)
        newDiv.text(<v:itl key="@Common.MediaNotFound" encode="JS"/>);
      else
        renderMedia(newDiv, list[0]);
    }
  });
}

function formatShortDateTimeFromXML(xmlDateTime) {
  var dt = xmlToDate(xmlDateTime);
  return formatDate(dt, <%=rights.ShortDateFormat.getInt()%>) + " " + formatTime(dt, <%=rights.ShortTimeFormat.getInt()%>);
}

function renderMedia(container, media) {
  //$('#lookupContainer').html('');
  mainactivity(mainactivity_step.lookupMedia);
  var div = $("#pref-medialookup-template").clone().appendTo(container);

  // Account/Portfolio
  div.find(".account-pic").css("background-image", "url(<v:config key="site_url"/>/repository?type=small&id=" + media.AccountProfilePictureId + ")");
  div.find(".account-name").text(media.AccountName);
  div.find(".wallet-balance").html(formatCurr(media.WalletBalance));
  div.find(".wallet-credit").html(formatCurr(media.WalletCreditLimit));
  div.find(".wallet-expiration").text((media.WalletExpireDate) ? formatDate(media.WalletExpireDate, <%=rights.ShortDateFormat.getInt()%>) : "-");
  
  // Menu
  div.find(".menu-media .pref-item-value").text(media.MediaCalcCode);
  div.find(".menu-ticket .pref-item-value").text(media.MainProductName);
  if ((media.PortfolioUsageCount) && (media.PortfolioUsageCount > 0))
    div.find(".menu-usages .pref-item-value").html("<span class='badge'>" + media.PortfolioUsageCount + "</span>");
  else 
    div.find(".menu-usages .pref-item-value").text(<v:itl key="@Ticket.NotUsed" encode="JS"/>);
  div.find(".menu-medias .pref-item-value").html("<span class='badge'>" + media.PortfolioMediaCount + "</span>");
  div.find(".menu-tickets .pref-item-value").html("<span class='badge'>" + media.TicketCount + "</span>");
  
  div.find(".menu-medias").setClass("hidden", media.PortfolioMediaCount <= 1);
  div.find(".menu-tickets").setClass("hidden", media.TicketCount <=  1);

  // SubMenu Events
  var divBody = container.closest(".tab-content");
  $(".pref-item-arrow").on("<%=pageBase.getEventMouseDown()%>", function() {
    var $this = $(this);
    var newSelector = $this.attr("data-TemplateSelector");
    if (newSelector) {
      var newDiv = $(newSelector).clone().appendTo(container);
      //mobileSlide(divBody, newDiv, "R2L", redeemContentSlideCallback);
      
      newDiv.find(".tab-header-title").text($(this).find(".pref-item-caption").text());
      
      if ($this.is(".menu-media")) {
        // Media
    
        $('#mainHeaderBack').removeClass('hidden');
        container.find('#pref-medialookup-template').addClass('hidden');
        var mediaStatusClass = (media.MediaStatus == <%=LkSNTicketStatus.Active.getCode()%>) ? "good-status" : (media.MediaStatus < <%=LkSNTicketStatus.GoodTicketLimit%> ? "warn-status" : "bad-status"); 
        newDiv.find(".media-tdssn .pref-item-value").text(media.MediaCalcCode);
        newDiv.find(".media-status .pref-item-value").text(media.MediaStatusDesc).removeClass("good-status warn-status bad-status").addClass(mediaStatusClass);
        newDiv.find(".media-printed .pref-item-value").text((media.PrintDateTime) ? formatShortDateTimeFromXML(media.PrintDateTime) : <v:itl key="@Common.No" encode="JS"/>);
        newDiv.find(".media-exclusive .pref-item-value").text((media.ExclusiveUse) ? <v:itl key="@Common.Yes" encode="JS"/> : <v:itl key="@Common.No" encode="JS"/>);
        newDiv.find(".media-pah .pref-item-value").text((media.PrintAtHome) ? <v:itl key="@Common.Yes" encode="JS"/> : <v:itl key="@Common.No" encode="JS"/>);

        // Transaction
        newDiv.find(".trn-tdssn .pref-item-value").text(media.TransactionCode);
        newDiv.find(".trn-location .pref-item-value").text(media.LocationName);
        newDiv.find(".trn-oparea .pref-item-value").text(media.OpAreaName);
        newDiv.find(".trn-wks .pref-item-value").text(media.WorkstationName);
      }

      if ($this.is(".menu-ticket")) {
        // Ticket
        $('#mainHeaderBack').removeClass('hidden');
        
        container.find('#pref-medialookup-template').addClass('hidden');
        var ticketStatusClass = (media.MainTicketStatus == <%=LkSNTicketStatus.Active.getCode()%>) ? "good-status" : (media.MainTicketStatus < <%=LkSNTicketStatus.GoodTicketLimit%> ? "warn-status" : "bad-status");
        if (media.MainProductProfilePictureId)
          newDiv.find(".product-pic").removeClass("glyicon").addClass("profile-picture").css("background-image", "url(<v:config key="site_url"/>/repository?type=small&id=" + media.MainProductProfilePictureId + ")");
        newDiv.find(".product-name").text(media.MainProductName);
        newDiv.find(".product-code").text(media.MainProductCode);
        newDiv.find(".tck-product .pref-item-value").text(media.MainProductName);
        newDiv.find(".tck-tdssn .pref-item-value").text(media.MainTicketCode);
        newDiv.find(".tck-status .pref-item-value").text(media.MainTicketStatusDesc).removeClass("good-status warn-status bad-status").addClass(ticketStatusClass);
        newDiv.find(".tck-status").addClass((media.MainTicketStatus == <%=LkSNTicketStatus.Active.getCode()%>) ? "good-status" : (media.MainTicketStatus < <%=LkSNTicketStatus.GoodTicketLimit%> ? "warn-status" : "bad-status"));
        newDiv.find(".tck-price .pref-item-value").html(formatCurr(media.MainTicketPrice));
        newDiv.find(".tck-quantity .pref-item-value").text(media.MainTicketGroupQuantity);
        
        // Performance
        newDiv.find(".performance-datetime .pref-item-value").text(formatShortDateTimeFromXML(media.MainTicketPerformanceDateTimeFrom));
        newDiv.find(".performance-event .pref-item-value").text(media.MainTicketEventName);
        newDiv.find(".performance-location .pref-item-value").text(media.MainTicketLocationName);
        newDiv.find(".performance-seat .pref-item-value").html(media.MainTicketSeatName);
      }

      if ($this.is(".menu-usages")) {
        
        $('#mainHeaderBack').removeClass('hidden');
        container.find('#pref-medialookup-template').addClass('hidden');
        doSearchUsages(newDiv, media.MediaId);
      }
  
      if ($this.is(".menu-medias")) {
        $('#mainHeaderBack').removeClass('hidden');
        container.find('#pref-medialookup-template').addClass('hidden');
        doSearchPortfolioMedias(newDiv, media.PortfolioId);
      }
      if ($this.is(".menu-tickets")) {
        $('#mainHeaderBack').removeClass('hidden');
        container.find('#pref-medialookup-template').addClass('hidden');
        doSearchPortfolioTickets(newDiv, media.PortfolioId);
      }
    }
  });

}

function doSearchUsages(frm, mediaId) {
  var frmBody = frm;
  frmBody.addClass("waiting");
  
  var reqDO = {
    Command: "SearchTicketUsage",
    SearchTicketUsage: {
      PortfolioMediaId: mediaId
    }
  };
  
  vgsService("Portfolio", reqDO, true, function(ansDO) {
    frmBody.removeClass("waiting");
    
    var errorMsg = getVgsServiceError(ansDO);
    if (errorMsg != null)
      frm.text(errorMsg);
    else {
      var list = [];
      if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.SearchTicketUsage) && (ansDO.Answer.SearchTicketUsage.TicketUsageList))
        list = ansDO.Answer.SearchTicketUsage.TicketUsageList;
      
      for (var i=0; i<list.length; i++) 
        renderTicketUsage($("#rec-medialookup-usage-template").clone().appendTo(frmBody), list[i]);
    }
  });
}

function renderTicketUsage(divItem, usage) {
  var location = usage.AptLocationName;
  if (usage.AccessAreaName)
    location += " » " + usage.AccessAreaName;
  
  divItem.css("background-image", "url(<v:config key="site_url"/>/imagecache?size=128&name=" + usage.IconName + ")");
  divItem.find(".usage-datetime .medialookup-rec-text").text(formatShortDateTimeFromXML(usage.UsageDateTime));
  divItem.find(".usage-valresult .medialookup-rec-text").text(usage.ValidateResultDesc);
  divItem.find(".usage-location .medialookup-rec-text").text(location);
  divItem.find(".usage-product .medialookup-rec-text").text(usage.ProductName);
}

function doSearchPortfolioMedias(frm, portfolioId) {

  var frmBody = frm;
  frmBody.addClass("waiting");
  
  var reqDO = {
    Command: "Search",
    Search: {
      PortfolioId: portfolioId
    }
  };
  
  vgsService("Media", reqDO, true, function(ansDO) {
    frmBody.removeClass("waiting");
    
    var errorMsg = getVgsServiceError(ansDO);
    if (errorMsg != null)
      frm.text(errorMsg);
    else {
      var list = [];
      if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.Search) && (ansDO.Answer.Search.MediaList))
        list = ansDO.Answer.Search.MediaList;
      //alertjson(list);
      for (var i=0; i<list.length; i++) 
        //frmBody.html('');
        renderPortfolioMedia($("#rec-medialookup-pmedia-template").clone().appendTo(frmBody), list[i]);
    }
  });
}

function renderPortfolioMedia(divItem, media) {
  var printed = <v:itl key="@Common.No" encode="JS"/>;
  if (media.PrintDateTime)
    printed = formatShortDateTimeFromXML(media.PrintDateTime);
  
  divItem.attr("data-CommonStatus", media.CommonStatus);
  divItem.find(".pmedia-tdssn .medialookup-rec-text").text(media.MediaCalcCode);
  divItem.find(".pmedia-status .medialookup-rec-text").text(media.MediaStatusDesc);
  divItem.find(".pmedia-print .medialookup-rec-text").text(printed);
}

function doSearchPortfolioTickets(frm, portfolioId) {
  var frmBody = frm;
  frmBody.addClass("waiting");
  
  var reqDO = {
    Command: "Search",
    Search: {
      PortfolioId: portfolioId
    }
  };
  
  vgsService("Ticket", reqDO, true, function(ansDO) {
    frmBody.removeClass("waiting");
    
    var errorMsg = getVgsServiceError(ansDO);
    if (errorMsg != null)
      frm.text(errorMsg);
    else {
      var list = [];
      if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.Search) && (ansDO.Answer.Search.TicketList))
        list = ansDO.Answer.Search.TicketList;
      
      for (var i=0; i<list.length; i++) 
        renderPortfolioTicket($("#rec-medialookup-pticket-template").clone().appendTo(frmBody), list[i]);
    }
  });
}

function renderPortfolioTicket(divItem, ticket) {
  console.log(ticket);
  
  var price = formatCurr(ticket.UnitAmount);
  if (ticket.GroupQuantity != 1)
    price = ticket.GroupQuantity + " x " + price;
  
  divItem.attr("data-CommonStatus", ticket.CommonStatus);
  divItem.find(".pticket-tdssn .medialookup-rec-text").text(ticket.TicketCode);
  divItem.find(".pticket-status .medialookup-rec-text").text(ticket.TicketStatusDesc);
  divItem.find(".pticket-product .medialookup-rec-text").text(ticket.ProductName);
  divItem.find(".pticket-price .medialookup-rec-text").html(price);
  
  var perf = null
  if ((ticket.PerformanceList) && (ticket.PerformanceList.length > 0)) 
    perf = ticket.PerformanceList[0].Performance;
  
  if (perf == null) {
    divItem.find(".pticket-event").remove();
    divItem.find(".pticket-perf").remove();
  }
  else {
    divItem.find(".pticket-event .medialookup-rec-text").text(perf.EventName);
    divItem.find(".pticket-perf .medialookup-rec-text").text(formatShortDateTimeFromXML(perf.DateTimeFrom));
  }
}

</script>