"""Módulo principal con la arquitectura de agentes (Pau y Dani) e interfaz Gradio profesional para APSARA."""

from sendgrid.helpers.mail import Mail
from sendgrid import SendGridAPIClient
import requests
from rag_engine import RAGEngine
from pydantic import BaseModel, Field
from openai import OpenAI
import gradio as gr
from dotenv import load_dotenv
from agents import Agent, Runner, function_tool, trace
import asyncio
import json
import os

# --- SOLUCIÓN SSL PARA macOS (Evita el error de certificado autofirmado en SendGrid) ---
import ssl
import certifi

os.environ["SSL_CERT_FILE"] = certifi.where()
os.environ["REQUESTS_CA_BUNDLE"] = certifi.where()

try:
    _create_unverified_https_context = ssl._create_unverified_context
except AttributeError:
    pass
else:
    ssl._create_default_https_context = _create_unverified_https_context
# -------------------------------------------------------------------------------------


# Cargar las variables de entorno desde el archivo .env
load_dotenv(override=True)

# Inicializar el motor RAG para la recuperación de contexto corporativo y técnico
rag = RAGEngine(data_path="./data")


class LeadData(BaseModel):
    """Esquema de datos con Pydantic para validar la información recopilada del cliente potencial."""

    nombre: str = Field(description="Nombre completo del cliente.")
    telefono: str = Field(description="Número de teléfono con código de país.")
    pais: str = Field(
        description="País de residencia o ubicación del cliente.")
    empresa: str = Field(description="Nombre de la compañía u organización.")
    correo: str = Field(
        description="Correo electrónico corporativo o personal.")
    servicios: str = Field(
        description="Servicios de interés o requerimiento técnico."
    )


@function_tool
def send_lead_notification(
    nombre: str,
    telefono: str,
    pais: str,
    empresa: str,
    correo: str,
    servicios: str,
) -> str:
    """Envía los datos del lead recopilados vía SendGrid (correo) y Pushover (alerta push al móvil)."""
    # 1. Envío de correo electrónico a través de la API de SendGrid usando certificados seguros
    try:
        sg_client = SendGridAPIClient(
            api_key=os.environ.get("SENDGRID_API_KEY")
        )
        content = (
            f"Nuevo Lead de APSARA:\n"
            f"Nombre: {nombre}\n"
            f"Teléfono: {telefono}\n"
            f"País: {pais}\n"
            f"Empresa: {empresa}\n"
            f"Correo: {correo}\n"
            f"Interés: {servicios}"
        )
        message = Mail(
            from_email=os.environ.get("FROM_EMAIL"),
            to_emails=os.environ.get("TO_EMAIL"),
            subject=f"Nuevo Lead Comercial: {nombre} - {empresa}",
            plain_text_content=content,
        )
        sg_client.send(message)
    except Exception as err:
        print(f"⚠️ Error al enviar correo con SendGrid: {err}")

    # 2. Envío de notificación push al iPhone utilizando la API de Pushover
    try:
        requests.post(
            "https://api.pushover.net/1/messages.json",
            data={
                "token": os.environ.get("PUSHOVER_TOKEN"),
                "user": os.environ.get("PUSHOVER_USER"),
                "message": (
                    f"Lead APSARA: {nombre} ({empresa}) - {servicios}"
                ),
            },
            timeout=10,
        )
    except Exception as err:
        print(f"⚠️ Error al enviar notificación con Pushover: {err}")

    return "¡Información registrada y enviada con éxito al equipo de APSARA!"


# Definición del Agente Operativo (Dani) encargado del despacho de notificaciones
dani_agent = Agent(
    name="Agente Dani",
    instructions=(
        "Eres Dani, asistente operativo encargado de despachar "
        "la información de los clientes potenciales."
    ),
    tools=[send_lead_notification],
    model="gpt-4o-mini",
)

# Definición del Agente Comercial (Pau) experto en ventas bajo la metodología del Vendedor Desafiante
pau_agent = Agent(
    name="Agente Pau",
    instructions=(
        "Eres Pau, representante de APSARA (marca comercial de Idelfonso Guardo)[cite: 3]. "
        "Tu objetivo es vender servicios de Arquitectura Cloud, Infraestructura Híbrida y Agentes de IA[cite: 3] "
        "aplicando la filosofía del Vendedor Desafiante (Enseñar, Adaptar, Controlar). "
        "Usa el contexto técnico proporcionado[cite: 3, 4]. Si el cliente no desea dar datos, aporta valor. "
        "Cuando el cliente muestre interés firme, recopila amablemente y paso a paso los 6 datos requeridos: "
        "1. Nombre completo, 2. Teléfono con código de país, 3. País, 4. Nombre de la empresa, "
        "5. Correo electrónico y 6. Servicios de interés. "
        "IMPORTANTE: Si el cliente te da solo algunos datos parciales, acógelos cordialmente, "
        "confirma qué datos ya tienes y pídele amablemente los faltantes. "
        "NO invoques la herramienta 'send_lead_notification' hasta tener los 6 datos completos."
    ),
    tools=[send_lead_notification],
    model="gpt-4o-mini",
)


def chat_with_pau(message: str, history: list) -> str:
    """Conecta el mensaje del usuario y el historial con el SDK de agentes de OpenAI y el motor RAG."""
    # 1. Consultar contexto técnico relevante en los documentos PDF mediante RAG
    contexto_tecnico = rag.query(message)

    # 2. Formatear el historial de la conversación para que el agente mantenga la memoria
    historial_formateado = ""
    for msg in history:
        role = msg.get("role")
        content = msg.get("content")
        if role == "user":
            historial_formateado += f"Cliente: {content}\n"
        elif role == "assistant":
            historial_formateado += f"Pau: {content}\n"

    # 3. Construir el prompt completo integrando memoria, mensaje actual y contexto RAG
    prompt_completo = (
        f"Historial de la conversación previa:\n{historial_formateado}\n"
        f"Nuevo mensaje del cliente: {message}\n\n"
        f"Contexto técnico de APSARA extraído de documentos:\n{contexto_tecnico}"
    )

    # Función auxiliar asíncrona para ejecutar el agente mediante Runner
    async def run_agent():
        with trace("APSARA-Sales-Chat"):
            result = await Runner.run(pau_agent, prompt_completo)
            return result.final_output

    # Crear un nuevo event loop aislado para manejar la asincronía dentro de Gradio
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)
    try:
        response = loop.run_until_complete(run_agent())
        return response
    except Exception as exc:
        return f"Lo siento, ocurrió un error procesando tu solicitud: {str(exc)}"
    finally:
        loop.close()


# Configuración del tema visual personalizado para la interfaz (Paleta formal/azul y oscura Cloud)
custom_theme = gr.themes.Soft(
    primary_hue="blue",
    secondary_hue="slate",
    neutral_hue="slate",
).set(
    body_background_fill="#0F172A",
    block_background_fill="#1E293B",
    border_color_primary="#334155",
)

# Construcción de la interfaz web profesional con gr.ChatInterface
with gr.Blocks(title="APSARA | Cloud Solutions & AI") as demo:
    gr.Markdown(
        "# ☁️ APSARA — Cloud Solutions & AI Agents\n"
        "*No vendemos horas de soporte; diagnosticamos, diseñamos y automatizamos.*[cite: 3]",
        elem_id="title-markdown",
    )

    gr.ChatInterface(
        fn=chat_with_pau,
        chatbot=gr.Chatbot(
            height=450, label="Conversación con Pau (Estratega Comercial)"),
        textbox=gr.Textbox(
            placeholder="Hola Pau, necesito optimizar costos en mi infraestructura AWS...",
            container=False,
            scale=7,
        ),
        title="",
        description="",
    )


if __name__ == "__main__":
    print("🚀 Lanzando la interfaz web de APSARA en vivo...")
    demo.launch(server_name="127.0.0.1", server_port=7860,
                share=False, theme=custom_theme)
