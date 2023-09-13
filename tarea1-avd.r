{"metadata":{"kernelspec":{"name":"ir","display_name":"R","language":"R"},"language_info":{"name":"R","codemirror_mode":"r","pygments_lexer":"r","mimetype":"text/x-r-source","file_extension":".r","version":"4.0.5"}},"nbformat_minor":4,"nbformat":4,"cells":[{"cell_type":"code","source":"gc()","metadata":{"_uuid":"051d70d956493feee0c6d64651c6a088724dca2a","_execution_state":"idle","execution":{"iopub.status.busy":"2023-09-13T14:33:32.379395Z","iopub.execute_input":"2023-09-13T14:33:32.415355Z","iopub.status.idle":"2023-09-13T14:33:32.550711Z"},"collapsed":true,"jupyter":{"outputs_hidden":true},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"code","source":"library(tidyverse)\nlibrary(data.table)\nlibrary(caret)","metadata":{"execution":{"iopub.status.busy":"2023-09-13T14:43:04.160421Z","iopub.execute_input":"2023-09-13T14:43:04.162740Z","iopub.status.idle":"2023-09-13T14:43:04.182217Z"},"trusted":true},"execution_count":null,"outputs":[]},{"cell_type":"markdown","source":"# Tarea 1\n## Análisis y Visualización de Datos\n\nEstudiante: Enzo Loiza","metadata":{}},{"cell_type":"markdown","source":"## Pregunta 1\n\nComo todos sabemos, la pandemia tuvo grandes implicancias en todos los ámbitos de la sociedad, incluyendo el ámbito educacional. En este contexto, y como anticipación a posibles brotes futuros de enfermedades diversas, se le ha encomendado a Ud. cuantificar el impacto que tiene en el rendimiento académico de los estudiantes el transitar desde una situación de asistencia normal a una de estudio remoto por motivo de cuarentenas. Para realizar esta labor, se dispone de datos de estudiantes de los años 2019 y 2020.","metadata":{}},{"cell_type":"markdown","source":"(a) (1 punto) Realice un análisis exploratorio de las variables presentes en la base de datos, abarcando lo siguiente:\n\n(i) Cálculo de medidas de tendencia central (media, mediana) y de dispersión (varianza, rango intercuartil) para las variables `PROM GRAL 2019` y `PROM GRAL 2020`.\n\n(ii) Histogramas de las variables `PROM GRAL 2019` y `PROM GRAL 2020`, que corresponden al rendimiento de los alumnos en octavo básico y primero medio respectivamente. ¿Qué diferencias observa entre ambos histogramas? ¿Qué puede concluir de estas diferencias?","metadata":{}},{"cell_type":"code","source":"df1 <- fread(\"/kaggle/input/AVDdatasets/BD_Tarea_1_2023_Pregunta_1.csv\", encoding = \"Latin-1\")\nsummary(df1[c(1,2)])","metadata":{"execution":{"iopub.status.busy":"2023-09-13T14:45:07.736873Z","iopub.execute_input":"2023-09-13T14:45:07.738635Z","iopub.status.idle":"2023-09-13T14:45:07.789887Z"},"trusted":true},"execution_count":null,"outputs":[]}],"kernelspec":{"name":"ir","display_name":"R","language":"R"},"language_info":{"name":"R","codemirror_mode":"r","pygments_lexer":"r","mimetype":"text/x-r-source","file_extension":".r","version":"4.0.5"}}