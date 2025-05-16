UIMob.init("account", function($view, params) {
  var account = {};
  var media = {};
  var ticket = {};
  var actions = [];
  var canEdit = false;

  $view.find(".btn-toolbar-menu").click(onMenuClick);
  $view.find(".account-detail").click(onAccountDetailClick);

  var $picture = $view.find(".account-pic"); 
  $picture.click(onPictureClick); 

  $(document).von($view, "AccountChange", onAccountChange);
  
  loadData(params);

  
  function loadData(params) {
    UIMob.showWaitGlass();
    snpAPI("Account", "LoadShopCartAccount", {
      "ShopCartId": shopCart.ShopCartId,
      "AccountId": params.AccountId,
      "MediaId": params.MediaId,
      "MediaCode": params.MediaCode,
      "TicketId": params.TicketId
    }).finally(function() {
      UIMob.hideWaitGlass();
    }).then(function(ansDO) {
      account = ansDO.Account || {};
      media = ansDO.MediaRef || {};
      ticket = ansDO.TicketRef || {};
      actions = ansDO.ActionList || [];
      canEdit = true; // TODO: check rights
      renderAll();
    }).catch(function(error) {
      UIMob.tabNavBack($view.closest(".mob-view").parent());
      UIMob.showError(error.message || error);
    });
  }
  
  function renderAll() {
    $view.find(".lookup-content").removeClass("hidden");
    for (var i=0; i<actions.length; i++)
      actions[i].execute = doActionTBI;

//    getAction("ticket-void").execute = executeTicketVoid;
    getAction("set-privilegecard").execute = executeSetMembership;
    getAction("create-reservation").execute = executeCreateReservation;
    
    renderAccount();
    renderPortfolio();
    renderMedia();
  }
  
  function renderAccount() {
    $view.setClass("read-only", canEdit !== true);
    
    var displayName = account.DisplayName || "- " + itl("@Common.Empty").toLowerCase() + " -";
    var statusColor = (account.AccountStatus == LkSN.AccountStatus.Blocked.code) ? "orange" : "red";
    $view.find(".tab-header-title").text(displayName);
    $view.find(".account-name").text(displayName);
    $view.find(".account-status").css("color", "var(--base-" + statusColor + "-color)").text((account.AccountStatus == LkSN.AccountStatus.Active.code) ? "" : getLookupDesc(LkSN.AccountStatus, account.AccountStatus));

    var $accountBody = $view.find(".account-detail");
    $accountBody.find(".mob-card-data").remove();
    UIMob.addCardData($accountBody, account.CategoryRecursiveName, "list-ul");
    UIMob.addCardData($accountBody, account.CalcAddress, "map-marker-alt");
    UIMob.addCardData($accountBody, account.CalcPhones, "phone");
    UIMob.addCardData($accountBody, account.EmailAddress, "at");

    if (account.ProfilePictureId)
      $picture.empty().css("background-image", "url(" + calcRepositoryURL(account.ProfilePictureId, "small") + ")");
    else
      $picture.html("<i class='fa fa-" + account.IconAlias + "'></i>");
  }
  
  function renderPortfolio() {
    var $portfolioContainer = $view.find(".portfolio-container").empty();
    var $widget = $view.find(".templates .portfolio-section").clone().appendTo($portfolioContainer);


    var $prefBalance = $widget.find("#pref-item-balance");
    $prefBalance.click(function() {
      showDetailView(PKG_CAS, "account-balance", {
        "Account": account
      });
    });

    var $prefPortfolios = $widget.find("#pref-item-portfolios");
    if ((account.PortfolioCount || 0) <= 0)
      $prefPortfolios.remove();
    else {
      $prefPortfolios.find(".pref-item-value").html("<span class='badge'>" + account.PortfolioCount + "</span>");
      
      $prefPortfolios.click(function() {
        showDetailView(PKG_CAS, "portfolio-list", {
          "AccountId": account.AccountId,
          "onItemClick": function($viewMedias, portfolioRef) {
            UIMob.tabNavBack($viewMedias.closest(".mob-view").parent());
            params.TicketId = portfolioRef.MainTicketId;
            params.MediaId = portfolioRef.MainMediaId;
            loadData(params);
          }
        });
      });
    }
  }

  function renderMedia() {
    $view.find(".media-container").empty();
    var $widget = $view.find(".templates .media-section").clone().appendTo($view.find(".media-container"));
    var $ticketBlock = $widget.find(".ticket-block");
    var $ticketBody = $ticketBlock.find(".mob-card-body");
    
    if (ticket.TicketId == null) 
      $("<div class='no-ticket-title'/>").appendTo($ticketBlock.empty()).text(itl("@Lookup.ValidateResult.NoTicketsAttached"));
    else {
      
      var perf = ((ticket.PerformanceList || []).length == 0) ? null : ticket.PerformanceList[0];

      $ticketBody.find(".text-productname").text(ticket.ProductName);
      $ticketBody.find(".text-price").text(formatCurr(ticket.UnitAmount));

      UIMob.addCardData($ticketBody, (perf == null) ? null : perf.Performance.EventName + " " + formatShortDateTimeFromXML(perf.Performance.DateTimeFrom), "masks-theater");
      UIMob.addCardData($ticketBody, ticket.ProductCode, "tag");
      UIMob.addCardData($ticketBody, ticket.TicketCode, "code");
      UIMob.addCardData($ticketBody, ((ticket.GroupQuantity || 1) == 1) ? null : itl("@Common.Quantity") + " " + ticket.GroupQuantity, "hashtag");
      UIMob.addCardData($ticketBody, getLookupDesc(LkSN.TicketStatus, ticket.TicketStatus), "flag").addClass(getTicketStatusClass(ticket.TicketStatus));
    }
    
    var $prefMedia = $widget.find("#pref-item-media");
    if (media.MediaId == null)
      $prefMedia.remove();
    else {
      $prefMedia.find(".pref-item-value").text(media.MediaCalcCode).addClass(getTicketStatusClass(media.MediaStatus));
      $prefMedia.click(function() {
        showDetailView(PKG_CAS, "medialookup-media", {"MediaRef":media});
      });
    }
    
    var portfolioId = (ticket.PortfolioId) ? ticket.PortfolioId : (media.PortfolioId) ? media.PortfolioId : null;
    var ticketCount = (ticket.PortfolioTicketCount) ? ticket.PortfolioTicketCount : (media.TicketCount) ? media.TicketCount : 0;
    var mediaCount = (ticket.PortfolioMediaCount) ? ticket.PortfolioMediaCount : (media.PortfolioMediaCount) ? media.PortfolioMediaCount : 0;
      
    var $prefTickets = $widget.find("#pref-item-tickets");
    if (ticketCount <= 0)
      $prefTickets.remove();
    else {
      $prefTickets.find(".pref-item-value").html("<span class='badge'>" + ticketCount + "</span>");
      $prefTickets.click(function() {
        showDetailView(PKG_CAS, "medialookup-tickets", {
          "PortfolioId": portfolioId,
          "onItemClick": function($viewTickets, ticketRef) {
            UIMob.tabNavBack($viewTickets.closest(".mob-view").parent());
            params.TicketId = ticketRef.TicketId;
            loadData(params);
          }
        });
      });
    }
    
    var $prefMedias = $widget.find("#pref-item-medias");
    if (mediaCount <= 0)
      $prefMedias.remove();
    else {
      $prefMedias.find(".pref-item-value").html("<span class='badge'>" + mediaCount + "</span>");
      $prefMedias.click(function() {
        showDetailView(PKG_CAS, "medialookup-medias", {
          "PortfolioId": portfolioId,
          "onItemClick": function($viewMedias, mediaRef) {
            UIMob.tabNavBack($viewMedias.closest(".mob-view").parent());
            params.MediaId = mediaRef.MediaId;
            loadData(params);
          }
        });
      });
    }
    
    var $prefUsages = $widget.find("#pref-item-usages");
    if (strToIntDef(ticket.UsageCount, 0) <= 0)
      $prefUsages.removeClass("pref-item-arrow").find(".pref-item-value").text(itl("@Ticket.NotUsed"));
    else {
      $prefUsages.find(".pref-item-value").html("<span class='badge'>" + ticket.UsageCount + "</span>");
      $prefUsages.click(function() {
        showDetailView(PKG_CAS, "medialookup-usages", {"TicketId":ticket.TicketId});
      });
    }
  }
  
  function getTicketStatusClass(ticketStatus) {
    if (ticketStatus == LkSN.TicketStatus.Active.code)
      return "good-status";
    if (ticketStatus < goodTicketLimit)
      return "warn-status";
    return "bad-status"
  }
  
  function getAction(actionName) {
    for (var i=0; i<actions.length; i++)
      if (actions[i].Name == actionName)
        return actions[i];
    throw "Unable to find action: '" + actionName + "'";
  }

  function onAccountChange(event, newAccount) {
    account = newAccount;
    renderAccount(newAccount);
  }
  
  function onMenuClick() {
    UIMob.popupMenu({
      "Target": this,
      "Items": actions
    });
  }
  
  function showDetailView(packageName, viewName, params) {
    UIMob.tabSlideView({
      "container": $view.closest(".tab-content"),
      "packageName": packageName,
      "viewName": viewName,
      //"dir": "R2L",
      "params": params
    });
  }
  
  function onAccountDetailClick() {
    if (canEdit) {
      UIMob.tabSlideView({
        container: $view.closest(".tab-content"),
        packageName: PKG_CAS,
        viewName: "account-edit",
        params: {
          "Account": account
        }
      });
    }
  }
  
  function takePicture() {
    UIMob.showWaitGlass();
    snpNative("openCamera", {"OutputType":"picture"}).finally(function() {
      UIMob.hideWaitGlass();
    }).then(function(data) {
      if (data) {
        if (data.ImageType != "jpg")
          throw "Unsupported image type: " + data.ImageType;

        UIMob.showWaitGlass();
        snpAPI("Repository", "Save", {
          "EntityType": account.EntityType,
          "EntityId": account.AccountId,
          "ProfilePicture": true,
          "FileName": "mobile.jpg",
          "DocData": data.ImageData
        }).finally(function() {
          UIMob.hideWaitGlass();
        }).then(function(ansDO) {
          account.ProfilePictureId = ansDO.RepositoryId;
          $picture.css("background-image", "url(" + calcRepositoryURL(ansDO.RepositoryId, "small") + ")");
        });
      }
    });
  }
  
  function onPictureClick() {
    if (canEdit) {
      if (account.ProfilePictureId == null) 
        takePicture();
      else {
        UIMob.tabSlideView({
          container: $view.closest(".tab-content"),
          packageName: PKG_CAS,
          viewName: "account-pic",
          params: {
            "ProfilePictureId": account.ProfilePictureId,
            "EntityId": account.AccountId,
            "EntityType": account.EntityType,
            "takePicture": takePicture,
            "setRepositoryId": function(repositoryId) {
              if (repositoryId != account.ProfilePictureId) {
                UIMob.showWaitGlass();
                account.ProfilePictureId = repositoryId;
                snpAPI("Account", "SaveAccount", account).finally(function() {
                  UIMob.hideWaitGlass();
                }).then(function() {
                  $picture.css("background-image", "url(" + calcRepositoryURL(repositoryId, "small") + ")");
                });
              }
            }
          }
        });
      }
    }
  }
  
  function doAddTicketToCart(ticketId, transactionType) {
    UIMob.showWaitGlass();
    BLCart.shopCartAPI("AddTicketToCart", {
      "TicketId": ticketId,
      "TransactionType": transactionType
    }).finally(function() {
      UIMob.hideWaitGlass();
    }).then(function() {
      UIMob.tabNavBack($view.closest(".tab-content"));
      UIMob.setActiveTabMain(PKG_CAS + ".shopcart");
      BLMob.showMediaPickupDialog({
        "AllowExisting": true
      });
    });
  }
  
  function doActionTBI(action) {
    UIMob.showMessage("TBI: " + action.Name);
  }
  
  function executeTicketVoid(action) {
    if (media.TicketCount == 1) 
      doAddTicketToCart(media.MainTicketId, LkSN.TransactionType.TicketVoid.code);
    else if (media.TicketCount > 1) {
      UIMob.tabSlideView({
        container: $view.closest(".tab-content"),
        packageName: PKG_CAS,
        viewName: "ticketpickup",
        params: {
          PortfolioId: media.PortfolioId,
          callback: function(ticket) {
            doAddTicketToCart(ticket.TicketId, LkSN.TransactionType.TicketVoid.code);
          }
        }
      });
    }
  }
  
  function executeSetMembership(action) {
    UIMob.tabSlideView({
      container: "#page-main",
      packageName: PKG_CAS,
      viewName: "ticketpickup",
      params: {
        AccountId: account.AccountId,
        PrivilegeCardOnly: true,
        ActiveOnly: true,
        callback: function(ticket) {
          UIMob.showWaitGlass();
          BLCart.shopCartAPI("SetPrivilegeCard", {
            "TicketId": ticket.TicketId
          }).finally(function() {
            UIMob.hideWaitGlass();
          }).then(function() {
            UIMob.tabNavBack($view.closest(".tab-content"));
            UIMob.setActiveTabMain(PKG_CAS + ".shopcart");
          });
        }
      }
    });
  }
  
  function executeCreateReservation(action) {
    UIMob.showWaitGlass();
    BLCart.shopCartAPI("SetOwnerAccount", {
      "AccountId": account.AccountId
    }).finally(function() {
      UIMob.hideWaitGlass();
    }).then(function() {
      UIMob.tabNavBack($view.closest(".tab-content"));
      UIMob.setActiveTabMain(PKG_CAS + ".shopcart");
    });
  }
});
