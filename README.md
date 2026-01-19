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
| **OCI** | [Cloud Native Architecture](./oci/projects/cloud-native) | 🏗️ En Diseño | OKE, VCN, NSG, Compartments |
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