# asm-server

Simple HTTP server in x86 NASM linux assembly. Ignores request and responds with hello.

### Build and run

Requires `nasm`, `ld`, `make`

```sh
git clone https://github.com/jesperkha/asm-server.git
cd asm-server
make
```

In another terminal window run:

```sh
curl localhost:8080
```

### Resources

- [Syscall table](https://filippo.io/linux-syscall-table/)
- [NASM Docs](https://leopard-adc.pepas.com/documentation/DeveloperTools/nasm/nasmdoc0.html)
