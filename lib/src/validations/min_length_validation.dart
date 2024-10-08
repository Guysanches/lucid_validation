part of 'validations.dart';

/// Extension on [LucidValidationBuilder] for [String] properties to add a minimum length validation.
///
/// This extension adds a `minLength` method that can be used to ensure that the length of a string
/// meets a specified minimum number of characters.
extension MinLengthValidation on SimpleValidationBuilder<String> {
  /// Adds a validation rule that checks if the length of a [String] is greater than or equal to [num].
  ///
  /// [num] is the minimum required length for the string.
  /// [message] is the error message returned if the validation fails. Defaults to "Must be at least $num characters long".
  /// [code] is an optional error code for translation purposes.
  ///
  /// Returns the [LucidValidationBuilder] to allow for method chaining.
  ///
  /// Example:
  /// ```dart
  /// ...
  /// ruleFor((user) => user.password, key: 'password')
  ///   .maxLength(8);
  /// ```
  SimpleValidationBuilder<String> minLength(int num, {String message = r'Must be at least $num characters long', String code = 'min_length'}) {
    return must(
      (value) => value.length >= num,
      message.replaceAll(r'$num', num.toString()),
      code,
    );
  }
}
