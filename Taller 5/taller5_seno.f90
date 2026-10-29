! Taller 5: calculo de la integral de sin(x) en [0, pi/2)
! mediante los metodos de valor medio y de acierto y error.
! Objetivo: comparar las estimaciones y la dispersion de ambos metodos.
! Archivo de salida: seno.dat, con media y desviacion estandar de cada metodo.

program taller5_seno
  implicit none

  ! Define la precision doble que se utilizara en los calculos reales.
  integer, parameter :: dp = kind(1.0d0)

  ! N es el numero de muestras utilizadas en cada estimacion.
  ! R es el numero de repeticiones independientes del experimento.
  integer, parameter :: N = 1000, R = 1000

  ! Define los limites de integracion.
  ! a = 0 y b = pi/2, calculado como 2*atan(1).
  ! H = 1 es la altura del rectangulo utilizado en acierto y error.
  real(dp), parameter :: a = 0.0_dp, b = 2.0_dp*atan(1.0_dp), H = 1.0_dp

  ! Variables enteras para controlar las repeticiones y las muestras.
  ! n_bajo cuenta los puntos ubicados debajo de la curva seno.
  ! n_sem almacena el tamano requerido para la semilla del generador.
  ! u_dat identifica el archivo de salida.
  integer :: rep, i, n_bajo, n_sem, u_dat

  ! Arreglo que almacena la semilla utilizada para inicializar
  ! el generador de numeros pseudoaleatorios.
  integer, allocatable :: semilla(:)

  ! Variables para los numeros aleatorios y las coordenadas de los puntos.
  ! suma_f acumula los valores de sin(x) en el metodo de valor medio.
  ! I_vm e I_ae almacenan las estimaciones de cada metodo en una repeticion.
  real(dp) :: u, v, x, y, suma_f, I_vm, I_ae

  ! Acumuladores de las estimaciones y sus cuadrados para ambos metodos.
  ! Se usan para calcular las medias y desviaciones estandar al final.
  real(dp) :: s_vm, s2_vm, s_ae, s2_ae
  real(dp) :: media_vm, desv_vm, media_ae, desv_ae

  ! Consulta el tamano necesario para el arreglo de la semilla.
  ! Este tamano puede depender de la implementacion de Fortran.
  call random_seed(size=n_sem)

  ! Reserva memoria para almacenar la semilla completa.
  allocate(semilla(n_sem))

  ! Establece una semilla fija para que la secuencia pseudoaleatoria
  ! pueda reproducirse con la misma implementacion y condiciones.
  semilla = 314
  call random_seed(put=semilla)

  ! Inicializa en cero los acumuladores de ambos metodos.
  ! Esto permite sumar las estimaciones de las R repeticiones
  ! sin incluir valores residuales de calculos anteriores.
  s_vm = 0.0_dp
  s2_vm = 0.0_dp
  s_ae = 0.0_dp
  s2_ae = 0.0_dp

  ! Repite el experimento R veces para estudiar la dispersion
  ! estadistica de las estimaciones obtenidas por cada metodo.
  do rep = 1, R

     ! B1: metodo de valor medio.
     ! Reinicia la suma de los valores de la funcion seno
     ! antes de comenzar una nueva estimacion.
     suma_f = 0.0_dp

     ! Genera N puntos aleatorios en el intervalo [a,b).
     do i = 1, N

        ! Genera un numero aleatorio u entre 0 y 1.
        call random_number(u)

        ! Transforma u para obtener un punto x dentro del intervalo.
        x = a + (b - a)*u

        ! Evalua sin(x) y acumula el resultado para calcular su promedio.
        suma_f = suma_f + sin(x)

     end do

     ! Calcula la integral aproximada multiplicando el promedio
     ! de los valores de sin(x) por la longitud del intervalo.
     I_vm = (b - a) * (suma_f / real(N, dp))

     ! B2: metodo de acierto y error.
     ! Reinicia el contador de puntos situados debajo de la curva.
     n_bajo = 0

     ! Genera N puntos aleatorios dentro del rectangulo
     ! [a,b) x [0,H), que contiene la region bajo la curva seno.
     do i = 1, N

        ! Genera dos numeros aleatorios para construir las coordenadas.
        call random_number(u)
        call random_number(v)

        ! Calcula la coordenada horizontal x dentro del intervalo [a,b).
        x = a + (b - a)*u

        ! Calcula la coordenada vertical y dentro del intervalo [0,H).
        y = H*v

        ! Si y es menor que sin(x), el punto queda debajo de la curva.
        ! En ese caso, se incrementa el contador de aciertos.
        if (y < sin(x)) n_bajo = n_bajo + 1

     end do

     ! Estima la integral como el area del rectangulo multiplicada
     ! por la proporcion de puntos que quedaron debajo de la curva.
     I_ae = (b - a) * H * (real(n_bajo, dp) / real(N, dp))

     ! B3: acumula las estimaciones de valor medio y acierto y error.
     ! Tambien acumula sus cuadrados para calcular la desviacion estandar.
     s_vm = s_vm + I_vm
     s2_vm = s2_vm + I_vm**2

     s_ae = s_ae + I_ae
     s2_ae = s2_ae + I_ae**2

  end do

  ! B4: calcula la media de las R estimaciones de cada metodo.
  ! La media resume el valor central obtenido en las repeticiones.
  media_vm = s_vm / real(R, dp)
  media_ae = s_ae / real(R, dp)

  ! Calcula la desviacion estandar muestral del metodo de valor medio.
  ! El factor R/(R-1) aplica la correccion muestral de Bessel.
  ! La desviacion estandar mide cuanto varian las estimaciones entre repeticiones.
  desv_vm = sqrt(real(R, dp)/real(R - 1, dp) * &
           (s2_vm/real(R, dp) - media_vm**2))

  ! Calcula la desviacion estandar muestral del metodo de acierto y error,
  ! utilizando las estimaciones acumuladas durante las R repeticiones.
  desv_ae = sqrt(real(R, dp)/real(R - 1, dp) * &
           (s2_ae/real(R, dp) - media_ae**2))

  ! Crea o reemplaza el archivo de salida para guardar las cuatro estadisticas.
  ! status='replace' evita conservar resultados de una ejecucion anterior.
  open(newunit=u_dat, file='seno.dat', status='replace')

  ! Escribe cuatro valores reales en notacion cientifica, sin encabezado:
  ! media del valor medio, desviacion del valor medio,
  ! media de acierto y error y desviacion de acierto y error.
  ! Este formato facilita la lectura automatica desde Python.
  write(u_dat,'(4es25.16e3)') media_vm, desv_vm, media_ae, desv_ae

  ! Cierra el archivo para finalizar correctamente la escritura de resultados.
  close(u_dat)

  ! Muestra en pantalla la media y la desviacion estandar de cada metodo.
  ! Esto permite comparar directamente sus resultados.
  print '(a,2f10.5)', 'Valor medio (media, desviacion): ', media_vm, desv_vm
  print '(a,2f10.5)', 'Acierto y error (media, desviacion): ', media_ae, desv_ae

end program taller5_seno
