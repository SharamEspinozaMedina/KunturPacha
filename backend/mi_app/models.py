from django.db import models

class Usuario(models.Model):
    nombre = models.CharField(max_length=100)
    correo = models.EmailField(unique=True, max_length=150)
    contrasenia = models.TextField()
    genero = models.CharField(max_length=20, choices=[
        ('Masculino', 'Masculino'),
        ('Femenino', 'Femenino'),
        ('Otro', 'Otro'),
    ], null=True, blank=True)
    pais = models.CharField(max_length=100)
    ciudad = models.CharField(max_length=100)
    codigo_recuperacion = models.CharField(max_length=6, null=True, blank=True, unique=True)  # Nuevo campo
    
    def __str__(self):
        return self.nombre  # Para ver el nombre en el admin de Django
