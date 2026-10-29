! Taller 5 -- Estimación de pi mediante el método de acierto y error
! utilizando un generador congruencial lineal (LCG) con parámetros (57, 1, 256).
! Salida: lcg.dat, un archivo con dos columnas: número de puntos (N) y pi estimado.

program taller5_lcg
  implicit none

  ! Define la precisión numérica de tipo real de doble precisión.
  ! Se utiliza para realizar los cálculos con mayor precisión decimal.
  integer, parameter :: dp = kind(1.0d0)

  ! Define los parámetros del generador congruencial lineal (LCG):
  ! a_lcg es el multiplicador, c_lcg es el incremento y M_lcg es el módulo.
  ! Estos valores se utilizan para generar una secuencia de números pseudoaleatorios.
  integer, parameter :: a_lcg = 57, c_lcg = 1, M_lcg = 256

  ! Declara las variables enteras:
  ! k controla el exponente de N, r almacena el estado del generador
  ! y u_dat identifica la unidad asociada al archivo de salida.
  integer :: k, r, u_dat

  ! Utiliza enteros de 8 bytes para contar puntos y aciertos.
  ! Esto permite manejar cantidades grandes de puntos, hasta N = 10^7.
  integer(8) :: i, n_total, n_aciertos

  ! Declara las variables reales:
  ! x e y son las coordenadas de cada punto generado y pi_est
  ! almacena la estimación de pi obtenida mediante Monte Carlo.
  real(dp) :: x, y, pi_est

  ! Crea el archivo lcg.dat para guardar los resultados.
  ! Si el archivo ya existe, reemplaza su contenido anterior.
  open(newunit=u_dat,file='lcg.dat',status='replace')

  ! Recorre las cantidades de puntos N = 10^2, 10^3, ..., 10^7.
  ! Para cada cantidad se calcula una nueva estimación de pi.
  do k = 2, 7
     n_total = 10_8**k

     ! Inicializa el generador con la semilla 10 para cada valor de N.
     ! Esto hace que la secuencia comience desde el mismo estado
     ! en cada iteración del ciclo externo.
     r = 10

     ! Asigna un valor provisional a pi_est antes de realizar el cálculo.
     pi_est = -1.0_dp

     ! Inicializa en cero el contador de puntos que caen dentro del círculo.
     ! Se reinicia para que cada estimación utilice únicamente sus propios aciertos.
     n_aciertos = 0

     ! Genera n_total puntos y comprueba si cada punto está dentro
     ! del círculo unitario inscrito en el cuadrado [-1,1] x [-1,1].
     do i = 1, n_total

        ! Actualiza el estado del generador mediante la fórmula:
        ! r_nuevo = (a_lcg*r_anterior + c_lcg) módulo M_lcg.
        ! El resultado se utiliza para generar la primera coordenada del punto.
        r = mod(a_lcg*r + c_lcg, M_lcg)

        ! Convierte el entero generado en una coordenada real dentro
        ! del intervalo [-1,1), mediante una transformación lineal.
        x = 2.0_dp*real(r, dp)/real(M_lcg, dp) - 1.0_dp

        ! Actualiza nuevamente el estado del generador para obtener
        ! el segundo número del par, que se utilizará como coordenada y.
        r = mod(a_lcg*r + c_lcg, M_lcg)

        ! Transforma el segundo número generado al intervalo [-1,1).
        y = 2.0_dp*real(r, dp)/real(M_lcg, dp) - 1.0_dp

        ! Comprueba si el punto (x,y) está dentro del círculo unitario.
        ! La ecuación x^2 + y^2 < 1 identifica los puntos interiores.
        ! Si se cumple la condición, aumenta el contador de aciertos en uno.
        if (x*x + y*y < 1.0_dp) n_aciertos = n_aciertos + 1
     end do

     ! Estima pi usando la proporción de puntos dentro del círculo.
     ! Como el círculo unitario ocupa una fracción pi/4 del área del cuadrado,
     ! se multiplica por cuatro la proporción de aciertos.
     pi_est = 4.0_dp*real(n_aciertos, dp)/real(n_total, dp)

     ! Escribe en lcg.dat el número total de puntos y la estimación de pi.
     ! El formato guarda N como entero y pi_est en notación científica,
     ! sin encabezados, para facilitar su lectura posterior con Python.
     write(u_dat,'(i10,es25.16e3)') n_total,pi_est

     ! Muestra en pantalla el número de puntos y la estimación de pi
     ! con seis cifras decimales para revisar los resultados de cada corrida.
     print '(i10,f12.6)', n_total,pi_est
  end do

  ! Cierra el archivo después de guardar todos los resultados.
  close(u_dat)

end program taller5_lcg
