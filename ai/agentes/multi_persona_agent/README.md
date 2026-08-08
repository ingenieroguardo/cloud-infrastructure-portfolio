# 🤖 Agente Conversacional Multi-Persona (Gemini)

Este es un agente de IA modular construido con **Python** y **Streamlit**, diseñado para interactuar mediante diferentes personalidades utilizando el modelo de Google **Gemini 3.5 Flash-Lite**.

Este proyecto demuestra mi capacidad para implementar agentes de IA con gestión de estado de sesión, streaming de respuestas y configuración dinámica de instrucciones de sistema (`system_instructions`).

## 🚀 Características
* **Gestión Inteligente de Sesiones**: Mantiene el contexto de la conversación incluso al cambiar de personalidad.
* **Streaming en tiempo real**: Respuesta fluida para una mejor experiencia de usuario.
* **Arquitectura Modular**: Fácilmente extensible para añadir nuevas personalidades o integrar herramientas externas (RAG, APIs, etc.).
* **Configuración de IA**: Implementación de parámetros de control (`temperature`, `max_output_tokens`) para ajustar el comportamiento del modelo.

---

## 🛠️ Tecnologías Utilizadas
* **Backend**: Python
* **Framework**: Streamlit
* **IA**: Google GenAI SDK (Gemini 3.5 Flash-Lite)
* **Gestión de Entorno**: `python-dotenv`

---
## ⚙️ Configuración y Ejecución

1. **Clonar el repositorio** y navegar a esta carpeta.
2. **Instalar dependencias**:
   ```bash
   pip install -r requirements.txt
3. **Configurar la API Key**:
   - Crea un archivo `.env` en la raíz del proyecto.
   - Agrega tu clave de API de Gemini:
     ```
     GEMINI_API_KEY=tu_clave_aqui
     ```
4. **Ejecutar la aplicación**:
   ```bash
   streamlit run multi_persona_agent.py
   ```
5. **Abrir el navegador** y acceder a `http://localhost:8501`.

---

##  Posibles Evoluciones bajo Apsara
Como parte de mi consultoría en Apsara, este agente es la base para soluciones más complejas, a través de los siguientes pasos de implementación:

**Agentes con conocimiento corporativo (RAG):** Integración con bases de conocimiento propias (PDFs, documentación técnica).

**Automatización de workflows:** Conexión con APIs de terceros para ejecutar tareas reales desde el chat.

**Despliegue Enterprise:** Contenerización con Docker y despliegue en infraestructuras Cloud (AWS/OCI).

Autor: Idelfonso Guardo | Arquitecto de Soluciones Senior & Estratega Cloud