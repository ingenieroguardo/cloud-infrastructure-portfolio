# cloud-infrastructure-portfolio ☁️

[![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4.svg?style=flat&logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Solutions%20Architect-232F3E.svg?style=flat&logo=amazon-aws)](https://aws.amazon.com/)
[![OCI](https://img.shields.io/badge/OCI-Architect%20Professional-F80000.svg?style=flat&logo=oracle)](https://www.oracle.com/cloud/)

## 🚀 Propósito del Proyecto
Este repositorio es mi portafolio profesional de **Infraestructura como Código (IaC)**. Aquí documento y despliego arquitecturas escalables, seguras y altamente disponibles en los principales proveedores de nube (**AWS, OCI, GCP**).

El enfoque principal es demostrar el dominio de **Terraform** bajo estándares Enterprise: modularización, gestión de estado remoto y seguridad *by design*.

---

## 🏗️ Roadmap de Implementación

| Proveedor | Proyecto | Estatus | Tecnologías Clave |
| :--- | :--- | :--- | :--- |
| **AWS** | [Scalable Web Cluster](./aws/projects/scalable-webapp) | ✅ Completado | VPC, EKS, NAT GW, Load Balancer |
| **OCI** | [Cloud Native Architecture](./oci/projects/cloud-native) | ✅ Completado | OKE, VCN, NSG, Compartments |
| **GCP** | [Data Pipeline Infra](./gcp/projects/data-infra) | 📅 Pendiente | GKE, Cloud SQL, Pub/Sub |

---

## 📂 Proyecto Destacado: AWS EKS Full Stack Foundation

He finalizado con éxito el despliegue de una infraestructura completa en AWS que soporta cargas de trabajo orquestadas por Kubernetes.

### **Logros Técnicos:**
* **Networking:** Creación de una VPC con arquitectura Multi-AZ (192.168.0.0/16) utilizando subredes públicas y privadas.
* **Cómputo (EKS):** Implementación de un clúster de **Amazon EKS** con **Managed Node Groups** (instancias t3.small) para optimización de costos y alta disponibilidad.
* **Seguridad:** Configuración de **Security Group Referencing** para aislar los nodos y permitir tráfico únicamente desde el Load Balancer.
* **Validación de Workload:** Despliegue exitoso de un servicio Nginx tipo `LoadBalancer`, validando la conectividad de extremo a extremo y la resolución de DNS externa.



---

## 🛠️ Estándares Técnicos Aplicados
* **Modularidad:** Estructura basada en módulos reutilizables para VPC, Seguridad y EKS.
* **Troubleshooting Activo:** Resolución de conflictos de aprovisionamiento de tipos de instancia y límites de cuenta en tiempo real.
* **Clean Lifecycle:** Ciclo completo de vida de la infraestructura probado (Init -> Plan -> Apply -> Workload Test -> Destroy).


---

## ☁️ Oracle Cloud Infrastructure (OCI) Implementation

Para la segunda fase de mi portafolio "Cloud-Native", decidí replicar la arquitectura de AWS en OCI, aprovechando la flexibilidad de sus recursos y su robusto servicio de Kubernetes (OKE).

### Arquitectura de Red y Seguridad
* **VCN & Segregación:** Implementación de una VCN con subredes públicas para el balanceo de carga y privadas para los nodos de cómputo.
* **Defensa en Profundidad:** Uso de **Network Security Groups (NSGs)** para el control de tráfico a nivel de VNIC, eliminando la dependencia de Security Lists de subred y permitiendo un encadenamiento de reglas más seguro (referenciando el NSG del Load Balancer desde el pool de nodos).

### Kubernetes Engine (OKE)
* **Shapes Flexibles:** Configuración de un clúster OKE utilizando instancias `VM.Standard.E4.Flex` (AMD EPYC), optimizando costos al asignar 1 OCPU y 16GB de RAM por nodo.
* **VCN-Native Pod Networking:** Implementación de redes nativas para pods, mejorando el rendimiento y la visibilidad de la red dentro del clúster.
* **Imagen Validada:** Uso de imágenes de Oracle Linux 8.10 (probadas previamente en entornos de producción como *Tesorería 3.0*) para garantizar estabilidad.

### Infraestructura como Código (IaC)
El despliegue es 100% automatizado mediante **Terraform**, utilizando un diseño modular que permite la portabilidad de componentes entre diferentes regiones (en este caso, operando sobre `us-chicago-1`).

---

## 📂 Estructura del Repositorio
```bash
.
├── aws/
│   ├── modules/    # Módulos reutilizables (VPC, Security, etc.)
│   └── projects/   # Implementaciones específicas (Scalable Webapp)
├── oci/
└── gcp/

📧 Contacto
¿Interesado en colaborar o conocer más sobre mi experiencia?

[Perfil Linkedin](https://www.linkedin.com/in/idelfonsocloudsolutionsengineer) 

[https://www.linkedin.com/in/idelfonsocloudsolutionsengineer/ | ingeniero.guardo@gmail.com]