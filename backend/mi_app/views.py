from django.shortcuts import render

from rest_framework import viewsets
from .models import Usuario
from .serializers import UsuarioSerializer

class UsuarioViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all()  # Obtiene todos los usuarios
    serializer_class = UsuarioSerializer  # Usa el serializador

