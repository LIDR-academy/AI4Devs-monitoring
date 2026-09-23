# AGENTS.MD - Protocolo de Operación (Architect Agent)

Este archivo define el comportamiento obligatorio para cualquier instancia de IA que opere en este repositorio dentro de **Google Antigravity**. El cumplimiento de estas reglas es indispensable para garantizar la coherencia atómica del proyecto.

---

## 1. SISTEMA DE REGISTRO (LOGGING)
**Regla:** Antes de ejecutar cualquier tarea compleja, es obligatorio registrar el contexto en `prompts.md`.

### A. Verificación de Existencia
Si `prompts.md` **no** existe, debe crearse con el siguiente encabezado:
* **Autor**: [Usuario]
* **Proyecto**: [Nombre extraído del contexto o preguntar]
* **Descripción**: Bitácora de trazabilidad para entornos multi-agente.

### B. Lógica de Escritura (Anticolisión)
Para evitar condiciones de carrera en entornos asíncronos, se prohíbe el uso de IDs incrementales simples.
1. **Identificador Único:** Usa estrictamente el formato `YYYYMMDD-HHMM-SS` (UTC).
2. **Sincronización:** Realiza una lectura (`read`) de `prompts.md` inmediatamente antes de escribir para asegurar que no se pisen registros.
3. **Formato de Entrada:**
   ```markdown
   ## [ID-UNICO] - [Título Breve y Descriptivo]
   **Fecha:** YYYY-MM-DD HH:MM
   **Prompt Original:**
   > [Copia literal y completa del prompt del usuario. NO resumir.]
   
   **Resumen de Acción:**
   [Resumen técnico de 1-2 líneas de la solución planteada]
   ---