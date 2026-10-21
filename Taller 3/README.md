# Física Computacional (106018C) — Taller 3

## Ajuste lineal y péndulo simple

**Estudiante:** Angie Katherine Nazate Cuaspa  
**Semana:** 3  
**Lenguajes:** Fortran 2008 y Python  
**Fecha:** 30/09/2026

## 1. Objetivo

Analizar experimentalmente la relación entre la longitud de un péndulo simple y el cuadrado de su período de oscilación mediante un ajuste lineal por mínimos cuadrados, para estimar la aceleración de la gravedad.

## 2. Fundamento físico

Para pequeñas oscilaciones, el período de un péndulo simple se expresa como:

\[
T=2\pi\sqrt{\frac{L}{g}}
\]

Elevando al cuadrado:

\[
T^2=\frac{4\pi^2}{g}L
\]

Para realizar el ajuste lineal, se utiliza el modelo:

\[
T^2=aL+b
\]

donde \(L\) es la longitud en metros, \(T\) es el período en segundos, \(a\) es la pendiente y \(b\) es el intercepto. A partir de la pendiente se calcula la gravedad experimental:

\[
g=\frac{4\pi^2}{a}
\]

## 3. Desarrollo

El trabajo se realizó en las siguientes etapas:

1. **Limpieza de datos:** se procesaron los registros experimentales y se conservaron 87 mediciones para el análisis.
2. **Preparación de datos:** las longitudes se convirtieron de centímetros a metros y se calculó el período de cada medición a partir del tiempo medido y el número de oscilaciones.
3. **Ajuste lineal:** se implementó en Fortran 2008 el método de mínimos cuadrados para determinar la pendiente, el intercepto y el coeficiente de determinación.
4. **Cálculo de la gravedad:** se utilizó la pendiente del ajuste para estimar la aceleración experimental de la gravedad.
5. **Visualización:** se utilizó Python para representar los datos experimentales, la recta ajustada y los residuos.
6. **Verificación:** se ejecutaron pruebas automáticas para comprobar los archivos generados y la consistencia de los resultados.

## 4. Resultados

El programa obtuvo los siguientes valores:

| Magnitud | Resultado |
|---|---:|
| Número de mediciones \(N\) | 87 |
| Pendiente \(a\) | 4.0494334936 s²/m |
| Intercepto \(b\) | −3.15977714 × 10⁻³ s² |
| Coeficiente de determinación \(R^2\) | 0.9997419807 |
| Gravedad experimental \(g\) | 9.7491211218 m/s² |
| Gravedad de referencia | 9.81 m/s² |
| Error relativo | 0.62 % |

El valor de \(R^2\) indica una alta correspondencia entre los datos experimentales y el modelo lineal. La gravedad experimental presenta un error relativo aproximado del 0.62 % respecto al valor de referencia.

## 5. Verificación del programa

Se realizaron pruebas automáticas para comprobar la existencia y estructura de los archivos, el número de mediciones y la consistencia de los parámetros calculados.

**Resultado: 11 de 11 pruebas PASS.**

Las verificaciones incluyeron los valores de \(N\), \(a\), \(b\), \(R^2\) y \(g\), además de una comprobación de la plausibilidad física de la gravedad obtenida.

## 6. Archivos del taller

| Archivo | Descripción |
|---|---|
| `README.md` | Documentación del taller. |
| `informe_limpieza.xlsx` | Archivo con el proceso de limpieza de los datos. |
| `pendulo_limpio.dat` | Datos experimentales limpios, sin encabezado y con cinco columnas numéricas. |
| `ajuste_pendulo.f90` | Código fuente del ajuste lineal desarrollado en Fortran 2008. |
| `resultados_ajuste.dat` | Archivo con los cinco resultados numéricos generados por el programa. |
| `printout_resultados.png` | Captura de la salida del programa en la que se muestran los resultados. |
| `ajuste_pendulo_y_residuos.png` | Gráfica del ajuste lineal y de los residuos. |
| `diagrama_flujo.png` | Diagrama de flujo del algoritmo. |

**Nota:** los nombres de los archivos de imagen deben coincidir con los nombres reales utilizados en el repositorio.

## 7. Herramientas utilizadas

- **Fortran 2008:** lectura y procesamiento de datos, ajuste por mínimos cuadrados, cálculo de la gravedad y generación de resultados.
- **Python:** visualización de los datos, la recta ajustada y los residuos.
- **Google Colab:** entorno de ejecución y verificación del desarrollo.

## 8. Conclusión

El ajuste lineal permitió estudiar la relación entre \(T^2\) y \(L\) para un péndulo simple y estimar la aceleración de la gravedad. Se obtuvo un valor de 9.7491211218 m/s², con un error relativo del 0.62 % respecto a la referencia teórica. Las pruebas automáticas finalizaron con 11 de 11 resultados PASS.

## 9. Uso de herramientas de IA

Se utilizó ChatGPT como herramienta de apoyo para comprender la implementación del código, revisar posibles errores y organizar la documentación. La ejecución del programa y la verificación de los resultados se realizaron mediante el código desarrollado en Fortran 2008.