.data
prompt: .asciiz "Ingrese el numero de terminos de la serie Fibonacci: "  # Mensaje para pedir el n�mero de t�rminos
output_msg: .asciiz "La serie Fibonacci es: "  # Mensaje para mostrar la serie Fibonacci
sum_msg: .asciiz "La suma de la serie es: "  # Mensaje para mostrar la suma de la serie
comma_space: .asciiz ", "  # Coma y espacio para separar los n�meros en la salida
num_terms: .word 0  # Variable para almacenar el n�mero de t�rminos
fibonacci: .space 100  # Espacio para almacenar hasta 25 n�meros de Fibonacci (4 bytes cada uno)
sum: .word 0  # Variable para almacenar la suma de los n�meros de la serie

.text
.globl main

main:
    # Mostrar prompt para el n�mero de t�rminos de la serie Fibonacci
    li $v0, 4  # C�digo de syscall para imprimir cadena
    la $a0, prompt  # Cargar la direcci�n del mensaje en $a0
    syscall  # Llamar a la syscall

    # Leer el n�mero de t�rminos
    li $v0, 5  # C�digo de syscall para leer un entero
    syscall  # Llamar a la syscall
    move $t0, $v0  # Guardar el n�mero de t�rminos en $t0
    sw $t0, num_terms  # Almacenar el n�mero de t�rminos en la variable num_terms

    # Inicializar los primeros dos t�rminos de la serie Fibonacci
    la $t1, fibonacci  # Cargar la direcci�n base del array fibonacci en $t1
    li $t2, 0  # Primer t�rmino de la serie Fibonacci
    sw $t2, 0($t1)  # Almacenar el primer t�rmino en el array
    li $t2, 1  # Segundo t�rmino de la serie Fibonacci
    sw $t2, 4($t1)  # Almacenar el segundo t�rmino en el array

    # Generar la serie Fibonacci
    move $t3, $t0  # Copiar el n�mero de t�rminos a $t3 (contador de t�rminos)
    subi $t3, $t3, 2  # Restar 2 porque ya se consideraron los primeros dos t�rminos
    addi $t1, $t1, 8  # Apuntar al tercer t�rmino en el array
generate_fibonacci:
    beqz $t3, print_fibonacci  # Si $t3 es 0, saltar a print_fibonacci
    lw $t4, -4($t1)  # Cargar el t�rmino n-1 en $t4
    lw $t5, -8($t1)  # Cargar el t�rmino n-2 en $t5
    add $t6, $t4, $t5  # Calcular el t�rmino n sumando n-1 y n-2
    sw $t6, 0($t1)  # Almacenar el t�rmino n en el array
    addi $t1, $t1, 4  # Incrementar la direcci�n base del array en 4 bytes
    subi $t3, $t3, 1  # Decrementar el contador de t�rminos
    j generate_fibonacci  # Repetir el proceso

print_fibonacci:
    # Mostrar el mensaje de la serie Fibonacci
    li $v0, 4  # C�digo de syscall para imprimir cadena
    la $a0, output_msg  # Cargar la direcci�n del mensaje en $a0
    syscall  # Llamar a la syscall

    # Imprimir la serie Fibonacci
    la $t1, fibonacci  # Cargar la direcci�n base del array fibonacci en $t1
    move $t3, $t0  # Copiar el n�mero de t�rminos a $t3 (contador de t�rminos)
print_loop:
    beqz $t3, print_sum  # Si $t3 es 0, saltar a print_sum
    lw $a0, 0($t1)  # Cargar el t�rmino actual en $a0
    li $v0, 1  # C�digo de syscall para imprimir entero
    syscall  # Llamar a la syscall

    # Imprimir una coma y un espacio si no es el �ltimo t�rmino
    subi $t3, $t3, 1  # Decrementar el contador de t�rminos
    beqz $t3, print_sum  # Si $t3 es 0, saltar a print_sum
    li $v0, 4  # C�digo de syscall para imprimir cadena
    la $a0, comma_space  # Cargar la direcci�n de la coma y el espacio en $a0
    syscall  # Llamar a la syscall

    addi $t1, $t1, 4  # Incrementar la direcci�n base del array en 4 bytes
    j print_loop  # Repetir el proceso

print_sum:
    # Calcular la suma de la serie Fibonacci
    la $t1, fibonacci  # Cargar la direcci�n base del array fibonacci en $t1
    move $t3, $t0  # Copiar el n�mero de t�rminos a $t3 (contador de t�rminos)
    li $t7, 0  # Inicializar la suma en 0
sum_loop:
    beqz $t3, display_sum  # Si $t3 es 0, saltar a display_sum
    lw $t6, 0($t1)  # Cargar el t�rmino actual en $t6
    add $t7, $t7, $t6  # Sumar el t�rmino actual a la suma
    addi $t1, $t1, 4  # Incrementar la direcci�n base del array en 4 bytes
    subi $t3, $t3, 1  # Decrementar el contador de t�rminos
    j sum_loop  # Repetir el proceso

display_sum:
    # Mostrar el mensaje de la suma de la serie
    li $v0, 4  # C�digo de syscall para imprimir cadena
    la $a0, sum_msg  # Cargar la direcci�n del mensaje en $a0
    syscall  # Llamar a la syscall

    # Imprimir la suma de la serie
    move $a0, $t7  # Mover la suma al registro $a0
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
