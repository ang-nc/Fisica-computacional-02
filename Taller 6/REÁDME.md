# Taller 6 — Funciones, variables globales y locales, y módulos

**Curso:** Física Computacional (106018C) — 106018C\
**Estudiante:** Angie Katherine Nazate Cuaspa\
**Semana:** 7\
**Lenguajes:** Fortran 2008 y Python

## 1. Descripción

En este taller se estudia la organización modular de programas mediante funciones, subrutinas y módulos en Fortran, y funciones y módulos en Python.

Se aplica la fórmula semiempírica de masa nuclear para calcular la energía de enlace por nucleón, encontrar el núcleo más ligado para diferentes números másicos y comparar los resultados del modelo con datos experimentales.

También se construye una gráfica de la energía de enlace por nucleón en función del número másico.

## 2. Objetivos

- Implementar funciones y subrutinas que reciban argumentos y devuelvan resultados.
- Organizar constantes y procedimientos mediante módulos.
- Diferenciar variables locales y globales.
- Utilizar `intent(in)` e `intent(out)` en Fortran.
- Calcular los cuatro términos de la fórmula semiempírica.
- Encontrar el núcleo con mayor energía de enlace por nucleón.
- Leer, analizar y representar datos mediante Python.

## 3. Estructura de archivos

```text
Taller_6/
│
├── README.md
├── T06_Funciones.ipynb
├── Reporte_Taller_6.tex
│
└── taller_nucleo_atomico/
    ├── modulo_nucleo.f90
    ├── programa_nucleo.f90
    ├── analisis_nucleo.py
    ├── nucleos.dat
    ├── valle.dat
    ├── maximo.dat
    ├── maximo_python.dat
    └── curva_enlace.png
```

## 4. Descripción de los archivos

| Archivo                        | Descripción                                                                      |
| ------------------------------ | -------------------------------------------------------------------------------- |
| `T06_Funciones_resuelto.ipynb` | Notebook con los ejercicios, explicaciones, pseudocódigo y verificaciones.       |
| `modulo_nucleo.f90`            | Contiene las constantes y funciones del modelo nuclear.                          |
| `programa_nucleo.f90`          | Programa principal que calcula las energías y genera los archivos de resultados. |
| `analisis_nucleo.py`           | Contiene las funciones para leer, analizar y graficar los resultados.            |
| `nucleos.dat`                  | Almacena los resultados de ocho núcleos seleccionados.                           |
| `valle.dat`                    | Contiene la curva de máximo enlace para A entre 4 y 260.                         |
| `maximo.dat`                   | Almacena el núcleo más ligado encontrado en Fortran.                             |
| `maximo_python.dat`            | Almacena el máximo encontrado mediante Python.                                   |
| `curva_enlace.png`             | Gráfica de la energía de enlace por nucleón y los datos experimentales.          |
| `Reporte_Taller_6.tex`         | Informe académico de una página.                                                 |

## 5. Modelo físico

Se utiliza la fórmula semiempírica de masa nuclear con cuatro contribuciones:

- Término de volumen.
- Término de superficie.
- Término de Coulomb.
- Término de asimetría.

La energía de enlace por nucleón se calcula mediante:

[\
E_B=E\_{\mathrm{vol}}+E\_{\mathrm{sup}}\
+E\_{\mathrm{Coul}}+E\_{\mathrm{asim}}\
]

Se utiliza la convención de signo:

[\
B/A=-E_B\
]

Por tanto, un núcleo más ligado corresponde a un valor más negativo de (E_B).

## 6. Ejecución

### Requisitos

- Python 3.
- Fortran 2008.
- Compilador GNU Fortran (`gfortran`).
- Bibliotecas Python: NumPy y Matplotlib.

### Compilación de Fortran

Desde la carpeta principal del taller, ejecutar:

```bash
cd taller_nucleo_atomico

gfortran -Wall -Wextra modulo_nucleo.f90 programa_nucleo.f90 -o nucleo

./nucleo
```

Este procedimiento genera los archivos:

- `nucleos.dat`
- `valle.dat`
- `maximo.dat`

### Análisis con Python

Se recomienda abrir `T06_Funciones_resuelto.ipynb` en Google Colab y ejecutar todas las celdas en orden.

La parte de Python importa el módulo `analisis_nucleo.py`, lee los datos de `valle.dat`, encuentra el núcleo más ligado, genera `maximo_python.dat` y construye la gráfica `curva_enlace.png`.

## 7. Resultados principales

El modelo encuentra su máximo enlace por nucleón en:

[\
A=65,\qquad Z=29\
]

Con una energía de enlace por nucleón de:

[\
E_B=-8.69506906\ \text{MeV/nucleón}\
]

La comparación con los valores experimentales permite observar las diferencias entre el modelo semiempírico y los datos de referencia.

También se analiza la influencia del término de apareamiento para el caso de (A=56), y se calcula la energía liberada en una fisión simétrica idealizada del uranio-236.

## 8. Verificación

El notebook incluye cuatro pruebas de verificación:

1. Comprobación de los resultados de los ocho núcleos.
2. Verificación de la búsqueda del máximo enlace para cada número másico.
3. Comprobación de las energías calculadas y del caso U-238.
4. Comparación de los máximos obtenidos en Fortran y Python, y verificación de la gráfica.

**Resultado esperado: 4/4 PASS.**

Las verificaciones comprueban los resultados numéricos y la coherencia de los archivos generados.

## 9. Conclusión

El desarrollo del taller permitió aplicar la programación modular a un problema de física nuclear, separando los cálculos de las funciones, la organización de los datos y su representación gráfica.

Se utilizaron Fortran y Python de manera complementaria para calcular, verificar y analizar los resultados del modelo semiempírico de masa nuclear.
