from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UsuarioViewSet
from .views import login  # Importa la vista de login

router = DefaultRouter()
router.register(r'usuarios', UsuarioViewSet)  # Crea la ruta "/usuarios/"

urlpatterns = [
    path('', include(router.urls)),  # Agrega todas las rutas de la API
    path('usuarios/', include(router.urls)),  # Rutas existentes
    path('login/', login, name='login'),  # Nueva ruta para el login
]
