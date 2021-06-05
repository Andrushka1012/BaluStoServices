import 'package:balu_sto/helpers/preferences/base_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider {
  static late final PreferencesProvider instance = PreferencesProvider();

  static const _LAST_EMAIL_KEY = 'LAST_EMAIL';

  late final prefillEmail = stringPref(_LAST_EMAIL_KEY, '', _providePreferences);

  bool _isInitialized = false;
  late final SharedPreferences _preferences;

  /// Initialize [PreferencesProvider] with [SharedPreferences].
  /// Attempt access to [BasePreference] before initialization finished will throw an exception.
  Future<void> initialize() async {
    if (!_isInitialized) {
      _preferences = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  SharedPreferences _providePreferences() {
    assert(_isInitialized, 'PreferencesProvider was not initialized');
    return _preferences;
  }
}
