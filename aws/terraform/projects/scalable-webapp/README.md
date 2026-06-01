# AWS Scalable Web Application Foundation

Este proyecto despliega una infraestructura de nube altamente disponible y segura en AWS, diseñada para soportar cargas de trabajo orquestadas mediante Kubernetes (EKS). El despliegue sigue los principios del *Well-Architected Framework*.

## 🏗️ Decisiones de Arquitectura

- **Networking**: VPC con segmentación estricta; subredes públicas para balanceadores y privadas para cómputo.
- **Alta Disponibilidad**: Implementación Multi-AZ para resiliencia del plano de datos.
- **NAT Gateway**: Salida controlada a Internet. *Nota: NAT único para optimización de costos en laboratorio.*
- **Seguridad**: *Security Group Referencing* para aislar tráfico exclusivo desde el ALB hacia los nodos de EKS.

## 🗺️ Visualización de recursos desplegados 

La arquitectura implementada asegura una separación clara entre las capas de red:

![Mapa de Recursos VPC](https://github.com/ingenieroguardo/cloud-infrastructure-portfolio/blob/main/docs/images/vpc-resource-map.png)

![Estado del Cluster EKS](https://github.com/ingenieroguardo/cloud-infrastructure-portfolio/blob/main/docs/images/eks-cluster-status.png)

## ⚙️ CI/CD Pipeline con GitHub Actions

La infraestructura cuenta con despliegue automatizado mediante GitHub Actions:

- **Validación Continua**: `terraform validate` y `plan` automáticos en cada `push`/`pull request`.
- **Despliegue Controlado**: Job de `apply` protegido mediante `workflow_dispatch` (gatillo manual).
- **Seguridad**: Gestión de credenciales mediante *GitHub Secrets*.

![Acciones CI/CD](https://github.com/ingenieroguardo/cloud-infrastructure-portfolio/blob/main/docs/images/Actions%20CICD.png)

## ☁️ Gestión de Estado Remoto
Para garantizar la integridad y la colaboración segura en el despliegue de infraestructura, este proyecto utiliza un backend remoto:

- **Almacenamiento de Estado**: Se utiliza un bucket **Amazon S3** (`portafolio-cloud-s3`) para almacenar el archivo `terraform.tfstate` de manera persistente y versionada, permitiendo auditorías y recuperación ante desastres.
- **Bloqueo de Estado (State Locking)**: Se implementa una tabla **Amazon DynamoDB** para gestionar el bloqueo de estado, evitando colisiones cuando múltiples procesos o colaboradores intentan aplicar cambios simultáneamente.

![Estado Remoto S3](https://github.com/ingenieroguardo/cloud-infrastructure-portfolio/blob/main/docs/images/State-S3.png)
*Visualización del bucket S3 gestionando el versionado del estado de Terraform.*

---

## 🚀 Despliegue

1. Inicializar: `terraform init`
2. Validar: `terraform validate`
3. Planificar: `terraform plan -out=tfplan`
4. Aplicar: `terraform apply "tfplan"`

**Autor:** [Idelfonso Guardo](https://github.com/ingenieroguardo)