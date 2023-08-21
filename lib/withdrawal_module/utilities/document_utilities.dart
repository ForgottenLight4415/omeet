import 'dart:io';

import 'package:flutter/material.dart';

import '../data/models/document.dart';
import '../data/providers/app_server_provider.dart';
import '../utilities/api_urls.dart';
import '../widgets/upload_document_dialog.dart';

class DocumentUtilities {
  static final List<String> allowedAudioExtensions = ["wav", "mp3", "ogg", "m4a", "aac"];
  static final List<String> allowedVideoExtensions = ["mp4", "mov", "wmv", "flv", "avi"];

  static final List<String> allowedImageExtensions = ["jpg", "jpeg", "png", "tiff"];
  static final List<String> allowedDocumentExtensions = ["pdf", "doc", "docx"];
  static final List<String> allowedFileExtensions = allowedDocumentExtensions + allowedImageExtensions;

  static DocumentType getDocumentType(String filePath) {
    final String currentFileExtension = filePath.split(".").last;
    if (allowedImageExtensions.contains(currentFileExtension)) {
      return DocumentType.image;
    } else if (allowedDocumentExtensions.contains(currentFileExtension)) {
      return DocumentType.file;
    } else if (allowedVideoExtensions.contains(currentFileExtension)) {
      return DocumentType.video;
    } else if (allowedAudioExtensions.contains(currentFileExtension)) {
      return DocumentType.audio;
    }
    throw const AppException(code: 5000, cause: "Unsupported file");
  }

  static String getUploadUrl(DocumentType type) {
    switch (type) {
      case DocumentType.file:
      case DocumentType.image:
        return ApiUrl.uploadDocUrl;
      case DocumentType.audio:
      case DocumentType.video:
        return ApiUrl.uploadVideoUrl;
    }
  }

  static Future<bool> documentUploadDialog(BuildContext context, String caseId, DocumentType type,
      {File? file, bool noFileReporting = false}) async {
    bool? result = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      builder: (context) => UploadDocumentsDialog(
        caseId: caseId,
        type: type,
        recFile: file,
        noFileReporting: noFileReporting,
      ),
    );
    if (result != null && result) {
      return true;
    } else {
      return false;
    }
  }
}