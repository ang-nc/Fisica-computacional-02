"""Taller 6 -- Funciones para leer y analizar la curva de máximo enlace."""
import matplotlib.pyplot as plt

def leer_valle(archivo="taller_nucleo_atomico/valle.dat"):
    """Lee la curva de máximo enlace.

    Entrada: ruta de valle.dat, con columnas A, Z y E_B [MeV].
    Salida: tres listas (A, Z, E_B) con los datos del archivo.
    """
    datos = []
    with open(archivo, "r", encoding="utf-8") as f:
        for linea in f:
            if linea.strip():
                columnas = linea.split()
                datos.append((int(float(columnas[0])),
                              int(float(columnas[1])),
                              float(columnas[2])))
    A = [fila[0] for fila in datos]
    Z = [fila[1] for fila in datos]
    energia = [fila[2] for fila in datos]
    return A, Z, energia


def encontrar_maximo(A, Z, energia):
    """Encuentra el núcleo más ligado por nucleón mediante un ciclo.

    Entrada: listas A, Z y E_B [MeV] de la curva.
    Salida: tupla (A, Z, E_B) correspondiente al menor E_B.
    """
    if len(A) == 0:
        raise ValueError("La curva no contiene datos.")
    mejor = 0
    for i in range(1, len(energia)):
        if energia[i] < energia[mejor]:
            mejor = i
    return A[mejor], Z[mejor], energia[mejor]


def escribir_maximo(nucleo, archivo="taller_nucleo_atomico/maximo_python.dat"):
    """Escribe el núcleo más ligado con el formato de maximo.dat.

    Entrada: tupla (A, Z, E_B) y ruta de salida.
    Salida: archivo de una fila con A, Z y E_B.
    """
    A, Z, energia = nucleo
    with open(archivo, "w", encoding="utf-8") as f:
        f.write(f"{A:d} {Z:d} {energia:.16E}\n")


def graficar_curva(A, energia, experimentales,
                   archivo="taller_nucleo_atomico/curva_enlace.png"):
    """Grafica B/A=-E_B y los datos experimentales.

    Entrada: listas A y E_B del modelo, lista de tuplas experimentales
    (símbolo, Z, A, B/A) y ruta de la imagen.
    Salida: archivo PNG con la curva y los puntos experimentales.
    """
    A_exp = [dato[2] for dato in experimentales]
    BA_exp = [dato[3] for dato in experimentales]
    etiquetas = [dato[0] for dato in experimentales]

    plt.figure(figsize=(10, 6))
    plt.plot(A, [-e for e in energia], label="Modelo: máximo enlace", linewidth=2)
    plt.scatter(A_exp, BA_exp, marker="o", label="Datos experimentales", zorder=3)
    # Desplazamientos (en puntos) para que no se encimen las etiquetas de puntos cercanos
    desplazamientos = {"Fe-56": (-32, 6), "Ni-62": (6, -14),
                       "U-235": (-34, 6), "U-238": (4, -14)}
    for x, y, etiqueta in zip(A_exp, BA_exp, etiquetas):
        plt.annotate(etiqueta, (x, y), xytext=desplazamientos.get(etiqueta, (4, 5)),
                     textcoords="offset points", fontsize=8)
    plt.title("Energía de enlace por nucleón")
    plt.xlabel("Número de nucleones, A")
    plt.ylabel("B/A = -E_B (MeV)")
    plt.grid(True, alpha=0.3)
    plt.legend()
    plt.tight_layout()
    plt.savefig(archivo, dpi=200)
    plt.close()
