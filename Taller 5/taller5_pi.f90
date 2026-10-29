! Taller 5: Convergencia del estimador de pi mediante el metodo de acierto y error.
! Objetivo: estudiar como cambia la estimacion de pi al aumentar el numero de puntos.
! Archivos de salida:
!   convergencia.dat: contiene N, la media y la desviacion estandar de cada N.
!   pendiente.dat: contiene la pendiente del ajuste lineal entre log10(desviacion) y log10(N).

program taller5_pi
  implicit none

  ! Define la precision numerica utilizada para los calculos reales.
  ! La precision doble ayuda a reducir los errores de redondeo.
  integer, parameter :: dp = kind(1.0d0)

  ! Numero de corridas independientes realizadas para cada tamano de muestra.
  integer, parameter :: M = 20

  ! Variables enteras para controlar los ciclos, las unidades de archivo
  ! y la cantidad de puntos utilizados en el ajuste lineal.
  integer :: k, j, n_sem, u_dat, n_puntos

  ! Contadores enteros de 8 bytes para manejar cantidades grandes de puntos.
  ! n_total es el numero de puntos y n_aciertos cuenta los puntos dentro del circulo.
  integer(8) :: i, n_total, n_aciertos

  ! Arreglo que almacena la semilla usada para inicializar el generador aleatorio.
  integer, allocatable :: semilla(:)

  ! Variables reales para generar coordenadas, calcular pi y obtener estadisticas.
  ! u y v son numeros aleatorios; x e y son coordenadas del cuadrado.
  ! pi_est es una estimacion de pi; suma y suma2 acumulan las estimaciones.
  real(dp) :: u, v, x, y, pi_est, suma, suma2, media, desv

  ! Variables para el ajuste lineal de log10(desv) frente a log10(N).
  ! X_k e Y_k son los datos transformados y las demas variables acumulan sumas.
  real(dp) :: X_k, Y_k, sx, sy, sxx, sxy, pendiente

  ! Consulta cuantos enteros necesita el generador para almacenar la semilla.
  call random_seed(size=n_sem)

  ! Reserva memoria para guardar todos los elementos de la semilla.
  allocate(semilla(n_sem))

  ! Inicializa en cero las sumas del ajuste por minimos cuadrados.
  ! n_puntos cuenta cuantos tamanos de muestra se analizaran.
  sx = 0.0_dp
  sy = 0.0_dp
  sxx = 0.0_dp
  sxy = 0.0_dp
  n_puntos = 0

  ! Crea o reemplaza el archivo donde se guardaran los resultados estadisticos.
  open(newunit=u_dat, file='convergencia.dat', status='replace')

  ! Recorre los tamanos de muestra N = 10^2, 10^3, ..., 10^7.
  ! Cada valor permite estudiar el efecto de aumentar el numero de puntos.
  do k = 2, 7
     n_total = 10_8**k

     ! Reinicia las sumas antes de comenzar las M corridas de este N.
     suma = 0.0_dp
     suma2 = 0.0_dp

     ! Realiza M estimaciones independientes para calcular su media y dispersion.
     do j = 1, M

        ! Asigna una semilla diferente a cada combinacion de k y j.
        ! Esto permite obtener secuencias distintas entre las corridas.
        semilla = 1000*k + j
        call random_seed(put=semilla)

        ! Valor provisional de la estimacion, que se reemplaza tras el calculo.
        pi_est = -1.0_dp

        ! A1: estimacion de pi mediante el metodo de acierto y error.
        ! Se generan puntos uniformes en el cuadrado [-1,1) x [-1,1).
        ! La proporcion de puntos dentro del circulo unitario aproxima pi/4.
        n_aciertos = 0

        ! Genera y evalua cada uno de los N puntos aleatorios.
        do i = 1, n_total

           ! Genera dos numeros aleatorios entre 0 y 1.
           call random_number(u)
           call random_number(v)

           ! Transforma los numeros para obtener coordenadas entre -1 y 1.
           x = 2.0_dp*u - 1.0_dp
           y = 2.0_dp*v - 1.0_dp

           ! Comprueba si el punto esta dentro del circulo unitario:
           ! x^2 + y^2 < 1. Si se cumple, aumenta el contador de aciertos.
           if (x*x + y*y < 1.0_dp) n_aciertos = n_aciertos + 1

        end do

        ! Calcula pi como cuatro veces la proporcion de puntos dentro del circulo.
        ! real(..., dp) convierte los contadores a reales de precision dp
        ! para realizar una division real y no una division entera.
        pi_est = 4.0_dp*real(n_aciertos, dp)/real(n_total, dp)

        ! A2: acumula las estimaciones y sus cuadrados.
        ! Estas sumas permiten calcular la media y la desviacion estandar muestral.
        suma  = suma  + pi_est
        suma2 = suma2 + pi_est**2

     end do

     ! Inicializa las variables estadisticas con valores provisionales.
     media = -1.0_dp
     desv = -1.0_dp

     ! A3: calcula la media de las M estimaciones de pi.
     media = suma/real(M, dp)

     ! Calcula la desviacion estandar muestral usando la suma de cuadrados.
     ! El factor M/(M-1) aplica la correccion muestral de Bessel.
     ! La desviacion mide la dispersion de las estimaciones entre corridas.
     desv = sqrt(real(M, dp)/real(M-1, dp) * &
            (suma2/real(M, dp) - media**2))

     ! Guarda N, la media y la desviacion en el archivo de resultados.
     ! El formato escribe un entero y dos numeros reales en notacion cientifica.
     write(u_dat,'(i10,2es25.16e3)') n_total, media, desv

     ! Muestra en pantalla los resultados de cada tamano de muestra.
     print '(i10,2f12.6)', n_total, media, desv

     ! A4: transforma los datos a escala logaritmica para estudiar la convergencia.
     ! Si la desviacion disminuye aproximadamente como N^m, la pendiente m
     ! puede estimarse mediante un ajuste lineal en escala logaritmica.
     X_k = log10(real(n_total, dp))
     Y_k = log10(desv)

     ! Acumula las sumas necesarias para calcular la pendiente por minimos cuadrados.
     sx  = sx  + X_k
     sy  = sy  + Y_k
     sxx = sxx + X_k*X_k
     sxy = sxy + X_k*Y_k

     ! Registra un nuevo punto para el ajuste lineal.
     n_puntos = n_puntos + 1

  end do

  ! Cierra el archivo una vez guardados todos los resultados.
  close(u_dat)

  ! Inicializa la pendiente con un valor provisional antes de calcularla.
  pendiente = -1.0_dp

  ! A5: calcula la pendiente del ajuste lineal por minimos cuadrados.
  ! Esta expresion utiliza las sumas acumuladas de X, Y, X^2 y X*Y.
  pendiente = (real(n_puntos, dp)*sxy - sx*sy) / &
              (real(n_puntos, dp)*sxx - sx*sx)

  ! Crea o reemplaza el archivo que contiene la pendiente obtenida.
  open(newunit=u_dat, file='pendiente.dat', status='replace')

  ! Guarda la pendiente en notacion cientifica y cierra el archivo.
  write(u_dat,'(es25.16e3)') pendiente
  close(u_dat)

  ! Presenta la pendiente en pantalla para facilitar su interpretacion.
  print '(a,f9.4)', 'Pendiente de log10(s) contra log10(N): ', pendiente

end program taller5_pi
