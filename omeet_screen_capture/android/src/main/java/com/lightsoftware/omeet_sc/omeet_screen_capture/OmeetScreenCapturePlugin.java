package com.lightsoftware.omeet_sc.omeet_screen_capture;

import android.content.Context;
import android.content.Intent;
import android.os.Build;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** OmeetScreenCapturePlugin */
public class OmeetScreenCapturePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "omeet_screen_capture");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + Build.VERSION.RELEASE);
        break;
      case "startScreenshotService": {
        if (!ScreenCaptureService.IS_SERVICE_RUNNING) {
          final String claimNumber = call.argument("claimNumber");
          Intent intent = new Intent(context, ScreenCaptureService.class);
          intent.putExtra("claimNumber", claimNumber);
          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(intent);
          } else {
            context.startService(intent);
          }
          result.success(true);
        } else {
          result.success(false);
        }
      }
      break;
      case "stopScreenshotService": {
        Intent stopIntent = new Intent(context, ScreenCaptureService.class);
        context.stopService(stopIntent);
        result.success(true);
      }
      break;
      case "isServiceRunning": {
        result.success(ScreenCaptureService.IS_SERVICE_RUNNING);
      }
      break;
      case "claimNumber": {
        result.success(ScreenCaptureService.claimNumber);
      }
      break;
      default:
        result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}
