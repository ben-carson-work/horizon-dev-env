(function(window, $, undefined) {
  // Ionic Starter App

  // angular.module is a global place for creating, registering and retrieving Angular modules
  // 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
  // the 2nd parameter is an array of 'requires'
  // 'starter.services' is found in services.js
  // 'starter.controllers' is found in controllers.js
  angular.module('starter', [
    'ionic',
    'ngLodash',
    'starter.controllers',
    'starter.services',
    'starter.constants',
    'starter.directives',
    'starter.adm',
    'starter.pay',
    'starter.sop'
  ])

  .config(['$stateProvider', '$urlRouterProvider', '$httpProvider', '$logProvider', '$ionicConfigProvider', function($stateProvider, $urlRouterProvider, $httpProvider, $logProvider, $ionicConfigProvider) {
    $logProvider.debugEnabled(COMMON_JS.debug);
    //alert('debug: '+ COMMON_JS.debug);
    $httpProvider.interceptors.push('httpInterceptor');
    $ionicConfigProvider.platform.android.tabs.position('bottom'); // android's default is top
    $ionicConfigProvider.platform.android.tabs.style('standard'); // android's default is 'striped'
    $ionicConfigProvider.platform.android.navBar.alignTitle('center'); // android's default is left
    $ionicConfigProvider.platform.android.backButton.icon('ion-chevron-left');
    //console.log($ionicConfigProvider);

    // Ionic uses AngularUI Router which uses the concept of states
    // Learn more here: https://github.com/angular-ui/ui-router
    // Set up the various states which the app can be in.
    // Each state's controller can be found in controllers.js
    $stateProvider
      .state('app', {
        url: '/app',
        controller: 'AppCtrl',
        abstract: true,
        templateUrl: COMMON_JS.base_url + 'common/templates/app.html',
        resolve: {
          INIT: ['$rootScope', '$q', function($rootScope, $q){
            var deferred = $q.defer();
            var current_app = window.localStorage.getItem(COMMON_JS.appName +'_currentApplication');

            if (current_app) {
              app = JSON.parse(current_app);
              $rootScope.currentApplication = app.text;
            }

            deferred.resolve();
          }],
          LABELS: ['IS', function(IS) {
            return IS.labelsPromise(COMMON_JS.langISO);
          }]
        }
      })
      
      .state('app.menu', {
        url: '/menu',
        controller: 'MenuCtrl',
        templateUrl: COMMON_JS.base_url + 'common/templates/menu.html',
        resolve: {
          INIT: ['$state', '$rootScope', '$q', '$timeout', function($state, $rootScope, $q, $timeout){
            var deferred = $q.defer();
            var current_app = window.localStorage.getItem(COMMON_JS.appName +'_currentApplication');
            
            // redirect to localStorage current application:
            if (current_app && ($state.current.url !== '/info')) {
              $timeout(function(){
                app = JSON.parse(current_app);
                $rootScope.currentApplication = app.text;
                deferred.reject();

                if ($state.current.name !== app.url) {
                  $state.go(app.url);
                }
              }, 0);
            } else {
              deferred.resolve();
            }
            
            return deferred.promise;
          }],
          LABELS: ['IS', function(IS) {
            return IS.labelsPromise(COMMON_JS.langISO);
          }],
          MOB_APPS: ['$location', '$q', 'lodash', 'LABELS', function($location, $q, lodash, LABELS){
            var deferred = $q.defer();
            var loc_array = ($location.$$absUrl.split('#/app')[0]).split('&');
            var loc_index = lodash.findIndex(loc_array, function(o){
              if (lodash.startsWith(o, 'apps=')) {
                return o;
              }
            });
            
            var list = (loc_index != -1) ? loc_array[loc_index].replace('apps=','').split(',') : [];

            if (COMMON_JS.local && lodash.isEmpty(list)) {
              list = lodash.values(COMMON_JS.mob_apps_keys);
            }

            var new_list = [];

            lodash.forEach(list, function(val, i){
              var k = lodash.filter(COMMON_JS.mob_apps, {key: val})[0];
              k.text = LABELS['System.'+ val];

              switch (val) {
                case COMMON_JS.mob_apps_keys.adm:
                  k.url = 'app.adm.login';
                  break;
                case COMMON_JS.mob_apps_keys.payment:
                  if (COMMON_JS.autoLogin) {
                    k.url = 'app.pay.steps';
                  } else {
                    k.url = 'app.pay.login';
                  }
                  break;
                case COMMON_JS.mob_apps_keys.guest:
                  k.url = '';
                  break;
                case COMMON_JS.mob_apps_keys.operator:
                  k.url = '';
                  break;
                default:
                  break;
              }

              new_list.push(k);
            });

            //alert(JSON.stringify(new_list));
            deferred.resolve(new_list);
            return deferred.promise;
          }]
        } 
      });

    // if none of the above states are matched, use this as the fallback
    $urlRouterProvider.otherwise('/app/menu');

  }])

  .run(['$rootScope', '$state', '$log', '$ionicPlatform', '$ionicLoading', '$timeout', '$location', '$document', 'LOADER', 'lodash', 'UTILS', 'WS', function($rootScope, $state, $log, $ionicPlatform, $ionicLoading, $timeout, $location, $document, LOADER, lodash, UTILS, WS) {
    $ionicPlatform.ready(function() {
      //$log.debug('COMMON_JS', COMMON_JS);
      //$log.debug($state);

      if (!COMMON_JS.userValue && $state.current.name !== 'app.menu' && $state.current.name !== '') {
        $location.path('/app/menu');
      }

      var setPageClass = function(stateName) {
        $timeout(function(){
          $rootScope.pageClass = stateName ? 'page-'+ stateName.replace(/\./g,'-') : '';
        },0);
      };

      setPageClass($state.current.name);

      COMMON_METHODS.sendCommand("SetPlugins");
      COMMON_METHODS.sendCommand("StartRFID");

      window.onClosingApplication = function() {
        COMMON_METHODS.sendCommand("StopRFID");
        //alert('closing application');
        WS.logout(COMMON_JS.workstationId);
      };

      // media reader:
      var reader = {
        init: function() {
          this.brc_reader();
          this.code_read();
        },
        brc_reader: function() {
          var self = this;
          var keybuffer = "";
          var tsLast = (new Date()).getTime();

          $document.on('keydown', function(e){
            //$log.log(e.keyCode);
            if (!$(':focus').length) {
                var tsNow = (new Date()).getTime();

                if (tsNow - tsLast > 100) {
                    keybuffer = '';
                }       
                        
                if ((e.keyCode >= 48) && (e.keyCode <= 122)) {
                    keybuffer += String.fromCharCode(e.keyCode);
                } else if ((e.keyCode == COMMON_METHODS.keyboard('KEY_ENTER')) && (keybuffer.length >= 6)) {
                    self.doMediaRead(keybuffer);
                    keybuffer = "";
                }
                        
                tsLast = tsNow;
            }
          });
        },
        code_read: function() {
          var self = this;
          // angular's $document doesn't work with this event:
          $(document).bind("VGS_CodeRead", function(event, code) {
            if (code) {
              self.doMediaRead(code);
              //alert('VGS_CodeRead: '+ code);
            }
          });
        },
        doMediaRead: function(code) {
          $rootScope.$broadcast('brcReader', code);
        }
      };
      reader.init();
      
      $rootScope.$on('$stateChangeStart', function(event, toState, toParams, fromState, fromParams){
        //$log.debug('start', toState);
        
        $ionicLoading.show(LOADER).then(function(){
          //$log.debug("The loading indicator is now displayed");
        });
      });
      $rootScope.$on('$stateChangeSuccess', function(event, toState, toParams, fromState, fromParams){
        //$log.debug('success', toState);
        setPageClass(toState.name);

        $ionicLoading.hide().then(function(){
          //$log.debug("The loading indicator is now hidden");
        });
      });
      $rootScope.$on('$stateChangeError', function(event, toState, toParams, fromState, fromParams){
        $log.debug('error', toState);
        
        $ionicLoading.hide().then(function(){
          //$log.debug("The loading indicator is now hidden");
        });
      });
    });
  }]);

})(window, jQuery);
