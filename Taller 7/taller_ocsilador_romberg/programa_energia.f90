! ============================================================
! Programa: programa_energia   (Taller 7, Parte B)
! Proposito:
!   1. Integra la potencia disipada 2*gam*v(t)^2 en [0, 3] s con
!      Romberg (tol = 1e-6, criterio de la diagonal).
!   2. Calcula la perdida de energia E(0) - E(T) con las formulas
!      de x y v, y la compara con la integral.
!   3. Escribe tabla_energia.dat y resultado_energia.dat.
! ============================================================
program programa_energia
  use modulo_romberg, only: dp, romberg, energia
  implicit none

  ! Datos del problema (Actividad 3).
  real(dp), parameter :: a   = 0.0_dp       ! t inicial [s]
  real(dp), parameter :: b   = 3.0_dp       ! T [s]
  real(dp), parameter :: tol = 1.0e-6_dp    ! tolerancia de la diagonal
  integer,  parameter :: kmax   = 15        ! nivel maximo de refinamiento
  integer,  parameter :: opcion = 1         ! integrando 1: 2*gam*v^2

  real(dp), allocatable :: S(:,:)           ! tabla de Romberg, indices desde 0
  real(dp) :: e_ini, e_fin, e_ref, e_dis, dif
  integer  :: k_final, evaluaciones, k, j

  ! --- Actividad 3: energia disipada por Romberg, contando evaluaciones.
  call romberg(a, b, tol, kmax, opcion, S, k_final, evaluaciones)
  e_dis = S(k_final, k_final)

  ! --- Actividad 4: E(0) - E(T) con las formulas exactas de x y v.
  e_ini = energia(a)
  e_fin = energia(b)
  e_ref = e_ini - e_fin
  dif   = abs(e_dis - e_ref)

  ! --- Resumen en pantalla.
  print '(a,i3)',      'k_final               = ', k_final
  print '(a,i6)',      'evaluaciones          = ', evaluaciones
  print '(a,f18.10)',  'E_dis (Romberg)       = ', e_dis
  print '(a,f18.10)',  'E(0) - E(T)           = ', e_ref
  print '(a,es12.4)',  '|E_dis - (E(0)-E(T))| = ', dif

  ! --- Actividad 5: tabla_energia.dat.
  ! Fila k: S(k,0), ..., S(k,k). Solo se escribe la parte triangular.
  open(10, file='tabla_energia.dat', status='replace')
  do k = 0, k_final
     write(10, '(*(f18.10,1x))') (S(k,j), j = 0, k)
  end do
  close(10)

  ! --- Actividad 5: resultado_energia.dat (una linea).
  ! Columnas: k_final, evaluaciones, E_dis, E(0)-E(T), diferencia.
  open(20, file='resultado_energia.dat', status='replace')
  write(20, '(i3,1x,i5,1x,f18.10,1x,f18.10,1x,es12.4)') &
        k_final, evaluaciones, e_dis, e_ref, dif
  close(20)

  deallocate(S)
end program programa_energia
