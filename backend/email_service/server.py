from flask import Flask, request, jsonify
import smtplib
import ssl
from email.mime.text import MIMEText
from email.header import Header
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

EMAIL = "sespinozam@fcpn.edu.bo"
PASSWORD = "tgbo eetc znut qhai"

@app.route('/send_email', methods=['POST'])
def send_email():
    data = request.get_json()
    email_destino = data.get('email')
    codigo = data.get('codigo')

    if not email_destino or not codigo:
        return jsonify({'error': 'Faltan datos'}), 400

    try:
        # Crear el mensaje con codificación UTF-8
        mensaje = MIMEText(f'Tu código de verificación es: {codigo}', 'plain', 'utf-8')
        mensaje['Subject'] = Header('Código de Verificación', 'utf-8')
        mensaje['From'] = EMAIL
        mensaje['To'] = email_destino

        # Enviar el correo
        context = ssl.create_default_context()
        with smtplib.SMTP_SSL("smtp.gmail.com", 465, context=context) as server:
            server.login(EMAIL, PASSWORD)
            server.sendmail(EMAIL, email_destino, mensaje.as_string())

        return jsonify({'message': 'Correo enviado con éxito'}), 200
    except Exception as e:
        print({'error': str(e)})  # No uses jsonify aquí, solo print
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)


"""
from flask import Flask, request, jsonify
from flask_mail import Mail, Message

app = Flask(__name__)

# Configuración de Flask-Mail
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = 'sespinozam@fcpn.edu.bo'
app.config['MAIL_PASSWORD'] = 'tgbo eetc znut qhai'
app.config['MAIL_DEFAULT_SENDER'] = 'sespinozam@fcpn.edu.bo'

mail = Mail(app)

@app.route('/send_email', methods=['POST'])
def send_email():
    data = request.get_json()
    email = data.get('email')
    codigo = data.get('codigo')

    if not email or not codigo:
        return jsonify({'error': 'Faltan datos'}), 400

    try:
        msg = Message('Código de Verificación', recipients=[email])
        msg.body = f'Tu código de verificación es: {codigo}'
        mail.send(msg)
        return jsonify({'message': 'Correo enviado exitosamente'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
"""