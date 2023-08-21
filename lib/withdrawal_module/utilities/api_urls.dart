class ApiUrl {
  static const String baseUrl = 'https://omeet.in/MOTOR/ICICI/withdrawal/';
  static const String secondaryBaseUrl = "https://omeet.in/MOTOR/";

  // CLAIMS
  static const String getClaimsUrl = "allocatedclaims.php";
  static const String getOverallClaimsUrl = "overallcases.php";
  static const String getConcludedClaimsUrl = "concludedcases.php";
  static const String acceptedClaimsUrl = "acceptedcases.php";
  static const String rejectedClaimsUrl = "rejectedcases.php";
  static const String assignToSelfUrl = "reviewandaccept.php";
  static const String newClaim = "addnewcase.php";
  static const String claimConclusion = "conclusion.php";
  static const String callConclusion = "call_conclusion.php";
  static const String reporting = "reporting.php";

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
  static const String getDocumentsUrl = "documents.php";
  static const String getVideosUrl = "videos.php";
  static const String getAudioUrl = "audiolist.php";

  // DATA UPLOAD
  static const String uploadVideoUrl = "ICICI_Motor/meet/video_meet/s3upload/upload.php";
  static const String uploadDocUrl = "documents/s3jaya/mobupload.php";

  // MEET QUESTIONS SECTION
  static const String getQuestionsUrl = "allquestions.php";
  static const String submitAnswersUrl = "allquestionanswers.php";
}