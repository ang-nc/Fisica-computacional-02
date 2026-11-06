! Taller 6 -- Módulo del modelo de la gota líquida (fórmula semiempírica de masa)
! Contiene las constantes del modelo, los cuatro términos de la energía de enlace
! por nucleón, E_B, la masa atómica y la búsqueda del Z de máximo enlace.
module modulo_nucleo
  implicit none
  integer, parameter :: dp = kind(1.0d0)

  ! Constantes del modelo [MeV] (Zubairi y Weber, problema 7.2)
  real(dp), parameter :: a_V = 15.8_dp, a_S = 18.3_dp, a_C = 0.71_dp, a_A = 92.7_dp
  real(dp), parameter :: M_n = 939.57_dp, M_H = 938.78_dp

contains

  ! ------------------------------------------------------------------
  ! termino_volumen: término de volumen de E_B por nucleón
  !   Entradas: z (protones), a (nucleones)  -- z y a no se usan: el término es constante,
  !             pero se conserva la misma lista de argumentos que los otros tres términos
  !   Salida:   -a_V [MeV]
  ! ------------------------------------------------------------------
  real(dp) function termino_volumen(z, a)
    integer, intent(in) :: z, a
    termino_volumen = -a_V
  end function termino_volumen

  ! ------------------------------------------------------------------
  ! termino_superficie: término de superficie, a_S * A**(-1/3)
  !   Entradas: z (protones, no se usa), a (nucleones)
  !   Salida:   término de superficie [MeV]
  ! ------------------------------------------------------------------
  real(dp) function termino_superficie(z, a)
    integer, intent(in) :: z, a
    termino_superficie = a_S*real(a, dp)**(-1.0_dp/3.0_dp)
  end function termino_superficie

  ! ------------------------------------------------------------------
  ! termino_coulomb: término de Coulomb, a_C * Z**2 * A**(-4/3)
  !   Entradas: z (protones), a (nucleones)
  !   Salida:   término de Coulomb [MeV]
  ! ------------------------------------------------------------------
  real(dp) function termino_coulomb(z, a)
    integer, intent(in) :: z, a
    termino_coulomb = a_C*real(z, dp)**2*real(a, dp)**(-4.0_dp/3.0_dp)
  end function termino_coulomb

  ! ------------------------------------------------------------------
  ! termino_asimetria: término de asimetría, a_A * (Z - A/2)**2 / A**2
  !   Entradas: z (protones), a (nucleones)
  !   Salida:   término de asimetría [MeV]
  ! ------------------------------------------------------------------
  real(dp) function termino_asimetria(z, a)
    integer, intent(in) :: z, a
    termino_asimetria = a_A*(real(z, dp) - real(a, dp)/2.0_dp)**2/real(a, dp)**2
  end function termino_asimetria

  ! ------------------------------------------------------------------
  ! energia_enlace: energía de enlace por nucleón E_B(Z,A), suma de los cuatro términos
  !   Entradas: z (protones), a (nucleones)
  !   Salida:   E_B [MeV] (negativa para un núcleo ligado)
  ! ------------------------------------------------------------------
  real(dp) function energia_enlace(z, a)
    integer, intent(in) :: z, a
    energia_enlace = termino_volumen(z, a) + termino_superficie(z, a) &
                   + termino_coulomb(z, a) + termino_asimetria(z, a)
  end function energia_enlace

  ! ------------------------------------------------------------------
  ! masa_atomica: masa atómica aproximada M(Z,A) = Z*M_H + (A-Z)*M_n + A*E_B
  !   Entradas: z (protones), a (nucleones)
  !   Salida:   masa [MeV] (c = 1)
  ! ------------------------------------------------------------------
  real(dp) function masa_atomica(z, a)
    integer, intent(in) :: z, a
    masa_atomica = real(z, dp)*M_H + real(a - z, dp)*M_n + real(a, dp)*energia_enlace(z, a)
  end function masa_atomica

  ! ------------------------------------------------------------------
  ! z_estable: Z de máximo enlace (menor E_B) para un A dado, recorriendo Z = 1, ..., A
  !   Entrada:  a (nucleones)
  !   Salidas:  z_mejor (protones del núcleo más ligado), eb_mejor (su E_B [MeV])
  !   Es una subrutina porque entrega dos resultados independientes (regla de la sección 3.3).
  ! ------------------------------------------------------------------
  subroutine z_estable(a, z_mejor, eb_mejor)
    integer, intent(in)   :: a
    integer, intent(out)  :: z_mejor
    real(dp), intent(out) :: eb_mejor
    integer  :: z          ! candidato actual (local)
    real(dp) :: eb         ! E_B del candidato actual (local)

    z_mejor  = 1
    eb_mejor = energia_enlace(1, a)
    do z = 2, a
      eb = energia_enlace(z, a)
      if (eb < eb_mejor) then      ! más negativo = más ligado
        eb_mejor = eb
        z_mejor  = z
      end if
    end do
  end subroutine z_estable

end module modulo_nucleo
