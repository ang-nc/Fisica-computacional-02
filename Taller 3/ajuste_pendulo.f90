
program ajuste_pendulo

    implicit none

    !=========================================================
    ! Variables para archivos
    !=========================================================
    integer :: unidad
    integer :: unidad_salida
    integer :: ios

    !=========================================================
    ! Variables de los datos
    !=========================================================
    integer :: medicion_id
    integer :: numero_oscilaciones

    real(8) :: longitud_cm
    real(8) :: angulo_inicial_deg
    real(8) :: tiempo_medido_s

    real(8) :: L
    real(8) :: T
    real(8) :: T2

    !=========================================================
    ! Variables para las sumatorias
    !=========================================================
    integer :: n

    real(8) :: sx
    real(8) :: sy
    real(8) :: sxx
    real(8) :: sxy

    !=========================================================
    ! Variables del ajuste
    !=========================================================
    real(8) :: a
    real(8) :: b
    real(8) :: g

    !=========================================================
    ! Variables para R2
    !=========================================================
    real(8) :: y_ajuste
    real(8) :: y_prom
    real(8) :: ss_res
    real(8) :: ss_tot
    real(8) :: r2

    !=========================================================
    ! Constante pi
    !=========================================================
    real(8), parameter :: pi = 3.14159265358979323846d0


    !=========================================================
    ! Inicialización
    !=========================================================

    n   = 0
    sx  = 0.0d0
    sy  = 0.0d0
    sxx = 0.0d0
    sxy = 0.0d0


    !=========================================================
    ! 1. Abrir pendulo_limpio.dat
    !=========================================================

    open(newunit=unidad, file='pendulo_limpio.dat', &
         status='old', action='read', iostat=ios)

    if (ios /= 0) then
        print *, 'ERROR: no se pudo abrir pendulo_limpio.dat'
        stop
    end if


    !=========================================================
    ! 2-5. Primera lectura de los datos
    !=========================================================

    do

        read(unidad, *, iostat=ios) medicion_id, longitud_cm, &
            angulo_inicial_deg, numero_oscilaciones, tiempo_medido_s

        if (ios /= 0) exit


        !-----------------------------------------------------
        ! 3. Convertir longitud de cm a m
        !-----------------------------------------------------

        L = longitud_cm / 100.0d0


        !-----------------------------------------------------
        ! 4. Calcular periodo T y T^2
        !-----------------------------------------------------

        T = tiempo_medido_s / dble(numero_oscilaciones)

        T2 = T**2


        !-----------------------------------------------------
        ! 5. Acumular sumatorias
        !-----------------------------------------------------

        n   = n + 1

        sx  = sx  + L
        sy  = sy  + T2
        sxx = sxx + L**2
        sxy = sxy + L*T2

    end do

    close(unidad)


    !=========================================================
    ! 11. Comprobar que haya al menos dos datos
    !=========================================================

    if (n < 2) then
        print *, 'ERROR: se necesitan al menos dos datos.'
        stop
    end if


    !=========================================================
    ! 6. Calcular pendiente e intercepto
    !=========================================================

    if (dble(n)*sxx - sx**2 == 0.0d0) then
        print *, 'ERROR: denominador nulo en el ajuste.'
        stop
    end if


    a = (dble(n)*sxy - sx*sy) / &
        (dble(n)*sxx - sx**2)


    b = (sy - a*sx) / dble(n)


    !=========================================================
    ! 7. Calcular g
    !=========================================================

    g = 4.0d0*pi**2 / a


    !=========================================================
    ! Promedio de y
    !=========================================================

    y_prom = sy / dble(n)


    !=========================================================
    ! 8. Segunda lectura para calcular R2
    !=========================================================

    ss_res = 0.0d0
    ss_tot = 0.0d0


    open(newunit=unidad, file='pendulo_limpio.dat', &
         status='old', action='read', iostat=ios)

    if (ios /= 0) then
        print *, 'ERROR: no se pudo abrir nuevamente el archivo.'
        stop
    end if


    do

        read(unidad, *, iostat=ios) medicion_id, longitud_cm, &
            angulo_inicial_deg, numero_oscilaciones, tiempo_medido_s

        if (ios /= 0) exit


        !-----------------------------------------------------
        ! Reconstruir L y T^2
        !-----------------------------------------------------

        L = longitud_cm / 100.0d0

        T = tiempo_medido_s / dble(numero_oscilaciones)

        T2 = T**2


        !-----------------------------------------------------
        ! Valor predicho por el ajuste
        !-----------------------------------------------------

        y_ajuste = a*L + b


        !-----------------------------------------------------
        ! Suma de cuadrados de residuos
        !-----------------------------------------------------

        ss_res = ss_res + (T2 - y_ajuste)**2


        !-----------------------------------------------------
        ! Suma total de cuadrados
        !-----------------------------------------------------

        ss_tot = ss_tot + (T2 - y_prom)**2

    end do

    close(unidad)


    !=========================================================
    ! Comprobar denominador de R2
    !=========================================================

    if (ss_tot == 0.0d0) then
        print *, 'ERROR: denominador nulo al calcular R2.'
        stop
    end if


    !=========================================================
    ! Calcular R2
    !=========================================================

    r2 = 1.0d0 - ss_res/ss_tot


    !=========================================================
    ! 9. Mostrar resultados
    !=========================================================

    print *
    print *, '=========================================='
    print *, '          AJUSTE DEL PENDULO'
    print *, '=========================================='

    print *, 'N  = ', n
    print *, 'a  = ', a, ' s^2/m'
    print *, 'b  = ', b, ' s^2'
    print *, 'R2 = ', r2
    print *, 'g  = ', g, ' m/s^2'

    print *, '=========================================='


    !=========================================================
    ! 10. Guardar resultados
    !=========================================================

    open(newunit=unidad_salida, file='resultados_ajuste.dat', &
         status='replace', action='write')

    write(unidad_salida, *) n, a, b, r2, g

    close(unidad_salida)


end program ajuste_pendulo
