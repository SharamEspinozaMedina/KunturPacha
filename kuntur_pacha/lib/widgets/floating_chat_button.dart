import 'package:flutter/material.dart';
import 'package:kuntur_pacha/widgets/n8n_chat_widget.dart';

class FloatingChatButton extends StatefulWidget {
  const FloatingChatButton({Key? key}) : super(key: key);

  @override
  _FloatingChatButtonState createState() => _FloatingChatButtonState();
}

class _FloatingChatButtonState extends State<FloatingChatButton> {
  bool _isChatOpen = false;

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isChatOpen)
          Positioned(
            right: 20,
            bottom: 100,
            child: Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Encabezado del chat
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.chat, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Asistente Inteligente',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: _toggleChat,
                        ),
                      ],
                    ),
                  ),

                  // Área de mensajes (usando Expanded correctamente)
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(12),
                      children: [
                        _buildMessage(
                          'Hola, ¿en qué puedo ayudarte hoy?',
                          false,
                        ),
                      ],
                    ),
                  ),

                  // Área de entrada de texto
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Escribe tu mensaje...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.blue),
                          onPressed: () {
                            // Lógica para enviar mensaje
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => N8nChatWebView(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          right: 20,
          bottom: 20,
          child: FloatingActionButton(
            onPressed: _toggleChat,
            child: Icon(_isChatOpen ? Icons.close : Icons.chat),
            backgroundColor: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildMessage(String text, bool isUser) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isUser ? Colors.blue.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text),
    );
  }
}
