String cleanOrConvert(Object? object) {
  if (object != null) {
    String string = object.toString();
    return _cleanStrings(string);
  }
  return "Unavailable";
}

String _cleanStrings(String? string) {
  if (string == null || string.isEmpty) {
    return "Unavailable";
  }
  return string;
}
