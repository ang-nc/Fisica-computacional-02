
! Programa para analizar las mediciones de un péndulo simple mediante
! un ajuste lineal por el método de mínimos cuadrados.
! A partir de los datos experimentales, calcula la pendiente, el intercepto,
! el coeficiente de determinación R2 y la aceleración de la gravedad.

program ajuste_pendulo

    ! Evita la declaración implícita de variables y exige que todas
    ! las variables utilizadas se declaren explícitamente.
    implicit none

    !=========================================================
    ! Variables para archivos
    !=========================================================

    ! Identificador interno de la unidad utilizada para leer el archivo.
    integer :: unidad

    ! Identificador interno de la unidad utilizada para guardar resultados.
    integer :: unidad_salida

    ! Código de estado de las operaciones de lectura y apertura.
    ! Un valor igual a cero indica que la operación se realizó correctamente.
    integer :: ios


    !=========================================================
    ! Variables de los datos
    !=========================================================

    ! Identificador de cada medición experimental.
    integer :: medicion_id

    ! Número de oscilaciones realizadas durante la medición del tiempo.
    integer :: numero_oscilaciones

    ! Longitud del péndulo en centímetros, tal como aparece en el archivo.
    real(8) :: longitud_cm

    ! Ángulo inicial de oscilación expresado en grados.
    real(8) :: angulo_inicial_deg

    ! Tiempo total medido experimentalmente, expresado en segundos.
    real(8) :: tiempo_medido_s

    ! Longitud del péndulo convertida a metros.
    ! Se utiliza como variable independiente del ajuste lineal.
    real(8) :: L

    ! Período experimental: tiempo correspondiente a una oscilación,
    ! expresado en segundos.
    real(8) :: T

    ! Cuadrado del período, expresado en segundos cuadrados.
    ! Se utiliza como variable dependiente del ajuste lineal.
    real(8) :: T2


    !=========================================================
    ! Variables para las sumatorias
    !=========================================================

    ! Contador del número de mediciones leídas correctamente.
    integer :: n

    ! Sumatoria de las longitudes: suma de L.
    real(8) :: sx

    ! Sumatoria de los cuadrados de los períodos: suma de T^2.
    real(8) :: sy

    ! Sumatoria de los cuadrados de las longitudes: suma de L^2.
    real(8) :: sxx

    ! Sumatoria de los productos entre longitud y período al cuadrado:
    ! suma de L*T^2.
    real(8) :: sxy


    !=========================================================
    ! Variables del ajuste
    !=========================================================

    ! Pendiente de la recta de ajuste, con unidades s^2/m.
    real(8) :: a

    ! Intercepto de la recta con el eje vertical, con unidades s^2.
    real(8) :: b

    ! Aceleración experimental de la gravedad, con unidades m/s^2.
    real(8) :: g


    !=========================================================
    ! Variables para R2
    !=========================================================

    ! Valor de T^2 predicho por la recta de ajuste para cada longitud.
    real(8) :: y_ajuste

    ! Promedio de los valores experimentales de T^2.
    real(8) :: y_prom

    ! Suma de los cuadrados de las diferencias entre los valores
    ! experimentales y los valores predichos por la recta.
    real(8) :: ss_res

    ! Suma de los cuadrados de las diferencias entre los valores
    ! experimentales y el promedio de T^2.
    real(8) :: ss_tot

    ! Coeficiente de determinación: permite evaluar qué tan bien
    ! representa la recta de ajuste los datos experimentales.
    real(8) :: r2


    !=========================================================
    ! Constante pi
    !=========================================================

    ! Define el valor de pi con precisión de doble precisión.
    ! La palabra parameter indica que su valor permanece constante.
    real(8), parameter :: pi = 3.14159265358979323846d0


    !=========================================================
    ! Inicialización
    !=========================================================

    ! Inicializa el contador de mediciones en cero.
    n   = 0

    ! Inicializa en cero las sumatorias que se utilizarán
    ! para calcular los coeficientes del ajuste lineal.
    sx  = 0.0d0
    sy  = 0.0d0
    sxx = 0.0d0
    sxy = 0.0d0


    !=========================================================
    ! 1. Abrir pendulo_limpio.dat
    !=========================================================

    ! Abre el archivo de datos limpios en modo lectura.
    ! newunit asigna automáticamente una unidad disponible.
    ! status='old' exige que el archivo ya exista.
    ! action='read' indica que solo se leerán datos.
    ! iostat=ios permite comprobar si la apertura fue exitosa.
    open(newunit=unidad, file='pendulo_limpio.dat', &
         status='old', action='read', iostat=ios)

    ! Si la apertura falla, muestra un mensaje y detiene el programa.
    if (ios /= 0) then
        print *, 'ERROR: no se pudo abrir pendulo_limpio.dat'
        stop
    end if


    !=========================================================
    ! 2-5. Primera lectura de los datos
    !=========================================================

    ! Inicia un ciclo que permite leer una cantidad desconocida de filas.
    ! El ciclo termina cuando la lectura devuelve un estado distinto de cero,
    ! por ejemplo, al llegar al final del archivo.
    do

        ! Lee los cinco valores de cada fila del archivo:
        ! identificador, longitud, ángulo, oscilaciones y tiempo medido.
        ! iostat registra si la lectura fue correcta o si llegó al final.
        read(unidad, *, iostat=ios) medicion_id, longitud_cm, &
            angulo_inicial_deg, numero_oscilaciones, tiempo_medido_s

        ! Si la lectura no fue exitosa, sale del ciclo.
        if (ios /= 0) exit


        !-----------------------------------------------------
        ! 3. Convertir longitud de cm a m
        !-----------------------------------------------------

        ! Convierte la longitud de centímetros a metros.
        ! Se divide entre 100 porque 100 cm equivalen a 1 m.
        L = longitud_cm / 100.0d0


        !-----------------------------------------------------
        ! 4. Calcular periodo T y T^2
        !-----------------------------------------------------

        ! Calcula el período dividiendo el tiempo total medido
        ! entre el número de oscilaciones realizadas.
        T = tiempo_medido_s / dble(numero_oscilaciones)

        ! Calcula el cuadrado del período.
        ! El operador ** representa una potencia en Fortran.
        T2 = T**2


        !-----------------------------------------------------
        ! 5. Acumular sumatorias
        !-----------------------------------------------------

        ! Incrementa el contador por cada registro leído correctamente.
        n   = n + 1

        ! Acumula la suma de las longitudes L.
        sx  = sx  + L

        ! Acumula la suma de los cuadrados de los períodos T^2.
        sy  = sy  + T2

        ! Acumula la suma de los cuadrados de las longitudes L^2.
        sxx = sxx + L**2

        ! Acumula la suma de los productos L*T^2.
        sxy = sxy + L*T2

    end do

    ! Cierra el archivo después de completar la primera lectura.
    close(unidad)


    !=========================================================
    ! 11. Comprobar que haya al menos dos datos
    !=========================================================

    ! Comprueba que se hayan leído al menos dos mediciones.
    ! Con menos de dos datos no se puede determinar una recta
    ! de ajuste lineal a partir de las mediciones.
    if (n < 2) then
        print *, 'ERROR: se necesitan al menos dos datos.'
        stop
    end if


    !=========================================================
    ! 6. Calcular pendiente e intercepto
    !=========================================================

    ! Comprueba que el denominador de las fórmulas del ajuste
    ! lineal no sea cero, para evitar una división indefinida.
    if (dble(n)*sxx - sx**2 == 0.0d0) then
        print *, 'ERROR: denominador nulo en el ajuste.'
        stop
    end if

    ! Calcula la pendiente a de la recta de mínimos cuadrados:
    !
    ! a = [n*sum(L*T^2) - sum(L)*sum(T^2)] /
    !     [n*sum(L^2) - (sum(L))^2]
    !
    ! Esta pendiente describe cómo cambia T^2 con respecto a L.
    ! dble(n) convierte el contador entero a doble precisión
    ! para realizar las operaciones con números reales.
    a = (dble(n)*sxy - sx*sy) / &
        (dble(n)*sxx - sx**2)

    ! Calcula el intercepto b de la recta de ajuste:
    !
    ! b = [sum(T^2) - a*sum(L)] / n
    !
    ! El intercepto representa el valor extrapolado de T^2
    ! cuando la longitud L es igual a cero.
    b = (sy - a*sx) / dble(n)


    !=========================================================
    ! 7. Calcular g
    !=========================================================

    ! Para un péndulo simple y ángulos pequeños se cumple:
    !
    ! T^2 = (4*pi^2/g)*L
    !
    ! Por comparación con la recta T^2 = a*L + b,
    ! la pendiente teórica corresponde a a = 4*pi^2/g.
    ! Despejando, se obtiene la gravedad experimental:
    !
    ! g = 4*pi^2/a
    !
    ! El resultado se expresa en metros por segundo al cuadrado.
    g = 4.0d0*pi**2 / a


    !=========================================================
    ! Promedio de y
    !=========================================================

    ! Calcula el promedio de los valores de T^2.
    ! Este promedio se utilizará para calcular la suma total
    ! de cuadrados necesaria para obtener el coeficiente R2.
    y_prom = sy / dble(n)


    !=========================================================
    ! 8. Segunda lectura para calcular R2
    !=========================================================

    ! Inicializa las sumas de cuadrados en cero.
    ! ss_res mide la discrepancia entre los datos y la recta.
    ! ss_tot mide la variabilidad total de los datos respecto al promedio.
    ss_res = 0.0d0
    ss_tot = 0.0d0


    ! Abre nuevamente el archivo para recorrer los datos una segunda vez.
    ! Se necesita esta segunda lectura para comparar cada dato observado
    ! con su valor predicho por la recta de ajuste.
    open(newunit=unidad, file='pendulo_limpio.dat', &
         status='old', action='read', iostat=ios)

    ! Si no es posible volver a abrir el archivo, informa el error
    ! y detiene la ejecución.
    if (ios /= 0) then
        print *, 'ERROR: no se pudo abrir nuevamente el archivo.'
        stop
    end if


    ! Recorre de nuevo todas las filas del archivo para calcular R2.
    do

        ! Lee nuevamente los cinco valores de cada medición.
        read(unidad, *, iostat=ios) medicion_id, longitud_cm, &
            angulo_inicial_deg, numero_oscilaciones, tiempo_medido_s

        ! Termina la lectura al llegar al final del archivo
        ! o si ocurre algún error de lectura.
        if (ios /= 0) exit


        !-----------------------------------------------------
        ! Reconstruir L y T^2
        !-----------------------------------------------------

        ! Convierte nuevamente la longitud de centímetros a metros.
        L = longitud_cm / 100.0d0

        ! Reconstruye el período experimental de la medición.
        T = tiempo_medido_s / dble(numero_oscilaciones)

        ! Calcula el cuadrado del período observado.
        T2 = T**2


        !-----------------------------------------------------
        ! Valor predicho por el ajuste
        !-----------------------------------------------------

        ! Calcula el valor de T^2 predicho por la recta:
        !
        ! y_ajuste = a*L + b
        !
        ! Este valor se compara con el T^2 experimental.
        y_ajuste = a*L + b


        !-----------------------------------------------------
        ! Suma de cuadrados de residuos
        !-----------------------------------------------------

        ! Calcula el cuadrado de la diferencia entre el valor
        ! experimental T2 y el valor predicho y_ajuste.
        ! La suma de estas diferencias al cuadrado constituye ss_res.
        ss_res = ss_res + (T2 - y_ajuste)**2


        !-----------------------------------------------------
        ! Suma total de cuadrados
        !-----------------------------------------------------

        ! Calcula el cuadrado de la diferencia entre el valor
        ! experimental T2 y el promedio y_prom.
        ! La acumulación de estas diferencias constituye ss_tot.
        ss_tot = ss_tot + (T2 - y_prom)**2

    end do

    ! Cierra el archivo después de calcular las sumas de cuadrados.
    close(unidad)


    !=========================================================
    ! Comprobar denominador de R2
    !=========================================================

    ! Comprueba que exista variabilidad en los valores experimentales.
    ! Si ss_tot es cero, no se puede calcular R2 con esta fórmula.
    if (ss_tot == 0.0d0) then
        print *, 'ERROR: denominador nulo al calcular R2.'
        stop
    end if


    !=========================================================
    ! Calcular R2
    !=========================================================

    ! Calcula el coeficiente de determinación mediante:
    !
    ! R2 = 1 - ss_res/ss_tot
    !
    ! Un valor cercano a 1 indica que la recta representa
    ! adecuadamente la variación observada en los datos.
    r2 = 1.0d0 - ss_res/ss_tot


    !=========================================================
    ! 9. Mostrar resultados
    !=========================================================

    ! Imprime una línea en blanco para separar la salida anterior.
    print *

    ! Presenta un encabezado para identificar los resultados del programa.
    print *, '=========================================='
    print *, '          AJUSTE DEL PENDULO'
    print *, '=========================================='

    ! Muestra el número de mediciones procesadas.
    print *, 'N  = ', n

    ! Muestra la pendiente del ajuste, expresada en s^2/m.
    print *, 'a  = ', a, ' s^2/m'

    ! Muestra el intercepto de la recta, expresado en s^2.
    print *, 'b  = ', b, ' s^2'

    ! Muestra el coeficiente de determinación del ajuste.
    print *, 'R2 = ', r2

    ! Muestra la aceleración experimental de la gravedad, en m/s^2.
    print *, 'g  = ', g, ' m/s^2'

    ! Cierra visualmente el bloque de resultados.
    print *, '=========================================='


    !=========================================================
    ! 10. Guardar resultados
    !=========================================================

    ! Abre el archivo de salida para guardar los cinco resultados.
    ! status='replace' crea el archivo si no existe o reemplaza
    ! su contenido anterior si ya existe.
    ! action='write' indica que se utilizará para escribir.
    open(newunit=unidad_salida, file='resultados_ajuste.dat', &
         status='replace', action='write')

    ! Escribe en una sola línea los resultados en este orden:
    ! número de datos, pendiente, intercepto, R2 y gravedad.
    ! No se incluye una cabecera, para facilitar la lectura posterior.
    write(unidad_salida, *) n, a, b, r2, g

    ! Cierra el archivo después de guardar los resultados.
    close(unidad_salida)


! Finaliza el programa principal.
end program ajuste_pendulo

