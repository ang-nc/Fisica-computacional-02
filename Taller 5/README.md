# Física Computacional (106018C) — Taller 5: Integración por Monte Carlo

Este README documenta tres programas independientes en Fortran 2008 para estudiar métodos de Monte Carlo: la estimación de π por acierto y error, la integración de sin(x) con dos métodos probabilísticos y la estimación de π con un generador congruencial lineal (LCG). Las verificaciones de los resultados se hacen en Python, dentro del notebook.

## Contenido de la entrega

| Archivo                                                    | Descripción                                                                 |
| ---------------------------------------------------------- | --------------------------------------------------------------------------- |
| `taller5_pi.f90`                                           | Parte A: convergencia de la estimación de π                                 |
| `taller5_seno.f90`                                         | Parte B: integral de sin(x) por valor medio y por acierto y error           |
| `taller5_lcg.f90`                                          | Parte C: estimación de π con el LCG (57, 1, 256)                            |
| `convergencia.dat`, `pendiente.dat`, `seno.dat`, `lcg.dat` | Salidas de los programas                                                    |
| `convergencia_pi.png`                                      | Gráfica de convergencia con la pendiente ajustada                           |
| `T5MonteCarlo.ipynb`                                       | Notebook con el código, las verificaciones en Python y el resumen PASS/FAIL |
| FISICA_COMPUTACIONAL_TALLER_5                              | Reporte de una página                                                       |

## Requisitos

- Compilador Fortran compatible con Fortran 2008 (gfortran).
- Python 3.x con NumPy y Matplotlib.

Instalación de dependencias:

```bash
pip install numpy matplotlib
```

## Cómo reproducir los resultados

1. Abrir `T5MonteCarlo.ipynb` en Google Colab.
2. Ejecutar **Entorno de ejecución → Reiniciar y ejecutar todo**. Las celdas `%writefile` crean los archivos `.f90`, las celdas de compilación generan los ejecutables y los archivos `.dat`, y las celdas de Python hacen las verificaciones.
3. La celda final de verificación debe mostrar **5/5 PASS**.

Compilación manual de cualquier programa:

```bash
gfortran -std=f2008 -O2 -fcheck=all -o nombre_programa nombre_programa.f90
./nombre_programa
```

## Parte A. Estimación de π (`taller5_pi.f90`)

Estima π por acierto y error: se generan puntos uniformes en el cuadrado [-1, 1) × [-1, 1) y se cuenta cuántos caen dentro del círculo unitario (x² + y² < 1).

La estimación se calcula mediante:

**π ≈ 4 × (número de aciertos / número total de puntos)**

Se usa el generador intrínseco `random_number`, con una semilla distinta para cada corrida.

### Qué hace al ejecutarse

- Para cada N = 10², 10³, ..., 10⁷ realiza 20 corridas independientes.
- Calcula la media y la desviación estándar muestral (s) de las 20 estimaciones y las guarda en `convergencia.dat` (columnas: N, media, desviación).
- Ajusta por mínimos cuadrados una recta a log₁₀(s) frente a log₁₀(N) y guarda la **pendiente** (un único número) en `pendiente.dat`.

### Resultados

- Con N = 10⁷: media = 3.14153 y s = 0.0004.
- Con N = 100: s ≈ 0.162, cercana a la predicción 1.642 / √N ≈ 0.164.
- Pendiente obtenida: **-0.5079**, cercana al valor teórico -0.5 (el error estadístico decrece como N⁻¹/²).

## Parte B. Integración de sin(x) (`taller5_seno.f90`)

Estima la integral de sin(x) entre 0 y π/2, cuyo valor exacto es 1.

Se utilizan dos métodos:

- **Valor medio:** calcula el promedio de sin(x) en puntos uniformes del intervalo [0, π/2).
- **Acierto y error:** genera puntos en el rectángulo [0, π/2) × [0, 1) y cuenta los que quedan bajo la curva.

### Qué hace al ejecutarse

- Usa N = 1000 puntos por estimación y R = 1000 repeticiones de cada método, con semilla fija para reproducibilidad.
- Calcula la media y la desviación estándar muestral de las R estimaciones de cada método.
- Guarda las cuatro cantidades (media y desviación de cada método) en `seno.dat`.

### Resultados

| Método          |   Media | Desviación entre corridas |
| --------------- | ------: | ------------------------: |
| Valor medio     | 0.99973 |                   0.01529 |
| Acierto y error | 1.00009 |                   0.02465 |

Ambos métodos dan valores cercanos a 1. El valor medio tiene menor dispersión porque promedia valores continuos de sin(x), mientras que el método de acierto y error promedia resultados que valen 0 o 1.

Los valores coinciden con los predichos: 0.483 / √N ≈ 0.0153 y 0.756 / √N ≈ 0.0239.

## Parte C. Estimación de π con un LCG (`taller5_lcg.f90`)

Repite la estimación de π por acierto y error, pero reemplazando `random_number` por un generador congruencial lineal (LCG).

El generador utiliza la siguiente relación:

**r(n+1) = (a × r(n) + c) módulo m**

Parámetros utilizados:

- Multiplicador: a = 57.
- Incremento: c = 1.
- Módulo: m = 256.
- Semilla inicial: r(0) = 10.

Cada punto usa dos números consecutivos del generador como coordenadas (x, y), normalizados al intervalo [-1, 1).

### Qué hace al ejecutarse

- Para cada N = 10², ..., 10⁷ reinicia la semilla en r(0) = 10, genera los puntos con el LCG y estima π.
- Guarda N y la estimación en `lcg.dat`.

### Resultados

La estimación se **estanca en 3.09375**, unas 0.048 unidades por debajo de π, y no mejora desde N ≈ 10⁴.

Con solo 256 estados, el generador produce como máximo 128 parejas (x, y) distintas que se repiten siempre en el mismo orden. Por eso, la fracción de aciertos queda fija: el error es **sistemático** y no disminuye al aumentar N, a diferencia de la fluctuación estadística de la Parte A.

## Notas

- Los tres programas están en Fortran 2008 y guardan sus resultados en archivos `.dat` sin encabezado; las verificaciones y la gráfica se hacen en Python.
- El resumen final del notebook (PASS/FAIL) comprueba los criterios de las tres partes y da 5/5 PASS.
- La calidad del generador de números pseudoaleatorios es determinante: un generador de período corto, como este LCG, produce estimaciones poco confiables aunque aumente N.
