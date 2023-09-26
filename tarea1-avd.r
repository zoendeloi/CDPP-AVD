{"metadata":{"kernelspec":{"name":"ir","display_name":"R","language":"R"},"language_info":{"name":"R","codemirror_mode":"r","pygments_lexer":"r","mimetype":"text/x-r-source","file_extension":".r","version":"4.0.5"}},"nbformat_minor":4,"nbformat":4,"cells":[{"cell_type":"code","source":"gc()","metadata":{"_uuid":"051d70d956493feee0c6d64651c6a088724dca2a","_execution_state":"idle","execution":{"iopub.status.busy":"2023-09-26T17:45:31.602064Z","iopub.execute_input":"2023-09-26T17:45:31.607093Z","iopub.status.idle":"2023-09-26T17:45:31.962726Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"library(tidyverse)\nlibrary(patchwork)\nlibrary(cowplot)\nlibrary(data.table)\nlibrary(caret)","metadata":{"execution":{"iopub.status.busy":"2023-09-26T17:45:33.990969Z","iopub.execute_input":"2023-09-26T17:45:34.049814Z","iopub.status.idle":"2023-09-26T17:45:37.232158Z"},"collapsed":true,"jupyter":{"outputs_hidden":true},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"## Análisis y Visualización de Datos\n\nEstudiante: Enzo Loiza","metadata":{}},{"cell_type":"markdown","source":"# Pregunta 1\n\nComo todos sabemos, la pandemia tuvo grandes implicancias en todos los ámbitos de la sociedad, incluyendo el ámbito educacional. En este contexto, y como anticipación a posibles brotes futuros de enfermedades diversas, se le ha encomendado a Ud. cuantificar el impacto que tiene en el rendimiento académico de los estudiantes el transitar desde una situación de asistencia normal a una de estudio remoto por motivo de cuarentenas. Para realizar esta labor, se dispone de datos de estudiantes de los años 2019 y 2020.","metadata":{}},{"cell_type":"markdown","source":"## (a) Realizamos un análisis exploratorio\n\nde las variables presentes en la base de datos. Primero, abrimos la base de datos, hacemos una primera exploración mediante `str` (para ver qué contiene la base de datos), un `summary` inicial y obtenemos las varianzas de los Promedios Generales de los años 2019 y 2020. Luego, obtenemos los histogramas de ambas variables de interés.","metadata":{}},{"cell_type":"code","source":"df1 <- fread(\"/kaggle/input/AVDdatasets/BD_Tarea_1_2023_Pregunta_1.csv\", #base guardada como df1\n             encoding = \"Latin-1\")\nstr(df1) # 187329 instancias, variables son PROM_GRAL_2019, ...2020, GEN_ALU, ASISTENCIA_2019\nsummary(df1[,c(1,2)]) # primeros datos de tendencia central\nvar(df1$PROM_GRAL_2019) # varianza del promedio en 2019\nvar(df1$PROM_GRAL_2020) # varianza del promedio en 2020\n\ngraf1 <- ggplot(df1, aes(PROM_GRAL_2019)) +\n        geom_histogram(binwidth = .3, fill = \"#00AFBB\", color = \"black\") +\n        labs(title = \"Histograma de Promedios (2019)\", x = \"Valores\", y = \"Frecuencia\") +\n        theme_cowplot(8)\ngraf2 <- ggplot(df1, aes(PROM_GRAL_2020)) +\n        geom_histogram(binwidth = .3, fill = \"#00AFBB\", color = \"black\") +\n        labs(title = \"Histograma de Promedios (2020)\", x = \"Promedios\", y = \"Frecuencia\") +\n        theme_cowplot(8)\ngraf1 / graf2","metadata":{"execution":{"iopub.status.busy":"2023-09-26T19:30:20.144176Z","iopub.execute_input":"2023-09-26T19:30:20.147987Z","iopub.status.idle":"2023-09-26T19:30:21.494333Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"La base de datos tiene cuatro variables\n- `PROM_GRAL_2019`, que corresponde a los promedios generales de cada estudiante en 2019.\n- `PROM_GRAL_2020`, correspondiente a los promedios generales de cada estudiante en 2020.\n- `GEN_ALU`, variable dicotómica correspondiente al sexo del estudiante.\n- `ASISTENCIA_2019`, que indica el porcentaje de asistencia anual del estudiante en 2019.\n\nLas medidas de tendencia central de las variables `PROM_GRAL_2019` y `PROM_GRAL_2020` se muestran en la siguiente tabla:\n\n| Medida | Promedios 2019 | Promedios 2020 |\n|--------|----------------|----------------|\n| Media | 5.78 | 5.82 |\n| Mediana | 5.80 | 6.00 |\n| Varianza | 0.29 | 0.75 |\n| Min | 2.00 | 1.00 | \n| Rango Intercuartil | 5.40-6.20 | 5.30-6.50 |\n| | 0.80 | 1.20 |\n| Max | 7.00 | 7.00 |\n\nDe los resultados, vemos que existió un aumento pequeño en las medidas de tendencia central:\nen la media, de 5.78 a 5.82; y en la mediana, de 5.80 a 6.00.\nAdemás, las medidas de dispersión también aumentaron: la varianza pasó de 0.29 a 0.75, el rango intercuartil de 0.8 a 1.2.\nEste aumento es claro en los histogramas, pues, aunque la media y mediana aumentaron, la cola inferior de los promedios en 2020 es más extendida hacia promedios inferiores.\n\nLa conclusión (o hipótesis más bien) es que aumentaron algunas brechas de resultado de rendimiento académico en el total de la población, beneficiando a una parte de ella, pero perjudicando a otra. Esta brecha refleja (si se cumple el supuesto de aleatoriedad de la población) disparidades de aprendizajes de manera transversal.\n","metadata":{"execution":{"iopub.status.busy":"2023-09-14T19:21:36.752788Z","iopub.execute_input":"2023-09-14T19:21:36.754160Z","iopub.status.idle":"2023-09-14T19:21:36.784513Z"}}},{"cell_type":"markdown","source":"## (b) Usamos las funciones del paquete `caret`\n\nseparando los datos en un conjunto de entrenamiento y uno de testeo, dejando un 70% de los mismos para el entrenamiento, y ajuste el siguiente modelo de Regresión Lineal simple:\n\n$$\\text{PROM GRAL 2020} ∼ \\text{PROM GRAL 2019} + \\text{ASISTENCIA 2019} + \\text{GEN ALU}$$","metadata":{}},{"cell_type":"code","source":"set.seed(200) #seteamos la semilla 200 (aunque puede ser cualquiera)\ninTraining <- createDataPartition(df1$PROM_GRAL_2020,\n                                  p = 0.7,\n                                  list = FALSE)\ntraining <- df1[inTraining,]\ntesting <- df1[-inTraining,]","metadata":{"execution":{"iopub.status.busy":"2023-09-26T17:45:48.376092Z","iopub.execute_input":"2023-09-26T17:45:48.380227Z","iopub.status.idle":"2023-09-26T17:45:48.914166Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"modelo <- train(PROM_GRAL_2020 ~ PROM_GRAL_2019 +\n                   ASISTENCIA_2019 +\n                   GEN_ALU,\n                   data = training,\n                   method = \"lm\")","metadata":{"execution":{"iopub.status.busy":"2023-09-26T17:45:53.565690Z","iopub.execute_input":"2023-09-26T17:45:53.567870Z","iopub.status.idle":"2023-09-26T17:46:19.806265Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"predicciones <- predict(modelo,\n                        newdata = testing)\n\nhead(predicciones)","metadata":{"execution":{"iopub.status.busy":"2023-09-26T17:46:28.674653Z","iopub.execute_input":"2023-09-26T17:46:28.676903Z","iopub.status.idle":"2023-09-26T17:46:28.911427Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"Reportamos los coeficientes del modelo:","metadata":{}},{"cell_type":"code","source":"summary(modelo)","metadata":{"execution":{"iopub.status.busy":"2023-09-26T17:46:35.745990Z","iopub.execute_input":"2023-09-26T17:46:35.748174Z","iopub.status.idle":"2023-09-26T17:46:35.800973Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"Y el error cuadrático medio (MSE)","metadata":{}},{"cell_type":"code","source":"mse_train <- modelo$results$RMSE^2\nmse_train","metadata":{"execution":{"iopub.status.busy":"2023-09-26T17:46:39.908813Z","iopub.execute_input":"2023-09-26T17:46:39.910680Z","iopub.status.idle":"2023-09-26T17:46:39.934462Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"## (c) Calculamos el MSE\nen el conjunto de testeo,","metadata":{}},{"cell_type":"code","source":"mse_test <- mean((predicciones - testing$PROM_GRAL_2020)^2)\nmse_test","metadata":{"execution":{"iopub.status.busy":"2023-09-26T17:46:44.851305Z","iopub.execute_input":"2023-09-26T17:46:44.853228Z","iopub.status.idle":"2023-09-26T17:46:44.873014Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"y comparamos con el valor obtenido en el conjunto de entrenamiento (que en este caso es 0.5452, un poco mejor que `mse_test`).\n\nDe la parte (b) ya tenemos el `predict`. El MSE en la Base de entrenamiento es un poco menor que el de la base de prueba. Como son tan cercanos, no necesariamente significa que haya sobreajuste (*overfitting*).\n\nEl MSE es inferior a 0.6, lo que no es necesariamente alto. Habría que comparar con más modelos o hacer valización cruzada.","metadata":{}},{"cell_type":"markdown","source":"## (d) Extensiones del modelo para un caso futuro.\n\nLa muestra cubre la totalidad de estudiantes, por lo que podemos asegurar que es aleatoria y representativa. Si el modelo es bueno, tanto para la partición de entrenamiento como para la de testeo, puede significar buenas predicciones en casos futuros.\n\nSin embargo, ocurren dos cosas que limitan el uso del modelo en un futuro. Primero, la elección de variables que se utilizan en el modelo es escueta. Si hay mayor disponibilidad de información, como comunas, dependencia de los colegios, entre otros, podría ayudar a mejorar la predicción. Con esto en mente, el sobreajuste es siempre un problema al aumentar las variables. Por otro lado, el MSE es bastante alto, y está lejos de un ajuste ideal, sobre todo si la muestra es variable.","metadata":{}},{"cell_type":"markdown","source":"# Problema 2\n\nHabida cuenta de que el desarrollo científico del país y su descentralización son de gran importancia, resulta interesante evaluar la tendencia que presentan los estudiantes de Educación Media de Regiones a estudiar carreras del ámbito de Ciencias Básicas. En concreto, en esta pregunta Ud. deberá evaluar el poder predictivo de un modelo de Regresión Logística aplicado a los estudiantes de zonas rurales de la Región de Los Lagos, utilizando datos de matrícula de alumnos.","metadata":{}},{"cell_type":"markdown","source":"Abrimos primero la base de datos, luego transformamos algunas variables a formato `chr` para que queden amigables al modelo logistico.","metadata":{}},{"cell_type":"code","source":"df2 <- fread(\"/kaggle/input/AVDdatasets/BD_Tarea_1_2023_Pregunta_2.csv\",\n             encoding  = \"Latin-1\") # %>% filter(COD_REG_RBD == 10)","metadata":{"execution":{"iopub.status.busy":"2023-09-26T19:57:29.639153Z","iopub.execute_input":"2023-09-26T19:57:29.642542Z","iopub.status.idle":"2023-09-26T19:57:29.697222Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"## (a) Creación de sub-base\n\nUtilizando las variables `COD_REG_RBD` (que indica la región en que estudia el alumno) y `RURAL_RBD` (que indica si el alumno es de una zona rural o urbana) extrajimos de la base de datos una sub-base que contenga a los estudiantes de zonas rurales de la Región de Los Lagos. Este objeto se almacenó como `rurales`. Aprovechamos de guardar una base similar pero con los datos de estudiantes `urbanos`. Posteriormente, usamos algunas herramientas aprendidas en el diplomado para hacer una tabla que resume la proporción de los datos de estudiantes rurales frente a los totales. Como se observa en la tabla, 450 de 6122 estudiantes provienen de colegios rurales, correspondiente a un 7.35% de la Región de Los Lagos aproximadamente.","metadata":{}},{"cell_type":"code","source":"rurales <- df2 %>% filter(RURAL_RBD == \"1\" & COD_REG_RBD == 10)\nnrow(rurales)/nrow(df2)\n","metadata":{"execution":{"iopub.status.busy":"2023-09-26T20:04:07.724107Z","iopub.execute_input":"2023-09-26T20:04:07.726232Z","iopub.status.idle":"2023-09-26T20:04:07.758209Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"## (b) Regresión Logística\n\nLa variable CIENCIAS es una variable discreta, cuyos valores posibles indican si el alumno en cuestión ingresó a una carrera del ámbito de Ciencias Básicas (en cuyo caso la variable es 1) o no (en cuyo caso la variable es 0). Usando las funciones del paquete `caret`, separamos la base de datos generada en el ítem anterior en conjuntos de entrenamiento y testeo, dejando un 70% de los datos para el entrenamiento, y ajuste el siguiente modelo de Regresión Logística:\n\n$$\\text{CIENCIAS} ∼ \\text{GEN ALU} + \\text{EDAD ALU} + \\text{PROM GRAL} + \\text{ASISTENCIA}$$\n\nReportamos los valores de los coeficientes, y calculamos el error dentro de la muestra utilizando la fórmula de entropía cruzada binaria vista en el taller 2.","metadata":{}},{"cell_type":"code","source":"df2$CIENCIAS <- as.factor(df2$CIENCIAS)\nset.seed(123) #seteamos la semilla 200 (aunque puede ser cualquiera)\ninTraining <- createDataPartition(df2$CIENCIAS,\n                                  p = 0.7,\n                                  list = FALSE)\ntraining <- df2[inTraining,]\ntesting <- df2[-inTraining,]","metadata":{"execution":{"iopub.status.busy":"2023-09-26T20:06:33.066488Z","iopub.execute_input":"2023-09-26T20:06:33.068367Z","iopub.status.idle":"2023-09-26T20:06:33.172022Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"logit <- train(CIENCIAS ~ GEN_ALU + EDAD_ALU + PROM_GRAL + ASISTENCIA,\n               data = training,\n               method = \"glm\",\n               family=binomial())\n\nsummary(logit)","metadata":{"execution":{"iopub.status.busy":"2023-09-26T20:06:42.262253Z","iopub.execute_input":"2023-09-26T20:06:42.264199Z","iopub.status.idle":"2023-09-26T20:07:28.177085Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"entropia_binaria = function(u,v){\n    u = as.character(u)\n    entropia = ifelse(u == \"1\",\n                      -log(v),\n                      -log(1-v))\n    }\n\nprob_train <- predict(logit, newdata = training, type=\"prob\")\n\nEin = rep(0,times=nrow(training))\n\nfor (i in 0:length(prob_train[,2])){Ein[i] = entropia_binaria(training$CIENCIAS[i],prob_train[i,2])}\n\nEin = mean(Ein)\nEin","metadata":{"execution":{"iopub.status.busy":"2023-09-26T20:18:19.730004Z","iopub.execute_input":"2023-09-26T20:18:19.732575Z","iopub.status.idle":"2023-09-26T20:18:23.527994Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"Ein * 2* length(training$CIENCIAS)","metadata":{"execution":{"iopub.status.busy":"2023-09-26T20:18:25.675444Z","iopub.execute_input":"2023-09-26T20:18:25.677479Z","iopub.status.idle":"2023-09-26T20:18:25.696634Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"## (c) Estimación de error\n\nEstime el error fuera de la muestra utilizando la fórmula de entropía cruzada binaria (vista en el taller 2) incurrido por el modelo utilizando el conjunto de testeo (pista: puede utilizar la función predict del paquete caret).","metadata":{}},{"cell_type":"code","source":"pred_test <- predict(logit, testing, type = \"raw\")\nprob_test <- predict(logit, testing, type=\"prob\")\n\nEout = rep(0,times=nrow(testing))\nfor(i in 1:length(pred_test)){ Eout[i] = entropia_binaria(testing$CIENCIAS[i], prob_test[i,2]) }\n\nEout = mean(Eout)\nEout","metadata":{"execution":{"iopub.status.busy":"2023-09-26T20:18:29.694747Z","iopub.execute_input":"2023-09-26T20:18:29.701204Z","iopub.status.idle":"2023-09-26T20:18:31.435012Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"y comparamos con el error dentro de la muestra calculado en el ítem anterior (0.1205). En base a estos resultados. El error es bastante pequeño.","metadata":{}}]}