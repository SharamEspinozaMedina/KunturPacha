import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class N8nChatWidget extends StatefulWidget {
  const N8nChatWidget({Key? key}) : super(key: key);

  @override
  _N8nChatWidgetState createState() => _N8nChatWidgetState();
}

class _N8nChatWidgetState extends State<N8nChatWidget> {
  // ignore: unused_field
  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat de Soporte'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: '''
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Chat</title>
            <link href="https://cdn.jsdelivr.net/npm/@n8n/chat/dist/style.css" rel="stylesheet" />
          </head>
          <body>
            <div id="n8n-chat"></div>
            <link href="https://cdn.jsdelivr.net/npm/@n8n/chat/dist/style.css" rel="stylesheet" />
            <script type="module">
              import { createChat } from 'https://cdn.jsdelivr.net/npm/@n8n/chat/dist/chat.bundle.es.js';

              createChat({
                webhookUrl: 'http://localhost:5678/webhook/0040088c-8dff-4a4c-91ac-a5265d246bf1/chat',
                webhookConfig: {
                  method: 'POST',
                  headers: {}
                },
                target: '#n8n-chat',
                mode: 'window',
                chatInputKey: 'chatInput',
                chatSessionKey: 'sessionId',
                metadata: {},
                showWelcomeScreen: false,
                defaultLanguage: 'es',
                initialMessages: [
                  'hola, que tal! 👋',
                  'My name is Nathan. How can I assist you today?'
                ],
                i18n: {
                  es: {
                    title: 'Hola! 👋',
                    subtitle: "Bicentenario de Bolivia",
                    footer: '',
                    getStarted: 'New Conversation',
                    inputPlaceholder: 'Type your question..',
                  },
                },
              });
            </script>
          </body>
          </html>
        ''',
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
            useShouldOverrideUrlLoading: true,
            mediaPlaybackRequiresUserGesture: false,
          ),
          android: AndroidInAppWebViewOptions(useHybridComposition: true),
          ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
      ),
    );
  }
}
