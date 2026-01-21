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
# OCI Cloud-Native Infrastructure: Phase II 🚀

Este repositorio contiene la implementación de la segunda fase de mi portafolio **Cloud-Native**, migrando y escalando la arquitectura hacia **Oracle Cloud Infrastructure (OCI)**. El objetivo principal es demostrar un despliegue de grado empresarial utilizando **Kubernetes (OKE)** con un enfoque estricto en seguridad, rendimiento y optimización de costos.

## 🏗️ Arquitectura de Red y Topología

La infraestructura de red ha sido diseñada para garantizar una segregación total de funciones y minimizar la superficie de exposición:

* **VCN & Segregación:** Implementación de una Virtual Cloud Network (`192.168.0.0/16`) con una división estratégica de subredes:
    * **Public API Endpoint:** Subred `/30` dedicada exclusivamente al acceso del plano de control de Kubernetes.
    * **Public Load Balancer:** Subred `/24` para la exposición controlada de servicios hacia Internet.
    * **Private Worker Nodes:** Subred `/24` aislada, donde residen los nodos de cómputo, sin direccionamiento público.
* **Networking de Pods (Flannel):** Se ha implementado el CNI **Flannel**, proporcionando una red overlay ligera y eficiente que facilita la comunicación inter-pod sin sobrecarga innecesaria.
* **Segregación de Tráfico:** Uso de **Security Lists** por subred, permitiendo un flujo de tráfico unidireccional: los nodos pueden salir a Internet vía **NAT Gateway** y hablar con los servicios de Oracle vía **Service Gateway**, pero permanecen inaccesibles desde el exterior.



## ☸️ Managed Kubernetes (OKE)

El despliegue del clúster **Oracle Cloud Infrastructure Container Engine for Kubernetes (OKE)** se centra en la estabilidad y la modernidad:

* **Versión v1.34.1:** Uso de una de las versiones más recientes, alineada con las mejores prácticas de la comunidad de Kubernetes.
* **Shapes Flexibles:** Configuración de un Node Pool utilizando instancias **VM.Standard3.Flex** (Intel Ice Lake). Se optimizaron los recursos asignando **1 OCPU y 16GB de RAM** por nodo, permitiendo un escalado vertical preciso según la carga.
* **Imágenes Validadas:** Implementación de imágenes de **Oracle Linux 8.10 (OKE-Optimized)**. Estas imágenes han sido testeadas rigurosamente en entornos de alta demanda (como el proyecto *Tesorería 3.0*) para garantizar un tiempo de actividad (uptime) superior.
* **Acceso Seguro:** El punto final de la API es público para facilitar la administración remota, mientras que el tráfico de datos se mantiene estrictamente dentro de la red privada.



## 🛠️ Infraestructura como Código (IaC)

El despliegue es **100% automatizado mediante Terraform**, siguiendo principios de modularidad y portabilidad:

* **Diseño Modular:** Separación clara entre los módulos de red (`network`) y orquestación (`oke`), permitiendo reutilizar la lógica en distintas regiones o tenancies.
* **Gestión Dinámica:** Uso de *Data Sources* para la identificación en tiempo real de *Availability Domains* y *Service IDs* en la región de **us-chicago-1**, eliminando el "hardcoding" y aumentando la resiliencia del código.
* **Provider OCI:** Configuración avanzada del provider para manejar ciclos de vida complejos, incluyendo el uso de `taints` para actualizaciones controladas de infraestructura.

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