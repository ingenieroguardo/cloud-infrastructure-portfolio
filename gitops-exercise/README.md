# GitOps Scalable Infrastructure Framework

Este repositorio documenta un marco de trabajo (framework) de infraestructura altamente escalable bajo la metodología **GitOps**, diseñado para automatizar el ciclo de vida de despliegue de aplicaciones en Kubernetes. La solución es agnóstica a proveedores de nube (compatible con OKE, EKS, GKE, etc.) y garantiza consistencia, trazabilidad y observabilidad.

## 🏗️ Arquitectura de la Solución

El framework se basa en una arquitectura de microservicios desplegada en Kubernetes, orquestada mediante un flujo de CI/CD automatizado.

### Componentes Clave:
* **Orquestación:** Kubernetes (Cluster agnóstico).
* **GitOps:** ArgoCD para la sincronización continua del estado deseado.
* **CI/CD:** GitHub Actions para la automatización del pipeline.
* **Packaging:** Helm Charts con arquitectura base modular.
* **Observabilidad:** Stack completo de Prometheus y Grafana.

---

## 🚀 Flujo de Trabajo y Automatización

### CI/CD con GitHub Actions
El pipeline definido en `.github/workflows/gitops-exercise.yaml` garantiza que cada cambio en el código fuente dispare una cadena de valor inmediata:
1.  **Build & Push:** Construcción de imágenes Docker y publicación en GitHub Container Registry (GHCR).
2.  **Versioning:** Se utiliza el *Short SHA* del commit para etiquetar las imágenes, garantizando inmutabilidad y capacidad de rollback preciso.
3.  **GitOps Sync:** Actualización automática de los archivos `values.yaml` en este repositorio, disparando la reconciliación en ArgoCD.

![GitHub Actions Pipeline](https://github.com/ingenieroguardo/cloud-infrastructure-portfolio/blob/gitops-exercise/docs/images/gitops/github%20actions.png)

### GitOps con ArgoCD
ArgoCD actúa como el controlador del estado deseado. A través de la configuración de *Helm Charts*, ArgoCD despliega las aplicaciones basándose en los `values.yaml` específicos por ambiente, eliminando la configuración manual (`kubectl apply`).

![ArgoCD Dashboard](https://github.com/ingenieroguardo/cloud-infrastructure-portfolio/blob/gitops-exercise/docs/images/gitops/argocd.png)

---

## 🛠️ Estructura del Framework

La infraestructura utiliza `helm/base-app` como template maestro, permitiendo una gestión DRY (*Don't Repeat Yourself*) de los microservicios (`app-api` y `app-frontend`).

* **`script/setup-env.sh`**: Script fundamental para la inicialización del entorno y validación de dependencias del clúster antes de desplegar.
* **`helm/base-app/`**: Plantillas reutilizables (templates) que estandarizan el despliegue de recursos como Deployments, Services e Ingresses.
* **`k8s/observability/`**: Contiene los `values-prometheus.yaml` que definen la configuración específica de observabilidad.

![Microservicios Desplegados](https://github.com/ingenieroguardo/cloud-infrastructure-portfolio/blob/gitops-exercise/docs/images/gitops/pods-app.png)

---

## 📊 Observabilidad: El Corazón del Negocio

La implementación del stack **Prometheus + Grafana** es crítica para el éxito operativo: 
* **Para el equipo técnico:** Permite la detección proactiva de fallos, latencia y cuellos de botella en los microservicios.
* **Para el negocio:** Proporciona visibilidad en tiempo real del estado de los servicios, permitiendo decisiones basadas en datos y garantizando SLAs.

![Grafana Dashboard](https://github.com/ingenieroguardo/cloud-infrastructure-portfolio/blob/gitops-exercise/docs/images/gitops/grafana.png)
![Grafana Detail](https://github.com/ingenieroguardo/cloud-infrastructure-portfolio/blob/gitops-exercise/docs/images/gitops/grafana2.png)
![Observability Pods](https://github.com/ingenieroguardo/cloud-infrastructure-portfolio/blob/gitops-exercise/docs/images/gitops/pods-observability.png)

---

## 💡 Recomendaciones de Arquitectura

Para despliegues de producción, se recomienda encarecidamente utilizar un clúster mult-nodo:
* **Node Selectors & Affinity:** Se sugiere aplicar afinidad de nodos para aislar las cargas de trabajo de telemetría y observabilidad. Esto evita que los procesos de recolección de métricas compitan por recursos CPU/RAM con los microservicios de negocio, garantizando la estabilidad del aplicativo.

---

## 🚀 Setup Inicial

Para desplegar esta arquitectura, asegúrate de tener configurado tu `kubeconfig` y ejecuta el script de inicialización:

```bash
# Inicializar entorno
chmod +x script/setup-env.sh
./script/setup-env.sh