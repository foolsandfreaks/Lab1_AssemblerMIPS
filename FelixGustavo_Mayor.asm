.data
prompt: .asciiz "Ingrese el numero de valores a comparar (3-5): "  # Mensaje para pedir el n�mero de valores
input_msg: .asciiz "Ingrese un numero: "  # Mensaje para pedir cada n�mero
output_msg: .asciiz "El numero mayor es: "  # Mensaje para mostrar el n�mero mayor
num_values: .word 0  # Variable para almacenar el n�mero de valores a comparar
numbers: .space 20  # Espacio para almacenar hasta 5 n�meros (4 bytes cada uno)
max_value: .word 0  # Variable para almacenar el n�mero mayor

.text
.globl main

main:
    # Mostrar prompt para el n�mero de valores a comparar
    li $v0, 4  # C�digo de syscall para imprimir cadena
    la $a0, prompt  # Cargar la direcci�n del mensaje en $a0
    syscall  # Llamar a la syscall

    # Leer el n�mero de valores
    li $v0, 5  # C�digo de syscall para leer un entero
    syscall  # Llamar a la syscall
    move $t0, $v0  # Guardar el n�mero de valores en $t0
    sw $t0, num_values  # Almacenar el n�mero de valores en la variable num_values

    # Verificar que el n�mero de valores est� entre 3 y 5
    li $t1, 3  # Cargar el valor 3 en $t1
    li $t2, 5  # Cargar el valor 5 en $t2
    blt $t0, $t1, invalid_input  # Si $t0 es menor que 3, saltar a invalid_input
    bgt $t0, $t2, invalid_input  # Si $t0 es mayor que 5, saltar a invalid_input

    # Leer los n�meros del usuario
    la $t3, numbers  # Cargar la direcci�n base del array numbers en $t3
    move $t4, $t0  # Copiar el n�mero de valores a $t4 (contador de n�meros a leer)
read_numbers:
    beqz $t4, find_max  # Si $t4 es 0, saltar a find_max
    li $v0, 4  # C�digo de syscall para imprimir cadena
    la $a0, input_msg  # Cargar la direcci�n del mensaje en $a0
    syscall  # Llamar a la syscall

    li $v0, 5  # C�digo de syscall para leer un entero
    syscall  # Llamar a la syscall
    sw $v0, 0($t3)  # Guardar el n�mero le�do en el array numbers
    addi $t3, $t3, 4  # Incrementar la direcci�n base del array en 4 bytes
    subi $t4, $t4, 1  # Decrementar el contador de n�meros a leer
    j read_numbers  # Repetir el proceso

find_max:
    # Inicializar el valor m�ximo con el primer n�mero
    la $t3, numbers  # Cargar la direcci�n base del array numbers en $t3
    lw $t5, 0($t3)  # Cargar el primer n�mero en $t5
    sw $t5, max_value  # Guardar el primer n�mero como el valor m�ximo inicial

    # Encontrar el n�mero mayor
    move $t4, $t0  # Reiniciar el contador de n�meros
    addi $t4, $t4, -1  # Restar 1 porque ya se consider� el primer n�mero
    addi $t3, $t3, 4  # Apuntar al segundo n�mero en el array
compare_numbers:
    beqz $t4, print_max  # Si $t4 es 0, saltar a print_max
    lw $t6, 0($t3)  # Cargar el siguiente n�mero en $t6
    lw $t5, max_value  # Cargar el valor m�ximo actual en $t5
    ble $t6, $t5, next_number  # Si $t6 es menor o igual a $t5, saltar a next_number
    sw $t6, max_value  # Si $t6 es mayor, actualizar el valor m�ximo
next_number:
    addi $t3, $t3, 4  # Incrementar la direcci�n base del array en 4 bytes
    subi $t4, $t4, 1  # Decrementar el contador de n�meros
    j compare_numbers  # Repetir el proceso

print_max:
    # Mostrar el n�mero mayor
    li $v0, 4  # C�digo de syscall para imprimir cadena
    la $a0, output_msg  # Cargar la direcci�n del mensaje en $a0
    syscall  # Llamar a la syscall

    lw $a0, max_value  # Cargar el valor m�ximo en $a0
    li $v0, 1  # C�digo de syscall para imprimir entero
    syscall  # Llamar a la syscall

    # Salir del programa
    li $v0, 10  # C�digo de syscall para salir
    syscall  # Llamar a la syscall

invalid_input:
    # Manejar entrada inv�lida
    li $v0, 4  # C�digo de syscall para imprimir cadena
    la $a0, prompt  # Cargar la direcci�n del mensaje en $a0
    syscall  # Llamar a la syscall

    # Salir del programa
    li $v0, 10  # C�digo de syscall para salir
    syscall  # Llamar a la syscall

