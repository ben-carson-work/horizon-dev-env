angular.module('starter.adm', [
  'starter.adm_controllers',
  'starter.adm_directives'
])

.config(['$stateProvider', function($stateProvider){
    $stateProvider
      .state('app.adm', {
        url: '/adm',
        abstract: true,
        controller: 'AdmCtrl',
        templateUrl: COMMON_JS.base_url + 'mob_adm/templates/adm.html'
      })
      
      .state('app.adm.login', {
          url: '/login',
          templateUrl: COMMON_JS.base_url + 'common/templates/login.html',
          controller: 'AdmLoginCtrl'
      })
      
      // setup an abstract state for the tabs directive
      .state('app.adm.tab', {
        url: '/tab',
        abstract: true,
        templateUrl: COMMON_JS.base_url + 'mob_adm/templates/adm_tabs.html',
        controller: 'AdmTabsCtrl'
      })

      .state('app.adm.tab.redemption', {
        url: '/redemption',
        views: {
          'tab-redemption': {
            templateUrl: COMMON_JS.base_url + 'mob_adm/templates/adm_tab-redemption.html',
            controller: 'AdmRedemptionCtrl'
          }
        }
      })

      .state('app.adm.tab.media', {
          url: '/media/:media/:ticket?',
          views: {
            'tab-redemption': {
              templateUrl: COMMON_JS.base_url + 'mob_adm/templates/adm_media.html',
              controller: 'AdmMediaCtrl'
            }
          },
          resolve: {
            MEDIA: ['WS', '$stateParams', function(WS, $stateParams){
              return WS.searchMediaCode($stateParams.media, $stateParams.ticket).then(function(data){
                return data.Answer ? data.Answer.Search : [];
              });
            }]
          }
      })

      .state('app.adm.tab.mediadetail', {
          url: '/mediadetail',
          params: {media: null}, // pass media object without showing in url
          views: {
            'tab-redemption': {
              templateUrl: COMMON_JS.base_url + 'mob_adm/templates/adm_media-detail.html',
              controller: 'AdmMediaDetailCtrl'
            }
          }
      })

      .state('app.adm.tab.mediaproduct', {
          url: '/mediaproduct',
          params: {media: null}, // pass media object without showing in url
          views: {
            'tab-redemption': {
              templateUrl: COMMON_JS.base_url + 'mob_adm/templates/adm_media-product.html',
              controller: 'AdmMediaProductCtrl'
            }
          }
      })

      .state('app.adm.tab.ticketusage', {
          url: '/ticketusage/:media',
          views: {
            'tab-redemption': {
              templateUrl: COMMON_JS.base_url + 'mob_adm/templates/adm_ticket-usage.html',
              controller: 'AdmTicketUsageCtrl'
            }
          },
          resolve: {
            TICKET_USAGE: ['WS', '$stateParams', function(WS, $stateParams){
              return WS.searchTicketUsage($stateParams.media).then(function(data){
                return data.Answer ? data.Answer.SearchTicketUsage : [];
              });
            }]
          }
      })

      .state('app.adm.tab.portfoliomedias', {
          url: '/portfoliomedias/:id',
          views: {
            'tab-redemption': {
              templateUrl: COMMON_JS.base_url + 'mob_adm/templates/adm_portfolio-medias.html',
              controller: 'AdmPortfolioMediasCtrl'
            }
          },
          resolve: {
            MEDIA: ['WS', '$stateParams', function(WS, $stateParams){
              return WS.searchMedia($stateParams.id).then(function(data){
                return data.Answer ? data.Answer.Search : [];
              });
            }]
          }
      })

      .state('app.adm.tab.portfoliotickets', {
          url: '/portfoliotickets/:id',
          views: {
            'tab-redemption': {
              templateUrl: COMMON_JS.base_url + 'mob_adm/templates/adm_portfolio-tickets.html',
              controller: 'AdmPortfolioTicketsCtrl'
            }
          },
          resolve: {
            TICKETS: ['WS', '$stateParams', function(WS, $stateParams){
              return WS.searchTicket($stateParams.id).then(function(data){
                return data.Answer ? data.Answer.Search : [];
              });
            }]
          }
      })

      .state('app.adm.tab.attendance', {
          url: '/attendance',
          views: {
            'tab-attendance': {
              templateUrl: COMMON_JS.base_url + 'mob_adm/templates/adm_tab-attendance.html',
              controller: 'AdmAttendanceCtrl'
            }
          }
      })

      .state('app.adm.tab.info', {
        url: '/info',
        views: {
          'tab-info': {
            templateUrl: COMMON_JS.base_url + 'common/templates/info.html',
            controller: 'AdmInfoCtrl'
          }
        }
      })
      
      .state('app.adm.tab.gates', {
          url: '/gates',
          views: {
            'tab-info': {
              templateUrl: COMMON_JS.base_url + 'mob_adm/templates/adm_gates.html',
              controller: 'AdmGatesCtrl'
            }
          },
          resolve: {
            GATES: ['WS', function(WS){
              return WS.gates(COMMON_JS.operatingAreaCode, COMMON_JS.locationId).then(function(data){
                return data.Answer ? data.Answer.ItemList : [];
              });
            }]
          }
      });
}]);