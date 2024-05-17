import 'package:shared_preferences/shared_preferences.dart';
import 'package:ximu3_app/core/shared_preferences/shared_preferences_abstract.dart';

/// Concrete implementation of SharedPreferencesAbstract
class SharedPreferencesImpl extends SharedPreferencesAbstract {
  /// External library member
  final SharedPreferences sharedPreferences;

  /// Constructor with external library dependency
  SharedPreferencesImpl({required this.sharedPreferences});

  @override
  Set<String> getKeys() {
    return sharedPreferences.getKeys();
  }

  @override
  Object? get(String key) {
    return sharedPreferences.get(key);
  }

  @override
  bool? getBool(String key) {
    return sharedPreferences.getBool(key);
  }

  @override
  int? getInt(String key) {
    return sharedPreferences.getInt(key);
  }

  @override
  double? getDouble(String key) {
    return sharedPreferences.getDouble(key);
  }

  @override
  String? getString(String key) {
    return sharedPreferences.getString(key);
  }

  @override
  bool containsKey(String key) {
    return sharedPreferences.containsKey(key);
  }

  @override
  List<String>? getStringList(String key) {
    return sharedPreferences.getStringList(key);
  }

  @override
  Future<bool> setBool(String key, bool value) {
    return sharedPreferences.setBool(key, value);
  }

  @override
  Future<bool> setInt(String key, int value) {
    return sharedPreferences.setInt(key, value);
  }

  @override
  Future<bool> setDouble(String key, double value) {
    return sharedPreferences.setDouble(key, value);
  }

  @override
  Future<bool> setString(String key, String value) {
    return sharedPreferences.setString(key, value);
  }

  @override
  Future<bool> setStringList(String key, List<String> value) {
    return sharedPreferences.setStringList(key, value);
  }

  @override
  Future<bool> removeAllExcept(List<String> keys) async {
    final allKeys = sharedPreferences.getKeys();
    final keysToKeep = <String>{}..addAll(keys);
    final difference = allKeys.difference(keysToKeep);

    final actions = difference.map((key) => sharedPreferences.remove(key));
    final res = await Future.wait<bool>(actions, eagerError: true);
    return res.every((e) => e);
  }

  @override
  Future<bool> remove(String key) {
    return sharedPreferences.remove(key);
  }

  @override
  Future<bool> clear() {
    return sharedPreferences.clear();
  }

  @override
  Future<void> reload() async {
    return sharedPreferences.reload();
  }
}
