class AppStrings {
  static const String baseUrl = 'omeet.in';
  static const String subDirectory = 'BAGIC_Motor_Claim_Investigation/';
  static const String bridgeCallBaseUrl = "godjn.slashrtc.in";
  static const String bridgeCallBaseUrlNew = "cpaas-api-167-2.slashrtc.in";

  static const String sendMessageBaseUrl = "sms.gooadvert.com";
  static const String sendMessageUrl = "app/smsapi/index.php";

  static const String loginUrl = "api/loginm.php";
  static const String verifyOtp = "api/verify_otp.php";

  // CLAIMS
  static const String getClaimsUrl = "api/allclaims.php";
  static const String newClaim = "api/addnewcase.php";
  static const String claimConclusion = "api/conclusion.php";

  // DATA UPLOAD
  static const String uploadVideoUrl = "admin/meet/video_meet/s3upload/upload.php";
  static const String uploadImageUrl = "documents/s3jaya/mobupload.php";

  // VOICE CALL
  static const String callToken = "79b12042acc016a955281aed7bfa09a5";
  static const String voiceCallUrl = "slashRtc/callingApis/clicktoDial";
  static const String voiceCallUrlNew = "api/6cf11bb0-987c-11ec-824f-5bbca732c8cd/callAndConnect";

  // MEET DOCUMENTS SECTION
  static const String getDocumentsUrl = "api/documents.php";

  // MEET QUESTIONS SECTION
  static const String getQuestionsUrl = "api/allquestions.php";
  static const String submitAnswersUrl = "api/allquestionanswers.php";

  // ERRORS AND FILLERS
  static const String blank = "";
  static const String unknown = "Unknown";
  static const String noInternet = "No internet";
  static const String unavailable = "Unavailable";
  static const String locationDisabled = "Location is disabled.";
  static const String fileUploaded = "File uploaded successfully.";
  static const String fileUploadFailed = "Failed to upload the files.";
  static const String looksLikeOffline = "Looks like you are offline!\n";
  static const String somethingWrong = "Something went wrong on our end.";
  static const String locationPermission = "Location permission required.";

  // BUTTON TEXT
  static const String ok = "OK";
  static const String deny = "DENY";
  static const String allow = "ALLOW";
  static const String retry = "RETRY";
  static const String cancel = "CANCEL";
  static const String openSettings = "OPEN SETTINGS";
  static const String grantPermission = "GRANT PERMISSION";
  static const String stopRecording = "Stop recording";
  static const String startRecording = "Start recording";
  static const String recordVideo = "Record video";
  static const String recordAudio = "Record audio";

  // LONG INFORMATION TEXT
  static const String locationExplanation = "Location access is needed to access this feature.";
  static const String locationPermExplanation = "Location permission is needed to access this feature.";
  static const String camMicStoragePerm = "Camera, microphone and storage permission is required to access this feature.";
  static const String offlineSolution = "Check if your WiFi or mobile data is turned on and if you have access to the internet.";
  static const String locationPermExplanationB = "Location permission is needed to access this feature. Grant permission in settings?";
  static const String locationError = "Location is not enabled or permission is not granted";

  // IMAGE LINKS
  static const String noDataImage = "images/no-data.svg";
  static const String errorImage = "images/error.png";

  // FONT FAMILIES
  static const String secondaryFontFam = "Nunito";

  // APP TEXT
  static const String claimsLoading = "Getting claims...";
  static const String loading = "Loading...";
  static const String connecting = "Connecting to call service...";
  static const String noClaims = "No claims";
  static const String primary = "Primary";
  static const String secondary = "Secondary";
  static const String voiceCall = "Voice call";
  static const String receiveCall = "You'll receive a call soon.";
  static const String startingUpload = "Starting upload";
  static const String signingIn = "Signing in...";

  // DETAILS
  static const String customerName = "Customer name";
  static const String customerAddress = "Customer address";
  static const String phoneNumber = "Phone number: ";
  static const String phoneNumberAlt = "Alternate phone number: ";
  static const String emailAddress = "Email address";
}
