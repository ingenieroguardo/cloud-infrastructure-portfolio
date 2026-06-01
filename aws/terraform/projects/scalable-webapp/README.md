# AWS Scalable Web Application Foundation

Este proyecto despliega una infraestructura de nube altamente disponible y segura en AWS, diseñada para soportar cargas de trabajo orquestadas mediante Kubernetes (EKS). El despliegue sigue los principios del *Well-Architected Framework*.

## 🏗️ Decisiones de Arquitectura

- **Networking**: Se ha diseñado una VPC con segmentación de red estricta, utilizando subredes públicas para el balanceo de carga y subredes privadas para los recursos de cómputo (Worker Nodes).
- **Alta Disponibilidad**: El despliegue utiliza múltiples zonas de disponibilidad (Multi-AZ) para garantizar la resiliencia del plano de cómputo.
- **NAT Gateway**: Se ha implementado un NAT Gateway para permitir la salida controlada de tráfico desde las subredes privadas. 
  - *Nota técnica*: Para este laboratorio, se utiliza un único NAT Gateway para optimización de costos. En entornos de alta disponibilidad crítica, se recomienda el despliegue de un NAT Gateway por zona de disponibilidad.
- **Seguridad**: Se aplica el principio de menor privilegio mediante *Security Group Referencing*, permitiendo tráfico exclusivamente desde el Application Load Balancer (ALB) hacia los nodos de EKS.

## 🗺️ Visualización de la Arquitectura

Para garantizar una segregación clara entre los componentes públicos y privados, la arquitectura se despliega bajo la siguiente topología:

![Mapa de Recursos VPC](https://github.com/tu-usuario/cloud-infrastructure-portfolio/blob/main/aws/architecture/vpc-resource-map.png)
*Vista de los componentes de red (VPC, Subredes y Tablas de Enrutamiento).*

![Estado del Cluster EKS](https://github.com/tu-usuario/cloud-infrastructure-portfolio/blob/main/aws/architecture/eks-cluster-status.png)
*Estado activo del clúster en el plano de control de AWS.*

---

## 🛠️ Requisitos previos

- AWS CLI configurado con el perfil `aws-idel`.
- Terraform >= 1.5.0.
- Bucket S3 y tabla DynamoDB configurados para el estado remoto (definidos en `providers.tf`).

## 🚀 Despliegue

Para desplegar esta arquitectura:

1. Inicializar el entorno: `terraform init`
2. Validar sintaxis: `terraform validate`
3. Planificar cambios: `terraform plan -out=tfplan`
4. Aplicar despliegue: `terraform apply "tfplan"`

---
**Autor:** [Idelfonso Guardo](https://github.com/ingenieroguardo)