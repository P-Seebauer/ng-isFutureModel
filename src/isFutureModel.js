angular.module('isFutureModel',[])
.directive('isResourceFuture', function() {
  return {
  restrict: 'A',
  require: ['ngModel', '?futurePendingValue'],
  
  link: function(scope, element, attr, array) {
    var ctrl = array[0], pendingVal = array[1];
    ctrl.$formatters.push(function resourceFormatter(value){
      if (value.$promise != null && value.$resolved === false){
        value.$promise.then(function (data){
	// the original code:  
        // https://github.com/angular/angular.js/blob/master/src/ng/directive/input.js#L2231  
        // it doesn't get run, because the checks for ngModels differ from normal watch tests.
          
          // debugger; // uncomment here to see the pending message
          var viewValue = data, 
          idx = ctrl.$formatters.length,
          runFormatter = false;
          ctrl.$rollbackViewValue();
          while(idx--){ 
            formatter = ctrl.$formatters[idx];
            //jsperf.com/assigment-of-boolean-or-expression-vs-integer
            if (runFormatter |= formatter === resourceFormatter)
              viewValue = formatter(viewValue)
          }
          ctrl.$viewValue = viewValue;
          ctrl.$render();
          if (0 < ctrl.$validators.length)
            ctrl.$validate();
        }); 
        if(pendingVal != null)
          return pendingVal.value;
      }
      return value;
    });
  }
  };
})
  .directive('futurePendingValue', function(){
    return {
      scope: {futurePendingValue: '@'},
      restrict: 'A',
      controller: function($scope, $element, $attrs){
	this.value = $scope.futurePendingValue;
      },
    }
  });

