package com.lightsoftware.omeet_sc.omeet_screen_capture;

import android.app.Activity;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.RecoverableSecurityException;
import android.app.Service;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentSender;
import android.database.ContentObserver;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.os.Looper;
import android.provider.MediaStore;
import android.util.Log;
import android.widget.Adapter;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;

import java.io.File;
import java.io.IOException;
import java.util.Collections;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class ScreenCaptureService extends Service {
    private static final String TAG = "OMeet Screenshot Service";
    public static boolean IS_SERVICE_RUNNING = false;
    public static String claimNumber = "";

    private ContentObserver contentObserver;
    private String currentUpload = "";
    private String lastUpload = "";

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Toast.makeText(this, "Starting screenshot service. Please wait", Toast.LENGTH_SHORT).show();
        claimNumber = intent.getStringExtra("claimNumber");
        /*
         * Starting Android API 26, services running in the background must call [startForeground()]
         * within 5 seconds of calling [startForegroundService()]. Failing to do so may crash the application. 
         */
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForeground(1, setForegroundServiceNotification());
        }
        contentObserver = new ContentObserver(new Handler(Looper.getMainLooper())) {
            @Override
            public void onChange(boolean selfChange, @Nullable Uri uri) {
                super.onChange(selfChange, uri);
                queryScreenshots(uri);
                uploadFiles();
            }
        };
        this.getContentResolver().registerContentObserver(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                true,
                contentObserver
        );
        IS_SERVICE_RUNNING = true;
        Toast.makeText(
            this, 
            "Screenshots are being sent to server for claim number - " + claimNumber, 
            Toast.LENGTH_SHORT).show();
        return START_STICKY;
    }

    private void queryScreenshots(Uri uri) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            queryRelativeDataColumn(uri);
        } else {
            queryDataColumn(uri);
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.Q)
    private void queryRelativeDataColumn(Uri uri) {
        String[] projection = new String[] {
                MediaStore.Images.Media.DISPLAY_NAME,
                MediaStore.Images.Media.RELATIVE_PATH,
        };
        Cursor cursor = this.getContentResolver().query(
            uri,
            projection,
            null,
            null,
            null
        );
        int relativePathColumn = cursor.getColumnIndex(MediaStore.Images.Media.RELATIVE_PATH);
        int displayNameColumn = cursor.getColumnIndex(MediaStore.Images.Media.DISPLAY_NAME);
        while (cursor.moveToNext()) {
            String relativePath = cursor.getString(relativePathColumn);
            String name = cursor.getString(displayNameColumn);
            String generalRelativePath = relativePath.toLowerCase();
            String generalName = name.toLowerCase();
            if (generalRelativePath.contains("screenshot") || generalName.contains("screenshot")) {
                String fullPath = relativePath + name;
                Log.i(
                        TAG,
                        String.format("Detected screenshot at location: %s", fullPath)
                );
                if (!currentUpload.equals(fullPath)) {
                    currentUpload = fullPath;
                }
            }
        }
        cursor.close();
    }

    private void queryDataColumn(Uri uri) {
        String[] projection = new String[]{
                MediaStore.Images.Media.DATA
        };
        Cursor cursor = this.getContentResolver().query(
                uri,
                projection,
                null,
                null,
                null
        );
        int dataColumn = cursor.getColumnIndex(MediaStore.Images.Media.DATA);
        while (cursor.moveToNext()) {
            String path = cursor.getString(dataColumn);
            String generalPath = path.toLowerCase();
            if (generalPath.contains("screenshot")) {
                Log.i(
                        TAG,
                        String.format("Detected screenshot at location: %s", path)
                );
                if (!currentUpload.equals(path)) {
                    currentUpload = path;
                }
            }
        }
        cursor.close();
    }

    private void uploadFiles() {
        File file = new File("/storage/emulated/0/" + currentUpload);
        if (!currentUpload.equals(lastUpload) && file.exists()) {
            Log.i(TAG, "Uploading for: " + claimNumber);
            lastUpload = currentUpload;
            UploadTask task = new UploadTask();
            task.execute(file.getAbsolutePath(), claimNumber);
        } else {
            Log.i(TAG, "File is duplicate or does not exist.");
        }
        Log.i(TAG, "File uploader exited successfully.");
    }

    private boolean deleteUploadedItems(Uri fileUri) throws IntentSender.SendIntentException {
        final ContentResolver contentResolver = getContentResolver();
        final Context context = getApplicationContext();
        try {
            int rows = contentResolver.delete(fileUri, null, null);
            return rows > 0;
        } catch (SecurityException e) {
            IntentSender intentSender = null;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                intentSender = MediaStore.createDeleteRequest(
                        contentResolver,
                        Collections.singletonList(fileUri)
                ).getIntentSender();
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                RecoverableSecurityException recoverableSecurityException = (RecoverableSecurityException) e;
                intentSender = recoverableSecurityException
                        .getUserAction()
                        .getActionIntent()
                        .getIntentSender();
            }
            if (intentSender != null) {
                ((Activity) context).startIntentSenderForResult(
                        intentSender,
                        13,
                        null,
                        0,
                        0,
                        0,
                        null
                );
            }
        }
        return false;
    }

    private static class UploadTask extends AsyncTask<String, String, String> {

        @Override
        protected String doInBackground(String... strings) {
            File file = new File(strings[0]);
            String claimNumber = strings[1];
            String uploadUrl = "https://omeet.in/userimages/s3upload/upload.php";
            try {
                RequestBody requestBody = new MultipartBody.Builder().setType(MultipartBody.FORM)
                        .addFormDataPart("Claim_No", claimNumber)
                        .addFormDataPart("anyfile", file.getName(), RequestBody.create(file, MediaType.parse("*/*")))
                        .build();
                Request request = new Request.Builder()
                        .url(uploadUrl)
                        .post(requestBody)
                        .build();
                OkHttpClient client = new OkHttpClient();
                client.newCall(request).enqueue(new Callback() {
                    @Override
                    public void onFailure(@NonNull Call call, @NonNull IOException e) {
                        e.printStackTrace();
                    }

                    @Override
                    public void onResponse(@NonNull Call call, @NonNull Response response) {
                        if (response.isSuccessful()) {
                            if (file.delete()) {
                                Log.i(TAG, "File deleted");
                            } else {
                                Log.i(TAG, "File not deleted");
                            }
                        }
                    }
                });
                return "";
            } catch (Exception e) {
                e.printStackTrace();
            }
            return "";
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private Notification setForegroundServiceNotification() {
        NotificationChannel notificationChannel = new NotificationChannel(
                "omeet_screenshot_service",
                "OMeet Screenshot Service",
                NotificationManager.IMPORTANCE_LOW
        );
        NotificationManager manager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        assert manager != null;
        manager.createNotificationChannel(notificationChannel);
        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(
                this,
                "omeet_screenshot_service"
        );
        return notificationBuilder.setOngoing(true)
                .setContentTitle("OMeet is monitoring screenshots")
                .setPriority(NotificationManager.IMPORTANCE_LOW)
                .setCategory(Notification.CATEGORY_SERVICE)
                .setChannelId("omeet_screenshot_service")
                .build();
    }

    @Override
    public void onDestroy() {
        this.getContentResolver().unregisterContentObserver(contentObserver);
        contentObserver = null;
        IS_SERVICE_RUNNING = false;
        claimNumber = "";
        super.onDestroy();
    }
}
