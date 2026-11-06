! Taller 6 -- Programa principal: escribe nucleos.dat, valle.dat y maximo.dat
! Usa el módulo modulo_nucleo. No usa arreglos (se estudian en el Capítulo 3).
program programa_nucleo
  use modulo_nucleo, only: dp, termino_volumen, termino_superficie, termino_coulomb, &
       termino_asimetria, energia_enlace, masa_atomica, z_estable
  implicit none
  integer  :: a, z_mejor, z_global, a_global, unidad
  real(dp) :: eb_mejor, eb_global

  ! --- nucleos.dat: los ocho núclidos, en el orden del enunciado ---
  open(newunit=unidad, file='nucleos.dat', status='replace', action='write')
  call escribir_fila(unidad, 94, 244)    ! Pu-244
  call escribir_fila(unidad, 32,  70)    ! Ge-70
  call escribir_fila(unidad, 72, 179)    ! Hf-179
  call escribir_fila(unidad, 18,  38)    ! Ar-38
  call escribir_fila(unidad, 26,  56)    ! Fe-56
  call escribir_fila(unidad, 20,  40)    ! Ca-40
  call escribir_fila(unidad, 92, 235)    ! U-235
  call escribir_fila(unidad, 92, 238)    ! U-238
  close(unidad)

  ! --- valle.dat: Z de máximo enlace para A = 4, ..., 260, y mínimo global ---
  open(newunit=unidad, file='valle.dat', status='replace', action='write')
  eb_global = huge(1.0_dp)
  z_global  = 1
  a_global  = 4
  do a = 4, 260
    call z_estable(a, z_mejor, eb_mejor)
    write(unidad, '(i0,1x,i0,1x,es24.16)') a, z_mejor, eb_mejor
    if (eb_mejor < eb_global) then       ! más negativo que el mínimo global guardado
      eb_global = eb_mejor
      z_global  = z_mejor
      a_global  = a
    end if
  end do
  close(unidad)

  ! --- maximo.dat: el núcleo más ligado de toda la curva ---
  open(newunit=unidad, file='maximo.dat', status='replace', action='write')
  write(unidad, '(i0,1x,i0,1x,es24.16)') a_global, z_global, eb_global
  close(unidad)

contains

  ! ------------------------------------------------------------------
  ! escribir_fila: escribe una fila de nucleos.dat: Z, A, los cuatro términos, E_B y M
  !   Entradas: u (unidad del archivo abierto), nz (protones), na (nucleones)
  !   Salida:   una línea escrita en el archivo
  ! ------------------------------------------------------------------
  subroutine escribir_fila(u, nz, na)
    integer, intent(in) :: u, nz, na
    write(u, '(2(i0,1x),6(es24.16,1x))') nz, na, &
         termino_volumen(nz, na), termino_superficie(nz, na), &
         termino_coulomb(nz, na), termino_asimetria(nz, na), &
         energia_enlace(nz, na), masa_atomica(nz, na)
  end subroutine escribir_fila

end program programa_nucleo
