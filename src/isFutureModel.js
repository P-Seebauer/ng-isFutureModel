angular.module('isFuture',[])
.directive('isFuture', ['$timeout', function($timeout) {
  return {
  restrict: 'A',
  require: ['ngModel', '?futurePendingValue'],
  link: function(scope, element, attr, array) {
    var ctrl = array[0], pendingVal = array[1], runAfterPromise = false;
    // sometimes the $parsers get run in the $digest cycle of the $promise 
    // resolution. This is a bit hackish, but it works: we set a boolean to true
    // in for the case, that we are in the promise resolution and a $timeout of 
    // duration 1 to set it to false (hopefully after the cycle)
    ctrl.$parsers.unshift(function(text){
      if(runAfterPromise){
	runAfterPromise = false;
	return undefined // return undefined to stop the $parser application
      }
      return text
    });

    ctrl.$formatters.push(function resourceFormatter(value){
      if (value.$promise != null && value.$resolved === false){
        // it doesn't get run when the promise is resolved, because the checks for
	// ngModels differ from normal watch tests, and rely on object equality
	// thus we'll rerun the code by hand after the promise is resolved
        value.$promise.then(function (data){
	  runAfterPromise = true; // see explanation in the $parser
	  $timeout(function(){runAfterPromise = false},1,false);
	// the original code:  
        // https://github.com/angular/angular.js/blob/master/src/ng/directive/input.js#L2231  
          var viewValue  = data, // avoid false reparses from (probably errornous $parsers calls)
	    idx          = ctrl.$formatters.length,
	    formatter;
	  ctrl.$modelValue = data;
          while(idx--){
            formatter = ctrl.$formatters[idx];
	    if (formatter !== resourceFormatter) // we don't have to rerun this formatter
	      viewValue = formatter(viewValue)
          }
          ctrl.$viewValue = viewValue;
          ctrl.$render();
          if (! ctrl.$validators.length) ctrl.$validate();
	  
        }); 
        if(pendingVal != null){
	  return pendingVal.value;
	}
      }
      return value; // no promise, so we'll just pass throgh the value
    })}}}]) // end of: resourceFormatter, @link, "directive " «~« <object function call>
.directive('futurePendingValue', function(){
    return {
      // require: 'isFuture', sadly this isn't possible
      scope: {futurePendingValue: '@'},
      restrict: 'A',
      controller: function($scope, $element, $attrs){
	this.value = $scope.futurePendingValue;
      },
    }
  });
