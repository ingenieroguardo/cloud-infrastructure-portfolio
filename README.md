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
| **AWS** | [Scalable Web Cluster](./aws/projects/scalable-webapp) | ✅ Desplegado | VPC, NAT GW, Security Groups, S3 Backend |
| **AWS** | [EKS Managed Cluster](./aws/projects/eks-cluster) | 📅 Próximamente | EKS, Managed Node Groups, IAM Roles |
| **OCI** | [Cloud Native Architecture](./oci/projects/cloud-native) | 📅 Pendiente | OKE, VCN, Autonomous DB |
| **GCP** | [Data Pipeline Infra](./gcp/projects/data-infra) | 📅 Pendiente | GKE, Cloud SQL, Pub/Sub |

---

## 📂 Proyecto Destacado: AWS Foundation (Network & Security)

He implementado la base de red bajo el estándar de **Defensa en Profundidad**, utilizando el bloque CIDR `192.168.0.0/16` para simular un entorno corporativo robusto.



### **Detalles Técnicos:**
* **Multi-AZ Resilience:** Despliegue distribuido en 2 Zonas de Disponibilidad (`us-east-1a`, `us-east-1b`) para garantizar Alta Disponibilidad (HA).
* **Segregación de Capas (Tiered Networking):**
    * **Subredes Públicas:** Para Load Balancers y puntos de entrada con **Internet Gateway**.
    * **Subredes Privadas:** Para cargas críticas (EKS/DB), con salida segura vía **NAT Gateway**.
* **Security Group Referencing:** La capa de aplicación solo acepta tráfico originado desde el Security Group del Load Balancer, eliminando vectores de ataque externos directos.
* **State Management:** Uso de **S3 Backend** con encripción para el manejo del estado de Terraform.

---

## 🛠️ Estándares Técnicos Aplicados
* **Modularidad:** Uso de módulos reutilizables (DRY) para VPC y Seguridad.
* **Seguridad:** Implementación de privilegios mínimos y aislamiento de recursos.
* **Infraestructura Inmutable:** Todo cambio se gestiona exclusivamente vía código.

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

[https://www.linkedin.com/in/idelfonsocloudsolutionsengineer/ | ingeniero.guardo@gmail.com]