/// Abstract contract exposing the functionality of the SharedPreferences library
abstract class SharedPreferencesAbstract {
  /// Returns all keys in the persistent storage
  Set<String> getKeys();

  /// Reads a value of any type from persistent storage by given key
  Object? get(String key);

  /// Reads a bool value from persistent storage by given key
  bool? getBool(String key);

  /// Reads an int value from persistent storage by given key
  int? getInt(String key);

  /// Reads a double value from persistent storage by given key
  double? getDouble(String key);

  /// Reads a String value from persistent storage by given key
  String? getString(String key);

  /// Returns true if persistent storage the contains the given [key]
  bool containsKey(String key);

  /// Reads a set of string values from persistent storage by given key
  List<String>? getStringList(String key);

  /// Saves a boolean [value] to persistent storage in the background
  Future<bool> setBool(String key, bool value);

  /// Saves an int [value] to persistent storage in the background
  Future<bool> setInt(String key, int value);

  /// Saves a double [value] to persistent storage in the background
  Future<bool> setDouble(String key, double value);

  /// Saves a String [value] to persistent storage in the background
  Future<bool> setString(String key, String value);

  /// Saves a list of strings [value] to persistent storage in the background
  Future<bool> setStringList(String key, List<String> value);

  /// Removes all entries from persistent storage except the one listed inside keys array
  Future<bool> removeAllExcept(List<String> keys);

  /// Removes an entry from persistent storage by given key
  Future<bool> remove(String key);

  /// Returns true once the app's user preferences have been cleared
  Future<bool> clear();

  // Fetches the latest values from the host platform
  /// Use this method to observe modifications that were made in native code
  /// (without using the plugin) while the app is running.
  Future<void> reload();
}
