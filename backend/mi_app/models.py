from django.db import models

class Rol(models.Model):
    nombre_rol = models.CharField(max_length=50)
    descripcion = models.CharField(max_length=255)

    def __str__(self):
        return self.nombre_rol

class Permisos(models.Model):
    nombre_permiso = models.CharField(max_length=50)
    descripcion = models.CharField(max_length=255)

    def __str__(self):
        return self.nombre_permiso

class Tiene(models.Model):
    id_permiso = models.ForeignKey(Permisos, on_delete=models.CASCADE)
    id_rol = models.ForeignKey(Rol, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('id_permiso', 'id_rol')

class Usuario(models.Model):
    nombre = models.CharField(max_length=255)
    correo = models.CharField(max_length=100, unique=True)
    contrasena = models.CharField(max_length=255,default="temporal_contrasena")
    genero = models.CharField(max_length=50, null=True, blank=True)
    ciudad = models.CharField(max_length=100, null=True, blank=True)
    pais = models.CharField(max_length=50, null=True, blank=True)
    id_rol = models.ForeignKey(Rol, on_delete=models.SET_NULL, null=True)
    codigo_recuperacion = models.CharField(
        max_length=6, 
        null=True, 
        blank=True, 
        unique=True
    )

    def __str__(self):
        return self.nombre

class Evento(models.Model):
    nombre = models.CharField(max_length=255)
    descripcion = models.TextField()
    fecha = models.DateField()
    ubicacion = models.CharField(max_length=255)
    estado = models.CharField(max_length=50)

    def __str__(self):
        return self.nombre

class Organiza(models.Model):
    id_usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    id_evento = models.ForeignKey(Evento, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('id_usuario', 'id_evento')

class Agenda(models.Model):
    descripcion = models.TextField()
    id_usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)

    def __str__(self):
        return f"Agenda de {self.id_usuario.nombre}"

class EventoCultural(models.Model):
    id = models.OneToOneField(Evento, on_delete=models.CASCADE, primary_key=True)
    representacion_tipo = models.CharField(max_length=255)

    def __str__(self):
        return f"Cultural: {self.id.nombre}"

class EventoGastronomico(models.Model):
    id = models.OneToOneField(Evento, on_delete=models.CASCADE, primary_key=True)
    tipo_comida = models.CharField(max_length=255)

    def __str__(self):
        return f"Gastronómico: {self.id.nombre}"

class EventoAcademico(models.Model):
    id = models.OneToOneField(Evento, on_delete=models.CASCADE, primary_key=True)
    tema = models.CharField(max_length=255)

    def __str__(self):
        return f"Académico: {self.id.nombre}"

class EventoDeportivo(models.Model):
    id = models.OneToOneField(Evento, on_delete=models.CASCADE, primary_key=True)
    tipo_deporte = models.CharField(max_length=100)

    def __str__(self):
        return f"Deportivo: {self.id.nombre}"

class Historia(models.Model):
    titulo = models.CharField(max_length=255)
    descripcion = models.TextField()
    fecha = models.DateField()
    fecha_declaracion = models.DateField()
    pais = models.CharField(max_length=100)

    def __str__(self):
        return self.titulo

class Comentario(models.Model):
    contenido = models.TextField()
    fecha_hora = models.DateTimeField(auto_now_add=True)
    id_usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    id_historia = models.ForeignKey(Historia, on_delete=models.CASCADE)

    def __str__(self):
        return f"Comentario de {self.id_usuario.nombre}"

class Batalla(models.Model):
    id = models.OneToOneField(Historia, on_delete=models.CASCADE, primary_key=True)
    lugar = models.CharField(max_length=255)
    resultado = models.CharField(max_length=255)

    def __str__(self):
        return f"Batalla: {self.id.titulo}"

class Personaje(models.Model):
    id = models.OneToOneField(Historia, on_delete=models.CASCADE, primary_key=True)
    nombre = models.CharField(max_length=255)
    fecha_nacimiento = models.DateField(null=True, blank=True)
    fecha_fallecimiento = models.DateField(null=True, blank=True)
    contribucion = models.TextField()

    def __str__(self):
        return self.nombre

class ParticipaB(models.Model):
    id_personaje = models.ForeignKey(Personaje, on_delete=models.CASCADE)
    id_batalla = models.ForeignKey(Batalla, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('id_personaje', 'id_batalla')

class Independencia(models.Model):
    id = models.OneToOneField(Historia, on_delete=models.CASCADE, primary_key=True)
    fecha_declaracion = models.DateField()
    pais = models.CharField(max_length=60)

    def __str__(self):
        return f"Independencia de {self.pais}"

class ParticipaI(models.Model):
    id_independencia = models.ForeignKey(Independencia, on_delete=models.CASCADE)
    id_personaje = models.ForeignKey(Personaje, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('id_independencia', 'id_personaje')

class Presidente(models.Model):
    id = models.OneToOneField(Personaje, on_delete=models.CASCADE, primary_key=True)
    periodo_gobierno = models.CharField(max_length=255)
    partido_politico = models.CharField(max_length=255)

    def __str__(self):
        return f"Presidente {self.id.nombre}"

class Cultura(models.Model):
    id = models.OneToOneField(Historia, on_delete=models.CASCADE, primary_key=True)
    nombre = models.CharField(max_length=255)
    descripcion = models.TextField()

    def __str__(self):
        return self.nombre

class Etnia(models.Model):
    nombre = models.CharField(max_length=255)
    id_cultura = models.ForeignKey(Cultura, on_delete=models.CASCADE)
    ubicacion = models.CharField(max_length=255)

    def __str__(self):
        return self.nombre

class Cronograma(models.Model):
    id_evento = models.ForeignKey(Evento, on_delete=models.CASCADE)
    fecha = models.DateField()
    hora_inicio = models.TimeField()
    hora_fin = models.TimeField()

    def __str__(self):
        return f"Cronograma para {self.id_evento.nombre}"

class Esta(models.Model):
    id_cronograma = models.ForeignKey(Cronograma, on_delete=models.CASCADE)
    id_agenda = models.ForeignKey(Agenda, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('id_cronograma', 'id_agenda')

class PreferenciasUsuario(models.Model):
    clave = models.CharField(max_length=100)
    valor = models.CharField(max_length=100)
    id_usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)

    def __str__(self):
        return f"Preferencia {self.clave} de {self.id_usuario.nombre}"

class HistorialActividades(models.Model):
    id_usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    fecha_hora = models.DateTimeField(auto_now_add=True)
    actividad = models.CharField(max_length=255)
    detalle = models.TextField()

    def __str__(self):
        return f"Actividad de {self.id_usuario.nombre}"

class AuditoriaRoles(models.Model):
    id_usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    id_rol = models.ForeignKey(Rol, on_delete=models.CASCADE)
    fecha_hora = models.DateTimeField(auto_now_add=True)
    accion = models.CharField(max_length=100)
    detalle = models.TextField()

    def __str__(self):
        return f"Auditoría de rol para {self.id_usuario.nombre}"

class Multimedia(models.Model):
    id_usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    url_archivo = models.CharField(max_length=2048)
    fecha_subida = models.DateTimeField(auto_now_add=True)
    descripcion = models.TextField()

    def __str__(self):
        return f"Multimedia subida por {self.id_usuario.nombre}"

class MultimediaH(models.Model):
    id = models.OneToOneField(Multimedia, on_delete=models.CASCADE, primary_key=True)
    id_historia = models.ForeignKey(Historia, on_delete=models.CASCADE)

    def __str__(self):
        return f"Multimedia para {self.id_historia.titulo}"

class MultimediaE(models.Model):
    id = models.OneToOneField(Multimedia, on_delete=models.CASCADE, primary_key=True)
    id_evento = models.ForeignKey(Evento, on_delete=models.CASCADE)

    def __str__(self):
        return f"Multimedia para {self.id_evento.nombre}"

class Fuente(models.Model):
    id_usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    id_historia = models.ForeignKey(Historia, on_delete=models.CASCADE)
    tipo = models.CharField(max_length=100)
    titulo = models.CharField(max_length=255)
    autor = models.CharField(max_length=255)
    anio_publicacion = models.DateField()
    enlace = models.CharField(max_length=2048)
    descripcion = models.TextField()

    def __str__(self):
        return self.titulo

class Participantes(models.Model):
    nombre = models.CharField(max_length=255)
    tipo = models.CharField(max_length=100)
    descripcion = models.TextField()

    def __str__(self):
        return self.nombre

class EventoParticipante(models.Model):
    id_evento = models.ForeignKey(Evento, on_delete=models.CASCADE)
    id_participante = models.ForeignKey(Participantes, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('id_evento', 'id_participante')

class Recursos(models.Model):
    nombre = models.CharField(max_length=255)
    tipo = models.CharField(max_length=100)
    descripcion = models.TextField()
    cantidad = models.IntegerField()
    disponibilidad = models.CharField(max_length=50)

    def __str__(self):
        return self.nombre

class EventoRecurso(models.Model):
    id_evento = models.ForeignKey(Evento, on_delete=models.CASCADE)
    id_recurso = models.ForeignKey(Recursos, on_delete=models.CASCADE)
    cantidad_utilizada = models.IntegerField()
    observaciones = models.TextField()

    class Meta:
        unique_together = ('id_evento', 'id_recurso')

class Patrocinadores(models.Model):
    nombre = models.CharField(max_length=255)
    tipo = models.CharField(max_length=100)
    contacto = models.CharField(max_length=255)
    descripcion = models.TextField()

    def __str__(self):
        return self.nombre

class EventoPatrocinador(models.Model):
    id_evento = models.ForeignKey(Evento, on_delete=models.CASCADE)
    id_patrocinador = models.ForeignKey(Patrocinadores, on_delete=models.CASCADE)
    tipo_apoyo = models.CharField(max_length=255)
    monto_aportado = models.IntegerField()

    class Meta:
        unique_together = ('id_evento', 'id_patrocinador')

class CostumbresEtnias(models.Model):
    id_etnia = models.ForeignKey(Etnia, on_delete=models.CASCADE)
    nombre = models.CharField(max_length=255)
    descripcion = models.TextField()
    categoria = models.CharField(max_length=255)

    def __str__(self):
        return f"{self.nombre} de {self.id_etnia.nombre}"

class Idioma(models.Model):
    nombre = models.CharField(max_length=255)
    familia_linguistica = models.CharField(max_length=255)

    def __str__(self):
        return self.nombre

class IdiomasEtnia(models.Model):
    id_etnia = models.ForeignKey(Etnia, on_delete=models.CASCADE)
    id_idioma = models.ForeignKey(Idioma, on_delete=models.CASCADE)
    nivel_uso = models.CharField(max_length=100)
    estado = models.CharField(max_length=50)

    class Meta:
        unique_together = ('id_etnia', 'id_idioma')

class ActividadCronograma(models.Model):
    id_cronograma = models.ForeignKey(Cronograma, on_delete=models.CASCADE)
    actividad = models.CharField(max_length=255)
    descripcion = models.TextField()

    def __str__(self):
        return self.actividad