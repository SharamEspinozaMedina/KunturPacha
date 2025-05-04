from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UsuarioViewSet, EventoViewSet
from .views import login  # Importa la vista de login
from .views import recuperar_contrasenia
from .views import restablecer_contrasenia

router = DefaultRouter()
router.register(r'usuarios', UsuarioViewSet)  # Crea la ruta "/usuarios/"
router.register(r'eventos', EventoViewSet, basename='evento')

urlpatterns = [
    path('', include(router.urls)),  # Agrega todas las rutas de la API
    path('usuarios/', include(router.urls)),  # Rutas existentes
    path('login/', login, name='login'),  # Nueva ruta para el login
    path('recuperar-contrasenia/', recuperar_contrasenia, name='recuperar_contrasenia'),
     path('restablecer-contrasenia/', restablecer_contrasenia, name='restablecer_contrasenia'),

]
