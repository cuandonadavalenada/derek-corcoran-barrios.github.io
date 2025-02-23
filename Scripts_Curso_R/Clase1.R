# Vector

data(uspop)

x = c(2,4,6,8)
y <- x + 8

# Dataframes

data("iris")

iris["Species"]
iris$Species

### filas,columnas
iris[1:50,c(1,5)] # Solo la primera especie


## Una tabla de contigencia

data("HairEyeColor")

## Dplyr

library(tidyverse)


## Group by y summarise
DF <- summarise(iris, Mean_Petal_Length = mean(Petal.Length), SD_Petal_Length = sd(Petal.Length))


Por_Especie <- group_by(iris, Species)
DF2 <- summarise(Por_Especie, Mean_Petal_Length = mean(Petal.Length), SD_Petal_Length = sd(Petal.Length))


## Agrupar por mas de una variable

data("mtcars")

DF3 <- group_by(mtcars, cyl, am)
DF3 <- summarise(DF3, MPG = mean(mpg))


## Mutate crea variables nuevas

DF4 <- mutate(mtcars, hp_wt_ratio = hp/wt)


#### Pipeline


abs(round(sqrt(log(4)),2))

DF <- iris %>% 
  mutate(Ratio_Petal_Sepal  = Petal.Length/Sepal.Length) %>% 
  group_by(Species) %>% 
  summarise(Mean_Ratio = mean(Ratio_Petal_Sepal), SD_Ratio = sd(Ratio_Petal_Sepal))

### Summarise_all

DF <- iris %>% 
  group_by(Species) %>% 
  summarise_all(.funs = list(Mean = mean, SD = sd, Median = median))


DF <- iris %>% 
  group_by(Species) %>% 
  summarise_at(.vars = c("Sepal.Length", "Sepal.Width"), .funs = list(Nombre_1 = mean, sd, median))

write_csv(DF, "Tabla.csv")


### Filter


DF <- mtcars %>% 
  dplyr::filter(cyl %in% c(6,8)) %>% 
  group_by(am) %>% 
  summarise(Consumo = mean(mpg)) 

df <- iris %>% 
  group_by(Species) %>% 
  summarise(Numero = n())


df <- iris %>% dplyr::filter(Petal.Length > 4.5) %>% 
  group_by(Species) %>% 
  summarise(Numero = n())

## Select

data(mpg)

mtcars_chico <- mpg %>% 
  dplyr::filter(class == "suv") %>% 
  dplyr::select(cty, hwy, cyl)

data("iris")
iris2 <- iris %>% dplyr::select(starts_with("Petal"), Species)


iris_con_NA <- iris

iris_con_NA[2,4] <- NA
iris_con_NA[3,2] <- NA
iris_con_NA[7,1] <- NA


Iris_Filtrado <- iris_con_NA %>% 
  dplyr::filter_at(vars(Sepal.Length:Petal.Length), ~!is.na(.x))



### Ejercicios
# 1 
#
#¿Que proporción de las comunas ha tenido en algun momento mas de 50 casos por cada 100.000 habitantes?

library(tidyverse)
## Leo la base de datos
Comunas_sobre_50 <- read_csv("https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto19/CasosActivosPorComuna_std.csv") %>% 
# Elimino los totales regionales
  dplyr::filter(Comuna != "Total", !str_detect(Comuna, "Desconocido")) %>% 
  # Cambio nombre de columna
  rename(Casos_activos = "Casos activos") %>% 
  # Genero columna de prevalencia
  mutate(Casos_por_100.000 = 100000*(Casos_activos/Poblacion)) %>% 
  # Filtro sobre 50
  dplyr::filter(Casos_por_100.000 > 50) %>% 
  # Agrupar por comuna
  group_by(Comuna) %>%
  # Cuantas veces aparece cada comuna
  summarise(n = n()) %>% 
  ## Lo ordenamos
  arrange(desc(n))

n_comunas_sobre_50 = nrow(Comunas_sobre_50)  


comunas_totales <- read_csv("https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto19/CasosActivosPorComuna_std.csv") %>% 
  dplyr::filter(Comuna != "Total", !str_detect(Comuna, "Desconocido")) %>% 
  group_by(Comuna) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))

n_comunas <- nrow(comunas_totales)

n_comunas <- read_csv("https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto19/CasosActivosPorComuna_std.csv") %>% 
  dplyr::filter(Comuna != "Total", !str_detect(Comuna, "Desconocido")) %>% 
  pull(Comuna) %>% unique() %>% 
  length()

Proporcion <- n_comunas_sobre_50/n_comunas



#3 Genera una tabla de cuales comunas han tenido sobre 50 casos por cada 100.000 habitantes y de esas comunas crea una variable que sea la prevalencia máxima de dicha comuna.

Prevalencia_max <- read_csv("https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto19/CasosActivosPorComuna_std.csv") %>% 
  dplyr::filter(Comuna != "Total") %>% 
  rename(Casos_activos = "Casos activos") %>% 
  mutate(Casos_por_100.000 = 100000*(Casos_activos/Poblacion)) %>% 
  dplyr::filter(Casos_por_100.000 > 50) %>% 
  # Agrupamos por comuna
  group_by(Comuna) %>% 
  # Filter cuando sea igual al maximo
  dplyr::filter(Casos_por_100.000 == max(Casos_por_100.000)) %>% 
  rename(Prevalencia_max = Casos_por_100.000) %>% 
  arrange(desc(Prevalencia_max))

#

Prevalencia_max_top_10 <- read_csv("https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto19/CasosActivosPorComuna_std.csv") %>% 
  dplyr::filter(Comuna != "Total") %>% 
  rename(Casos_activos = "Casos activos") %>% 
  mutate(Casos_por_100.000 = 100000*(Casos_activos/Poblacion)) %>% 
  dplyr::filter(Casos_por_100.000 > 50) %>% 
  group_by(Comuna) %>% 
  dplyr::filter(Casos_por_100.000 == max(Casos_por_100.000)) %>% 
  rename(Prevalencia_maxima = Casos_por_100.000) %>% 
  arrange(desc(Prevalencia_maxima))

Prevalencia_max_top_10 <- Prevalencia_max_top_10[1:10,] 


Prevalencia_max_top_10 <- read_csv("https://raw.githubusercontent.com/MinCiencia/Datos-COVID19/master/output/producto19/CasosActivosPorComuna_std.csv") %>% 
  dplyr::filter(Comuna != "Total") %>% 
  rename(Casos_activos = "Casos activos") %>% 
  mutate(Casos_por_100.000 = 100000*(Casos_activos/Poblacion)) %>% 
  dplyr::filter(Casos_por_100.000 > 50) %>% 
  group_by(Comuna) %>% 
  dplyr::filter(Casos_por_100.000 == max(Casos_por_100.000)) %>% 
  rename(Prevalencia_maxima = Casos_por_100.000) %>% 
  dplyr::top_n(Prevalencia_maxima, n = 10)
