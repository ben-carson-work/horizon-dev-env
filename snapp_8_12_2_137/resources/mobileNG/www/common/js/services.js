angular.module('starter.services', [])

.factory('UTILS', ['$rootScope', '$log', function($rootScope, $log){
    var utils = {};

    utils.formatImageUrl = function(id, mode, size) {
        var str = '';

        if (mode === 'repository') {
            str = COMMON_JS.site_url +'repository?type='+ (size || 'small') +'&id=' + id;
        } else if (mode === 'imagecache')  {
            str = COMMON_JS.site_url +'imagecache?size='+ (size || 128) +'&name=' + id;
        }

        return str;
    };

    utils.displayErrorMsg = function(obj) {
        obj.event = obj.event || 'genericError';
        $rootScope.$broadcast(obj.event, obj);
    };

    utils.info = {
        get: function() {
            var obj = {
                userValue: COMMON_JS.userValue,
                locationValue: COMMON_JS.locationValue,
                operatingAreaId: COMMON_JS.operatingAreaId,
                operatingAreaValue: COMMON_JS.operatingAreaValue,
                workstationValue: COMMON_JS.workstationName,
                accessPointGateValue: COMMON_JS.accessPointGateValue,
                accessPointValue: COMMON_JS.accessPointValue,
                accessPointId: COMMON_JS.accessPointId
            };
            return obj;
        },
        set: function(data) {
          COMMON_JS.vgsSessionToken = data.SessionToken;
          COMMON_JS.workstationName = data.Workstation.WorkstationName;
          COMMON_JS.operatingAreaValue = data.Workstation.OpAreaName;
          COMMON_JS.operatingAreaId = data.Workstation.OpAreaId;
          COMMON_JS.locationId = data.Workstation.AccessPointList[0].AptLocationAccountId;
          COMMON_JS.locationValue = data.Workstation.AccessPointList[0].AptLocationDisplayName;
          COMMON_JS.accessPointGateValue = data.Workstation.AccessPointList[0].AptOperAreaDisplayName
          COMMON_JS.accessPointValue = data.Workstation.AccessPointList[0].AptName;
          COMMON_JS.accessPointId = data.Workstation.AccessPointList[0].AccessPointId;
          COMMON_JS.userValue = data.User.AccountName;
        }
    };

    utils.activatePlugins = function(data) {
        if (data) {
	        COMMON_METHODS.activatePlugins(data);
        }
    };
    
    return utils;
}])

.factory('IS', ['$rootScope', '$http', '$log', '$q', 'lodash', function($rootScope, $http, $log, $q, lodash){
    var internalService = {};

    internalService.getLabels = function(lang) {
        var lang = lang || 'en';
        var req = {
            method: 'GET',
            url: COMMON_JS.site_url + 'admin?page=itl&langiso='+ lang
        };

        //angularLoad to load scripts as services: return angularLoad.loadScript(url);
        return $http(req).then(function(data){
            return data;
        }, function(err){
            $log.debug(err);
        });
    };
    
    internalService.labelsPromise = function(lang) {
        if (lodash.isEmpty($rootScope.LABELS)) {
            return internalService.getLabels(lang).then(function(data){
              $rootScope.LABELS = data ? data.data : {};
              return $rootScope.LABELS;
            });
        } else {
            var deferred = $q.defer();
            deferred.resolve($rootScope.LABELS); 
            return deferred.promise;
        }
    }; 
    
    return internalService;
}])

.factory('WS',['$http', '$log', function($http, $log){
  var webService = {};

  var vgsService = function(cmd, request, content) {
      // if content is not present use standard one:
      var content = content || {
        Header: {
            Token: COMMON_JS.vgsSessionToken
        },
        Request: request
      };

      var req = {
          method: 'POST',
          url: COMMON_JS.site_url + 'service?cmd='+ cmd +'&format=json',
          /*
          headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Accept': 'application/json, text/javascript',
              'X-Requested-With': 'XMLHttpRequest'
          },
          data: "message=" + encodeURIComponent(JSON.stringify(content))
          */
          data: content
      };

      return $http(req).then(function(data){
          return data ? (data.data) : data;
      }, function(err){
          $log.debug(err);
      });
  };

  webService.workstation = function(workstationId){
      var req = {
          Command: "LoadEntWorkstation",
          LoadEntWorkstation: {
              WorkstationId: workstationId
          }
      };

      return vgsService('WORKSTATION', req);
  };
  
  webService.login = function(obj) {
    var req = {
        Command: "Login",
        Login: {
            WorkstationId: obj.workstationId,
            ReturnDetails: obj.details || false,
            ReturnRights: obj.rights || false
        }
    };
    
    if (obj.mediaCode){
      req.Login.MediaCode = obj.mediaCode;
    } else {
      req.Login.UserName = obj.username;
      req.Login.Password = obj.password;
    }
    
    return vgsService('LOGIN', req);
  };

  webService.logout = function(workstationId) {
    var req = {
        Command: "Logout",
        Logout: {
            WorkstationId: workstationId
        }
    };
    
    return vgsService('LOGIN', req);
  };

  webService.gates = function(entityType, locationId) {
    var req = {
        EntityType: entityType,
        OpArea: {
            LocationId: locationId
        }
    };
    
    return vgsService('COMMONLIST', req);
  };

  webService.catalog = function(catalogId){
      var req = {
          Command: "LoadEntCatalog",
          LoadEntCatalog: {
              CatalogId: catalogId
          }
      };

      return vgsService('CATALOG', req);
  };

  webService.account = function(accountId){
      var req = {
          Command: "LoadEntAccount",
          LoadEntAccount: {
              AccountId: accountId
          }
      };

      return vgsService('ACCOUNT', req);
  };

  webService.category = function(categoryId){
      var req = {
          Command: "LoadEntCategory",
          LoadEntCategory: {
              CategoryId: categoryId
          }
      };

      return vgsService('CATEGORY', req);
  };

  webService.event = function(eventId){
      var req = {
          Command: "LoadEntEvent",
          LoadEntEvent: {
              EventId: eventId
          }
      };

      return vgsService('EVENT', req);
  };

  webService.product = function(productId){
      var req = {
          Command: "LoadEntProduct",
          LoadEntProduct: {
              ProductId: productId
          }
      };

      return vgsService('PRODUCT', req);
  };
  
  webService.performance = function(eventId){
      var req = {
          Command: "SearchDate",
          SearchDate: {
              EventId: eventId,
              DateFrom: "2016-05-25",
              DateTo: "2016-06-26"
          }
      };

      return vgsService('PERFORMANCE', req);
  };

  webService.performanceTime = function(eventId, catalogId, startDate, endDate, recordsPerPage) {
      var req = {
          Command: "Search",
          Search: {
              EventId: eventId,
              CatalogId: catalogId,
              /*
              "SellableDateTimeFrom": startDate,
              "ToDateTime": endDate,
              */
              PerformingFromDateTime: startDate,
              PerformingToDateTime: endDate,
              RecordPerPage: recordsPerPage
          }
      };

      return vgsService('PERFORMANCE', req);
  };

  webService.performanceSellTime = function(eventId, catalogId, startDate, endDate, recordsPerPage) {
      var req = {
          Command: "Search",
          Search: {
              EventId: eventId,
              CatalogId: catalogId,
              SellableDateTimeFrom: startDate,
              ToDateTime: endDate,
              RecordPerPage: recordsPerPage
          }
      };

      return vgsService('PERFORMANCE', req);
  };

  webService.searchPerformance = function(eventId, catalogId, startDate, endDate, records){
      var req = {
          Command: "Search",
          Search: {
              EventId: eventId,
              CatalogId: catalogId,
              PerformingFromDateTime: startDate,
              PerformingToDateTime: endDate,
              RecordPerPage: records
          }
      };

      return vgsService('PERFORMANCE', req);
  };

  webService.getSellableProducts = function(performanceId, catalogId, saleChannelId) {
      var req = {
          Command: "GetSellableProducts",
          GetSellableProducts: {
              PerformanceId: performanceId,
              //"CatalogId": catalogId,
              SaleChannelId: saleChannelId
          }
      };

      return vgsService('PERFORMANCE', req);
  };

  webService.searchPerformanceByAccessPoint = function(accessPointId, startDate, endDate, page, records){
      var req = {
          Command: "Search",
          Search: {
              AccessPointId: accessPointId,
              PerformingFromDateTime: startDate,
              PerformingToDateTime: endDate,
              PagePos: page || 1,
              RecordPerPage: records || 10
          }
      };

      return vgsService('PERFORMANCE', req);
  };

  webService.saleschannel = function(type) {
      var req = {
          Command: "Search",
          Search: {
              SaleChannelType: type
          }
      };

      return vgsService('SALECHANNEL', req);
  };

  webService.lookupPortfolio = function(mediaCode) {
      var req = {
          Command: "Lookup",
          Lookup: {
              MediaCode: mediaCode
          }
      };

      return vgsService('PORTFOLIO', req);
  };

  webService.searchTicketUsage = function(portfolioId) {
    var req = {
          Command: "SearchTicketUsage",
          SearchTicketUsage: {
              PortfolioMediaId: portfolioId
          }
    };

    return vgsService('PORTFOLIO', req);
  };

  webService.searchTicket = function(portfolioId) {
    var req = {
        Command: "Search",
        Search: {
            PortfolioId: portfolioId
        }
    };

    return vgsService('TICKET', req);
  };
  
  webService.searchMedia = function(portfolioId){
      var req = {
          Command: "Search",
          Search: {
              PortfolioId: portfolioId
          }
      };

      return vgsService('MEDIA', req);
  };

  webService.searchPortfolio = function(accountId){
      var req = {
          Command: "Search",
          Search: {
              AccountId: accountId
          }
      };

      return vgsService('PORTFOLIO', req);
  };

  webService.searchEvents = function(catalogId, startDate, endDate, recordsPerPage){
      var req = {
          Command: "Search",
          Search: {
              CatalogId: catalogId,
              RecordPerPage: recordsPerPage,
              OnSaleFrom: startDate,
              OnSaleTo: endDate
          }
      };

      return vgsService('EVENT', req);
  };

  webService.searchMediaCode = function(mediaCode, ticketId) {
    var req = {
          Command: "Search",
          Search: {
            MediaCode: mediaCode,
            DefaultTicketId: ticketId || null
          }
      };

      return vgsService('MEDIA', req);
  };

  webService.addToCart = function(productId , quantity, shopCart) {
      var req = {
          Command: "AddToCart",
          AddToCart: {
              ProductId: productId,
              QuantityDelta: quantity ? quantity : 1
          },
      };

      req.ShopCart = shopCart;
      return vgsService('SHOPCART', req);
  };

  webService.removeItem = function(shopCartItemId, shopCart) {
      var req = {
          Command: "RemoveItem",
          RemoveItem: {
              ShopCartItemId: shopCartItemId
          },
      };

      req.ShopCart = shopCart;
      return vgsService('SHOPCART', req);
  };

  webService.editItemQuantity = function(shopCartItemId, quantity, shopCart) {
      var req = {
          Command: "EditItemQuantity",
          EditItemQuantity: {
              ShopCartItemId: shopCartItemId,
              QuantityDelta: quantity ? quantity : 1
          },
      };

      req.ShopCart = shopCart;
      return vgsService('SHOPCART', req);
  };

  webService.changeOperatingArea = function(accessPointId, operatingAreaId) {
    var req = {
          Command: "ChangeOperatingArea",
          ChangeOperatingArea: {
              WorkstationId: accessPointId,
              OperatingAreaId: operatingAreaId
          }
      };

      return vgsService('WORKSTATION', req);
  };

  webService.validate = function(accessPointId, mediaCode, scanType) {
    var req = {
        MediaCode: mediaCode,
        MediaCodeType: 0,
        SkipBiometricCheck: true,
        RedemptionPoint: {
            AccessPointId: accessPointId,
            UsageType: (scanType === "exit") ? COMMON_JS.usageTypeCodes.exit : COMMON_JS.usageTypeCodes.entry,
            OperatorCmd: ((scanType === "simulate") || (scanType === "lookup")) ? COMMON_JS.accessPointOperator.none : COMMON_JS.accessPointOperator.ticket
        }
    };
    
    return vgsService('VALIDATE', req);
  };

  webService.walletPayment = function(obj) {
    var req = {
        Command: "WalletPayment",
        WalletPayment: {
            MediaCode: obj.mediaCode,
            Amount: obj.amount || 0,
            Notes: obj.notes || '',
            ReturnReceipt: obj.receipt || false
        }
    };
    
    return vgsService('PORTFOLIO', req);
  };

  webService.getParsedTransactionReceipt = function(transactionId) {
    var req = {
        Command: 'GetParsedTransactionReceipt',
        GetParsedTransactionReceipt: {
            TransactionId: transactionId,
            DocTemplateId: null
        }
    };

    return vgsService('Transaction', req);
  }

  return webService;
}])

.factory('httpInterceptor', ['$rootScope', '$q', '$log', '$location', '$timeout', 'lodash', '$injector', 'UTILS', function($rootScope, $q, $log, $location, $timeout, lodash, $injector, UTILS) {
    var ignoreError = function(header, reqCode) {
        return (header.RequestCode.toLowerCase() === reqCode) && (header.StatusCode !== 200);
    };

    var showErrors = function(header) {
        if (!lodash.isEmpty($rootScope.LABELS)) {
            UTILS.displayErrorMsg({title: $rootScope.LABELS['Common.Error'], msg: header.ErrorMessage});
        } else {
            var IS = $injector.get('IS');

            IS.getLabels(COMMON_JS.langISO).then(function(data){
                $rootScope.LABELS = data ? data.data : {};
                UTILS.displayErrorMsg({title: $rootScope.LABELS['Common.Error'], msg: header.ErrorMessage});
            });
        }
    };
    
    return {
        'request': function(config) {
            return config;
        },
        'requestError': function(rejection) {
            $log.debug('request error', rejection);
            /*
            if (canRecover(rejection)) {
                return responseOrNewPromise
            }*/
            return $q.reject(rejection);
        },
        'response': function(response) {
            //$log.debug('response', response);
            var header = response.data.Header;
      
            if (lodash.startsWith(response.config.url, COMMON_JS.site_url + 'service')) {
                if (($location.$$path === '/app/adm/login') || ($location.$$path === '/app/sop/login') || (($location.$$path === '/app/pay/login') && !COMMON_JS.autoLogin)) {
                    if (ignoreError(header, 'login')) {
                        return response;
                    }
                }

                if ((header.StatusCode === 401) || (header.StatusCode === 1203)) { // unauthorized or invalid request token
                    showErrors(header);
                    
                    if (lodash.startsWith($location.$$path, '/app/adm/')) { // mob_adm
                        $timeout(function(){
                            $location.path('/app/adm/login');
                        }, 0);
                    } else if (lodash.startsWith($location.$$path, '/app/pay/')) { // mob_pay
                        if (!COMMON_JS.autoLogin) {
                            $timeout(function(){
                                $location.path('/app/pay/login');
                            }, 0);
                        }
                    } else if (lodash.startsWith($location.$$path, '/app/sop/')) { // mob_sop
                        $timeout(function(){
                            $location.path('/app/sop/login');
                        }, 0);
                    }            
                } else if(header.StatusCode !== 200) {
                    if ($location.$$path === '/app/pay/steps') {
                        if (ignoreError(header, 'portfolio')) {
                            return response;
                        }
                    }

                    showErrors(header);
                }
            }
            return response;
        },
        'responseError': function(rejection) {
            $log.debug('response error', rejection);
            /*
            if (canRecover(rejection)) {
                return responseOrNewPromise
            }
            */
            return $q.reject(rejection);
        }
    };
}]);
