angular.module('starter.directives', [])

.directive('toggleFocus', ['$timeout', function($timeout){
    return {
        restrict: 'A',
        link: function($scope, $element, $attrs) {
            $element.bind('click', function(e){
                var active = !($attrs.keyboardactive === 'true');
                var $targetId = $('.'+ $attrs.targetid);

                if (active) {
                    $timeout(function(){
                        $targetId.focus();
                    }, 200);  
                } else {
                    $timeout(function(){
                        $targetId.blur();
                    }, 200); 
                }
            });
        }
    }
}])

.directive('myAutofocus', ['$timeout', '$log', function($timeout, $log) {
  return {
    restrict: 'A',
    link : function($scope, $element, $attrs) {
      $timeout(function() {
        $element[0].focus();
      }, 500);
    }
  }
}]);
