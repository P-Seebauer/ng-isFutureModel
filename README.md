# isFuture #

## Requirements

`Angular.js` ≥ 1.3

## Why?

Ever tried bind a future to a `ng-model`? At least me and someone else [on Stackoverflow][soquestion] did and got an unstatisfying result/answer (“don't”). This module is similar to my answer on SO.

Bind a `ngResource` to a `ngModel`. Works with other futures, that have a `$promise` and a `$resolved` property, too. Works best with an own `$formatter`/`$parser` directive.

    <textarea is-future
		ng-model="value1" ></textarea>

## API

### `is-future`

One directive that ensures that the `$viewValue` of the model is updated when the `$resource` promise is resolved. Just hook it onto your input field.

### `future-pending-value`

Whith this directive you can supply a value for the time while your promise is unresolved (otherwise you'll get an empty object in most cases which is barely desiderable)

    <textarea future-pending-value="['downloading things']"
		is-future
		ng-model="value1" ></textarea> 

## Contributing

Welcome!

## License

This project is licensed under the [MIT license].

[soquestion]: http://stackoverflow.com/questions/18775726/angularjs-with-resource-and-custom-formatter-parser-directive-not-working/26831144
[MIT license]: http://opensource.org/licenses/MIT
