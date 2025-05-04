from rest_framework import serializers
from .models import Usuario, Evento, EventoCultural, EventoGastronomico, EventoAcademico, EventoDeportivo, Cronograma

class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = '__all__'  # Incluir todos los campos del modelo

class CronogramaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cronograma
        fields = ['fecha', 'hora_inicio', 'hora_fin']

class EventoSerializer(serializers.ModelSerializer):
    tipo = serializers.SerializerMethodField()
    detalles_tipo = serializers.SerializerMethodField()
    cronogramas = CronogramaSerializer(many=True, read_only=True, source='cronograma_set')

    class Meta:
        model = Evento
        fields = ['id', 'nombre', 'descripcion', 'fecha', 'ubicacion', 'estado', 'tipo', 'detalles_tipo', 'cronogramas']

    def get_tipo(self, obj):
        if hasattr(obj, 'eventocultural'):
            return 'Cultural'
        elif hasattr(obj, 'eventogastronomico'):
            return 'Gastronómico'
        elif hasattr(obj, 'eventoacademico'):
            return 'Académico'
        elif hasattr(obj, 'eventodeportivo'):
            return 'Deportivo'
        return 'General'

    def get_detalles_tipo(self, obj):
        if hasattr(obj, 'eventocultural'):
            return {'tipo_representacion': obj.eventocultural.representacion_tipo}
        elif hasattr(obj, 'eventogastronomico'):
            return {'tipo_comida': obj.eventogastronomico.tipo_comida}
        elif hasattr(obj, 'eventoacademico'):
            return {'tema': obj.eventoacademico.tema}
        elif hasattr(obj, 'eventodeportivo'):
            return {'tipo_deporte': obj.eventodeportivo.tipo_deporte}
        return {}
