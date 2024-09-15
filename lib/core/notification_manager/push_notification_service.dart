import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'firebase_secrets.dart';

class PushNotificationService
{
  static Future<String> getAccessToken() async
  {

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(FirebaseSecrets.serviceAccountJson),
        FirebaseSecrets.scopes
    );
    auth.AccessCredentials credentials = await auth.
    obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(FirebaseSecrets.serviceAccountJson),
        FirebaseSecrets.scopes,
      client
    );
    client.close();
    return credentials.accessToken.data;
  }

  static sendNotificationToSelectedDriver({
    required String deviceToken,
  }) async
  {
    try
    {
      final String serverAccessTokenKey = await getAccessToken();

      final Map<String, dynamic> message =
      {
        'message':
        {
          'token': deviceToken,
          'notification':
          {
            'title': 'test 01',
            'body': 'test body 01'
          },
          'data':
          {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          }
        }
      };
      final http.Response response = await http.post(
          Uri.parse(FirebaseSecrets.endpointFirebaseCloudMessaging),
          headers:
          {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $serverAccessTokenKey'
          },
          body: jsonEncode(message)
      );
      if(response.statusCode == 200)
      {
        print('notification sent successfully');
      }
      else
      {
        print('failed to send notification');
      }
    }
    catch(e)
    {
      print('error in sendNotificationToSelectedDriver ${e.toString()} *********');
    }
  }
}