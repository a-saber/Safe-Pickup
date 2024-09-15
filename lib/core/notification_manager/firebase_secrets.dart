class FirebaseSecrets
{
  static List<String> scopes =
  [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/firebase.database',
    'https://www.googleapis.com/auth/firebase.messaging',
  ];
  static final serviceAccountJson =
  {
    "type": "service_account",
    "project_id": "callson-cc7f9",
    "private_key_id": "81d1c3749a033a28e72cbd099bda6329ab155dcb",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDGtKgRlHaXSeu0\nLgi3rl1Fgys73WifROVMZpmtR2WctzY2VTvzHTuN00ngtvmOD0IVrsrJ1b5vwf7y\ntvc2tO3pTDTWMmQW+ex+OhRkmqOk2XlgTNpmRJHDPzLgxuw7yCovDLrGvQwBAmbX\n6cwTcUTcTMykGD8XrfR8L9FQ7T+cGPZCjv02E9cTm+jA8EdHOXWIaZKLbmZ9d/c/\nZ75X4dbAXZL/XLJha1CftMoYcis+QJxEMjhN3zjXqWwFw7uHQenew5fx8DjU7UBK\nBEmbOUgtY2sCiBNZl16Km+q73ORdCZACLjBBpMBK7Sz0ny9jj/aXoBV1/deJzYPb\nkKY7G55FAgMBAAECggEAINA7gu+v58rivBXwBZkrOOvwy0mEWezQKt40mYtVSdxt\nfOp1ZG/a4lBWfl/o9R8q7Ba50TvVX3I7TkyNpYCaWzDk9sxKgArUlYG01Wo+BN6O\n7yqx1DqVkZcRqVHgN/0VjkB9ZY1Zep8xaY1n0HwfgXvDPYPtg1UMLyfcWo9bNkUU\nI2g8PYX5NL7Z+dKqHCf0bKPjC6wkXSCX+5rkn/aXCKPo5BbLcy0iMBOrKMoWtVtt\nqgjJn9qpnLuGc4HSAJxD53N3ebvS+rgpN0J+NoxxN7TjhulP9cxjuv5cCQhyJG3y\nxkGsBcviqM9l9NXYufxba1LOUz7L+ggXgVP12uOo3wKBgQD5aef26BhmS80PPOtR\njBihZaBV+HaPaJwO1yBDZs9dVIkkGIbof7F1GC5YqBH8BZfW3KQsVcMYJ4DNuGoZ\nmyhiXRu+nKLPJ1aN9k5DIBIUamA5gESyHwS4OubwZDBZf4OJJ/jWmI6vNJIyS1tD\nWTv1yvcYevDLKnvZJwfi5195dwKBgQDL8/Pf1h7DVEpPBtlCiodYU43cEAlU7bA0\nJOQFEDJBDBoJHeLqd2W72eStQAs6yiR+vOCk7Vomf21jpnY08q5f20YEGH3aHkx1\nbjkDKBlJfyU6AWjW8UJv037VDccsVVfHDTJgACkJ5EoYbL0B770UDMUlMSVQASAf\nK28a/nLVIwKBgDDuBvTYWZkP+92mbN/lpRtcrZTQFqpRsnPy3kB61emQYQs0yJqq\nGm1HXihEaKrRihU72fVcqdZ+QXWaXS5C0yxg6cV+Qy5yoDdff8EJdKKOr+v37wIm\nta1S2OWGMjoMmwh4UAgBi9RxctDtGa1fvzScKdeinsSsw/k5AAIStBdHAoGAGXc5\ncS50IuGIcbuiLwvLAH1WTi72a1NOWARvMC6oh7SyH4dKyQnlewIm6nb/r/SDgAun\nZRB53Cq3BuVHBy9yFGf1oxdHx49W7qa3maxNE/87L7XzWDtBl2LqCEIzJ1b0odcE\n/jWm6iRGGCyjoPVFP5akmxM63HV3hEzRD6bLwc8CgYEAhjw9XQCYxn/jXgv/7A2H\nhpWF3GxlAQCMtBBBo72Z8ACKSZmV4hy6qNj1l91PKEi8o3xXj/8DWUVajAF4HlCB\nqUZVZhJiz2hVf5+5jQCPw+tH7vP5JMllWpLlqjyFwrz4/dc1U685YP5COH97Q5dG\nWrRQAK5+R1dhbge7X4NTfIc=\n-----END PRIVATE KEY-----\n",
    "client_email": "call-son-safe-pickup@callson-cc7f9.iam.gserviceaccount.com",
    "client_id": "101077716339486453991",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/call-son-safe-pickup%40callson-cc7f9.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };
  static String endpointFirebaseCloudMessaging = "https://fcm.googleapis.com/v1/projects/callson-cc7f9/messages:send";
}