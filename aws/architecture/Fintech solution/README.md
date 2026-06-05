# Arquitectura Híbrida para Sector FinTech en AWS

## Contexto del Proyecto
Este proyecto presenta una arquitectura de referencia diseñada para una institución financiera que requiere modernizar su núcleo de servicios (Core Banking) mediante la adopción de un modelo híbrido en AWS. La solución aborda el reto de coexistencia entre aplicaciones *legacy* ejecutándose en un Centro de Datos On-premises y servicios modernos basados en microservicios en la nube.

La arquitectura se enfoca en **seguridad robusta, alta disponibilidad, escalabilidad y cumplimiento normativo**, manteniendo una estrategia *cloud-agnostic* mediante el uso de Kubernetes (EKS) para evitar el *vendor lock-in*.

## Diagrama de Arquitectura
![Arquitectura FinTech](https://github.com/ingenieroguardo/cloud-infrastructure-portfolio/blob/main/docs/images/Diseño_arquitectónico/Fintech.svg)

---

## Componentes y Decisiones de Diseño

### 1. Conectividad Híbrida y Seguridad Perimetral
* **Conexión:** Se establece un túnel dedicado mediante **AWS Direct Connect** con cifrado **MACsec** para garantizar la seguridad de los datos en tránsito entre el DC On-premises y AWS.
* **Gestión de Tráfico:** El tráfico se centraliza a través de un **Transit Gateway**, facilitando la escalabilidad de la red a medida que el ecosistema crezca.
* **Seguridad:** Implementación de **AWS WAF** y **Shield** en el borde (Edge) mediante **CloudFront** para mitigar ataques DDoS y ataques de capa 7.

### 2. Capa de Cómputo y Modernización
* **Amazon EKS:** Cluster gestionado para orquestar microservicios, permitiendo portabilidad entre entornos.
* **Service Mesh:** Uso de **Istio** para implementar mTLS *end-to-end* entre pods, garantizando una arquitectura *Zero Trust*.
* **Orquestación:** **Karpenter** se encarga del escalado dinámico de nodos bajo demanda.

### 3. Persistencia y Seguridad de Datos
* **Bases de Datos:** Uso de **Amazon Aurora PostgreSQL Serverless v2** para garantizar alta disponibilidad y escalabilidad automática según la carga transaccional.
* **Cifrado (Compliance):** Todos los volúmenes de datos en Aurora, buckets S3 y volúmenes EBS están cifrados mediante **Customer Managed Keys (CMK)** gestionadas en **AWS KMS**. Esto cumple con los estándares de auditoría financiera más estrictos, otorgando al cliente el control total sobre el ciclo de vida de las llaves.
* **Acceso a Contenido:** La comunicación entre **CloudFront** y el bucket **S3** (estáticos) se realiza exclusivamente a través de **Origin Access Control (OAC)**, bloqueando cualquier acceso público directo.

### 4. Estrategia de Resiliencia y Disaster Recovery (DR)
Esta arquitectura ha sido diseñada bajo principios de alta disponibilidad, contemplando una estrategia de recuperación ante desastres en una región secundaria de AWS:
* **RPO (Recovery Point Objective):** Se garantiza mediante los backups continuos de Aurora y la replicación asíncrona de datos entre regiones, minimizando la pérdida de información.
* **RTO (Recovery Time Objective):** La infraestructura está definida íntegramente mediante **IaC (Terraform)**. En caso de una falla catastrófica en la región primaria, el despliegue del cluster EKS y la infraestructura crítica en una región *standby* puede ser ejecutado de forma automatizada, garantizando tiempos de recuperación optimizados.

---

## Stack Tecnológico
- **Cloud Provider:** AWS
- **IaC:** Terraform
- **Orquestación:** Kubernetes (EKS), Karpenter
- **Service Mesh:** Istio
- **Event-Driven:** Amazon MSK (Managed Streaming for Apache Kafka)
- **Caché:** ElastiCache para Redis
- **Analytics:** AWS Glue, Amazon Redshift
- **Inteligencia:** Amazon Lex (Chatbots)
