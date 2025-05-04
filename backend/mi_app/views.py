from django.shortcuts import render
from rest_framework import viewsets, filters
from django_filters.rest_framework import DjangoFilterBackend
from .models import Usuario, Evento
from .serializers import EventoDetalleSerializer, UsuarioSerializer, EventoSerializer
from django.contrib.auth import authenticate
from rest_framework.decorators import api_view, action
from rest_framework.response import Response
from rest_framework import status
from django.core.mail import send_mail
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import random
import json

class UsuarioViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all()  # Obtiene todos los usuarios
    serializer_class = UsuarioSerializer  # Usa el serializador

@api_view(['POST'])
def login(request):
    correo = request.data.get('correo')
    contrasena = request.data.get('contrasena')

    if not correo or not contrasena:
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
    if usuario.contrasena == contrasena:
        return Response(
            {'message': 'Inicio de sesión exitoso', 'usuario': usuario.nombre},
            status=status.HTTP_200_OK,
        )
    else:
        return Response(
            {'error': 'Contraseña incorrecta'},
            status=status.HTTP_401_UNAUTHORIZED,
        )

@csrf_exempt
def recuperar_contrasenia(request):
    if request.method == 'POST':
        try:
            # Leer el cuerpo de la solicitud como JSON
            data = json.loads(request.body)
            correo = data.get('correo')  # Asegúrate de que el campo sea 'correo'
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Datos inválidos'}, status=400)

        if not correo:
            return JsonResponse({'error': 'Correo es requerido'}, status=400)

        try:
            usuario = Usuario.objects.get(correo=correo)
        except Usuario.DoesNotExist:
            print(f"Correo recibido: {correo}")  # Verifica el correo recibido
            return JsonResponse({'error': 'Correo no encontrado'}, status=404)

        # Generar un código de recuperación
        codigo = str(random.randint(100000, 999999))

        # Guardar el código en el usuario (puedes usar un campo temporal en el modelo)
        usuario.codigo_recuperacion = codigo
        usuario.save()

        # Enviar el correo
        send_mail(
            'Código de Recuperación de Contraseña',
            f'Tu código de recuperación es: {codigo}',
            'sespinozam@fcpn.edu.bo',  # Cambia esto por tu correo
            [correo],
            fail_silently=False,
        )

        return JsonResponse({'message': 'Correo enviado con éxito'}, status=200)
    else:
        return JsonResponse({'error': 'Método no permitido'}, status=405)

# views.py

@csrf_exempt
def restablecer_contrasenia(request):
    
    if request.method == 'POST':
        try:
            # Leer el cuerpo de la solicitud como JSON
            data = json.loads(request.body)
            codigo = data.get('codigo')
            nueva_contrasena = data.get('nueva_contrasena')
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Datos inválidos'}, status=400)

        if not codigo or not nueva_contrasena:
            return JsonResponse({'error': 'Código y nueva contraseña son requeridos'}, status=400)

        try:
            # Buscar el usuario por el código de recuperación
            usuario = Usuario.objects.get(codigo_recuperacion=codigo)
        except Usuario.DoesNotExist:
            print('aca'+codigo)
            return JsonResponse({'error': 'Codigo invalido'}, status=404)
        except Usuario.MultipleObjectsReturned:
            return JsonResponse({'error': 'Código duplicado en la base de datos'}, status=400)

        # Actualizar la contraseña
        usuario.contrasena = nueva_contrasena
        usuario.codigo_recuperacion = None  # Limpiar el código de recuperación
        usuario.save()

        return JsonResponse({'message': 'Contraseña restablecida con éxito'}, status=200)
    else:
        return JsonResponse({'error': 'Método no permitido'}, status=405)

class EventoViewSet(viewsets.ModelViewSet):
    queryset = Evento.objects.all().prefetch_related(
        'eventocultural',
        'eventogastronomico',
        'eventoacademico',
        'eventodeportivo',
        'cronograma_set'
    )
    serializer_class = EventoSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = {
        'estado': ['exact'],
        'fecha': ['gte', 'lte', 'exact'],
        'ubicacion': ['exact', 'icontains'],
    }
    search_fields = ['nombre', 'descripcion']
    ordering_fields = ['fecha', 'nombre']

    @action(detail=False, methods=['get'])
    def filtrar(self, request):
        queryset = self.get_queryset()
        
        # Filtro por tipo
        tipo = request.query_params.get('tipo', None)
        if tipo:
            if tipo == 'Cultural':
                queryset = queryset.filter(eventocultural__isnull=False)
            elif tipo == 'Gastronómico':
                queryset = queryset.filter(eventogastronomico__isnull=False)
            elif tipo == 'Académico':
                queryset = queryset.filter(eventoacademico__isnull=False)
            elif tipo == 'Deportivo':
                queryset = queryset.filter(eventodeportivo__isnull=False)

        # Filtro por año
        año = request.query_params.get('año', None)
        if año and año.isdigit():
            queryset = queryset.filter(fecha__year=año)

        # Ordenamiento
        orden = request.query_params.get('orden', None)
        if orden == 'recientes':
            queryset = queryset.order_by('-fecha')
        elif orden == 'nombre':
            queryset = queryset.order_by('nombre')

        page = self.paginate_queryset(queryset)
        if page is not None:
            serializer = self.get_serializer(page, many=True)
            return self.get_paginated_response(serializer.data)

        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

    # En EventoViewSet, agrega este método
    @action(detail=True, methods=['get'])
    def detalles(self, request, pk=None):
        evento = self.get_object()
        
        # Obtener todos los datos relacionados
        evento.participantes = evento.eventoparticipante_set.all().select_related('id_participante')
        evento.patrocinadores = evento.eventopatrocinador_set.all().select_related('id_patrocinador')
        evento.recursos = evento.eventorecurso_set.all().select_related('id_recurso')
        evento.cronogramas = evento.cronograma_set.all().prefetch_related('actividadcronograma_set')
        evento.multimedia = evento.multimediae_set.all().select_related('id')
        
        serializer = EventoDetalleSerializer(evento)
        return Response(serializer.data)
