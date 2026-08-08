# 🤖 Agente Conversacional Multi-Persona (Gemini)

Este es un agente de IA modular construido con **Python** y **Streamlit**, diseñado para interactuar mediante diferentes personalidades utilizando el modelo de Google **Gemini 3.5 Flash-Lite**.

Este proyecto demuestra mi capacidad para implementar agentes de IA con gestión de estado de sesión, streaming de respuestas y configuración dinámica de instrucciones de sistema (`system_instructions`).

## 🚀 Características
* **Gestión Inteligente de Sesiones**: Mantiene el contexto de la conversación incluso al cambiar de personalidad.
* **Streaming en tiempo real**: Respuesta fluida para una mejor experiencia de usuario.
* **Arquitectura Modular**: Fácilmente extensible para añadir nuevas personalidades o integrar herramientas externas (RAG, APIs, etc.).
* **Configuración de IA**: Implementación de parámetros de control (`temperature`, `max_output_tokens`) para ajustar el comportamiento del modelo.

## 🛠️ Tecnologías Utilizadas
* **Backend**: Python
* **Framework**: Streamlit
* **IA**: Google GenAI SDK (Gemini 3.5 Flash-Lite)
* **Gestión de Entorno**: `python-dotenv`

## ⚙️ Configuración y Ejecución

1. **Clonar el repositorio** y navegar a esta carpeta.
2. **Instalar dependencias**:
   ```bash
   pip install -r requirements.txt