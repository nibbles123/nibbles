import 'dart:convert';

import 'package:http/http.dart' as http;

class SendEmailService {
 static Future sendOtpEmail(email, subject, message) async {
    final url = Uri.parse("https://api.sendgrid.com/v3/mail/send");
    final response = await http.post(url,
        headers: {
          'Authorization':
              'Bearer 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',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          "personalizations": [
            {
              "to": [
                {"email": email}
              ]
            }
          ],
          "from": {"email": "farhan.ehmad2001@gmail.com"},
          "subject": subject,
          "content": [
            {"type": "text/plain", "value": message}
          ]
        }));
    print(response.body);
  }
}
