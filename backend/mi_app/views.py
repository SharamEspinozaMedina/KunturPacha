from django.shortcuts import render
from rest_framework import viewsets
from .models import Usuario
from .serializers import UsuarioSerializer
from django.contrib.auth import authenticate
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status

class UsuarioViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all()  # Obtiene todos los usuarios
    serializer_class = UsuarioSerializer  # Usa el serializador

@api_view(['POST'])
def login(request):
    correo = request.data.get('correo')
    contrasenia = request.data.get('contrasenia')

    if not correo or not contrasenia:
        return Response(
            {'error': 'Correo y contraseña son requeridos'},
            status=status.HTTP_400_BAD_REQUEST,
        )

    # Buscar el usuario por correo
    try:
        usuario = Usuario.objects.get(correo=correo)
    except Usuario.DoesNotExist:
        return Response(
            {'error': 'Usuario no encontrado'},
            status=status.HTTP_404_NOT_FOUND,
        )

    # Verificar la contraseña (aquí deberías usar un sistema de autenticación seguro)
    if usuario.contrasenia == contrasenia:
        return Response(
            {'message': 'Inicio de sesión exitoso', 'usuario': usuario.nombre},
            status=status.HTTP_200_OK,
        )
    else:
        return Response(
            {'error': 'Contraseña incorrecta'},
            status=status.HTTP_401_UNAUTHORIZED,
        )
