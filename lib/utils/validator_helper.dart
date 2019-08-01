class ValidatorHelper {
  static String newProductValidator(String value) {
    return value.isEmpty ? "Please add a name" : null;
  }

  static String editingMagnitudeValidator(String value) {
    return value.isEmpty ? "Please add a magnitude" : null;
  }
}
