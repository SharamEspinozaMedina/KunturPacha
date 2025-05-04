from rest_framework import serializers
from .models import ActividadCronograma, MultimediaE, Participantes, Patrocinadores, Recursos, Usuario, Evento, EventoCultural, EventoGastronomico, EventoAcademico, EventoDeportivo, Cronograma

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

# Agrega estos serializers al inicio del archivo
class ParticipanteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Participantes
        fields = ['id', 'nombre', 'tipo', 'descripcion']

class PatrocinadorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Patrocinadores
        fields = ['id', 'nombre', 'tipo', 'contacto', 'descripcion']

class RecursoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Recursos
        fields = ['id', 'nombre', 'tipo', 'descripcion', 'cantidad', 'disponibilidad']

class ActividadCronogramaSerializer(serializers.ModelSerializer):
    class Meta:
        model = ActividadCronograma
        fields = ['actividad', 'descripcion']

class CronogramaDetalleSerializer(serializers.ModelSerializer):
    actividades = ActividadCronogramaSerializer(many=True, source='actividadcronograma_set')
    
    class Meta:
        model = Cronograma
        fields = ['fecha', 'hora_inicio', 'hora_fin', 'actividades']

class MultimediaESerializer(serializers.ModelSerializer):
    class Meta:
        model = MultimediaE
        fields = ['url_archivo', 'descripcion']

# Actualiza el EventoSerializer o crea uno nuevo para detalles
class EventoDetalleSerializer(serializers.ModelSerializer):
    participantes = serializers.SerializerMethodField()
    patrocinadores = serializers.SerializerMethodField()
    recursos = serializers.SerializerMethodField()
    cronogramas = serializers.SerializerMethodField()
    multimedia = serializers.SerializerMethodField()
    
    class Meta:
        model = Evento
        fields = [
            'id', 'nombre', 'descripcion', 'fecha', 'ubicacion', 'estado',
            'participantes', 'patrocinadores', 'recursos', 'cronogramas', 'multimedia'
        ]
    
    def get_participantes(self, obj):
        participantes = []
        for ep in obj.eventoparticipante_set.all():
            participantes.append({
                'id': ep.id_participante.id,
                'nombre': ep.id_participante.nombre,
                'tipo': ep.id_participante.tipo,
                'descripcion': ep.id_participante.descripcion
            })
        return participantes
    
    def get_patrocinadores(self, obj):
        patrocinadores = []
        for ep in obj.eventopatrocinador_set.all():
            patrocinadores.append({
                'id': ep.id_patrocinador.id,
                'nombre': ep.id_patrocinador.nombre,
                'tipo': ep.id_patrocinador.tipo,
                'contacto': ep.id_patrocinador.contacto,
                'descripcion': ep.id_patrocinador.descripcion,
                'tipo_apoyo': ep.tipo_apoyo,
                'monto_aportado': ep.monto_aportado
            })
        return patrocinadores
    
    def get_recursos(self, obj):
        recursos = []
        for er in obj.eventorecurso_set.all():
            recursos.append({
                'id': er.id_recurso.id,
                'nombre': er.id_recurso.nombre,
                'tipo': er.id_recurso.tipo,
                'descripcion': er.id_recurso.descripcion,
                'cantidad': er.cantidad_utilizada,
                'disponibilidad': er.id_recurso.disponibilidad,
                'observaciones': er.observaciones
            })
        return recursos
    
    def get_cronogramas(self, obj):
        cronogramas = []
        for c in obj.cronograma_set.all():
            actividades = [{
                'actividad': ac.actividad,
                'descripcion': ac.descripcion
            } for ac in c.actividadcronograma_set.all()]
            
            cronogramas.append({
                'fecha': c.fecha,
                'hora_inicio': c.hora_inicio,
                'hora_fin': c.hora_fin,
                'actividades': actividades
            })
        return cronogramas
    
    def get_multimedia(self, obj):
        return [{
            'url': m.id.url_archivo,
            'descripcion': m.id.descripcion
        } for m in obj.multimediae_set.all()]
