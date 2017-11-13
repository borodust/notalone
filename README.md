[![Build Status](https://travis-ci.org/borodust/notalone.svg?branch=v1.0.4)](https://travis-ci.org/borodust/notalone) [![Build status](https://ci.appveyor.com/api/projects/status/yaef8j6v3a9aqr85?svg=true)](https://ci.appveyor.com/project/borodust/notalone)

# NOTALONE

You wake up nowhere in the night. Hungry zombies around, but your ol' pal "BOOMSTICK" is with you.

SHOOT 'EM ALL!


## Controls
| Action  | Control |
|---------|---------|
| Shoot | Left mouse button |
| Run | WASD |
| Look around | Mouse cursor |

## Installation and running

Binaries available at [releases](https://github.com/borodust/notalone/releases) page.

You also can install it via `quicklisp`:

```lisp
(ql-dist:install-dist "http://bodge.borodust.org/dist/org.borodust.bodge.txt")

(ql:quickload :notalone)

(notalone:play-game)
```

## Requirements

* OpenGL 3.3+
* 64-bit (x86_64) Windows, GNU/Linux or macOS
* x86_64 SBCL or CCL


## Info

Made with [trivial-gamekit](https://github.com/borodust/trivial-gamekit)
