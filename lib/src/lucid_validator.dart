import '../lucid_validation.dart';

/// Abstract class for creating validation logic for a specific entity type [E].
///
/// [E] represents the type of the entity being validated.
abstract class LucidValidator<E> {
  final List<LucidValidationBuilder<dynamic, E>> _builders = [];

  /// Registers a validation rule for a specific property of the entity.
  ///
  /// [func] is a function that selects the property from the entity [E].
  /// [key] is an optional string that can be used to identify the property for validation purposes.
  ///
  /// Returns a [LucidValidationBuilder] that allows you to chain additional validation rules.
  ///
  /// Example:
  /// ```dart
  /// final validator = UserValidation();
  /// validator.ruleFor((user) => user.email).validEmail();
  /// ```
  LucidValidationBuilder<TProp, E> ruleFor<TProp>(TProp Function(E entity) selector, {String key = ''}) {
    final builder = _LucidValidationBuilder<TProp, E>(key, selector);
    _builders.add(builder);

    return builder;
  }

  /// Returns a validation function for a specific field identified by [key].
  ///
  /// The function returned can be used to validate a single field, typically in forms.
  ///
  /// Example:
  /// ```dart
  /// final validator = UserValidation();
  /// final emailValidator = validator.byField('email');
  /// String? validationResult = emailValidator('user@example.com');
  /// ```
  String? Function([String?]) byField(E entity, String key) {
    final builder = _builders
        .where(
          (builder) => builder.key == key,
        )
        .firstOrNull;

    if (builder == null) {
      return ([_]) => null;
    }

    return ([_]) {
      final errors = builder.executeRules(entity);
      if (errors.isNotEmpty) {
        return errors.first.message;
      }
      return null;
    };
  }

  /// Validates the entire entity [E] and returns a list of [ValidationError]s if any rules fail.
  ///
  /// This method iterates through all registered rules and checks if the entity meets all of them.
  ///
  /// Example:
  /// ```dart
  /// final validator = UserValidation();
  /// final errors = validator.validate(user);
  /// if (errors.isEmpty) {
  ///   print('All validations passed');
  /// } else {
  ///   print('Validation failed: ${errors.map((e) => e.message).join(', ')}');
  /// }
  /// ```
  ValidationResult validate(E entity) {
    final errors = _builders.fold(<ValidationError>[], (previousErrors, errors) {
      return previousErrors..addAll(errors.executeRules(entity));
    });

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}

class _LucidValidationBuilder<TProp, Entity> extends LucidValidationBuilder<TProp, Entity> {
  _LucidValidationBuilder(super.key, super.selector);
}
