angular.module('starter.pay', ['starter.pay_controllers'])

.config(['$stateProvider', function($stateProvider){
    $stateProvider
        .state('app.pay', {
            url: '/pay',
            abstract: true,
            controller: 'PayCtrl',
            templateUrl: COMMON_JS.base_url + 'mob_pay/templates/pay.html'
        })

        .state('app.pay.login', {
            url: '/login',
            controller: 'PayLoginCtrl',
            templateUrl: COMMON_JS.base_url + 'common/templates/login.html'
        })

        .state('app.pay.steps', {
            url: '/steps',
            templateUrl: COMMON_JS.base_url + 'mob_pay/templates/steps.html',
            controller: 'PayStepsCtrl'
        })
        
        .state('app.pay.info', {
            url: '/info',
            templateUrl: COMMON_JS.base_url + 'common/templates/info.html',
            controller: 'PayInfoCtrl'
        });
}]);