**# Física Computacional (106018C) — Taller 2**



Este taller desarrolla ejercicios de precisión numérica y una aplicación de Python al modelamiento del decaimiento radiactivo. El código completo se encuentra en el notebook `colab.ipynb`.



**## Contenido**



**### Parte A. Jugando con la precisión en Python**



Se implementa la función `suma\_seno` utilizando la serie de Taylor de $\\sin(x)$ mediante una relación recursiva entre términos.



Se realizan los siguientes análisis:



\* Tabla de convergencia para diferentes valores de $x$.

\* Comparación del error relativo con la tolerancia $10^{-8}$.

\* Evaluación de la serie para $x=100$ sin reducción de periodicidad.

\* Comparación entre la implementación recursiva y una implementación ingenua que calcula cada término utilizando `math.factorial` y potencias.

\* Comparación del tiempo de ejecución y la precisión de ambas implementaciones.

\* Verificación de `suma\_seno\_reducida` mediante casos de prueba conocidos.



Para valores grandes de $x$, se observa una pérdida importante de precisión cuando no se utiliza reducción de periodicidad.



**### Parte B. Decaimiento radiactivo**



Se modela el decaimiento de una muestra de $N\_0=10000$ núcleos con una vida media de $5$ años mediante



$$

N(t)=N\_0e^{-\\lambda t},

\\qquad

\\lambda=\\frac{\\ln 2}{t\_{1/2}}.

$$



Se utiliza NumPy para:



\* Calcular la constante de decaimiento.

\* Generar tiempos entre 0 y 30 años mediante `numpy.linspace()`.

\* Calcular $N(t)$ de forma vectorizada.

\* Representar gráficamente el decaimiento utilizando Matplotlib.

\* Identificar una, dos y tres vidas medias.

\* Calcular aproximadamente los tiempos correspondientes al 50 %, 25 % y 10 % de la cantidad inicial.

\* Comparar los resultados obtenidos con valores de referencia.



**### Parte C. Verificación PASS/FAIL**



Al final del notebook se incluye una sección de verificación con casos de prueba conocidos para las Partes A y B.



Los resultados se presentan mediante los estados:



**```text**

**PASS**

**FAIL**

**```**



La verificación permite comprobar que las funciones implementadas producen resultados dentro de las tolerancias establecidas.



**## Herramientas utilizadas**



\* Python 3

\* NumPy

\* Matplotlib

\* `math`

\* `time`

\* Google Colab



**## Archivo principal**



El desarrollo completo del taller se encuentra en:



`colab.ipynb`



\## Resultados principales



Para el modelo de decaimiento radiactivo se obtuvo:



$$

\\lambda = 0.138629\\ {\\rm año}^{-1}.

$$



La cantidad de núcleos se reduce a:



\* 50 % en 5 años.

\* 25 % en 10 años.

\* 10 % aproximadamente en 16.61 años.



Los casos de verificación implementados en el notebook fueron superados con resultado `PASS`.



