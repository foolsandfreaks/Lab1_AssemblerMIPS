.data
prompt: .asciiz "Ingrese el numero de terminos de la serie Fibonacci: "  # Mensaje para pedir el número de términos
output_msg: .asciiz "La serie Fibonacci es: "  # Mensaje para mostrar la serie Fibonacci
sum_msg: .asciiz "La suma de la serie es: "  # Mensaje para mostrar la suma de la serie
comma_space: .asciiz ", "  # Coma y espacio para separar los números en la salida
num_terms: .word 0  # Variable para almacenar el número de términos
fibonacci: .space 100  # Espacio para almacenar hasta 25 números de Fibonacci (4 bytes cada uno)
sum: .word 0  # Variable para almacenar la suma de los números de la serie

.text
.globl main

main:
    # Mostrar prompt para el número de términos de la serie Fibonacci
    li $v0, 4  # Código de syscall para imprimir cadena
    la $a0, prompt  # Cargar la dirección del mensaje en $a0
    syscall  # Llamar a la syscall

    # Leer el número de términos
    li $v0, 5  # Código de syscall para leer un entero
    syscall  # Llamar a la syscall
    move $t0, $v0  # Guardar el número de términos en $t0
    sw $t0, num_terms  # Almacenar el número de términos en la variable num_terms

    # Inicializar los primeros dos términos de la serie Fibonacci
    la $t1, fibonacci  # Cargar la dirección base del array fibonacci en $t1
    li $t2, 0  # Primer término de la serie Fibonacci
    sw $t2, 0($t1)  # Almacenar el primer término en el array
    li $t2, 1  # Segundo término de la serie Fibonacci
    sw $t2, 4($t1)  # Almacenar el segundo término en el array

    # Generar la serie Fibonacci
    move $t3, $t0  # Copiar el número de términos a $t3 (contador de términos)
    subi $t3, $t3, 2  # Restar 2 porque ya se consideraron los primeros dos términos
    addi $t1, $t1, 8  # Apuntar al tercer término en el array
generate_fibonacci:
    beqz $t3, print_fibonacci  # Si $t3 es 0, saltar a print_fibonacci
    lw $t4, -4($t1)  # Cargar el término n-1 en $t4
    lw $t5, -8($t1)  # Cargar el término n-2 en $t5
    add $t6, $t4, $t5  # Calcular el término n sumando n-1 y n-2
    sw $t6, 0($t1)  # Almacenar el término n en el array
    addi $t1, $t1, 4  # Incrementar la dirección base del array en 4 bytes
    subi $t3, $t3, 1  # Decrementar el contador de términos
    j generate_fibonacci  # Repetir el proceso

print_fibonacci:
    # Mostrar el mensaje de la serie Fibonacci
    li $v0, 4  # Código de syscall para imprimir cadena
    la $a0, output_msg  # Cargar la dirección del mensaje en $a0
    syscall  # Llamar a la syscall

    # Imprimir la serie Fibonacci
    la $t1, fibonacci  # Cargar la dirección base del array fibonacci en $t1
    move $t3, $t0  # Copiar el número de términos a $t3 (contador de términos)
print_loop:
    beqz $t3, print_sum  # Si $t3 es 0, saltar a print_sum
    lw $a0, 0($t1)  # Cargar el término actual en $a0
    li $v0, 1  # Código de syscall para imprimir entero
    syscall  # Llamar a la syscall

    # Imprimir una coma y un espacio si no es el último término
    subi $t3, $t3, 1  # Decrementar el contador de términos
    beqz $t3, print_sum  # Si $t3 es 0, saltar a print_sum
    li $v0, 4  # Código de syscall para imprimir cadena
    la $a0, comma_space  # Cargar la dirección de la coma y el espacio en $a0
    syscall  # Llamar a la syscall

    addi $t1, $t1, 4  # Incrementar la dirección base del array en 4 bytes
    j print_loop  # Repetir el proceso

print_sum:
    # Calcular la suma de la serie Fibonacci
    la $t1, fibonacci  # Cargar la dirección base del array fibonacci en $t1
    move $t3, $t0  # Copiar el número de términos a $t3 (contador de términos)
    li $t7, 0  # Inicializar la suma en 0
sum_loop:
    beqz $t3, display_sum  # Si $t3 es 0, saltar a display_sum
    lw $t6, 0($t1)  # Cargar el término actual en $t6
    add $t7, $t7, $t6  # Sumar el término actual a la suma
    addi $t1, $t1, 4  # Incrementar la dirección base del array en 4 bytes
    subi $t3, $t3, 1  # Decrementar el contador de términos
    j sum_loop  # Repetir el proceso

display_sum:
    # Mostrar el mensaje de la suma de la serie
    li $v0, 4  # Código de syscall para imprimir cadena
    la $a0, sum_msg  # Cargar la dirección del mensaje en $a0
    syscall  # Llamar a la syscall

    # Imprimir la suma de la serie
    move $a0, $t7  # Mover la suma al registro $a0
    li $v0, 1  # Código de syscall para imprimir entero
    syscall  # Llamar a la syscall

    # Salir del programa
    li $v0, 10  # Código de syscall para salir
    syscall  # Llamar a la syscall

invalid_input:
    # Manejar entrada inválida
    li $v0, 4  # Código de syscall para imprimir cadena
    la $a0, prompt  # Cargar la dirección del mensaje en $a0
    syscall  # Llamar a la syscall

    # Salir del programa
    li $v0, 10  # Código de syscall para salir
    syscall  # Llamar a la syscall
