class ApiUrl {
  static const String baseUrl = 'https://omeet.in/api/health_audit/';

  static const String loginUrl = "loginm.php";
  static const String verifyOtp = "verify_otp.php";

  // CLAIMS
  static const String getClaimsUrl = "allclaims.php";
  static const String getHospitalClaimsUrl = "allclaims_hospital_claims.php";

  // DATA UPLOAD
  static const String uploadVideoUrl = "https://omeet.in/BAGIC_Health_Claim_Investigation/admin/meet/video_meet/s3upload/upload.php";
  static const String uploadDocUrl = "https://omeet.in/BAGIC_Health_Claim_Investigation/documents/s3jaya/mobupload.php";

  // MEET DOCUMENTS SECTION
  static const String actualDocBaseUrl = "$baseUrl/documents/s3jaya/displaydocs.php?vurl=";
  static const String actualVideoBaseUrl = "$baseUrl/admin/meet/video_meet/s3upload/displayvideo.php?vurl=";
  static const String getDocumentsUrl = "documents.php";
  static const String getVideosUrl = "videos.php";
  static const String getAudioUrl = "audiolist.php";
  static const String claimConclusion = "conclusion.php";

  // MEET QUESTIONS SECTION
  static const String getQuestionsUrl = "allquestions.php";
  static const String submitAnswersUrl = "allquestionanswers.php";
}