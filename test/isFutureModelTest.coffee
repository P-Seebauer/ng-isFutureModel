angular.module('myApp',['ngResource'])
  .directive 'jsonconvert', ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attr, ctrl) ->
      ctrl.$parsers.push    (text) -> JSON.parse(text)
      ctrl.$formatters.push (text) ->
        JSON.stringify(text,null,0)

describe 'isFutureModel',->
  expectedModel = data: 1
  expectedValue = JSON.stringify(expectedModel,null,0)
  myTemplate = (attrs = {}) ->
    attrString = (key + "=#{value}" for own key, value of attrs).join(' ')
    """
      <input #{attrString} jsonconvert is-future-model ng-model='modelValue'/>
    """

  beforeEach () ->
    module 'isFutureModel'
    module 'myApp'
    module 'ngResource'

  afterEach inject ($document, $rootScope, $httpBackend) ->
    ($document.find 'body').html ''
    delete $rootScope.modelValue
    $httpBackend.verifyNoOutstandingExpectation();
    $httpBackend.verifyNoOutstandingRequest();

  it "should work with none-futures", inject ($compile, $rootScope) ->
    $rootScope.modelValue = expectedModel
    $rootScope.$digest()
    element = ($compile myTemplate()) $rootScope
    console.log element[0]
    (expect element[0]).to.have.property("value",expectedValue)

  it "should work with a future value",
    inject ($compile, $rootScope, $resource, $httpBackend) ->
      $httpBackend.expectGET('some.data.json').respond 200, expectedModel
      $rootScope.modelValue = ($resource 'some.data.json').get({})
      element = ($compile myTemplate()) $rootScope
      $httpBackend.flush()
      (expect element[0]).to.have.property("value",expectedValue)
