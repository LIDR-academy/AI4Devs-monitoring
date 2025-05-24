--------------------------------------------
PROMPT #1
--------------------------------------------
Eres un desarrollador full-stack experto en aplicaciones web usando tecnologias como React en front end, Express con Prisma para el backend. Analiza este proyecto en su totalidad, y lee el @README.md para tener el contexto del proyecto ATS llamado "LTI", en el que trabajaremos. No hagas nada aun, solo comprende el proyecto en el que nos encontramos.

--------------------------------------------
PROMPT #2
--------------------------------------------
Ahora que tienes el contexto del proyecto, hay un ejercicio que me gustaria resolver. Te paso el ejercicio:

@Ejercicio.md 

Teniendo en cuenta el ejercicio, Podrias por favor, listarme el paso a paso de lo que debo hacer para desarrollar el ejercicio, explicandolo uno a uno a alguien que nunca lo ha hecho, y con ello poderlo completar con los requerimientos mencionados, manteniendo una solucion directa, sencilla y que cumpla con el objetivo propuesto? Considera: 

- Actualmente ya estamos trabajando en el repositorio, por ende ya esta descargado.
- Ya cree mi cuenta AWS.
- Ya tengo instalado OpenTofu y Terraform en mi maquina local.

--------------------------------------------
PROMPT #3
--------------------------------------------
Empecemos por la Fase 1: Preparacion del entorno. Por cada paso tengo: 
- Paso 1, ya cree la cuenta datadog
- Paso 2, ya obtuve las credenciales de datadog, y ya cree la nueva application key.
- Paso 3, aqui estoy. No entiendo muy bien donde o como debo configurar las variables de entorno. 

--------------------------------------------
PROMPT #4
--------------------------------------------
Ya tengo la FASE 1 completada. Pasemos a la Fase 2. Alli, iremos con el Paso 4, Crear estructura de archivos. Actualmente ya existe la carpeta prompts y el archivo "datadog-aws-prompts.md". Revisa lo que haga falta para luego, ir a la Fase 3.

--------------------------------------------
PROMPT #5
--------------------------------------------
Vamos con la FASE 3: Configuración de Terraform para Datadog. A partir de esto, quiero que prosigas con los pasos: 
- Paso 5: Configurar el proveedor Datadog.
- Paso 6: Definir variables.

Para ello, tengo el archivo @VariablesEntorno.md , donde hay datos sobre las API keys, APP keys y demas. Usalos como creas conveniente e indicame que otra información se necesita configurar para dar esta fase como completada.

--------------------------------------------
PROMPT #6
--------------------------------------------
El comando "terraform Init" arrojo este resultado, indicando que si se inicializo correctamente. Consideras la Fase 3 terminada ?

--------------------------------------------
PROMPT #7
--------------------------------------------
Continuemos con la FASE 4: Integración AWS-Datadog. Para ello, ejecuta 
- Paso 7: Configurar rol IAM para Datadog
- Paso 8: Configurar agente Datadog en EC2
Si necesitas informacion de las plataformas no dudes en preguntarmelo.

--------------------------------------------
PROMPT #8
--------------------------------------------
Ejecute "Terraform validate" como sugeriste, y el resultado fue este. Que crees que debo hacer para arreglarlo, y asi mismo, poder proseguir con la Fase 5? Hay variables que debo setear ? Revisa el codigo generado, en la ultima fase.

--------------------------------------------
PROMPT #9
--------------------------------------------
Actualiza los valores de @terraform.tfvars con los valores adatadog de @VariablesEntorno.md. Con estos valores, consideras que podemos pasar a la Fase 5 ? 

--------------------------------------------
PROMPT #10
--------------------------------------------
Pasemos a la FASE 5: Dashboard en Datadog. Para ello sugeriste hacer: 
- Paso 9 Crear dashboard.
- Paso 10: Outputs
Ejecuta estos pasos, teniendo presente que, en la fase anterior, tuviste que verificar comandos deprecados. Asegurate que esto funcione antes de pasar a la FASE 6, donde haremos despliegue y verificacion.