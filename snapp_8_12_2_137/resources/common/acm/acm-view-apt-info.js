$(document).ready(function() {
  "use strict";

  $(document).on("view-activate", ".apt-view[data-view='info']", _onViewActivate);
  
  function _onViewActivate() {
    var $view = $(this);
    var $apt = $view.closest(".apt");
    var status = $apt.data("status") || {};
    var valres = status.LastValidateResult || {};
    var ticket = valres.Ticket || {};

    _loadInfoProduct($view, ticket.TicketId);
    _loadInfoUsages($view, ticket.TicketId);
    
    ACM.addClickHandler($view.find(".apt-tool-close"), _onToolClick_Close);

    var $btnTicket = $view.find(".apt-tool-ticket").setClass("hidden", window.javaApp == null);
    ACM.addClickHandler($btnTicket, _onToolClick_Ticket);

    var $btnMedia = $view.find(".apt-tool-media").setClass("hidden", window.javaApp == null);
    ACM.addClickHandler($btnMedia, _onToolClick_Media);
  }
  
  function _loadInfoProduct($view, ticketId) {
    var $cont = $view.find(".apt-info-product-container").empty();
    var $spinner = $("#acm-templates .spinner-block").clone().appendTo($cont);
    
    _getTicketRef(ticketId, function(ticket) {
      _getTransactionRef(ticket.TransactionId, function(transaction) {
        $spinner.remove();
        var $template = $view.find(".templates .apt-info-product").clone().appendTo($cont);
        ACM.bindData($template, {"ticket":ticket, "transaction":transaction});
      });
    });
  } 
  
  function _getTicketRef(ticketId, callback) {
    var reqDO = {
      Command: "Search",
      Search: {
        TicketId: ticketId
      }
    };
    vgsService("Ticket", reqDO, true, function(ansDO) {
      var errorMsg = getVgsServiceError(ansDO);
      if (errorMsg != null) 
        throw errorMsg;

      var tickets = ((ansDO.Answer || {}).Search || {}).TicketList || [];
      if (tickets.length <= 0)
        throw "expecting at least 1 record"; 
      callback(tickets[0]);
    });
  }
  
  function _getTransactionRef(transactionId, callback) {
    var reqDO = {
      Command: "Search",
      Search: {
        Filters: {
          TransactionId: transactionId
        }
      }
    };
    vgsService("Transaction", reqDO, true, function(ansDO) {
      var errorMsg = getVgsServiceError(ansDO);
      if (errorMsg != null) 
        throw errorMsg;

      var transactions = ((ansDO.Answer || {}).Search || {}).TransactionList || [];
      if (transactions.length <= 0)
        throw "expecting at least 1 record"; 
      callback(transactions[0]);
    });
  }
  
  function _loadInfoUsages($view, ticketId) {
    var $cont = $view.find(".apt-info-usage-list").empty();
    var $spinner = $("#acm-templates .spinner-block").clone().appendTo($cont);
    
    var reqDO = {
      Command: "SearchTicketUsage",
      SearchTicketUsage: {
        TicketId: ticketId
      }
    };
    
    vgsService("Portfolio", reqDO, true, function(ansDO) {
      var errorMsg = getVgsServiceError(ansDO);
      if (errorMsg != null) {
        // TODO
        throw errorMsg;
      }
      else {
        $spinner.remove();
        var usages = ((ansDO.Answer || {}).SearchTicketUsage || {}).TicketUsageList || [];
        if (usages.length <= 0)
          throw "No record found"; // TODO
        else {
          for (var i=0; i<usages.length; i++) {
            var usage = usages[i];
            var $template = $view.find(".templates .apt-info-usage").clone().appendTo($cont);
            ACM.bindData($template, {"usage":usage});
            $template.find(".apt-usage-icon img").attr("src", calcIconName(usage.IconName, 50));
          }
        } 
      }
    });
  } 
  
  function _onToolClick_Close(event, ui) {
    ACM.setActiveView(ui.$apt, "main");
  }
  
  function _onToolClick_Ticket() {
    var status = ui.$apt.data("status") || {};
    var valres = status.LastValidateResult || {};
    var ticket = valres.Ticket || {};
    var ticketId = ticket.TicketId;

    javaApp.lookupTicket(ticketId);
  }
  
  function _onToolClick_Media() {
    var status = ui.$apt.data("status") || {};
    var valres = status.LastValidateResult || {};
    var media = valres.Media || {};
    var mediaId = media.MediaId;

    javaApp.lookupMedia(mediaId);
  }
});
