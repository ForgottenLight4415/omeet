class ApiUrl {
  static const String baseUrl = 'https://omeet.in/MOTOR/ICICI/';
  static const String secondaryBaseUrl = "https://omeet.in/MOTOR/";

  static const String loginUrl = "api/loginm.php";
  static const String verifyOtp = "api/verify_otp.php";

  // CLAIMS
  static const String getClaimsUrl = "api/allclaims.php";
  static const String acceptedClaimsUrl = "api/acceptedcases.php";
  static const String rejectedClaimsUrl = "api/rejectedcases.php";
  static const String assignToSelfUrl = "api/reviewandaccept.php";
  static const String newClaim = "api/addnewcase.php";
  static const String claimConclusion = "api/conclusion.php";
  static const String callConclusion = "api/call_conclusion.php";
  static const String reporting = "api/reporting.php";

  //  VOICE CALL AND MESSAGES
  static const String bridgeCallUrl = "https://dashboard.hellotubelight.com/tenant/v1/cpaas/calls";
  static const String bridgeCallToken = "5493e3de-3b6d-4b08-b20d-089fe49413ad";
  static const String sendMessageUrl = "http://sms.gooadvert.com/app/smsapi/index.php";
  static const String smsKey = "562A39B5CE0B91";
  static const String smsEntity = "1501693730000042530";
  static const String smsTempId = "1507165743675014713";
  static const String smsRouteId = "636";
  static const String smsType = "text";
  static const String smsSenderId = "GODJNO";

  // MEET DOCUMENTS SECTION
  static const String actualDocBaseUrl = "$secondaryBaseUrl/documents/s3jaya/displaydocs.php?vurl=";
  static const String actualVideoBaseUrl = "$secondaryBaseUrl/ICICI_Motor/meet/video_meet/s3upload/displayvideo.php?vurl=";
  static const String getDocumentsUrl = "api/documents.php";
  static const String getVideosUrl = "api/videos.php";
  static const String getAudioUrl = "api/audiolist.php";

  // DATA UPLOAD
  static const String uploadVideoUrl = "ICICI_Motor/meet/video_meet/s3upload/upload.php";
  static const String uploadDocUrl = "documents/s3jaya/mobupload.php";

  // MEET QUESTIONS SECTION
  static const String getQuestionsUrl = "api/allquestions.php";
  static const String submitAnswersUrl = "api/allquestionanswers.php";
}