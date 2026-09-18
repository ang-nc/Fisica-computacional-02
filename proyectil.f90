
program altura_proyectil

    implicit none

    real :: v0
    real :: angulo_grados
    real :: angulo_rad
    real :: h_max

    real :: angulo_prueba
    real :: v0_prueba
    real :: h_esperada
    real :: h_calculada
    real :: angulo_rad_prueba
    real :: error
    real :: tolerancia

    integer :: i

    real, parameter :: PI = 3.14159265
    real, parameter :: g = 9.8

    tolerancia = 0.001

    print *, "CALCULO DE LA ALTURA MAXIMA DE UN PROYECTIL"
    print *

    print *, "Ingrese la rapidez inicial (m/s):"
    read *, v0

    print *, "Ingrese el angulo respecto a la horizontal (grados):"
    read *, angulo_grados

    print *
    print *, "DATOS INGRESADOS:"
    print *, "Rapidez inicial =", v0, "m/s"
    print *, "Angulo =", angulo_grados, "grados"

    angulo_rad = angulo_grados * PI / 180.0

    h_max = (v0**2 * sin(angulo_rad)**2) / (2.0 * g)

    print *
    print *, "Angulo en radianes =", angulo_rad
    print *, "Altura maxima =", h_max, "m"

    print *
    print *, "======================================"
    print *, "CELDA DE VERIFICACION"
    print *, "======================================"

    do i = 1, 3

        if (i == 1) then
            angulo_prueba = 90.0
            v0_prueba = 9.8
            h_esperada = 4.9000

        else if (i == 2) then
            angulo_prueba = 45.0
            v0_prueba = 20.0
            h_esperada = 10.2041

        else
            angulo_prueba = 30.0
            v0_prueba = 20.0
            h_esperada = 5.1020
        end if

        angulo_rad_prueba = angulo_prueba * PI / 180.0

        h_calculada = (v0_prueba**2 * sin(angulo_rad_prueba)**2) / (2.0 * g)

        error = abs(h_calculada - h_esperada)

        if (error < tolerancia) then
            print *, "Caso", i, ": PASS"
        else
            print *, "Caso", i, ": FAIL"
        end if

        print *, "  Angulo =", angulo_prueba, "grados"
        print *, "  v0 =", v0_prueba, "m/s"
        print *, "  Calculada =", h_calculada, "m"
        print *, "  Esperada =", h_esperada, "m"

    end do

end program altura_proyectil