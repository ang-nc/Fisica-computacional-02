\documentclass[11pt]{article}

\usepackage[a4paper,margin=2cm]{geometry}
\usepackage[spanish]{babel}
\usepackage[utf8]{inputenc}
\usepackage{amsmath,amssymb}
\usepackage{booktabs}

\pagestyle{empty}
\setlength{\parindent}{0pt}
\setlength{\parskip}{4pt}

% ---------- Datos del taller: editar aquí ----------
\newcommand{\curso}{Física Computacional (106018C)}
\newcommand{\taller}{Taller [N.º] --- [1]}
\newcommand{\semana}{Semana [N.º 4]}
\newcommand{\lenguaje}{[Fortran]}
\newcommand{\estudiante}{[Angie Katherine Nazate Cuaspa 202422480]}
\newcommand{\fechaentrega}{[19/09/2025]}
% -----------------------------------------------------

\begin{document}

\begin{center}
{\large\bfseries \curso} \\[2pt]
{\bfseries \taller} \\[2pt]
\semana\ \quad --- \quad Lenguaje: \lenguaje \\[2pt]
\estudiante\ \quad --- \quad \fechaentrega
\end{center}

\vspace{4pt}
\hrule
\vspace{6pt}

% ---------------- 1. Contexto físico ----------------
\textbf{1. Contexto físico.} [Se estudió el movimiento de un proyectil lanzado con una velocidad inicial y un ángulo determinados, con el objetivo de calcular la altura máxima alcanzada. Este cálculo permite analizar una característica importante del movimiento parabólico mediante herramientas computacionales.]

% ---------------- 2. Método / Algoritmo ----------------
\textbf{2. Método.} 
[Se utilizó la ecuación de la altura máxima del movimiento parabólico. El programa recibe la velocidad inicial y el ángulo de lanzamiento, convierte el ángulo de grados a radianes y calcula la altura máxima.
]

% Ejemplo: \int_a^b f(x)\,dx \approx \frac{h}{2}\sum_{i=0}^{n-1}\left[f(x_i)+f(x_{i+1})\right]
[\begin{equation*}
h_{\max}=\frac{v_0^2\sin^2(\theta)}{2g}
\end{equation*}]

% ---------------- 3. Resultado numérico ----------------

\textbf{3. Resultado.} 
Se realizaron tres casos de prueba y se compararon los resultados obtenidos por el programa con los valores de referencia. \begin{center} \begin{tabular}{lccc} \toprule Caso & Valor obtenido (m) & Valor de referencia (m) & Error relativo \\ \midrule 1: 90° & 4.9000010 & 4.9000 & 0.00002\% \\ 2: 45° & 10.2040806 & 10.2041 & 0.00019\% \\ 3: 30° & 5.1020477 & 5.1020 & 0.00094\% \\ \bottomrule \end{tabular} \end{center} \textbf{Verificación (PASS/FAIL):} 3 de 3 casos de la celda de verificación pasaron.

% ---------------- 4. Obstáculo / decisión de implementación ----------------
\textbf{4. Obstáculo o decisión de implementación.} 
[Un aspecto importante de la implementación fue realizar correctamente
la conversión del ángulo de grados a radianes, ya que las funciones
trigonométricas utilizadas en Fortran trabajan con radianes. Además,
se realizaron casos de prueba para comprobar que los resultados
obtenidos coincidieran con los valores de referencia.]

% ---------------- 5. Conclusión ----------------
\textbf{5. Conclusión.} [Se aprendió a implementar una expresión física en Fortran y a verificar numéricamente los resultados mediante casos de prueba. La comparación con los valores de referencia mostró que el programa calcula correctamente la altura máxima para los casos evaluados.]

% ---------------- 6. Uso de herramientas de IA ----------------
\textbf{6. Uso de herramientas de IA.}
[Se utilizó DeepSeek como herramienta de apoyo para comprender la implementación del problema en Fortran, revisar errores y organizar la estructura del reporte. La ejecución, compilación y verificación de los resultados se realizaron mediante el código desarrollado y probado en Google Colab.]

\vspace{4pt}
\hrule
\vspace{4pt}
{\small Código fuente: ver archivo adjunto \texttt{[proyectil.f90]}.}

\end{document}