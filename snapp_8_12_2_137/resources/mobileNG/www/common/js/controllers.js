angular.module('starter.controllers', [])

.controller('AppCtrl',['$scope', '$rootScope', '$state', '$log', '$ionicPopup', 'UTILS', function($scope, $rootScope, $state, $log, $ionicPopup, UTILS) {
  $scope.showAlert = function(obj) {
    var alertPopup = $ionicPopup.alert({
        title: obj.title || '',
        template: obj.msg || '',
        okText: obj.okText || $rootScope.LABELS['Common.Ok']
    });

    alertPopup.then(function(res) {
        $log.debug('alert showed up');
    });

    return alertPopup;
  };

  $scope.showConfirm = function(obj) {
    var confirmPopup = $ionicPopup.confirm({
        title: obj.title || '',
        template: obj.msg || '',
        okText: obj.okText || $rootScope.LABELS['Common.Ok'],
        cancelText: obj.cancelText || $rootScope.LABELS['Common.Cancel']
    });

    confirmPopup.then(function(res) {
      if (res) {
        //$log.debug('you are sure');
      } else {
        //$log.debug('you are not sure');
      }
    });

    return confirmPopup;
  };

  $scope.$on('genericError', function(ev, obj){
    $scope.showAlert(obj);
  });

  $scope.formatImageUrl = UTILS.formatImageUrl;
  $scope.formatCurrency = UTILS.formatCurrency;
  $scope.appIcons = COMMON_JS.icons;

  $scope.amountPattern = '^([+-]?[0-9]+(?:['+ COMMON_JS.decimalSeparator.replace('.', '\\.') +']{1}[0-9]{1,2})?)$';

  $scope.formatShortDateTimeFromXML = COMMON_METHODS.formatShortDateTimeFromXML;
  $scope.dateToXML = COMMON_METHODS.dateToXML;

  $scope.$on('setAppCurrency', function(ev, obj){
    $scope.appCurrency = obj;
  });
}])

.controller('MenuCtrl', ['$scope', '$rootScope', '$state', '$log', 'MOB_APPS', function($scope, $rootScope, $state, $log, MOB_APPS){
  $scope.mob_apps = MOB_APPS;

  $scope.goToState = function(app) {
    $rootScope.currentApplication = app.text;
    window.localStorage.setItem(COMMON_JS.appName +'_currentApplication', JSON.stringify(app));
    $state.go(app.url);
  };
}])

.controller('InfoCtrl',['$scope', '$rootScope', '$state', '$log', 'WS', '$ionicLoading', 'LOADER', 'UTILS', function($scope, $rootScope, $state, $log, WS, $ionicLoading, LOADER, UTILS) {
  $scope.info = UTILS.info.get();

  if ($state.current.name === 'app.pay.info') {
    $scope.hideGate = true;
    $scope.hideAccessPoint = true;
  };

  $scope.goToGates = function() {
    $state.go('app.adm.tab.gates');
  };

  $scope.goToMenu = function() {
    $state.go('app.menu');
  };

  $scope.redirectAfterLogout = function() {
    if ($state.current.name === 'app.adm.info') {
      $state.go('app.adm.login');
    } else {
      $state.go('app.menu');
    }
  };

  $scope.logout = function(title, msg) {
    $scope.showConfirm({
      title: title,
      msg: msg,
      okText: $rootScope.LABELS['Common.Logout'],
      cancelText: $rootScope.LABELS['Common.Cancel']
    }).then(function(res){
      if (res) {
        $ionicLoading.show(LOADER);

        WS.logout(COMMON_JS.workstationId).then(function(data){
          if (data.Header.StatusCode === 200) {
            $log.debug('logout', data);
            $scope.redirectAfterLogout();
          }
        }).finally(function(){
          $ionicLoading.hide();
        });
      } else {
        // cancel
      }
    });
  };

  $scope.resetLicense = function(msg) {
    $scope.showConfirm({
      title: $rootScope.LABELS['Common.ResetLicense'],
      msg: msg,
      okText: $rootScope.LABELS['Common.Reset'],
      cancelText: $rootScope.LABELS['Common.Cancel']
    }).then(function(res){
      if (res) {
        $ionicLoading.show(LOADER);

        WS.logout(COMMON_JS.workstationId).then(function(data){
          if (data.Header.StatusCode === 200) {
            $log.debug('logout', data);
            COMMON_METHODS.sendCommand('Unregister');
            $scope.redirectAfterLogout();
          }
        }).finally(function(){
          $ionicLoading.hide();
        });  
      } else {
        // cancel
      }
    });
  };

  $rootScope.$on('changeOperatingArea', function(e, obj) {
    $scope.info.operatingAreaId = obj.id;
    $scope.info.accessPointGateValue = obj.name;
  });
}]);
