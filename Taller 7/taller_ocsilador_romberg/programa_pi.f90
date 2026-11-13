! ============================================================
! Programa: programa_pi   (Taller 7, Parte D)
! Proposito: calcular pi = integral de 0 a 1 de 4/(1+x^2) dx con el
!            MISMO modulo de Romberg de la Parte B, sin modificarlo.
! Salida:    resultado_pi.dat (k_final, evaluaciones, valor, error)
! ============================================================
program programa_pi
  use modulo_romberg, only: dp, pi, romberg
  implicit none

  real(dp), parameter :: a   = 0.0_dp
  real(dp), parameter :: b   = 1.0_dp
  real(dp), parameter :: tol = 1.0e-5_dp    ! tolerancia de la Parte D
  integer,  parameter :: kmax   = 15
  integer,  parameter :: opcion = 2         ! integrando 2: 4/(1+x^2)

  real(dp), allocatable :: S(:,:)
  real(dp) :: valor, err
  integer  :: k_final, evaluaciones

  call romberg(a, b, tol, kmax, opcion, S, k_final, evaluaciones)

  valor = S(k_final, k_final)
  err   = abs(valor - pi)                    ! error |S(k,k) - pi|

  print '(a,i3)',     'k_final      = ', k_final
  print '(a,i6)',     'evaluaciones = ', evaluaciones
  print '(a,f18.10)', 'pi (Romberg) = ', valor
  print '(a,es12.4)', 'error        = ', err

  open(30, file='resultado_pi.dat', status='replace')
  write(30, '(i3,1x,i5,1x,f18.10,1x,es12.4)') k_final, evaluaciones, valor, err
  close(30)

  deallocate(S)
end program programa_pi
