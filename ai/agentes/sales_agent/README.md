# ☁️ APSARA — Cloud Solutions & AI Agents

> Sistema multi-agente inteligente enfocado en consultoría de arquitectura Cloud, infraestructura híbrida y automatización, operado bajo la metodología comercial del **Vendedor Desafiante**.

---

## 🚀 Finalidad del Proyecto

**APSARA** es una solución conversacional diseñada para actuar como el primer punto de contacto con clientes potenciales. El sistema combina recuperación de información documental avanzada (**RAG**) con una arquitectura de agentes autónomos estructurada mediante el **OpenAI Agents SDK**. 

Su objetivo principal es diagnosticar las necesidades técnicas de los clientes (optimización en AWS, adopción Cloud, FinOps, SRE u observabilidad), aportar valor formativo durante la conversación, mantener memoria contextual y despachar automáticamente los leads calificados hacia canales operativos (correo electrónico y notificaciones móviles).

---

## 🏛️ Arquitectura de Agentes y Componentes

El proyecto está construido bajo un enfoque modular y desacoplado, dividiendo las responsabilidades entre la IA conversacional, la recuperación de conocimiento y la logística operativa:

```text
 ┌──────────────┐       Pregunta / Contexto       ┌──────────────┐
 │ Usuario (UI) │ ──────────────────────────────> │  Agente Pau  │
 └──────────────┘                                 └──────┬───────┘
         ▲                                                │ RAG Engine
         │ Interfaz Gráfica (Gradio)                      ▼
         │                                        ┌──────────────┐
         └────────────────────────────────────────┤  ChromaDB /  │
                                                  │  LangChain   │
                                                  └──────────────┘
                                                          │ Cierre de Trato
                                                          ▼
                                                  ┌──────────────┐
                                                  │  Agente Dani │ (Tool Calling)
                                                  └──────┬───────┘
                                                         │
                                    ┌────────────────────┴────────────────────┐
                                    ▼                                         ▼
                            [SendGrid API] (Email)                  [Pushover API] (Push iPhone)


---

## Agente Comercial (Pau)

🤖 Agentes Inteligentes
1. Agente Comercial — Pau
Rol

Pau es el agente comercial y consultora técnica de APSARA.

Su responsabilidad principal es mantener conversaciones comerciales naturales con potenciales clientes, identificar sus necesidades y utilizar el conocimiento técnico disponible para construir respuestas relevantes y fundamentadas.

Metodología de ventas

Pau utiliza la metodología del Vendedor Desafiante (Challenger Sale) basada en tres principios:

Enseñar para diferenciar
Aporta información técnica y estratégica relevante.
Ayuda al cliente a identificar problemas u oportunidades que posiblemente no había considerado.
Adaptar
Ajusta la conversación según el perfil, necesidades y contexto del cliente.
Personaliza las recomendaciones de acuerdo con los servicios de interés.
Controlar
Mantiene el control de la conversación comercial.
Orienta al cliente hacia el siguiente paso apropiado.
Capacidades

Pau utiliza un motor RAG (Retrieval-Augmented Generation) para consultar documentación corporativa y perfiles profesionales antes de construir sus respuestas.

Esto le permite argumentar con información contextualizada y autoridad técnica en áreas como:

Cloud Computing
Cloud Native
DevOps
Infrastructure as Code
Automatización
Arquitecturas de nube
Servicios profesionales
Experiencia y capacidades del equipo

Durante la conversación, Pau recopila de forma natural la información necesaria para consolidar un lead:

Dato	Descripción
Nombre	Nombre del potencial cliente
Teléfono	Número de contacto
País	País de procedencia
Empresa	Organización a la que pertenece
Correo	Email de contacto
Servicios de interés	Necesidades o servicios solicitados

La recopilación de estos datos forma parte natural de la conversación y evita convertir el proceso comercial en un formulario rígido.

⚙️ 2. Agente Operativo — Dani
Rol

Dani es el asistente operativo responsable de procesar los leads una vez que Pau ha recopilado y consolidado la información necesaria.

Invocación automática

Dani es invocado mediante herramientas del OpenAI Agents SDK, utilizando @function_tool.

El flujo conceptual es:

Cliente
   │
   ▼
Pau
   │
   │ Conversación comercial
   │
   ▼
Recopilación de información
   │
   ▼
Lead consolidado
   │
   ▼
@function_tool
   │
   ▼
Dani
   │
   ├──────────────► SendGrid
   │                 Email / CRM
   │
   └──────────────► Pushover
                     Notificación Push
Responsabilidades

Dani se encarga de:

Recibir los datos consolidados del lead.
Procesar la información recibida desde Pau.
Enviar notificaciones simultáneas.
Notificar al equipo comercial mediante correo electrónico.
Generar una alerta push en tiempo real mediante Pushover.

De esta manera se separan claramente las responsabilidades:

Pau vende y califica. Dani opera y notifica.

🧠 Motor RAG — rag_engine.py

El motor RAG proporciona a los agentes acceso al conocimiento corporativo y técnico de APSARA.

Está desarrollado utilizando:

LangChain
ChromaDB
PyPDFLoader
OpenAI Embeddings
RecursiveCharacterTextSplitter

La base de datos vectorial utiliza persistencia local:

./chroma_db
Flujo del RAG
PDF corporativos
      │
      ▼
PyPDFLoader
      │
      ▼
Extracción del contenido
      │
      ▼
RecursiveCharacterTextSplitter
      │
      ▼
Fragmentación del documento
      │
      ▼
OpenAI Embeddings
      │
      ▼
ChromaDB
      │
      ▼
Base vectorial persistente

Durante la ejecución:

Pregunta del usuario
       │
       ▼
Generación del embedding
       │
       ▼
Búsqueda semántica
       │
       ▼
ChromaDB
       │
       ▼
Fragmentos relevantes
       │
       ▼
Contexto
       │
       ▼
Agente Pau
       │
       ▼
Respuesta contextualizada
Persistencia

ChromaDB almacena los embeddings y metadatos localmente en:

./chroma_db

Esto permite reutilizar el índice vectorial entre ejecuciones sin necesidad de procesar nuevamente todos los documentos cada vez que se inicia la aplicación.

🛠️ Stack Tecnológico
Core de IA
OpenAI Agents SDK
Agent
Runner
trace
@function_tool
OpenAI GPT-4o-mini
OpenAI Embeddings
Orquestación RAG
LangChain
ChromaDB
PyPDFLoader
RecursiveCharacterTextSplitter
Interfaz Web
Gradio
Paleta de colores corporativa personalizada para entornos Cloud / DevOps
Notificaciones y CRM
SendGrid
Envío de correos transaccionales.
Pushover
Alertas push en tiempo real al iPhone.
Gestión del entorno
Python
python-dotenv
certifi
Pydantic
📂 Estructura del Repositorio
.
├── data/                    # Documentos PDF corporativos
│   ├── brochure.pdf
│   └── perfil-tecnico.pdf
│
├── chroma_db/               # Base de datos vectorial persistente
│
├── rag_engine.py            # Motor RAG
│                            # Carga, fragmentación,
│                            # embeddings y consultas
│
├── salesAgent.py            # Agentes Pau y Dani
│                            # Herramientas y UI Gradio
│
├── requirements.txt         # Dependencias del proyecto
│
└── .env                     # Variables de entorno
                             # No incluido en Git

Importante: el archivo .env contiene información confidencial y nunca debe incluirse en el repositorio.

Se recomienda añadirlo al .gitignore:

.env
.venv/
__pycache__/
chroma_db/
⚙️ Guía de Instalación y Configuración
1. Clonar el repositorio
git clone https://github.com/tu-usuario/cloud-infrastructure-portfolio.git
cd cloud-infrastructure-portfolio
2. Crear el entorno virtual

Se recomienda utilizar un entorno virtual de Python para aislar las dependencias del proyecto.

Linux / macOS
python -m venv .venv
source .venv/bin/activate
Windows
python -m venv .venv
.venv\Scripts\activate
3. Instalar las dependencias
pip install -r requirements.txt

También puedes utilizar gestores modernos como uv para administrar el entorno y las dependencias.

🔐 Configuración de Variables de Entorno

Crea un archivo .env en la raíz del proyecto.

OPENAI_API_KEY=tu_clave_de_openai


SENDGRID_API_KEY=tu_clave_de_sendgrid
FROM_EMAIL=tu_correo_verificado_en_sendgrid@gmail.com
TO_EMAIL=tu_correo_destinatario@gmail.com


PUSHOVER_TOKEN=tu_token_de_aplicacion_pushover
PUSHOVER_USER=tu_user_key_de_pushover
Variables requeridas
Variable	Propósito
OPENAI_API_KEY	Autenticación con OpenAI
SENDGRID_API_KEY	Autenticación con SendGrid
FROM_EMAIL	Dirección remitente autorizada
TO_EMAIL	Dirección destinataria
PUSHOVER_TOKEN	Token de la aplicación Pushover
PUSHOVER_USER	Identificador del usuario Pushover

Seguridad: nunca publiques estas credenciales en GitHub ni las incluyas directamente en el código fuente.

🚀 Ejecución del Sistema

Para iniciar la interfaz web interactiva de APSARA con Gradio:

python salesAgent.py

Una vez iniciado el servidor, abre en tu navegador la URL local proporcionada por Gradio.

Por defecto:

http://127.0.0.1:7860
🔄 Flujo Completo de la Aplicación

El flujo principal de APSARA puede resumirse de la siguiente manera:

┌───────────────────────┐
│     Usuario / Lead    │
└───────────┬───────────┘
            │
            ▼
┌───────────────────────┐
│      Gradio UI        │
└───────────┬───────────┘
            │
            ▼
┌───────────────────────┐
│       Pau Agent       │
│                       │
│ Comercial + Técnico   │
└───────────┬───────────┘
            │
            ├───────────────────────┐
            │                       │
            ▼                       ▼
┌───────────────────────┐   ┌──────────────────────┐
│       RAG Engine      │   │   Lead Qualification │
│                       │   │                      │
│ LangChain + ChromaDB  │   │ Datos del cliente    │
└───────────┬───────────┘   └──────────┬───────────┘
            │                          │
            └────────────┬─────────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │   Lead Consolidado   │
              └──────────┬───────────┘
                         │
                         ▼
              ┌──────────────────────┐
              │      Dani Agent      │
              │   @function_tool     │
              └──────────┬───────────┘
                         │
                 ┌───────┴───────┐
                 ▼               ▼
        ┌────────────────┐ ┌───────────────┐
        │    SendGrid    │ │   Pushover    │
        │     Email      │ │ Push Alert    │
        └────────────────┘ └───────────────┘
📊 Separación de Responsabilidades
Componente	Responsabilidad
Gradio	Interfaz de usuario
Pau	Conversación, estrategia comercial y consultoría técnica
RAG Engine	Recuperación de conocimiento corporativo
ChromaDB	Persistencia de embeddings y búsqueda semántica
Dani	Operación y notificación de leads
SendGrid	Notificaciones mediante email
Pushover	Alertas push en tiempo real

Esta separación permite mantener una arquitectura modular donde cada componente tiene una responsabilidad clara.

🔒 Buenas Prácticas de Seguridad

Antes de desplegar el proyecto en un entorno productivo:

No almacenar API Keys directamente en el código.
No subir .env al repositorio.
Utilizar variables de entorno o un gestor de secretos.
Aplicar permisos mínimos a las credenciales utilizadas.
Rotar periódicamente las API Keys.
Evitar almacenar información sensible de clientes innecesariamente.
Validar y sanitizar los datos recibidos desde el usuario.
Configurar correctamente los dominios y remitentes autorizados en SendGrid.
🧪 Desarrollo y Extensión

La arquitectura permite incorporar nuevas capacidades sin modificar significativamente el flujo principal.

Algunas extensiones posibles:

Integración con un CRM real.
Persistencia de leads en una base de datos.
Incorporación de nuevos documentos al RAG.
Soporte para múltiples agentes especializados.
Integración con WhatsApp.
Integración con Microsoft Teams o Slack.
Dashboard de métricas comerciales.
Tracking de conversiones.
Automatización de seguimiento de leads.
Despliegue en servicios Cloud.
Uso de una base vectorial administrada.
📄 Licencia

Este proyecto se distribuye bajo los términos de la Licencia MIT.

Puedes utilizarlo, modificarlo y adaptarlo para tus propios flujos de trabajo profesionales, respetando los términos establecidos por dicha licencia.

👨‍💻 Proyecto

APSARA — AI Sales & Cloud/DevOps Assistant

Arquitectura basada en agentes de IA, RAG y automatización comercial para transformar conocimiento técnico en conversaciones comerciales accionables.
