angular.module('starter.adm_controllers', [])

.controller('AdmCtrl',['$scope', '$log', function($scope, $log) {
  //$log.debug('AdmCtrl');
  $scope.$on('redemptionKeyboard', function(ev, obj){
    $scope.manualBarcode = obj.keyboardIsActive;
  });
}])

.controller('AdmLoginCtrl', ['$scope', '$log', '$state', 'WS', '$ionicLoading', 'LOADER', '$window', '$timeout', 'lodash', 'UTILS', function($scope, $log, $state, WS, $ionicLoading, LOADER, $window, $timeout, lodash, UTILS) { 
  $scope.login = {
    username: '',
    password: ''
  };
  
  $scope.logo = COMMON_JS.logo;
  
  $scope.doLogin = function(mediaCode){
    //$log.debug('login form submitted');
    $ionicLoading.show(LOADER);

    WS.login({
        workstationId: COMMON_JS.workstationId,
        username: $scope.login.username,
        password: $scope.login.password,
        mediaCode: mediaCode,
        details: true,
        rights: true
      }).then(function(data){
        $log.debug(data);

        if (data.Header.StatusCode === 200) {
          $scope.loginError = false;
          UTILS.info.set(data.Answer.Login);
          UTILS.activatePlugins(data.Answer.Login.Workstation.PluginList);

          var mainCurrency = lodash.filter(data.Answer.Login.Workstation.CurrencyList, {'CurrencyId': data.Answer.Login.Workstation.MainCurrencyId});
          $scope.$emit('setAppCurrency', mainCurrency[0]);
          $state.go('app.adm.tab.redemption');
        } else {
          $scope.loginError = true;
          $scope.loginErrorMsg = data.Header.ErrorMessage;
        }
    }).finally(function(){
      $ionicLoading.hide();
    });
  };

  $scope.$on('brcReader', function(e, code){
    $scope.doLogin(code);
  });
  
  $scope.userkeydown = function(e){
    if (e.keyCode === COMMON_METHODS.keyboard('KEY_ENTER')) {
      $timeout(function(){
        $('#txt-password').focus();
      }, 0); 
    }
  };
}])

.controller('AdmTabsCtrl',['$scope', '$rootScope', function($scope, $rootScope) {
  
}])

.controller('AdmRedemptionCtrl',['$scope', '$rootScope', '$state', '$ionicModal', '$ionicLoading', 'LOADER', 'WS', '$log', 'lodash', function($scope, $rootScope, $state, $ionicModal, $ionicLoading, LOADER, WS, $log, lodash) {
  $scope.init = function() {
    $scope.data = {
      mediaCode: ''
    };

    $scope.validateData = [];
  };
  $scope.init();

  $scope.mediaNotFoundCode = COMMON_JS.mediaNotFound;

  $scope.toggleKeyboard = function(val) {
    $scope.keyboardIsActive = (val != undefined) ? val : !$scope.keyboardIsActive;
    $scope.$emit('redemptionKeyboard', {keyboardIsActive: $scope.keyboardIsActive});
  };

  $scope.scan = {
      types: lodash.keys(COMMON_JS.usageTypes),
      usageTypes: COMMON_JS.usageTypes,
      buttons: [
        $rootScope.LABELS['Entitlement.Entry'], 
        $rootScope.LABELS['AccessPoint.SimulatedEntry'], 
        $rootScope.LABELS['Common.Exit'], 
        $rootScope.LABELS['Common.Lookup'],
        $rootScope.LABELS['Common.Cancel']
      ]
  };
  $scope.scan.selected = COMMON_JS.initScanType();

  $ionicModal.fromTemplateUrl(COMMON_JS.base_url + 'mob_adm/templates/adm_tab-redemption-scanModal.html', {
    scope: $scope,
    animation: 'slide-in-up'
  }).then(function(modal) {
    $scope.modal = modal;
  });
  $scope.openModal = function() {
    $scope.modal.show();
  };
  $scope.closeModal = function() {
    $scope.modal.hide();
  };
  // Cleanup the modal when we're done with it!
  $scope.$on('$destroy', function() {
    $scope.modal.remove();
  });
  // Execute action on hide modal
  $scope.$on('modal.hidden', function() {
    // Execute action
  });
  // Execute action on remove modal
  $scope.$on('modal.removed', function() {
    // Execute action
  });

  $scope.scanUsageType = function() {
    $scope.openModal();
  };

  $scope.clickedScanButton = function(index) {
    if (index < $scope.scan.types.length) {
      $scope.scan.selected = COMMON_JS.setScanType($scope.scan.types[index]);
    }
    $scope.closeModal();
  };

  $scope.validateService = function(){
    $ionicLoading.show(LOADER);
    // code scanned or manual inserted
    WS.validate(COMMON_JS.accessPointId, $scope.data.mediaCode, $scope.scan.selected).then(function(data){
      $log.debug(data);

      if (!lodash.isEmpty(data.Answer)){
        $scope.validateSubmitted = true;
        $scope.validateData.unshift(data.Answer);
        $scope.validateData[0].usedMediaCode = angular.copy($scope.data.mediaCode);
        $scope.data.mediaCode = '';         
      }
    }).finally(function(){
      $ionicLoading.hide();
    });
  };

  $scope.lookupService = function(mediaCode, ticketId) {
    var mediaCode = mediaCode || $scope.data.mediaCode;
    $state.go('app.adm.tab.media', {media: mediaCode, ticket: ticketId});
  };

  $scope.validate = function() {
    $scope.validateSubmitted = false;

    if ($scope.scan.selected === 'lookup') {
      $scope.lookupService();
    } else {
      $scope.validateService();
    }
  };

  $scope.$on('brcReader', function(e, code){
    $scope.data.mediaCode = code;
    $scope.validate();
  });

  // view events:
  $scope.$on('$ionicView.beforeEnter', function(e) {
    //$scope.init();
  });
  $scope.$on('$ionicView.beforeLeave', function(e) {
    $scope.toggleKeyboard(false);
  });
  //
}])

.controller('AdmAttendanceCtrl',['$scope', '$ionicLoading', 'LOADER', 'WS', '$log', function($scope, $ionicLoading, LOADER, WS, $log) {
  // With the new view caching in Ionic, Controllers are only called
  // when they are recreated or on app start, instead of every page change.
  // To listen for when this page is active (for example, to refresh data),
  // listen for the $ionicView.enter event:
  //
  $scope.$on('$ionicView.beforeEnter', function(e) {
    var dtFrom = new Date();
    var dtTo = new Date();
    var page = 1;

    dtFrom.setMinutes(dtFrom.getMinutes() - 30);
    dtTo.setHours(dtTo.getHours() + 10);

    $ionicLoading.show(LOADER);
    
    $log.debug(dtFrom);
    $log.debug(dtTo);

    WS.searchPerformanceByAccessPoint(COMMON_JS.accessPointId, COMMON_METHODS.dateToXML(dtFrom), COMMON_METHODS.dateToXML(dtTo), page).then(function(data){
      $log.debug(data);
      $scope.attendance = data.Answer ? data.Answer.Search : {};
    }).finally(function(){
      $ionicLoading.hide();
    });
  });
}])

.controller('AdmInfoCtrl',['$scope', function($scope) {
  $scope.dataPage = 'adm_info';
}])

.controller('AdmGatesCtrl',['$scope', '$state', '$ionicLoading', 'LOADER', '$log', 'WS', 'GATES', function($scope, $state, $ionicLoading, LOADER, $log, WS, GATES) {
  $scope.gates = GATES;

  $scope.select = function(item) {
    $log.debug('selected gate id', item.ItemId);

    $ionicLoading.show(LOADER);

    WS.changeOperatingArea(COMMON_JS.accessPointId, item.ItemId).then(function(data){
      if (data.Header.StatusCode === 200) {
        $scope.selectedId = item.ItemId;   
        $scope.$emit('changeOperatingArea', {id: item.ItemId, name: item.ItemName});
        $state.go('app.adm.tab.info');
      } else {
        $log.debug('changeOperatingArea', data.Header);
      }
    }).finally(function(){
      $ionicLoading.hide();
    });
  };
}])

.controller('AdmMediaCtrl',['$scope', '$state', '$ionicLoading', 'LOADER', '$log', 'WS', 'MEDIA', function($scope, $state, $ionicLoading, LOADER, $log, WS, MEDIA) {
  $scope.media = MEDIA;

  $scope.searchTicketUsage = function(mediaId) {
    $state.go('app.adm.tab.ticketusage', {media: mediaId});
  };

  $scope.mediaProduct = function(media) {
    $state.go('app.adm.tab.mediaproduct', {media: media});
  };

  $scope.mediaDetail = function(media) {
    $state.go('app.adm.tab.mediadetail', {media: media});
  };

  $scope.portfolioMedias = function(portfolioId) {
    $state.go('app.adm.tab.portfoliomedias', {id: portfolioId});
  };

  $scope.portfolioTickets = function(portfolioId) {
    $state.go('app.adm.tab.portfoliotickets', {id: portfolioId});
  };
}])

.controller('AdmMediaProductCtrl',['$scope', '$stateParams', '$log', function($scope, $stateParams, $log) {
  $log.debug('stateParams', $stateParams);
  $scope.media = $stateParams.media;

  $scope.now = new Date();

  $scope.statusClass = ($scope.media.MainTicketStatus === COMMON_JS.ticketStatusActive) ? 'good-status' : ($scope.media.MainTicketStatus < COMMON_JS.ticketStatusGoodLimit ? 'warn-status' : 'bad-status');
}])

.controller('AdmMediaDetailCtrl',['$scope', '$stateParams', '$log', function($scope, $stateParams, $log) {
  $log.debug('stateParams', $stateParams);
  $scope.media = $stateParams.media;

  $scope.statusClass = ($scope.media.MediaStatus === COMMON_JS.ticketStatusActive) ? 'good-status' : ($scope.media.MediaStatus < COMMON_JS.ticketStatusGoodLimit ? 'warn-status' : 'bad-status');
}])

.controller('AdmTicketUsageCtrl',['$scope', 'TICKET_USAGE', function($scope, TICKET_USAGE) {
  $scope.usages = TICKET_USAGE;
}])

.controller('AdmPortfolioMediasCtrl',['$scope', 'MEDIA', function($scope, MEDIA) {
  $scope.medias = MEDIA;
}])

.controller('AdmPortfolioTicketsCtrl',['$scope', 'TICKETS', function($scope, TICKETS) {
  $scope.tickets = TICKETS;
}]);