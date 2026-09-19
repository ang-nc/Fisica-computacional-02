Física Computacional (106018C)

Taller 1 — Semana 4 — Lenguaje: Fortran

Angie Katherine Nazate Cuaspa 202422480 — 19/09/2025

1\. Contexto físico

Se estudió el movimiento de un proyectil lanzado con una velocidad inicial y un ángulo determinados, con el objetivo de calcular la altura máxima alcanzada. Este cálculo permite analizar una característica importante del movimiento parabólico mediante herramientas computacionales.

2\. Método

Se utilizó la ecuación de la altura máxima del movimiento parabólico. El programa recibe la velocidad inicial y el ángulo de lanzamiento, convierte el ángulo de grados a radianes y calcula la altura máxima.hmax​=2gv02​sin2(θ)​3. Resultado

Se realizaron tres casos de prueba y se compararon los resultados obtenidos por el programa con los valores de referencia.CasoValor obtenido (m)Valor de referencia (m)Error relativo1: 90°4.90000104.90000.00002%2: 45°10.204080610.20410.00019%3: 30°5.10204775.10200.00094%Verificación (PASS/FAIL): 3 de 3 casos pasaron.

4\. Obstáculo o decisión de implementación

Un aspecto importante fue realizar correctamente la conversión del ángulo de grados a radianes, ya que las funciones trigonométricas en Fortran trabajan con radianes. Además, se realizaron casos de prueba para comprobar que los resultados coincidieran con los valores de referencia.

5\. Conclusión

Se aprendió a implementar una expresión física en Fortran y a verificar numéricamente los resultados mediante casos de prueba. La comparación con los valores de referencia mostró que el programa calcula correctamente la altura máxima.

6\. Uso de herramientas de IA

Se utilizó DeepSeek como apoyo para comprender la implementación en Fortran, revisar errores y organizar la estructura del reporte. La ejecución y verificación se realizaron en Google Colab.

Código fuente: ver archivo proyectil.f90

