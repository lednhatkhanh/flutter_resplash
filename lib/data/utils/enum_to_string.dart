String enumToString<T>(T enumInput, String Function(String) transformer) {
  if (enumInput == null) {
    return '';
  }

  final enumString = enumInput.toString().split('.').last;
  return transformer != null ? transformer(enumString) : enumString;
}
