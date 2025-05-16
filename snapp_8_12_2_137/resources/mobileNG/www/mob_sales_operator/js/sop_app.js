angular.module('starter.sop', ['starter.sop_controllers'])

.config(['$stateProvider', function($stateProvider){
    $stateProvider
        .state('app.sop', {
            url: '/sop',
            abstract: true,
            controller: 'SopCtrl',
            templateUrl: COMMON_JS.base_url + 'mob_sales_operator/templates/sop.html'
        })

        .state('app.sop.login', {
            url: '/login',
            controller: 'SopLoginCtrl',
            templateUrl: COMMON_JS.base_url + 'common/templates/login.html'
        })

        .state('app.sop.tab', {
            url: '/tab',
            abstract: true,
            templateUrl: COMMON_JS.base_url + 'mob_sales_operator/templates/sop_tabs.html',
            controller: 'SopTabsCtrl'
        })

        .state('app.sop.tab.catalog', {
            url: '/catalog',
            views: {
                'tab-catalog': {
                    templateUrl: COMMON_JS.base_url + 'mob_sales_operator/templates/catalog.html',
                    controller: 'SopCatalogCtrl'
                }
            }
        })

        .state('app.sop.tab.shopcart', {
            url: '/shopcart',
            views: {
                'tab-shopcart': {
                    templateUrl: COMMON_JS.base_url + 'mob_sales_operator/templates/shopcart.html',
                    controller: 'SopShopcartCtrl'
                }
            }
        })

        .state('app.sop.tab.account', {
            url: '/account',
            views: {
                'tab-account': {
                    templateUrl: COMMON_JS.base_url + 'mob_sales_operator/templates/account.html',
                    controller: 'SopAccountCtrl'
                }
            }
        })

        .state('app.sop.tab.lookup', {
            url: '/lookup',
            views: {
                'tab-lookup': {
                    templateUrl: COMMON_JS.base_url + 'mob_sales_operator/templates/lookup.html',
                    controller: 'SopLookupCtrl'
                }
            }
        })
        
        .state('app.sop.tab.info', {
            url: '/info',
            views: {
                'tab-info': {
                    templateUrl: COMMON_JS.base_url + 'common/templates/info.html',
                    controller: 'SopInfoCtrl'
                }
            }
        });
}]);