! ============================================================
! Modulo: modulo_romberg
! Proposito:
!   - Define los dos integrandos del Taller 7:
!       opcion = 1 -> energia disipada, f(t) = 2*gam*v(t)^2   (Parte B)
!       opcion = 2 -> pi,               f(x) = 4/(1 + x^2)    (Parte D)
!   - Implementa la integracion de Romberg: trapecio compuesto
!     refinado sin repetir evaluaciones (seccion 3.4) mas la
!     extrapolacion de Richardson.
!   - Cuenta cada evaluacion real del integrando.
! El modulo se usa SIN cambios en programa_energia (Parte B) y en
! programa_pi (Parte D).
! ============================================================
module modulo_romberg
  implicit none

  ! Doble precision para todos los reales.
  integer, parameter :: dp = kind(1.0d0)

  ! Valor de pi en doble precision.
  real(dp), parameter :: pi = 4.0_dp*atan(1.0_dp)

  ! Parametros del oscilador x(t) = exp(-gam*t)*cos(omega*t).
  ! (Se evita el nombre "gamma" porque es una funcion intrinseca.)
  real(dp), parameter :: gam   = 0.5_dp          ! amortiguamiento [1/s]
  real(dp), parameter :: omega = 2.0_dp*pi       ! frecuencia angular [rad/s]

  ! Contador del modulo: aumenta en 1 cada vez que se llama a f.
  integer :: n_eval = 0

contains

  ! ------------------------------------------------------------
  ! posicion: x(t) = exp(-gam*t)*cos(omega*t)
  ! Entrada: t, tiempo [s].  Salida: posicion [m].
  ! ------------------------------------------------------------
  real(dp) function posicion(t)
    real(dp), intent(in) :: t
    posicion = exp(-gam*t)*cos(omega*t)
  end function posicion

  ! ------------------------------------------------------------
  ! velocidad: v(t) = -exp(-gam*t)*(gam*cos(omega*t) + omega*sin(omega*t))
  ! Entrada: t, tiempo [s].  Salida: velocidad [m/s].
  ! ------------------------------------------------------------
  real(dp) function velocidad(t)
    real(dp), intent(in) :: t
    velocidad = -exp(-gam*t)*(gam*cos(omega*t) + omega*sin(omega*t))
  end function velocidad

  ! ------------------------------------------------------------
  ! energia: energia mecanica por unidad de masa [J/kg]
  !   E(t) = 1/2*v(t)^2 + 1/2*(omega^2 + gam^2)*x(t)^2
  ! Entrada: t, tiempo [s].  Salida: E(t).
  ! ------------------------------------------------------------
  real(dp) function energia(t)
    real(dp), intent(in) :: t
    energia = 0.5_dp*velocidad(t)**2 &
            + 0.5_dp*(omega**2 + gam**2)*posicion(t)**2
  end function energia

  ! ------------------------------------------------------------
  ! f: integrando elegido con el argumento entero "opcion".
  !   opcion = 1: potencia disipada 2*gam*v(t)^2   (x es el tiempo t)
  !   opcion = 2: 4/(1 + x^2)                      (integral = pi)
  ! Cada llamada suma 1 al contador n_eval.
  ! ------------------------------------------------------------
  real(dp) function f(x, opcion)
    real(dp), intent(in) :: x
    integer,  intent(in) :: opcion

    ! La evaluacion se cuenta aqui, dentro del integrando, para que
    ! ninguna llamada quede sin contar.
    n_eval = n_eval + 1

    select case (opcion)
    case (1)
       f = 2.0_dp*gam*velocidad(x)**2
    case (2)
       f = 4.0_dp/(1.0_dp + x**2)
    case default
       error stop 'f: opcion de integrando no definida (use 1 o 2)'
    end select
  end function f

  ! ------------------------------------------------------------
  ! romberg: tabla de Romberg por trapecio recursivo + Richardson
  !          (sigue el pseudocodigo marco del taller).
  ! Entradas:
  !   a, b      limites de integracion
  !   tol       tolerancia para |S(k,k) - S(k-1,k-1)|
  !   kmax      nivel maximo de refinamiento (kmax <= 30)
  !   opcion    integrando que se usa en f
  ! Salidas:
  !   S             tabla triangular, con indices desde 0 en las 2 dimensiones
  !   k_final       nivel donde se cumplio la tolerancia (o kmax si no se cumplio)
  !   evaluaciones  numero total de evaluaciones de f (debe ser 2**k_final + 1)
  ! ------------------------------------------------------------
  subroutine romberg(a, b, tol, kmax, opcion, S, k_final, evaluaciones)
    real(dp), intent(in)               :: a, b, tol
    integer,  intent(in)               :: kmax, opcion
    real(dp), allocatable, intent(out) :: S(:,:)
    integer,  intent(out)              :: k_final, evaluaciones

    real(dp) :: h, suma
    integer  :: k, j, i
    logical  :: convergio

    ! 2**(k-1) es un entero: se limita kmax para evitar desbordamiento.
    if (kmax < 1 .or. kmax > 30) error stop 'romberg: kmax debe estar en 1..30'

    ! Tabla con indices 0..kmax en ambas dimensiones (seccion 3.4).
    allocate(S(0:kmax, 0:kmax))
    S = 0.0_dp

    ! Cada integracion empieza con el contador en cero.
    n_eval = 0
    convergio = .false.

    ! Nivel 0: un solo trapecio con los dos extremos. (2 evaluaciones)
    h = b - a                                      ! Delta x
    S(0,0) = 0.5_dp*h*(f(a, opcion) + f(b, opcion))

    do k = 1, kmax
       h = h/2.0_dp                                ! h_k = Delta x / 2**k

       ! Espacio 1 del pseudocodigo: solo los puntos medios NUEVOS,
       ! a + (2i-1)*h con i = 1..2**(k-1). Los puntos del nivel
       ! anterior ya se evaluaron y no se repiten.
       suma = 0.0_dp
       do i = 1, 2**(k-1)
          suma = suma + f(a + real(2*i - 1, dp)*h, opcion)
       end do

       ! Espacio 3: trapecio refinado a partir del nivel anterior.
       S(k,0) = 0.5_dp*S(k-1,0) + h*suma

       ! Richardson: la columna j elimina el termino de error h^(2j).
       do j = 1, k
          S(k,j) = (4.0_dp**j*S(k,j-1) - S(k-1,j-1)) / (4.0_dp**j - 1.0_dp)
       end do

       ! Criterio de parada sobre la diagonal.
       if (abs(S(k,k) - S(k-1,k-1)) < tol) then
          k_final = k
          convergio = .true.
          exit
       end if
    end do

    ! Si el ciclo termino sin cumplir la tolerancia, se avisa y se
    ! devuelve el ultimo nivel calculado.
    if (.not. convergio) then
       k_final = kmax
       print '(a)', 'Aviso: no se alcanzo la tolerancia con kmax niveles.'
    end if

    ! Espacio 2: el total de evaluaciones lo lleva el contador de f.
    evaluaciones = n_eval
  end subroutine romberg

end module modulo_romberg
