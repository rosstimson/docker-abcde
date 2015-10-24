# abcde

This Dockerfile will build a Docker container with [abcde][abcde] and
various other tools that need to be custom compiled due to licensing
such as ffmpeg with fdk_aac support.

In other words this aims to be a one-stop shop for ripping, tagging, and
encoding your music CDs. It will even embed the album art.

## Usage

### Build

Because of some funky licensing I cannot just share this Docker image on
Docker Hub, you will need to build it for yourself. You can do so with:

```
docker build -t abcde .
```

### Configure

First off you should configure abcde with your preferences to
set which codecs you wish to convert your music to etc. abcde
comes with a lot of settings but the example config file is
generally well commented, to get started you can view
[my config](https://github.com/rosstimson/dotfiles/blob/master/.abcde.conf).

### Run

docker run -it \
-v /tmp/.X11-unix/:/tmp/.X11-unix \
-v $HOME/.abcde.conf:/root/.abcde.conf \
-v $HOME/Music:/root/Music \
--device=/dev/sr0:/dev/cdrom \
-e DISPLAY \
abcde

If you're on a Linux machine and want the album artwork preview to work
you might have to disable authentication for accessing the hosts Xorg
server like so:

```
xhost +
```

## License and Author

Author:: [Ross Timson][rosstimson]
<[ross@rosstimson.com](mailto:ross@rosstimson.com)>.

License:: Licensed under [WTFPL][wtfpl].


[rosstimson]:         https://rosstimson.com
[repo]:               https://github.com/rosstimson/docker-abcde
[issues]:             https://github.com/rosstimson/docker-abcde/issues
[wtfpl]:              http://www.wtfpl.net/
[abcde]:              http://lly.org/~rcw/abcde/page/
