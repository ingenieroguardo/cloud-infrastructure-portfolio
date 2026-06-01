## Arquitectura: Escalabilidad y Resiliencia Serverless
Esta arquitectura fue diseñada para una plataforma logística con el objetivo de proporcionar una solución altamente disponible, segura y optimizada en costos, utilizando un enfoque Serverless-first en AWS.

## 🏗️ Decisiones de Arquitectura
- **Cómputo Serverless**: Implementación de Amazon ECS con AWS Fargate, eliminando la carga operativa de administrar servidores (EC2) y facilitando el escalado automático.

- **Bases de Datos**: Amazon Aurora PostgreSQL Serverless v2 para un escalado dinámico y eficiente, eliminando el aprovisionamiento manual de capacidad.

- **Desacoplamiento**: Implementación de un bus de mensajes mediante Amazon SNS y SQS para procesar tareas pesadas de forma asíncrona, mejorando la latencia del sistema.

- **Seguridad**: Defensa en profundidad combinando AWS WAF (protección perimetral), Cognito (autenticación) y Secrets Manager (gestión de credenciales).

## 🗺️ Visualización de la Arquitectura 
La solución asegura una alta disponibilidad mediante el despliegue en múltiples zonas de disponibilidad (Multi-AZ):

![Diagrama de Arquitectura](https://github.com/ingenieroguardo/cloud-infrastructure-portfolio/blob/main/docs/images/Diseño_arquitectónico/logistica.png)
Diagrama de flujo de datos y componentes de la plataforma.

## ⚙️ CI/CD Pipeline con GitHub Actions
Toda la infraestructura sigue la filosofía IaC (Infraestructura como Código):

- **Modularidad**: Estructura de Terraform altamente reutilizable para facilitar despliegues en múltiples entornos (dev, qa, prod).
- **Validación Automática**: Integración con GitHub Actions para ejecutar terraform validate y plan en cada propuesta de cambio.
- **Seguridad**: Integración de políticas de IAM de menor privilegio gestionadas mediante GitHub Secrets.

## ☁️ Gestión de Estado Remoto

- **Persistencia**: Estado de Terraform almacenado en Amazon S3 con versionado habilitado para auditoría y recuperación.
- **Concurrencia**: Bloqueo de estado gestionado mediante Amazon DynamoDB, garantizando consistencia en despliegues concurrentes.

## 🚀 Despliegue

1. Inicializar: `terraform init`
2. Validar: `terraform validate`
3. Planificar: `terraform plan -out=tfplan`
4. Aplicar: `terraform apply "tfplan"`

**Autor:** [Idelfonso Guardo](https://github.com/ingenieroguardo)