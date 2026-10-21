\# Física Computacional (106018C) — Taller 4

\## Números aleatorios y difusión



\*\*Estudiante:\*\* Angie Katherine Nazate Cuaspa  

\*\*Lenguaje:\*\* Python  

\*\*Fecha de entrega:\*\* 19 de octubre de 2026



\## 1. Objetivo



Estudiar el movimiento aleatorio mediante simulaciones computacionales, analizar la relación entre el desplazamiento cuadrático medio y el tiempo, comparar la calidad de diferentes generadores de números aleatorios y aplicar el modelo de difusión a un caso físico.



\## 2. Fundamento teórico



En una caminata aleatoria unidimensional, cada partícula realiza pasos hacia la derecha o hacia la izquierda. Para pasos independientes y equiprobables, el desplazamiento medio tiende a cero, mientras que el desplazamiento cuadrático medio crece aproximadamente de forma lineal con el tiempo:



\\\[

\\langle x^2\\rangle \\approx 2Dt.

\\]



Aquí, \\(D\\) es el coeficiente de difusión. Si la pendiente del ajuste lineal de \\(\\langle x^2\\rangle\\) frente al tiempo es \\(m\\), entonces:



\\\[

D=\\frac{m}{2}.

\\]



Para pasos de longitud \\(a\\) y duración \\(\\Delta t\\), el valor teórico es:



\\\[

D\_{\\mathrm{teo}}=\\frac{a^2}{2\\Delta t}.

\\]



El error relativo porcentual se calcula mediante:



\\\[

E\_r=

\\frac{|D\_{\\mathrm{est}}-D\_{\\mathrm{teo}}|}

{D\_{\\mathrm{teo}}}\\times100\\%.

\\]



\## 3. Desarrollo del taller



\### Punto C. Simulación de caminatas aleatorias y difusión



Se simularon caminatas aleatorias independientes para estudiar el crecimiento del desplazamiento cuadrático medio. Se compararon resultados con diferentes cantidades de caminatas para observar cómo mejora la estimación estadística al aumentar el número de realizaciones.



Parámetros y resultados principales:



\- Longitud del paso: \\(a=1\\).

\- Duración del paso: \\(\\Delta t=1\\).

\- Número de pasos: \\(N=200\\).

\- Para \\(K=100\\), se obtuvo una pendiente de \\(m=1.33523\\), con \\(D\_{\\mathrm{est}}=0.66761\\) y una diferencia relativa del \\(33.52\\%\\) respecto a \\(D\_{\\mathrm{teo}}=0.5\\).

\- Para \\(K=2000\\), se obtuvo \\(m=1.03839\\), con \\(D\_{\\mathrm{est}}=0.51919\\) y una diferencia relativa del \\(3.84\\%\\).



Los resultados muestran que el promedio de un mayor número de caminatas permite obtener una estimación más cercana al valor teórico en esta simulación.



\### Punto D. Calidad de los generadores aleatorios



Se compararon tres generadores utilizando \\(K=2000\\) caminatas, \\(N=200\\) pasos y una semilla fija para el generador `random.Random`.



| Generador | \\(D\_{\\mathrm{est}}\\) | \\(D\_{\\mathrm{teo}}\\) | Error relativo |

|---|---:|---:|---:|

| `random.Random` (Mersenne Twister) | 0.5192 | 0.5000 | 3.84 % |

| LCG tipo `drand48` | 0.4855 | 0.5000 | 2.90 % |

| LCG deficiente | 0.0862 | 0.5000 | 82.76 % |



El generador LCG deficiente utilizó los parámetros \\(a=57\\), \\(c=1\\), \\(m=256\\) y semilla \\(10\\). Su caminata presentó un comportamiento periódico, con retornos a la posición cero en los pasos 0, 256, 512, 768 y 1024.



La comparación evidencia que un generador con propiedades estadísticas deficientes puede distorsionar la simulación y producir estimaciones poco confiables del coeficiente de difusión.



\### Punto E. Aplicación física: difusión del oxígeno



Se aplicó el modelo de caminata aleatoria a un caso de difusión del oxígeno en agua, utilizando:



\- Coeficiente de difusión de referencia: \\(D\_{\\mathrm{O\_2}}=2\\times10^{-9}\\ \\mathrm{m^2/s}\\).

\- Duración física del paso: \\(\\Delta t=10^{-6}\\ \\mathrm{s}\\).

\- Pendiente de la simulación: \\(m=1.03839\\).



La longitud física del paso se calculó mediante:



\\\[

a\_{\\mathrm{fisico}}=\\sqrt{2D\_{\\mathrm{O\_2}}\\Delta t}

\\approx 6.3246\\times10^{-8}\\ \\mathrm{m}.

\\]



Esto equivale aproximadamente a \\(63.2\\ \\mathrm{nm}\\).



Con la pendiente obtenida, el coeficiente de difusión simulado fue:



\\\[

D\_{\\mathrm{sim}}=

\\frac{m\\,a\_{\\mathrm{fisico}}^2}{2\\Delta t}

\\approx 2.077\\times10^{-9}\\ \\mathrm{m^2/s}.

\\]



El error relativo respecto al valor de referencia fue aproximadamente del \*\*3.85 %\*\*.



Los tiempos característicos estimados mediante \\(t=L^2/(2D\_{\\mathrm{O\_2}})\\) fueron:



| Distancia \\(L\\) | Tiempo característico |

|---|---:|

| \\(10\\ \\mu\\mathrm{m}\\) | 0.025 s |

| \\(1\\ \\mathrm{mm}\\) | 250 s (4.17 min) |

| \\(1\\ \\mathrm{cm}\\) | 25 000 s (6.94 h) |

| \\(1\\ \\mathrm{m}\\) | 250 000 000 s (7.92 años) |



Para una distancia de \\(1\\ \\mathrm{cm}\\), el número estimado de pasos físicos es \\(2.5\\times10^{10}\\).



Estos tiempos son escalas características de difusión, no garantías de que todas las partículas alcancen una distancia específica. En sistemas grandes, como lagos, la advección y la turbulencia también pueden ser determinantes en el transporte de sustancias.



\## 4. Verificación



La batería de pruebas automáticas del notebook obtuvo \*\*17 de 17 pruebas PASS\*\*.



Se verificaron, entre otros aspectos:



\- La regla de movimiento y la posición inicial.

\- La reproducibilidad con una misma semilla.

\- La simetría estadística y el crecimiento del desplazamiento cuadrático medio.

\- El ajuste lineal y la conversión de su pendiente al coeficiente de difusión.

\- La consistencia de los archivos CSV.

\- La comparación de los generadores aleatorios.

\- Los cálculos de longitud física del paso y tiempos característicos.

\- La periodicidad de la caminata con el LCG deficiente.

\- La generación de la figura final.



\## 5. Conclusiones



La simulación permitió estudiar la difusión a partir de caminatas aleatorias y comprobar la relación aproximadamente lineal entre el desplazamiento cuadrático medio y el tiempo. Al aumentar el número de caminatas de 100 a 2000, la estimación del coeficiente de difusión se acercó al valor teórico.



La comparación de generadores mostró que el LCG deficiente produjo un error relativo considerable y un patrón periódico. Por ello, la calidad del generador aleatorio es importante para obtener resultados físicos confiables.



Finalmente, la aplicación al oxígeno mostró que la difusión molecular puede ser lenta a escalas macroscópicas. En sistemas naturales, otros mecanismos de transporte, como la turbulencia y la advección, también deben considerarse.



\## 6. Uso de herramientas de inteligencia artificial



Se utilizaron herramientas de inteligencia artificial como apoyo para revisar la organización del código, interpretar resultados numéricos, mejorar la documentación y estructurar el informe. Los resultados reportados se contrastaron con las salidas de la simulación y las pruebas automáticas del notebook.





\---



\*\*Curso:\*\* Física Computacional (106018C)  

\*\*Tema:\*\* Números aleatorios y difusión  

\*\*Lenguaje:\*\* Python



