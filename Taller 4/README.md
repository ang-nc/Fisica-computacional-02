# Física Computacional (106018C) — Taller 4
## Números aleatorios y difusión

**Estudiante:** Angie Katherine Nazate Cuaspa  
**Lenguaje:** Python  
**Fecha de entrega:** 19 de octubre de 2026

## 1. Objetivo

Estudiar las caminatas aleatorias, analizar la difusión mediante simulaciones computacionales, comparar la calidad de diferentes generadores de números aleatorios y aplicar el modelo a la difusión del oxígeno en agua.

## 2. Fundamento teórico

En una caminata aleatoria unidimensional, el desplazamiento cuadrático medio se relaciona aproximadamente con el tiempo mediante:

`<x^2> = 2 * D * t`

Donde:

- `D`: coeficiente de difusión.
- `t`: tiempo transcurrido.
- `<x^2>`: desplazamiento cuadrático medio.

Si la pendiente del ajuste lineal de `<x^2>` frente al tiempo es `m`, entonces:

`D = m / 2`

Para pasos de longitud `a` y duración `dt`, el coeficiente teórico es:

`D_teorico = a^2 / (2 * dt)`

El error relativo porcentual se calcula como:

`Error (%) = abs(D_estimado - D_teorico) / D_teorico * 100`

## 3. Desarrollo del taller

### Punto C. Simulación de caminatas aleatorias

Se simularon caminatas aleatorias independientes para estudiar el crecimiento del desplazamiento cuadrático medio y estimar el coeficiente de difusión mediante un ajuste lineal.

Parámetros principales:

- Longitud del paso: `a = 1`.
- Duración del paso: `dt = 1`.
- Número de pasos: `N = 200`.

Resultados:

| Caminatas (K) | Pendiente (m) | D estimado | D teórico | Error relativo |
|---:|---:|---:|---:|---:|
| 100 | 1.33523 | 0.66761 | 0.50000 | 33.52 % |
| 2000 | 1.03839 | 0.51919 | 0.50000 | 3.84 % |

Al aumentar el número de caminatas, la estimación obtenida se acercó al valor teórico de difusión.

### Punto D. Calidad de los generadores aleatorios

Se compararon tres generadores utilizando 2000 caminatas y 200 pasos.

| Generador | D estimado | D teórico | Error relativo |
|---|---:|---:|---:|
| `random.Random` (Mersenne Twister) | 0.5192 | 0.5000 | 3.84 % |
| LCG tipo `drand48` | 0.4855 | 0.5000 | 2.90 % |
| LCG deficiente | 0.0862 | 0.5000 | 82.76 % |

El LCG deficiente utilizó los parámetros `a = 57`, `c = 1`, `m = 256` y semilla `10`.

En la caminata larga, la posición regresó a cero en los pasos 0, 256, 512, 768 y 1024. Este comportamiento periódico muestra que un generador de baja calidad puede afectar los resultados de la simulación.

### Punto E. Aplicación física: difusión del oxígeno

Se utilizó como referencia un coeficiente de difusión del oxígeno en agua de `2e-9 m^2/s`, con un intervalo temporal físico de `1e-6 s`.

La longitud física del paso fue:

`a_fisico = sqrt(2 * D_O2 * dt_fisico)`

Resultado:

`a_fisico = 6.3246e-8 m = 63.2 nm`

Con la pendiente de la simulación, el coeficiente de difusión estimado fue:

`D_sim = 2.077e-9 m^2/s`

El error relativo respecto al valor de referencia fue aproximadamente del **3.85 %**.

#### Tiempos característicos de difusión

| Distancia | Tiempo estimado |
|---|---:|
| 10 micrómetros | 0.025 s |
| 1 mm | 250 s (4.17 min) |
| 1 cm | 25 000 s (6.94 h) |
| 1 m | 250 000 000 s (7.92 años) |

Para una distancia de 1 cm, el número estimado de pasos físicos es `2.5e10`.

Estos valores son tiempos característicos de difusión; no significan que todas las partículas recorran exactamente esa distancia en ese tiempo. En sistemas naturales grandes también influyen la advección y la turbulencia.

## 4. Verificación del código

La batería de pruebas automáticas obtuvo **17 de 17 pruebas PASS**.

Se verificaron:

- La regla de movimiento y la posición inicial.
- La reproducibilidad con una misma semilla.
- La simetría estadística.
- El crecimiento del desplazamiento cuadrático medio.
- El ajuste lineal y el cálculo del coeficiente de difusión.
- La consistencia de los archivos CSV.
- La comparación de los generadores aleatorios.
- Los cálculos físicos y los tiempos característicos.
- La periodicidad de la caminata con el LCG deficiente.
- La generación de las figuras.

## 5. Conclusiones

La simulación mostró que el desplazamiento cuadrático medio crece aproximadamente de forma lineal con el tiempo. Al aumentar el número de caminatas, la estimación del coeficiente de difusión se acercó al valor teórico.

La comparación evidenció que un generador aleatorio deficiente puede producir resultados poco confiables y patrones periódicos. Finalmente, la aplicación al oxígeno mostró que la difusión molecular puede ser lenta a escalas macroscópicas, donde también son importantes la advección y la turbulencia.

## 6. Uso de herramientas de inteligencia artificial

Se utilizaron herramientas de inteligencia artificial como apoyo para revisar el código, interpretar resultados, organizar la documentación y mejorar la presentación del informe. Los resultados se contrastaron con las salidas del programa y las pruebas automáticas.

---

**Curso:** Física Computacional (106018C)  
**Tema:** Números aleatorios y difusión  
**Lenguaje:** Python
