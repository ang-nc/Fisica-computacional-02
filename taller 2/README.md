# Física Computacional (106018C) — Taller 2

Este taller aborda dos aplicaciones de Python: el estudio de la precisión numérica mediante series de Taylor y el modelamiento del decaimiento radiactivo. Cada parte se desarrolla en un notebook independiente de Google Colab e incluye pruebas de verificación automática mediante los estados `PASS` y `FAIL`.

## Contenido

* [Parte A. Jugando con la precisión en Python](#parte-a-jugando-con-la-precisión-en-python)
* [Parte B. Decaimiento radiactivo](#parte-b-decaimiento-radiactivo-con-python)
* [Herramientas utilizadas](#herramientas-utilizadas)
* [Organización de los archivos](#organización-de-los-archivos)

\---

## Parte A. Jugando con la precisión en Python

**Notebook:** `A precisión en python.ipynb`

Esta parte estudia la aproximación de la función seno mediante su serie de Taylor y analiza la convergencia, el error numérico y el tiempo de ejecución de diferentes implementaciones.

### Funciones principales

|Función|Descripción|
|-|-|
|`suma\\\\\\\_seno(x, tol, max\\\\\\\_iter)`|Aproxima el seno mediante una serie de Taylor calculada recursivamente.|
|`suma\\\\\\\_seno\\\\\\\_reducida(x, tol, max\\\\\\\_iter)`|Reduce el argumento utilizando la periodicidad del seno antes de evaluar la serie.|
|`suma\\\\\\\_seno\\\\\\\_factorial(x, tol, max\\\\\\\_iter)`|Calcula directamente los términos mediante factoriales para comparar precisión y rendimiento.|

### Análisis realizados

* Tabla de convergencia para diferentes valores de `x`.
* Comparación de los resultados con `math.sin(x)`.
* Evaluación del error relativo y de la tolerancia numérica de `1e-8`.
* Análisis de la pérdida de precisión al evaluar la serie para `x = 100` sin reducción de periodicidad.
* Comparación de las implementaciones recursiva y factorial en precisión y tiempo de ejecución.
* Verificación de la función `suma\\\\\\\_seno\\\\\\\_reducida` mediante casos de prueba conocidos.

### Verificación PASS/FAIL

Se evaluaron tres casos de prueba para la función `suma\\\\\\\_seno\\\\\\\_reducida`.

|Valor de `x`|Estado|
|-:|-|
|`0.5`|PASS|
|`100.0`|PASS|
|`-237.0`|PASS|

**Resultado:** 3 de 3 pruebas aprobadas.

\---

## Parte B. Decaimiento radiactivo con Python

**Notebook:** `B\\\\\\\_decaimiento\\\\\\\_radiactivo\\\\\\\_con\\\\\\\_python.ipynb`

Se modela el decaimiento radiactivo de una muestra inicial de 10 000 núcleos, con una vida media de 5 años.

El modelo utilizado es:

$$
N(t) = N\_0 e^{-\\lambda t}
$$

donde la constante de decaimiento se calcula mediante:

$$
\\lambda = \\frac{\\ln(2)}{t\_{1/2}}
$$

### Función principal

|Función|Descripción|
|-|-|
|`N\\\\\\\_decaimiento(t, N0=10000, t\\\\\\\_half=5.0)`|Calcula la cantidad de núcleos restantes en función del tiempo, la cantidad inicial y la vida media.|

### Análisis realizados

* Cálculo de la constante de decaimiento.
* Generación de tiempos entre 0 y 30 años mediante `numpy.linspace()`.
* Cálculo vectorizado de la cantidad de núcleos utilizando NumPy.
* Representación gráfica con Matplotlib, incluyendo título, nombres de los ejes, unidades y cuadrícula.
* Identificación de una, dos y tres vidas medias.
* Cálculo de los tiempos necesarios para que permanezca el 50 %, el 25 % y el 10 % de la muestra inicial.
* Comparación de los resultados con los valores de referencia.

### Resultados principales

La constante de decaimiento obtenida es:

$$
\\lambda \\approx 0.138629\\ \\text{año}^{-1}
$$

Los tiempos calculados para las fracciones restantes son:

|Fracción restante|Tiempo aproximado|
|-:|-:|
|50 %|5.0000 años|
|25 %|10.0000 años|
|10 %|16.6096 años|

### Verificación PASS/FAIL

Se comprobó el funcionamiento de la función con tres casos conocidos.

|Tiempo|Fracción esperada|Estado|
|-:|-:|-|
|0 años|1.000|PASS|
|5 años|0.500|PASS|
|10 años|0.250|PASS|

**Resultado:** 3 de 3 pruebas aprobadas.

\---

## Herramientas utilizadas

* Python 3
* NumPy
* Matplotlib
* `math`
* `time`
* Google Colab

## Organización de los archivos

El taller está organizado en dos notebooks independientes:

|Archivo|Contenido|
|-|-|
|`A precisión en python.ipynb`|Serie de Taylor, convergencia, precisión numérica y comparación de implementaciones.|
|`B\\\\\\\_decaimiento\\\\\\\_radiactivo\\\\\\\_con\\\\\\\_python.ipynb`|Modelo de decaimiento radiactivo, cálculo de tiempos y visualización gráfica.|

Cada notebook contiene el desarrollo de su respectiva parte y una sección final de verificación automática `PASS/FAIL`.

## Conclusión

El taller permitió aplicar Python al análisis de la precisión numérica y al modelamiento de un fenómeno físico. En la Parte A se estudió la convergencia de la serie de Taylor del seno y la importancia de reducir el argumento para mejorar la precisión numérica. En la Parte B se implementó el modelo exponencial del decaimiento radiactivo y se representó gráficamente su evolución mediante operaciones vectorizadas.

Las seis pruebas reportadas fueron aprobadas: tres correspondientes a la Parte A y tres a la Parte B.



