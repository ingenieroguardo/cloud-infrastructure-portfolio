# ☁️ APSARA — Cloud Solutions & AI Agents

<p align="center">
  <img src="https://shields.io" alt="Python">
  <img src="https://shields.io" alt="OpenAI">
  <img src="https://shields.io⚡-green?style=for-the-badge" alt="LangChain">
  <img src="https://shields.io" alt="MIT License">
</p>

> **APSARA** es un sistema multi-agente inteligente enfocado en consultoría de arquitectura Cloud, infraestructura híbrida y automatización. Opera bajo la metodología comercial disruptiva del **Vendedor Desafiante (Challenger Sale)**.

---

## 🚀 Finalidad del Proyecto

**APSARA** actúa como el primer punto de contacto inteligente y automatizado con clientes potenciales. El sistema combina recuperación de información documental avanzada (**RAG**) con una arquitectura de agentes autónomos estructurada mediante el **OpenAI Agents SDK**.

### Objetivos Principales
* **Diagnóstico Técnico**: Identificar necesidades clave en optimización AWS, adopción Cloud, FinOps, SRE u observabilidad.
* **Aporte de Valor**: Educar y desafiar al cliente durante la conversación con fundamentos técnicos sólidos.
* **Automatización de Leads**: Capturar datos de forma natural y despachar leads calificados instantáneamente hacia canales operativos (Email y Push).

---

## 🏛️ Arquitectura del Sistema

El proyecto está construido bajo un enfoque modular y desacoplado, dividiendo las responsabilidades entre la IA conversacional, la recuperación de conocimiento y la logística operativa.

### 🔄 Flujo de Interacción General

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
```

---

## 🤖 Arquitectura Multi-Agente

### 1. Agente Comercial y Consultora Técnica — Pau
Es la interfaz comercial del sistema. Su rol es mantener conversaciones fluidas, descubrir dolores técnicos y evangelizar al cliente utilizando la metodología **Challenger Sale**:

* **Enseñar para diferenciar**: Proporciona insights estratégicos y ayuda al cliente a ver riesgos u oportunidades de arquitectura que no había mapeado.
* **Adaptar**: Modifica el tono y las soluciones recomendadas según el perfil de la empresa y su madurez tecnológica.
* **Controlar**: Dirige la conversación de forma asertiva hacia la resolución del problema y el cierre del trato.

#### 📋 Datos Capturados por Pau de Forma Natural

| Dato | Descripción |
| :--- | :--- |
| **Nombre** | Nombre del potencial cliente |
| **Empresa** | Organización a la que pertenece |
| **País** | Ubicación geográfica para contexto regional |
| **Correo** | Email de contacto corporativo |
| **Teléfono** | Número de contacto directo |
| **Servicios de Interés** | Necesidades específicas (AWS, FinOps, DevOps, etc.) |

---

### 2. Agente Operativo — Dani
Responsable de la logística post-venta. Se activa automáticamente mediante herramientas del OpenAI Agents SDK (`@function_tool`) cuando Pau consolida el perfil del lead.

```text
Cliente ➔ Pau (Venta/Calificación) ➔ Lead Consolidado ➔ @function_tool ➔ Dani (Operación) ➔ [SendGrid / Pushover]
```

* **Acciones Simultáneas**: Genera un correo formal de CRM mediante **SendGrid API** y dispara una alerta push en tiempo real al iPhone del equipo de ventas a través de **Pushover API**.
* *Principio de diseño:* **Pau vende y califica. Dani opera y notifica.**

---

## 🧠 Motor RAG (`rag_engine.py`)

Proporciona a los agentes acceso al conocimiento corporativo e historial técnico de la organización (Brochures, PDFs de arquitecturas y perfiles del equipo).

### Componentes Core
* **Ingesta**: `PyPDFLoader` + `RecursiveCharacterTextSplitter`
* **Embeddings**: `OpenAI Embeddings`
* **Vector Store**: `ChromaDB` con persistencia local en `./chroma_db`

### 🛠️ Flujo de Procesamiento y Consulta RAG

```text
[PDFs Corporativos] ➔ [PyPDFLoader] ➔ [RecursiveCharacterTextSplitter] ➔ [OpenAI Embeddings] ➔ [ChromaDB Local]
                                                                                               │
[Pregunta Usuario]  ➔ [Generar Embedding] ➔ [Búsqueda Semántica] ➔ [Fragmentos Relevantes] ◄────┘
                                                                           │
                                                                           ▼
                                                              [Agente Pau ➔ Respuesta]
```

---

## 📊 Separación de Responsabilidades y Stack

| Componente / Capa | Tecnología | Responsabilidad Principal |
| :--- | :--- | :--- |
| **Core de IA** | OpenAI Agents SDK (GPT-4o-mini) | Gestión del ciclo de vida de los agentes y orquestación. |
| **Orquestación RAG** | LangChain / ChromaDB | Extracción, fragmentación y recuperación semántica de conocimiento. |
| **Interfaz Web** | Gradio | UI conversacional con paleta de colores personalizada (Cloud/DevOps). |
| **Notificaciones** | SendGrid API / Pushover API | Envío de correos transaccionales y alertas Push instantáneas. |
| **Entorno** | Python / Pydantic / Dotenv | Validaciones de tipos, variables de entorno y ejecución core. |

---

## 📂 Estructura del Repositorio

```📂
.
├── data/                    # Documentos PDF corporativos (brochure, perfiles)
│   ├── brochure.pdf
│   └── perfil-tecnico.pdf
├── chroma_db/               # Base de datos vectorial persistente (Local)
├── rag_engine.py            # Script del Motor RAG (Embeddings y consultas)
├── salesAgent.py            # Lógica de agentes (Pau, Dani) e Interfaz Gradio
├── requirements.txt         # Dependencias del proyecto
└── .env                     # Archivo de configuración secreta (Excluido en Git)
```

---

## ⚙️ Guía de Instalación y Configuración

### 1. Clonar el repositorio
```bash
git clone https://github.com
cd cloud-infrastructure-portfolio
```

### 2. Configurar Entorno Virtual
Se recomienda utilizar entornos aislados para evitar conflictos de dependencias.

* **Linux / macOS:**
  ```bash
  python -m venv .venv
  source .venv/bin/activate
  ```
* **Windows (PowerShell):**
  ```powershell
  python -m venv .venv
  .venv\Scripts\Activate.ps1
  ```

### 3. Instalar Dependencias
```bash
pip install -r requirements.txt
```
*(También puedes utilizar gestores modernos y rápidos como `uv`)*

---

## 🔐 Configuración de Variables de Entorno

Crea un archivo llamado `.env` en la raíz del proyecto. **Nunca subas este archivo a GitHub.**

```env
# OpenAI Core
OPENAI_API_KEY=tu_clave_de_openai

# Email CRM (SendGrid)
SENDGRID_API_KEY=tu_clave_de_sendgrid
FROM_EMAIL=tu_correo_verificado_en_sendgrid@gmail.com
TO_EMAIL=tu_correo_destinatario@gmail.com

# Alertas Push (Pushover)
PUSHOVER_TOKEN=tu_token_de_aplicacion_pushover
PUSHOVER_USER=tu_user_key_de_pushover
```

> ⚠️ **Nota de Seguridad:** Asegúrate de que tu archivo `.gitignore` incluya las entradas `.env`, `.venv/`, `__pycache__/` y `chroma_db/`.

---

## 🚀 Ejecución del Sistema

Para levantar la interfaz web interactiva de APSARA:

```bash
python salesAgent.py
```

Una vez iniciado el servicio, abre tu navegador web en la dirección local por defecto:
👉 **[http://127.0.0.1:7860](http://127.0.0.1:7860)**

---

## 🧪 Próximos Pasos y Extensibilidad
* 🔄 Integración nativa con CRMs de mercado (HubSpot, Salesforce).
* 🗄️ Migración de ChromaDB local hacia una base vectorial administrada (Pinecone / Milvus).
* 💬 Despliegue multicanal hacia WhatsApp Business, Slack o Microsoft Teams.
* 📈 Dashboard analítico para trazar la tasa de conversión y analíticas de leads.

---

## 📄 Licencia

Este proyecto se distribuye bajo los términos de la **Licencia MIT**. Puedes usarlo, modificarlo y distribuirlo libremente para fines comerciales y privados. 

---
<p align="center"><b>APSARA</b> — Transformando conocimiento técnico en conversaciones comerciales accionables.</p>

