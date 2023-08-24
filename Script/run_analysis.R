#DEFINIR DIRECTORIO DE TRABAJO

## Define la ruta del directorio que deseas crear
nuevoDIR <- "C:/RStudio/Getting-and-Cleaning-Data"

## Crea las carpetas si no existen
if (!file.exists(nuevoDIR)) {
        dir.create(nuevoDIR, recursive = TRUE)
        cat("Directorio creado:", nuevoDIR, "\n")
} else {
        cat("El directorio ya existe:", nuevoDIR, "\n")
}

## Establece el nuevo directorio de trabajo
setwd(nuevoDIR)

## Imprime la ruta actual del directorio de trabajo
cat("Directorio de trabajo actual:", getwd(), "\n")

remove(list = ls())

#DESCARGO ARCHIVO CON DATOS

##Creo carpeta donde guardar los archivos.
if (!file.exists("Data")) {
        dir.create("Data", recursive = TRUE)
        cat("Carpeta creada.")
} else {
        cat("La carpeta ya existe.")
}

##Descargo y guardo archivo
urlDATA <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(urlDATA, "./Data/HAR_Dataset.zip")

#DESCOMPRIMO ARCHIVO ZIP

## Define la ruta al archivo zip
ruta_zip <- "./Data/HAR_Dataset.zip"

## Carga la librería 'zip' para trabajar con archivos zip
if (!requireNamespace("zip", quietly = TRUE)) {
        install.packages("zip")
}
library(zip)

## Extrae el archivo del zip a la carpeta "Data"
ruta_unzip <- "./Data"
unzip(ruta_zip, exdir = ruta_unzip)
remove(list = ls())

#LECTURA DE DATOS

## Lee el archivo de X_train
X_train <- read.table("./Data/UCI HAR Dataset/train/X_train.txt")

## Imprime los primeros registros del archivo para verificar
head(X_train)

## Lee el archivo de features
varNames <- read.table("./Data/UCI HAR Dataset/features.txt")

## Asignar los nombres de variables al marco de datos X_train
varNames <- varNames[order(varNames$V1), ]
colnames(X_train) <- varNames$V2

## Lee el archivo de y_train
y_train <- read.table("./Data/UCI HAR Dataset/train/y_train.txt")

## Imprime los primeros registros del archivo para verificar
head(y_train)

## Lee el archivo de activity_labels
activity_labels <- read.table("./Data/UCI HAR Dataset/activity_labels.txt")

## Imprime los primeros registros del archivo para verificar
head(activity_labels)

##Agrega variabe con etiquetas de actividad al archivo y_train
y_train <- merge(y_train, activity_labels, by.x = "V1", by.y = "V1", all = TRUE)

## Renombro las variables del archivo y_train
library(dplyr)
y_train <- rename(y_train, codActivity=V1, labActivity=V2)
head(y_train)

## Lee el archivo de subject_train
subject_train <- read.table("./Data/UCI HAR Dataset/train/subject_train.txt")

##Renombro la variable V1 de subject_train.
subject_train <- rename(subject_train, subject=V1)

## Imprime los primeros registros del archivo para verificar
head(subject_train)
table(subject_train)

#Combino los archivos "X_train" e "y_train"
xy_train <- cbind(X_train, y_train)

#Agrego la variable subjet a xy_train
xy_train <- cbind(xy_train, subject_train)

## Lee el archivo de total_acc_x_train
total_acc_x_train <- read.table("./Data/UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt")
