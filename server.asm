%define SYS_WRITE       1
%define SYS_CLOSE       3
%define SYS_SENDFILE    40
%define SYS_SOCKET      41
%define SYS_ACCEPT      43
%define SYS_SHUTDOWN    48
%define SYS_BIND        49
%define SYS_LISTEN      50
%define SYS_EXIT        60

%define AF_INET     2
%define SOCK_STREAM 1

global _start

section .data
    sockfd:       dq 0
    clientfd:     dq 0
    newline:      db `\n`
    error_msg:    db "error", 0
    shutdown_msg: db "Server shutdown", 0

    sockaddr:
        dw AF_INET
        dw 0x901f ; 8080
        dd 0
        dq 0

    client_addr_buf:
        times 16 db 0

    client_addr_len:
        dq 0

    response:
        db "HTTP/1.0 200 OK", 10
        db "Content-Type: text/html", 10, 10
        db "Hello world!", 10, 0


section .text
_start:
    ; Make server socket and store fd in sockfd
    mov rax, SYS_SOCKET
    mov rdi, AF_INET
    mov rsi, SOCK_STREAM
    mov rdx, 0
    syscall

    mov [sockfd], rax

    cmp rax, 0
    js  error

    ; Bind socket to port 8080
    mov rax, SYS_BIND
    mov rdi, [sockfd]
    mov rsi, sockaddr
    mov rdx, 16
    syscall

    cmp rax, 0
    js  error

    ; Listen
    mov rax, SYS_LISTEN
    mov rdi, [sockfd]
    mov rsi, 1
    syscall

    cmp rax, 0
    js  error

    ; Accept client socket
    mov rax, SYS_ACCEPT
    mov rdi, [sockfd]
    mov rsi, client_addr_buf
    mov rdx, client_addr_len
    syscall

    mov [clientfd], rax

    cmp rax, 0
    js  error

    ; Serve page
    mov  rdi, response
    call strlen
    mov  r12, rax ; length

    mov rax, SYS_WRITE
    mov rdi, [clientfd]
    mov rsi, response
    mov rdx, r12
    syscall
    
    cmp rax, 0
    js  error

    ; Send shutdown signal to client and close
    mov rax, SYS_SHUTDOWN
    mov rdi, [clientfd]
    mov rsi, 2 ; SHUT_RDWR
    syscall

    mov rax, SYS_CLOSE
    mov rdi, [clientfd]
    syscall

    ; Close server socket
    mov rax, SYS_CLOSE
    mov rdi, [sockfd]
    syscall

    ; Exit with status 0
    mov  rdi, shutdown_msg
    call println
    mov  rdi, 0
    call exit

error:
    mov  rdi, error_msg
    call println
    mov  rdi, 1
    call exit

; Get length of null-terminated string
strlen:
    push r12
    push r13
    mov  r12, 0   ; length
    mov  r13, rdi ; string ptr

.iter:
    cmp byte [r13 + r12], 0
    jz  .done
    inc r12
    jmp .iter

.done:
    mov rax, r12
    pop r13
    pop r12
    ret

; Print null-terminated string (rdi) with newline at end.
println:
    push r12
    push r13

    mov  r13, rdi   ; string ptr
    call strlen     ; ptr is already in rdi
    mov  r12, rax   ; len

    mov rax, SYS_WRITE
    mov rdi, 1
    mov rsi, r13
    mov rdx, r12
    syscall

    ; newline
    mov rax, SYS_WRITE
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    pop r13
    pop r12
    ret

; Exit program with status in rdi
exit:
    mov rax, SYS_EXIT
    syscall

