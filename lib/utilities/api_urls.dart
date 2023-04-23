class ApiUrl {
  static const String baseUrl = 'https://omeet.in/api/health_audit/';

  static const String loginUrl = "loginm.php";
  static const String verifyOtp = "verify_otp.php";

  // CLAIMS
  static const String getClaimsUrl = "allclaims.php";
  static const String getHospitalClaimsUrl = "allclaims_hospital_claims.php";
  static const String claimConclusion = "conclusion.php";

  // DATA UPLOAD
  static const String uploadVideoUrl = "https://omeet.in/BAGIC_Health_Claim_Investigation/admin/meet/video_meet/s3upload/upload.php";
  static const String uploadDocUrl = "https://omeet.in/BAGIC_Health_Claim_Investigation/documents/s3jaya/mobupload.php";

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
  static const String actualDocBaseUrl = "$baseUrl/documents/s3jaya/displaydocs.php?vurl=";
  static const String actualVideoBaseUrl = "$baseUrl/admin/meet/video_meet/s3upload/displayvideo.php?vurl=";
  static const String getDocumentsUrl = "documents.php";
  static const String getVideosUrl = "videos.php";
  static const String getAudioUrl = "audiolist.php";

  // MEET QUESTIONS SECTION
  static const String getQuestionsUrl = "allquestions.php";
  static const String submitAnswersUrl = "allquestionanswers.php";
}