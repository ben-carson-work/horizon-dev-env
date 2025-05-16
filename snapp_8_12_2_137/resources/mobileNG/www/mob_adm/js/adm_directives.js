angular.module('starter.adm_directives', [])

.directive('attendanceStatus', ['$log', function($log) {
  return {
    restrict: 'A',
    scope: '=',
    link : function($scope, $element, $attrs) {
      $scope.$watch('performance', function(){
        var now = new Date();
        var status = '';
        var perf = $scope.performance;

        if ((now >= COMMON_METHODS.xmlToDate(perf.AdmDateTimeFrom)) && (now <= COMMON_METHODS.xmlToDate(perf.AdmDateTimeTo))) {
          status = 'status-open';
        } else if ((now >= COMMON_METHODS.xmlToDate(perf.DateTimeFrom)) && (now <= COMMON_METHODS.xmlToDate(perf.DateTimeTo))) {
          status = 'status-busy';
        }

        $element.attr('data-status', status);
      });    
    }
  }
}]);