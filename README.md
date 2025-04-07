# asm-server

Simple HTTP server in x86 NASM linux assembly. Ignores request and responds with hello world html file.

### Build and run

Requires `nasm`, `ld`, `make`

```sh
git clone https://github.com/jesperkha/asm-server.git
cd asm-server
make
```

Go to `localhost:8080` in your browser.

### Resources

- [Syscall table](https://filippo.io/linux-syscall-table/)
- [NASM Docs](https://leopard-adc.pepas.com/documentation/DeveloperTools/nasm/nasmdoc0.html)
- Linux syscall man pages
