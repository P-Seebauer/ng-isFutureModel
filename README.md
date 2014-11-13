# isFuture #

## Requirements

`Angular.js` ≥ 1.3

## Why?

Bind a `ngResource` to a `ngModel`. Works with other futures, that have a `$promise` and a `$resolved` property, too.

    <textarea is-resource-future ng-model="value1" ></textarea> 

I ran into a problem with the futures returned by `ng-model`. Then I saw a [unstatisfying answer on SO][soquestion](basically “don't”), and coded a bit. This module is similar to my answer there.

## Contributing

Welcome!

## License

This project is licensed under the [MIT license].


[soquestion]: http://stackoverflow.com/questions/18775726/angularjs-with-resource-and-custom-formatter-parser-directive-not-working/26831144
[MIT license]: http://opensource.org/licenses/MIT
