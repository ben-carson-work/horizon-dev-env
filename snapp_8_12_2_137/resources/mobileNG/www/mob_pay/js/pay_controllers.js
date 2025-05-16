angular.module('starter.pay_controllers', [])

.controller('PayCtrl',['$scope', '$state', '$log', 'WS', 'lodash', '$ionicLoading', 'LOADER', 'lodash', 'UTILS', function($scope, $state, $log, WS, lodash, $ionicLoading, LOADER, lodash, UTILS) {
  $scope.activeStep = 1;

  $scope.isActiveStep = function(step) {
    return ($scope.activeStep === step);
  };

  $scope.$on('changeStep', function(e, obj){
    $scope.activeStep = obj.step;
  });

  $scope.$on('pay_login', function(e, obj){
    $ionicLoading.show(LOADER);

    WS.login(obj).then(function(data){
        $log.debug(data);

        if (data.Header.StatusCode === 200) {
          $scope.loginError = false;
          UTILS.info.set(data.Answer.Login);
          UTILS.activatePlugins(data.Answer.Login.Workstation.PluginList);

          var mainCurrency = lodash.filter(data.Answer.Login.Workstation.CurrencyList, {'CurrencyId': data.Answer.Login.Workstation.MainCurrencyId});
          $scope.$emit('setAppCurrency', mainCurrency[0]);
          $state.go('app.pay.steps');
        } else {
          $scope.loginError = true;
          $scope.loginErrorMsg = data.Header.ErrorMessage;
        }
    }).finally(function(){
      $ionicLoading.hide();
    });
  });

  $scope.$on('paystepsKeyboard', function(ev, obj){
    $scope.manualBarcode = obj.keyboardIsActive;
  });
}])

.controller('PayLoginCtrl', ['$scope', '$log', function($scope, $log) {
  $scope.login = {
    username: '',
    password: ''
  };
  
  $scope.logo = COMMON_JS.logo; 

  $scope.doLogin = function(mediaCode) {
    $scope.$emit('pay_login', {
        workstationId: COMMON_JS.workstationId,
        username: $scope.login.username,
        password: $scope.login.password,
        mediaCode: mediaCode,
        details: true
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

.controller('PayStepsCtrl',['$scope', '$rootScope', '$state', '$log', '$ionicLoading', 'LOADER', 'WS', 'lodash', function($scope, $rootScope, $state, $log, $ionicLoading, LOADER, WS, lodash) {
  $scope.$on('$ionicView.beforeEnter', function(e) {
    if (COMMON_JS.autoLogin) {
        $scope.$emit('pay_login', {
          workstationId: COMMON_JS.workstationId,
          details: true
        });
    }
  });

  $scope.iconInfo = COMMON_JS.icons.info;
  $scope.autoLogin = COMMON_JS.autoLogin;

  $scope.toggleKeyboard = function(val) {
    $scope.keyboardIsActive = (val != undefined) ? val : !$scope.keyboardIsActive;
    $scope.$emit('paystepsKeyboard', {keyboardIsActive: $scope.keyboardIsActive});
  };

  $scope.goToMenu = function() {
    $state.go('app.menu');
  };

  $scope.goToInfo = function() {
    $state.go('app.pay.info');
  };

  $scope.init = function() {
    $scope.step = {};
  };

  $scope.doStep = function(step, init) {
      var step = step || 1;

      //step = (step === 2) ? 3 : step;
      
      if (init) {
        $scope.init();
      }

      $scope.toggleKeyboard(false);
      $scope.$emit('changeStep', {step: step});
  };
   
  $scope.$on('$ionicView.beforeEnter', function(e) {
    $scope.doStep(1, true);
  });

  $scope.pay = function() {
    $scope.step.isAuthorizing = true;

    var amount = parseFloat($scope.step.amount);
    
    WS.walletPayment({
      mediaCode: $scope.step.barcode,
      amount: amount,
      notes: $scope.step.notes,
      receipt: true
    }).then(function(data){
      $log.debug(data);
      var wallet = data.Answer ? data.Answer.WalletPayment.WalletTransaction : {};

      console.log(wallet);
      if (!lodash.isEmpty(wallet)) {
        $scope.step.wallet = wallet;
        $scope.step.isApproved = true;
        //alert(JSON.stringify(wallet.Receipt.DriverList));
        
        // print receipt:
        NativeBridge.call("Print", [wallet.Receipt.DriverList, wallet.Receipt.DocData], function(successful, errorMsg){
          if (!successful) {
            $scope.showAlert({title: $rootScope.LABELS['Common.Error'], msg: errorMsg});
          }
        });
      } else {
        $scope.step.errorMsg = data.Header.ErrorMessage;
      }
    }).finally(function(){
        $scope.step.isAuthorizing = false;
        $scope.doStep(4);
    });
  };

  $scope.$on('brcReader', function(e, code){
    $scope.step.barcode = code;
    $scope.pay();
  });

  $scope.stepOneFormAction = function(form) {
    if (form.$valid) {
      //step 2: $scope.doStep(2);
      $scope.doStep(3);
    }
  };

  $scope.submitForm = function(form, e) {
    if (e) {
      if (e.keyCode === COMMON_METHODS.keyboard('KEY_TAB')) {
        $scope.stepOneFormAction(form);
      }
    } else {
      $scope.stepOneFormAction(form);
    }
  };
}])

.controller('PayInfoCtrl',['$scope', function($scope) {
  $scope.dataPage = 'pay_info';
}]);