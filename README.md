# Docker tdlib

Simple container that builds Telegram's tdlib (https://github.com/tdlib/td).

The final image uses a "scratch" image as base and exposes the built library in `/tdlib`, ready to be copied to `/usr/local`.

## Usage

### In your Dockerfile
Just use multistage Docker builds:
```dockerfile
FROM mattiamari/docker-tdlib as build-tdlib

FROM ubuntu:latest
COPY --from=build-tdlib /tdlib/ /usr/local/
```

### With `docker build`
```bash
docker build -t docker-tdlib github.com/mattiamari/docker-tdlib
```

#### Build arguments
The image has 2 optional arguments:
- `build_threads` is the number of threads that will be passed to `cmake -j {build_threads}`.
- `tdlib_tag` is the git tag (can also be a commit hash) that specifies the tdlib version to build.

You can use them like this:
```bash
docker build --build-arg build_threads=4 --build-arg tdlib_tag=v1.5.0 -t docker-tdlib github.com/mattiamari/docker-tdlib
```
