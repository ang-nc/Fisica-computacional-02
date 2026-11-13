# Taller 7 — Energía disipada, derivadas numéricas y cálculo de π

**Asignatura:** Física Computacional (106018C)\
**Estudiante:** Angie Katherine Nazate Cuaspa\
**Fecha:** 10/11/2026

## Descripción

Este taller desarrolla métodos numéricos aplicados al estudio de un oscilador amortiguado. Se utilizan aproximaciones de derivadas numéricas, integración mediante el método de Romberg y el método de Monte Carlo para estimar el valor de π.

El objetivo es implementar y comparar diferentes métodos computacionales, analizar sus errores y verificar los resultados obtenidos.

## Contenido del proyecto

- `T7_Arreglos_int_deriv.ipynb`: notebook principal con los procedimientos, cálculos y verificaciones.
- `modulo_romberg.f90`: módulo en Fortran que implementa la función de energía.
- `programa_energia.f90`: programa principal que utiliza el módulo para realizar los cálculos.

## Desarrollo

### 1. Energía disipada en un oscilador amortiguado

Se estudia el movimiento descrito por:

[\
x(t)=e^{-\gamma t}\cos(\omega t)\
]

Se calcula la energía disipada mediante integración numérica con el método de Romberg y se compara con la diferencia entre la energía inicial y final.

**Resultados:**

| Magnitud                     |              Resultado |
| ---------------------------- | ---------------------: |
| Energía disipada por Romberg |     18.9940046974 J/kg |
| Diferencia de energía        |     18.9940046969 J/kg |
| Diferencia absoluta          | (4.5347\times10^{-10}) |
| Iteración final              |                      8 |
| Evaluaciones                 |                    257 |

### 2. Aproximación de derivadas numéricas

Se implementan diferentes métodos para aproximar derivadas:

- Diferencia hacia adelante.
- Diferencia hacia atrás.
- Diferencia central.
- Fórmula de cinco puntos.

Se comparan los resultados con las derivadas analíticas para evaluar la precisión de cada aproximación.

### 3. Cálculo de π

Se estima el valor de π mediante dos procedimientos:

- **Método de Romberg:** integración numérica.
- **Método de Monte Carlo:** aproximación estadística mediante números aleatorios.

**Resultados:**

| Método              | Aproximación de π |
| ------------------- | ----------------: |
| Romberg             |      3.1415926653 |
| Monte Carlo         |        3.14102400 |
| Valor de referencia |      3.1415926536 |

## Tecnologías utilizadas

- Python.
- Fortran.
- Google Colab / Jupyter Notebook.
- Métodos de integración y diferenciación numérica.

## Ejecución

### Python

1. Abrir el archivo `T7_Arreglos_int_deriv(2).ipynb` en Google Colab o Jupyter Notebook.
2. Ejecutar las celdas en orden.
3. Revisar las aproximaciones, tablas y verificaciones obtenidas.

### Fortran

Los archivos `.f90` contienen el módulo y el programa principal.

Con el compilador GNU Fortran (`gfortran`), se pueden compilar desde la terminal con:

```bash
gfortran -c modulo_romberg.f90
gfortran programa_energia.f90 modulo_romberg.o -o programa_energia
./programa_energia
```

## Conclusiones

El desarrollo del taller permitió aplicar métodos numéricos para estudiar un oscilador amortiguado, aproximar derivadas y calcular integrales. La comparación entre los resultados numéricos y las expresiones de referencia permitió evaluar la precisión de los métodos implementados.

El método de Romberg obtuvo una aproximación precisa tanto para la energía disipada como para el cálculo de π. Por otra parte, el método de Monte Carlo permitió observar el comportamiento de una aproximación estadística y su dependencia del número de muestras.

## Autor

**Angie Katherine Nazate Cuaspa**\
Física Computacional — Universidad del Valle
