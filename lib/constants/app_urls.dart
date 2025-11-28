const String baseUrl = 'https://portal.journalist-alert.com/api';
// const String baseUrl = 'http://192.168.100.17:8000/api';

String url(String endpoint) {
  return baseUrl + endpoint;
}

String nonApiUrl(String endpoint) {
  return baseUrl.substring(0, baseUrl.length - 4) + endpoint;
}

// AUTH
String signupApiUrl = url("/register");
String loginApiUrl = url("/login");
String registerStepTwoApiUrl = url("/register-step-2");
String forgotPasswordApiUrl = url("/forgot-password");
String resetPasswordApiUrl = url("/reset-password");

// VERIFICATION
String resendOtpApiUrl = url("/resend-otp");
String verificationStatusApiUrl = url("/check-approval");
String otpVerificationApiUrl = url("/verify-otp");
String idVerificationApiUrl = url("/verify/id");

// ADDRESS
String getProvincesApiUrl = url("/get-provinces");
String getDistrictsApiUrl(String provinceId) =>
    url("/get-districts/$provinceId");
String getCitiesApiUrl(String districtId) => url("/get-cities/$districtId");

// COMPLAINTS
String panicAlertApiUrl = url("/panic-alerts");
String registerComplaintApiUrl = url("/complaints/add");
String getComplaintsApiUrl = url("/complaints");

// SUPPORT
String onlineSupportApiUrl = url("/support");

// FAQS
String getFaqsApiUrl = url("/faqs");

// EMERGENCY NUMBERS & UNITS
String getEmergencyNumbersApiUrl = url("/emergency-numbers");
String getEmergencyUnitsApiUrl = url("/emergency-units");

// POPULAR LANDMARKS
String getPopularLandmarksNumbersApiUrl = url("/popular-landmarks");

// STATS
String getRegionWiseStatsApiUrl(String? provinceId) => provinceId != null
    ? url("/stats/province/$provinceId")
    : url("/stats/province");
String getTimeWiseStatsApiUrl(String? year) =>
    year != null ? url("/stats/year/$year") : url("/stats/year");
