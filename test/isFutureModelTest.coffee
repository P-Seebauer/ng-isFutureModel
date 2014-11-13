angular.module('myApp',['ngResource'])
  .directive 'jsonconvert', ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attr, ctrl) ->
      ctrl.$parsers.push (text) ->
        JSON.parse(text)
      ctrl.$formatters.push (obj)  -> JSON.stringify(obj,null,0)

describe 'isFuture',->
  expectedModel = data: 1
  expectedValue = JSON.stringify(expectedModel,null,0)
  myTemplate = (attrs = ["is-future", "jsonconvert"], moreAttrs...) ->
    attrs = attrs.concat moreAttrs
    "<input #{attrs.join ' '} ng-model='modelValue'/>"
  beforeEach () ->
    module 'isFuture'
    module 'myApp'
    module 'ngResource'

  afterEach inject ($document, $rootScope, $httpBackend) ->
    ($document.find 'body').html ''
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    delete $rootScope['modelValue']

  it "should throw an error if no ngModel is present",->
      inject ($compile, $rootScope, $document) ->
        expect( ->
          try
            element = ($compile "<input is-future />") $rootScope
            $document.find('body').append element
          finally
            element?.detach()
          ).to.throw(/^\[\$compile:ctreq\] Controller \'ngModel\'/)
    

  it "should not run on none-futures", inject ($compile, $rootScope) ->
    $rootScope.modelValue = expectedModel
    element = ($compile myTemplate()) $rootScope
    $rootScope.$digest()
    (expect element[0]).to.have.property("value",expectedValue)

  it "should inject the value if a future is given",
    inject ($compile, $rootScope, $resource, $httpBackend) ->
      $httpBackend.expectGET('some.data.json').respond 200, expectedModel
      $rootScope.modelValue = ($resource 'some.data.json').get({})
      element = ($compile myTemplate()) $rootScope
      $httpBackend.flush()
      (expect element[0]).to.have.property("value",expectedValue) 

  it "should work independent of order",
    inject ($compile, $rootScope, $resource, $httpBackend) ->
      $httpBackend.expectGET('some.data.json').respond 200, expectedModel
      $rootScope.modelValue = ($resource 'some.data.json').get({})
      elements = 
        'is-future first': ($compile myTemplate(["is-future","jsonconvert"])) $rootScope
        'is-future last':  ($compile myTemplate(["jsonconvert","is-future"])) $rootScope
      $httpBackend.flush()
      for message, element of elements
        (expect element[0], message).to.have.property("value",expectedValue)
      undefined # avoid generation of _return value

  describe 'futurePendingValue',->
    it "should provide a value for the case of pending",
      inject ($compile, $rootScope, $resource, $httpBackend) ->
        $httpBackend.expectGET('some.data.json').respond 200, expectedModel
        $rootScope.modelValue = ($resource 'some.data.json').get({})
        element =
          ($compile myTemplate(undefined, 'future-pending-value="pending"')) $rootScope
        $rootScope.$digest()
        (expect element[0]).to.have.property("value", "\"pending\"")
        $httpBackend.flush()
        (expect element[0]).to.have.property("value",expectedValue)

    it "shouldn't be 'active' for none-futures",
      inject ($compile, $rootScope, $resource) ->
        $rootScope.modelValue = expectedModel
        element =
          ($compile myTemplate(undefined, 'future-pending-value="pending"')) $rootScope
        $rootScope.$digest()
        (expect element[0]).to.have.property("value", expectedValue)
        (expect element[0]).to.have.property("value",expectedValue)
