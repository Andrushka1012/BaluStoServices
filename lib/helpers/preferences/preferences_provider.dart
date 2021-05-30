import 'package:balu_sto/helpers/preferences/base_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider {
  // KEYS
  static const _IS_APP_WAS_LAUNCHED_BEFORE_KEY = 'isAppWasLaunchedBefore';

  // FIRST VERSION PROPERTIES KEYS
  static const _TOKEN_KEY = 'token';
  static const _LAST_EMAIL_KEY = 'LAST_EMAIL';

  // API CONFIG PROPERTIES KEYS
  static const _LAST_SUPPORTED_VERSION = 'LAST_SUPPORTED_VERSION';
  static const _CURRENT_VERSION = 'CURRENT_VERSION';
  static const _FEEDBACK_URL = 'FEEDBACK_URL';
  static const _WHAT_IS_UMMADUM_URL = 'WHAT_IS_UMMADUM_URL';
  static const _UMMADUM_FAQ_URL = 'UMMADUM_FAQ_URL';
  static const _USER_INVITATION_URL = 'USER_INVITATION_URL';
  static const _TERMS_OF_SERVICE_URL = 'TERMS_OF_SERVICE_URL';
  static const _POLICY_PRIVACY_URL = 'POLICY_PRIVACY_URL';
  static const _EXCHANGE_RATE_POINTS_TO_CURRENCY = 'EXCHANGE_RATE_POINTS_TO_CURRENCY';
  static const _CURRENCY = 'CURRENCY';

  // API SYNC E-TAGS
  static const _USER_COMMUNITIES_E_TAG = 'USER_COMMUNITIES_E_TAG';
  static const _USER_CONTACTS_E_TAG = '_USER_CONTACTS_E_TAG';

  late final isAppWasLaunchedBefore = boolPref(_IS_APP_WAS_LAUNCHED_BEFORE_KEY, false, _providePreferences);
  late final prefillEmail = stringPref(_LAST_EMAIL_KEY, '', _providePreferences);
  late final token = stringPref(_TOKEN_KEY, '', _providePreferences);

  late final lastSupportedVersion = stringPref(_LAST_SUPPORTED_VERSION, '', _providePreferences);
  late final currentSupportedVersion = stringPref(_CURRENT_VERSION, '', _providePreferences);
  late final feedbackUrl = stringPref(_FEEDBACK_URL, '', _providePreferences);
  late final whatIsUmmadumUrl = stringPref(_WHAT_IS_UMMADUM_URL, '', _providePreferences);
  late final ummadumFaqUrl = stringPref(_UMMADUM_FAQ_URL, '', _providePreferences);
  late final userInvitationUrl = stringPref(_USER_INVITATION_URL, '', _providePreferences);
  late final termOfServiceUrl = stringPref(_TERMS_OF_SERVICE_URL, '', _providePreferences);
  late final privacyPolicyUrl = stringPref(_POLICY_PRIVACY_URL, '', _providePreferences);
  late final exchangeRatePointsToCurrency = doublePref(_EXCHANGE_RATE_POINTS_TO_CURRENCY, 0.0, _providePreferences);
  late final currency = stringPref(_CURRENCY, '', _providePreferences);

  late final userCommunitiesETag = intPref(_USER_COMMUNITIES_E_TAG, -1, _providePreferences);
  late final userContactsETag = intPref(_USER_CONTACTS_E_TAG, -1, _providePreferences);

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
