part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [num] properties to add a less than validation.
///
/// This extension adds a `lessThan` method that can be used to ensure that a number
/// is less than a specified value.
extension LessThanValidation on SimpleValidationBuilder<num> {
  /// Adds a validation rule that checks if the [num] is less than [maxValue].
  ///
  /// [maxValue] is the value that the number must be less than.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be less than $maxValue".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.discount, key: 'discount')
  ///   .lessThan(100);
  /// ```
  SimpleValidationBuilder<num> lessThan(num maxValue, {String message = r'Must be less than $maxValue', String code = 'less_than'}) {
    return must(
      (value) => value < maxValue,
      message.replaceAll('$maxValue', maxValue.toString()),
      code,
    );
  }
}
