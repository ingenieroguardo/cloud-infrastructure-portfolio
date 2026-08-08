import os
import streamlit as st
from dotenv import load_dotenv
from google import genai
from google.genai import types

# Cargar las variables de entorno desde el archivo .env existente
load_dotenv()

# Obtener la clave de API de Gemini desde el entorno
api_key = os.getenv("GEMINI_API_KEY")

if not api_key:
    st.error(
        "No se encontró la clave GEMINI_API_KEY en el archivo .env. Por favor, configúrala."
    )
    st.stop()

# Configuración de la página de Streamlit
st.set_page_config(
    page_title="Chatbot con Google GenAI y Streamlit",
    page_icon="🤖",
    layout="centered",
)

# Título principal de la aplicación
st.title("🤖 Chatbot Inteligente con Google GenAI")
st.markdown(
    "Interactúa con diferentes personalidades utilizando el modelo **gemini-3.5-flash-lite**."
)

# Diccionario con las personalidades y sus respectivas instrucciones de sistema
PERSONALIDADES = {
    "Asistente general": (
        "Eres un asistente general útil, amigable, claro y conciso."
    ),
    "Cher Italiano": (
        "Eres un chef italiano apasionado, experto en gastronomía, que adora la "
        "pasta, la pizza y usa expresiones italianas en su conversación (como 'Mamma mia!', 'Perfetto!')."
    ),
    "Experto en Python": (
        "Eres un desarrollador experto en Python. Explicas los conceptos técnicos "
        "de manera precisa, proporcionando buenas prácticas y código limpio."
    ),
    "Profesor de historia": (
        "Eres un profesor de historia culto y elocuente. Te encanta contar anécdotas "
        "fascinantes y contextualizar los eventos históricos con detalles interesantes."
    ),
}

# Utilizar st.cache_resource para inicializar el cliente de forma persistente y evitar que se cierre


@st.cache_resource
def get_genai_client(key: str):
    return genai.Client(api_key=key)


client = get_genai_client(api_key)

# --- Barra lateral (Sidebar) ---
with st.sidebar:
    st.header("⚙️ Configuración")

    # Selector de personalidad
    personalidad_seleccionada = st.selectbox(
        "Selecciona una personalidad:", list(PERSONALIDADES.keys())
    )

    st.markdown("---")

    # Botón para limpiar la conversación y empezar de nuevo
    if st.button("🧹 Limpiar Conversación", use_container_width=True):
        st.session_state.messages = []
        if "chat_session" in st.session_state:
            del st.session_state.chat_session
        st.rerun()

    st.markdown("---")
    st.info(
        "**Instrucciones:**\n\n"
        "1. Asegúrate de tener `GEMINI_API_KEY` en tu archivo `.env`.\n"
        "2. Ejecuta con:\n`streamlit run chatbot.py`"
    )

# --- Inicialización del Estado de la Sesión ---

# Historial de mensajes para la interfaz visual
if "messages" not in st.session_state:
    st.session_state.messages = []

# Control de la personalidad activa anterior para detectar cambios
if "current_personality" not in st.session_state:
    st.session_state.current_personality = personalidad_seleccionada

# Instancia o actualización de la sesión de chat si cambia la personalidad o no existe
if "chat_session" not in st.session_state or st.session_state.current_personality != personalidad_seleccionada:
    st.session_state.current_personality = personalidad_seleccionada
    system_instruction = PERSONALIDADES[personalidad_seleccionada]

    # Configuración del modelo solicitada
    config = types.GenerateContentConfig(
        temperature=0.7,
        max_output_tokens=2000,
        system_instruction=system_instruction,
    )

    # Preparar el historial previo si existe para pasarlo a la nueva sesión
    history_for_api = []
    if "messages" in st.session_state and st.session_state.messages:
        for msg in st.session_state.messages:
            role = "user" if msg["role"] == "user" else "model"
            history_for_api.append(
                types.Content(
                    role=role, parts=[
                        types.Part.from_text(text=msg["content"])]
                )
            )

    # Crear la sesión de chat manteniendo el contexto
    st.session_state.chat_session = client.chats.create(
        model="gemini-3.5-flash-lite",
        config=config,
        history=history_for_api if history_for_api else None
    )

# --- Renderizado del Historial de Conversación ---
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

# --- Entrada del Usuario y Lógica de Respuesta ---
if prompt := st.chat_input("Escribe tu mensaje aquí..."):
    # Guardar y mostrar el mensaje del usuario inmediatamente
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    # Generar y mostrar la respuesta del asistente en Streaming
    with st.chat_message("assistant"):
        message_placeholder = st.empty()
        full_response = ""

        try:
            # Enviar el mensaje utilizando la sesión activa y streaming
            response_stream = st.session_state.chat_session.send_message_stream(
                prompt)

            for chunk in response_stream:
                if chunk.text:
                    full_response += chunk.text
                    message_placeholder.markdown(full_response + "▌")

            message_placeholder.markdown(full_response)

        except Exception as e:
            full_response = f"Ocurrió un error al procesar tu solicitud: {e}"
            message_placeholder.error(full_response)

    # Guardar la respuesta completa en el historial
    st.session_state.messages.append(
        {"role": "assistant", "content": full_response})
