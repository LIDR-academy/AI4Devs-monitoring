## Prompt 1 : inicializacion
Actua como ingeniero de software especializado en cultura devops, en especial en automatización y observabilidad. Te han asignado a un proyecto ya avanzado donde tienes su resumen en el @README.md donde entenderás bien como está organizado. Tómate el tiempo que creas necesario para analizar el proyecto y dominar su estructura. No te paras hasta no conseguir un resultado perfecto de la tarea. No alucines, analiza el codigo de los ficheros y navega para entender el proyecto. Define un plan al principio antes de hacer nada y evalua el resultado. Se crítico y meticuloso en la ejecución.



No. Por ahora solo quería que analizaras el proyecto. Ahora quiero hacerte entender lo que queremos hacer.
Te han pedido que mejores nuestro proyecto de infraestructura como código utilizando Terraform para implementar un canal de monitorización de Datadog en AWS. Aprovecharemos técnicas de prompt engineering para automatizar la generación de código, lo que nos permitirá monitorear y obtener insights valiosos de nuestra infraestructura AWS de manera automatizada.
Tu misión es extender el código Terraform existente para:

- Configurar la integración de Datadog con AWS usando Terraform.
- Instalar el agente Datadog en la instancia EC2.
- Crear un dashboard en Datadog para visualizar métricas clave de AWS.

Analiza la tarea en base a lo que hay ahora mismo en el proyecto. No hagas nada, solo dedica el tiempo que sea necesario a entender el objetivo final para no desviarnos. Vamos a hacerlo sencillo y voy a intentar darte unsos pasos claros para entender que hacer.

Solucioname mi duda. Que gustaria entender como debo hacer antes de empezar la tarea del aws-datadog. Es decir, deberia poder crear las vms en amazon, poder generar los zips y subirlos al s3 y ejecutar para tener backend y frontend en una instancia de ec2? La instnacia debe estar precreada o se crea con el terraform? Ayudame




pero si no tenemos un main, como debemos hacerlo? ejecutando ec2.tf, luego iam.tf y luego s3 o security groups? Soy un dummy. Dedica el tiempo que sea necesario para conseguir la tarea y no paraes hasta dar una solucion eficiente a la tarea. 


## Haciendo funcionar el proyecto sin datadog aun
Actua como devops experto en Terraform. Analiza @tf y crea un main que despliegue todos los recursos requeridos para este proyecto. Tómate el tiempo que creas necesario y no pares hasta encontrar el resultado perfecto. No alucines, navega por las carpetas y los archivos encontrando la solucion. Traza un plan y analiza el resultado antes de presentarmelo

## Añadimos el agente
Ahora tomate el tiempo necesario para leer estas guias:
@https://registry.terraform.io/providers/DataDog/datadog/latest/docs 
@https://docs.datadoghq.com/integrations/amazon_web_services/?tab=allpermissions 
@https://www.datadoghq.com/blog/managing-datadog-with-terraform/#deploy-datadog-with-terraform-today 
@https://docs.datadoghq.com/integrations/guide/aws-terraform-setup/ 
Añade los recursos para poder añadir el agente de datadog con la configuración correcta en el proyecto existente. No pares hasta encontrar el resultado acurado. Se meticuoso con el trabajo.