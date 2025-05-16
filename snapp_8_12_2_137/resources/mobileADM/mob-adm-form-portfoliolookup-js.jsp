<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>

<script>
function doPortfolioLookup(reqDO) {
  var newDiv = $("#frm-portfoliolookup-template").clone().appendTo(redeemRootContent.parent());
  var tabBody = newDiv.find(".tab-body");
  mobileSlide(redeemActiveContent, newDiv, "R2L", redeemContentSlideCallback);
  
  reqDO = {
    Command: "Search",
    Search: reqDO
  };
    
  vgsService("Portfolio", reqDO, true, function(ansDO) {
    try {
      tabBody.removeClass("waiting");
      
      var errorMsg = getVgsServiceError(ansDO);
      if (errorMsg != null)
        tabBody.text(errorMsg);
      else {
        var list = [];
        if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.Search) && (ansDO.Answer.Search.PortfolioList))
          list = ansDO.Answer.Search.PortfolioList;
  
        if (list.length == 0)
           newDiv.text(itl("@Common.MediaNotFound"));
        else
          renderPortfolio(tabBody, list[0]);
      }
    }
    finally {
      sendCommand("StartRFID");
    }
  });
}



function formatShortDateTimeFromXML(xmlDateTime) {
  var dt = xmlToDate(xmlDateTime);
  return formatDate(dt) + " " + formatTime(dt);
}

function renderPortfolio(container, portfolio) {
  var div = $("#pref-portfoliolookup-template").clone().appendTo(container);

  // Account/Portfolio
  if (portfolio.AccountProfilePictureId) 
    div.find(".account-pic").css("background-image", "url(" + calcRepositoryURL(portfolio.AccountProfilePictureId, "small") + ")");
  div.setClass("has-profile-picture", portfolio.AccountProfilePictureId);
  div.find(".account-name").text(portfolio.AccountName);
  div.find(".wallet-balance").html(formatCurr(portfolio.WalletBalance));
  div.find(".wallet-credit").html(formatCurr(portfolio.WalletCreditLimit));
  div.find(".wallet-expiration").text((portfolio.WalletExpireDate) ? formatDate(portfolio.WalletExpireDate, <%=rights.ShortDateFormat.getInt()%>) : "-");
  
  // Menu
  div.find(".menu-notes .pref-item-value").html("<span class='badge'>" + portfolio.AccountNoteCount + "</span>");
  div.find(".menu-media .pref-item-value").text(portfolio.MainMediaCalcCode);
  div.find(".menu-ticket .pref-item-value").text(portfolio.MainTicketProductName);
  if ((portfolio.UsageCount) && (portfolio.UsageCount > 0))
    div.find(".menu-usages .pref-item-value").html("<span class='badge'>" + portfolio.UsageCount + "</span>");
  else 
    div.find(".menu-usages .pref-item-value").text(itl("@Ticket.NotUsed"));
  div.find(".menu-medias .pref-item-value").html("<span class='badge'>" + portfolio.MediaCount + "</span>");
  div.find(".menu-tickets .pref-item-value").html("<span class='badge'>" + portfolio.TicketCount + "</span>");
  
  div.find(".menu-notes").setClass("hidden", portfolio.AccountNoteCount < 1);
  div.find(".menu-notes .badge").setClass("badge-red", portfolio.AccountHighlightNoteCount > 0);
  div.find(".menu-media").setClass("hidden", portfolio.MediaCount < 1);
  div.find(".menu-ticket").setClass("hidden", portfolio.TicketCount <  1);
  div.find(".menu-medias").setClass("hidden", portfolio.MediaCount <= 1);
  div.find(".menu-tickets").setClass("hidden", portfolio.TicketCount <=  1);

  // SubMenu Events
  var divBody = container.closest(".tab-content");
  container.find(".pref-item-arrow").on("click", function() {
    var $this = $(this);
    var newSelector = $this.attr("data-TemplateSelector");
    if (newSelector) {
      var newDiv = $(newSelector).clone().appendTo(divBody.parent());
      mobileSlide(divBody, newDiv, "R2L", redeemContentSlideCallback);
      
      newDiv.find(".tab-header-title").text($(this).find(".pref-item-caption").text());
      
      if ($this.is(".menu-notes")) 
        doSearchNotes(newDiv, portfolio.AccountId);
      
      if ($this.is(".menu-media")) 
        doSearchMedia(newDiv, portfolio.MainMediaId);

      if ($this.is(".menu-ticket")) 
        doSearchTicket(newDiv, portfolio.MainTicketId);

      if ($this.is(".menu-usages")) 
        doSearchUsages(newDiv, portfolio.PortfolioId);
  
      if ($this.is(".menu-medias")) 
        doSearchPortfolioMedias(newDiv, portfolio.PortfolioId);
  
      if ($this.is(".menu-tickets")) 
        doSearchPortfolioTickets(newDiv, portfolio.PortfolioId);
    }
  });
}

function doSearchMedia(frm, mediaId) {
  var frmBody = frm.find(".tab-body");
  frmBody.addClass("waiting");
  
  var reqDO = {
    Command: "Search",
    Search: {
      MediaId: mediaId
    }
  };
  
  vgsService("Media", reqDO, true, function(ansDO) {
    frmBody.removeClass("waiting");
    
    var errorMsg = getVgsServiceError(ansDO);
    if (errorMsg != null)
      frmBody.text(errorMsg);
    else {
      var media = null;
      if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.Search) && (ansDO.Answer.Search.MediaList))
        media = ansDO.Answer.Search.MediaList[0];
      
      if (media == null)
        frmBody.text("media not found");
      else {
        // Media
        var mediaStatusClass = (media.MediaStatus == <%=LkSNTicketStatus.Active.getCode()%>) ? "good-status" : (media.MediaStatus < <%=LkSNTicketStatus.GoodTicketLimit%> ? "warn-status" : "bad-status"); 
        frmBody.find(".media-tdssn .pref-item-value").text(media.MediaCalcCode);
        frmBody.find(".media-status .pref-item-value").text(media.MediaStatusDesc).removeClass("good-status warn-status bad-status").addClass(mediaStatusClass);
        frmBody.find(".media-printed .pref-item-value").text((media.PrintDateTime) ? formatShortDateTimeFromXML(media.PrintDateTime) : itl("@Common.No"));
        frmBody.find(".media-exclusive .pref-item-value").text((media.ExclusiveUse) ? itl("@Common.Yes") : itl("@Common.No"));
        frmBody.find(".media-pah .pref-item-value").text((media.PrintAtHome) ? itl("@Common.Yes") : itl("@Common.No"));

        // Transaction
        frmBody.find(".trn-tdssn .pref-item-value").text(media.TransactionCode);
        frmBody.find(".trn-location .pref-item-value").text(media.LocationName);
        frmBody.find(".trn-oparea .pref-item-value").text(media.OpAreaName);
        frmBody.find(".trn-wks .pref-item-value").text(media.WorkstationName);
      }
    }
  });
}

function doSearchTicket(frm, ticketId) {
  var frmBody = frm.find(".tab-body");
  frmBody.addClass("waiting");

  var reqDO = {
    Command: "Search",
    Search: {
      TicketId: ticketId
    }
  };
  
  vgsService("Ticket", reqDO, true, function(ansDO) {
    frmBody.removeClass("waiting");
    
    var errorMsg = getVgsServiceError(ansDO);
    if (errorMsg != null)
      frmBody.text(errorMsg);
    else {
      var ticket = null;
      if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.Search) && (ansDO.Answer.Search.TicketList))
        ticket = ansDO.Answer.Search.TicketList[0];
      
      if (ticket == null)
        frmBody.text("ticket not found");
      else {
        var ticketStatusClass = (ticket.TicketStatus == <%=LkSNTicketStatus.Active.getCode()%>) ? "good-status" : (ticket.TicketStatus < <%=LkSNTicketStatus.GoodTicketLimit%> ? "warn-status" : "bad-status");
        if (ticket.ProductProfilePictureId)
          frmBody.find(".product-pic").removeClass("glyicon").addClass("profile-picture").css("background-image", "url(" + calcRepositoryURL(ticket.ProductProfilePictureId, "small") + ")");
        frmBody.find(".product-name").text(ticket.ProductName);
        frmBody.find(".product-code").text(ticket.ProductCode);
        frmBody.find(".tck-product .pref-item-value").text(ticket.ProductName);
        frmBody.find(".tck-tdssn .pref-item-value").text(ticket.TicketCode);
        frmBody.find(".tck-status .pref-item-value").text(ticket.TicketStatusDesc).removeClass("good-status warn-status bad-status").addClass(ticketStatusClass);
        frmBody.find(".tck-status").addClass((ticket.TicketStatus == <%=LkSNTicketStatus.Active.getCode()%>) ? "good-status" : (ticket.TicketStatus < <%=LkSNTicketStatus.GoodTicketLimit%> ? "warn-status" : "bad-status"));
        frmBody.find(".tck-price .pref-item-value").html(formatCurr(ticket.UnitAmount));
        frmBody.find(".tck-quantity .pref-item-value").text(ticket.GroupQuantity);
        
        // Performance
        var perf = ((ticket.PerformanceList) && (ticket.PerformanceList.length > 0)) ? ticket.PerformanceList[0] : null;
        
        if (perf == null) 
          frmBody.find(".performance-section").remove();
        else {
          frmBody.find(".performance-datetime .pref-item-value").text(formatShortDateTimeFromXML(perf.Performance.DateTimeFrom));
          frmBody.find(".performance-event .pref-item-value").text(perf.Performance.EventName);
          frmBody.find(".performance-location .pref-item-value").text(perf.Performance.LocationName);
          if (perf.SeatName)
            frmBody.find(".performance-seat .pref-item-value").html(perf.SeatName);
          else
            frmBody.find(".performance-seat").remove();
        }
      }
    }
  });
}

function doSearchNotes(frm, accountId) {
  var frmBody = frm.find(".tab-body");
  frmBody.addClass("waiting");
  
  var $btnHighlight = frm.find(".btn-toolbar-highlight"); 
  $btnHighlight.click(_toggleHighlightFilter);

  var reqDO = {
    Command: "Search",
    Search: {
      EntityId: accountId,
      PagePos: 1,
      RecordPerPage: 50
    }
  };
  
  vgsService("Note", reqDO, true, function(ansDO) {
    frmBody.removeClass("waiting");
    
    var errorMsg = getVgsServiceError(ansDO);
    if (errorMsg != null)
      frmBody.text(errorMsg);
    else {
      var list = [];
      if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.Search) && (ansDO.Answer.Search.NoteList))
        list = ansDO.Answer.Search.NoteList;
      
      var highlight = false;
      for (var i=0; i<list.length; i++) {
        var note = list[i];
        renderNote($("#rec-portfoliolookup-note-template").clone().appendTo(frmBody), note);
        if (note.NoteType == <%=LkSNNoteType.Highlighted.getCode()%>)
          highlight = true;
      }
      
      $btnHighlight.setClass("selected", highlight);
      _applyFilter();
    }
  });
  
  function _toggleHighlightFilter() {
    $(this).toggleClass("selected");
    _applyFilter();
  }
  
  function _applyFilter() {
    frmBody.setClass("highlighted-filter", $btnHighlight.hasClass("selected"));
  }
}

function doSearchUsages(frm, portfolioId) {
  var frmBody = frm.find(".tab-body");
  frmBody.addClass("waiting");
  
  var reqDO = {
    Command: "SearchTicketUsage",
    SearchTicketUsage: {
      PortfolioId: portfolioId
    }
  };
  
  vgsService("Portfolio", reqDO, true, function(ansDO) {
    frmBody.removeClass("waiting");
    
    var errorMsg = getVgsServiceError(ansDO);
    if (errorMsg != null)
      frmBody.text(errorMsg);
    else {
      var list = [];
      if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.SearchTicketUsage) && (ansDO.Answer.SearchTicketUsage.TicketUsageList))
        list = ansDO.Answer.SearchTicketUsage.TicketUsageList;
      
      for (var i=0; i<list.length; i++) 
        renderTicketUsage($("#rec-portfoliolookup-usage-template").clone().appendTo(frmBody), list[i]);
    }
  });
}

function renderTicketUsage(divItem, usage) {
  var location = usage.AptLocationName;
  if (usage.AccessAreaName)
    location += " » " + usage.AccessAreaName;
  
  divItem.css("background-image", "url(" + calcIconName(usage.IconName, 128) + ")");
  divItem.find(".usage-datetime .portfoliolookup-rec-text").text(formatShortDateTimeFromXML(usage.UsageDateTime));
  divItem.find(".usage-valresult .portfoliolookup-rec-text").text(usage.ValidateResultDesc);
  divItem.find(".usage-location .portfoliolookup-rec-text").text(location);
  divItem.find(".usage-product .portfoliolookup-rec-text").text(usage.ProductName);
}

function renderNote(divItem, note) {
  divItem.setClass("highlighted-note", (note.NoteType == <%=LkSNNoteType.Highlighted.getCode()%>));

  if (note.UserProfilePictureId) {
    divItem.addClass("has-profile-picture");
    divItem.find(".note-userpic").css("background-image", "url(" + calcRepositoryURL(note.UserProfilePictureId, "small") + ")")
  }
  
  divItem.find(".note-user").text(note.UserAccountName);
  divItem.find(".note-datetime").text(formatShortDateTimeFromXML(note.NoteDateTime));
  divItem.find(".note-text").text(note.Note);
}

function doSearchPortfolioMedias(frm, portfolioId) {
  var frmBody = frm.find(".tab-body");
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
      frmBody.text(errorMsg);
    else {
      var list = [];
      if ((ansDO) && (ansDO.Answer) && (ansDO.Answer.Search) && (ansDO.Answer.Search.MediaList))
        list = ansDO.Answer.Search.MediaList;
      
      for (var i=0; i<list.length; i++) 
        renderPortfolioMedia($("#rec-portfoliolookup-pmedia-template").clone().appendTo(frmBody), list[i]);
    }
  });
}

function renderPortfolioMedia(divItem, media) {
  var printed = itl("@Common.No");
  if (media.PrintDateTime)
    printed = formatShortDateTimeFromXML(media.PrintDateTime);
  
  divItem.attr("data-CommonStatus", media.CommonStatus);
  divItem.find(".pmedia-tdssn .portfoliolookup-rec-text").text(media.MediaCalcCode);
  divItem.find(".pmedia-status .portfoliolookup-rec-text").text(media.MediaStatusDesc);
  divItem.find(".pmedia-print .portfoliolookup-rec-text").text(printed);
}

function doSearchPortfolioTickets(frm, portfolioId) {
  var frmBody = frm.find(".tab-body");
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
        renderPortfolioTicket($("#rec-portfoliolookup-pticket-template").clone().appendTo(frmBody), list[i]);
    }
  });
}

function renderPortfolioTicket(divItem, ticket) {
  var price = formatCurr(ticket.UnitAmount);
  if (ticket.GroupQuantity != 1)
    price = ticket.GroupQuantity + " x " + price;
  
  divItem.attr("data-CommonStatus", ticket.CommonStatus);
  divItem.find(".pticket-tdssn .portfoliolookup-rec-text").text(ticket.TicketCode);
  divItem.find(".pticket-status .portfoliolookup-rec-text").text(ticket.TicketStatusDesc);
  divItem.find(".pticket-product .portfoliolookup-rec-text").text(ticket.ProductName);
  divItem.find(".pticket-price .portfoliolookup-rec-text").html(price);
  
  var perf = null
  if ((ticket.PerformanceList) && (ticket.PerformanceList.length > 0)) 
    perf = ticket.PerformanceList[0].Performance;
  
  if (perf == null) {
    divItem.find(".pticket-event").remove();
    divItem.find(".pticket-perf").remove();
  }
  else {
    divItem.find(".pticket-event .portfoliolookup-rec-text").text(perf.EventName);
    divItem.find(".pticket-perf .portfoliolookup-rec-text").text(formatShortDateTimeFromXML(perf.DateTimeFrom));
  }
}

</script>