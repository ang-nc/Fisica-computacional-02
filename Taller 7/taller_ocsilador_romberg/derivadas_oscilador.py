# ============================================================
# Programa: derivadas_oscilador.py
# Proposito: estimar velocidad y aceleracion con diferencias
# finitas, compararlas con las derivadas exactas y guardar
# los datos, errores maximos y la grafica solicitada.
# ============================================================
import numpy as np
import matplotlib.pyplot as plt

# Parametros fisicos del oscilador.
G = 0.5                 # amortiguamiento [1/s]
W = 2*np.pi             # frecuencia angular [rad/s]

# Soluciones exactas: sirven como referencia para medir errores.
def x_ex(t):
    """Posicion exacta del oscilador."""
    return np.exp(-G*t)*np.cos(W*t)

def v_ex(t):
    """Primera derivada exacta de x(t)."""
    return -np.exp(-G*t)*(G*np.cos(W*t) + W*np.sin(W*t))

def a_ex(t):
    """Segunda derivada exacta de x(t)."""
    return np.exp(-G*t)*((G*G - W*W)*np.cos(W*t)
                         + 2*G*W*np.sin(W*t))

def calcular_derivadas(dt):
    # Malla uniforme de 0 a 3 s; se incluyen los dos extremos.
    t = np.arange(0, 3 + dt/2, dt)
    x = x_ex(t)

    # Diferencia adelantada: se asocia a los puntos izquierdos t[:-1].
    v_adel = (x[1:] - x[:-1])/dt

    # Diferencia atrasada: usa los mismos pares consecutivos,
    # pero se asocia a los puntos derechos t[1:]. Por eso se
    # compara con v_ex(t[1:]) al calcular el error.
    v_atras = (x[1:] - x[:-1])/dt

    # Diferencia central de primera derivada: solo en puntos interiores.
    v_cent = (x[2:] - x[:-2])/(2*dt)

    # Formula de cinco puntos, de orden 4. Requiere dos vecinos
    # a cada lado, por lo que se evalua de t[2] a t[-3].
    v_cinco = (-x[4:] + 8*x[3:-1] - 8*x[1:-3] + x[:-4])/(12*dt)

    # Segunda derivada central, de orden 2, en puntos interiores.
    a_cent = (x[2:] - 2*x[1:-1] + x[:-2])/(dt**2)

    return t, x, v_adel, v_atras, v_cent, v_cinco, a_cent

# Parte 1: calcular los arreglos para el paso principal dt=0.01 s.
dt = 0.01
t, x, v_adel, v_atras, v_cent, v_cinco, a_cent = calcular_derivadas(dt)

# Las formulas centrales se definen en los puntos interiores.
# Con 301 puntos totales, quedan 299 puntos validos.
interiores_t = t[1:-1]
interiores_x = x[1:-1]

# Guarda las cuatro columnas requeridas: t, x, v central y a central.
np.savetxt('derivadas_oscilador.dat',
           np.column_stack((interiores_t, interiores_x, v_cent, a_cent)),
           header='t_s x_m v_central_m_s a_central_m_s2', comments='# ')

# Parte 2: comparar las derivadas numericas con las exactas.
# Las curvas exactas abarcan toda la malla; las centrales no incluyen
# los extremos porque alli no hay puntos a ambos lados.
plt.figure(figsize=(10, 6))
plt.plot(t, v_ex(t), label='v exacta', color='#162A54')
plt.plot(interiores_t, v_cent, '--', label='v numerica central',
         color='#C9972C')
plt.plot(t, a_ex(t), label='a exacta', color='#B02A20')
plt.plot(interiores_t, a_cent, ':', label='a numerica central',
         color='#2E7D32')
plt.xlabel('Tiempo [s]')
plt.ylabel('Amplitud')
plt.title('Velocidad y aceleracion del oscilador amortiguado')
plt.legend()
plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.savefig('derivadas_oscilador.png', dpi=110)
plt.close()

# Parte 3: errores maximos para dt=0.01 y dt=0.005 s.
errores_filas = []
for dt in [0.01, 0.005]:
    t_d, x_d, vd_adel, vd_atras, vd_cent, vd_cinco, ad_cent = (
        calcular_derivadas(dt)
    )

    # Cada aproximacion se compara con la derivada exacta en
    # exactamente los puntos donde esa formula esta definida.
    err_adel = np.max(np.abs(vd_adel - v_ex(t_d[:-1])))
    err_atras = np.max(np.abs(vd_atras - v_ex(t_d[1:])))
    err_cent = np.max(np.abs(vd_cent - v_ex(t_d[1:-1])))
    err_cinco = np.max(np.abs(vd_cinco - v_ex(t_d[2:-2])))
    err_a_cent = np.max(np.abs(ad_cent - a_ex(t_d[1:-1])))

    # Se guarda dt seguido de los cinco errores maximos solicitados.
    errores_filas.append([dt, err_adel, err_atras, err_cent,
                          err_cinco, err_a_cent])

# Archivo con dos filas (un paso por fila) y seis columnas.
np.savetxt('errores_derivadas.dat', np.array(errores_filas),
           header='dt err_adelantada err_atrasada err_central '
                  'err_cinco_puntos err_aceleracion_central',
           comments='# ')
