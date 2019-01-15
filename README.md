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
(ql-dist:install-dist "http://bodge.borodust.org/dist/org.borodust.bodge.testing.txt")

(ql:quickload :notalone)

(notalone:play-game)
```

## Requirements

* OpenGL 3.3+
* 64-bit (x86_64) Windows, GNU/Linux or macOS
* x86_64 SBCL or CCL


## Credits

* Zombie sprites by [Curt](https://opengameart.org/content/zombie-rpg-sprites)
* Music "Orbital Colossus" by [Matthew Pablo](http://www.matthewpablo.com/game-soundtrack2)
* Spooky sounds by [bart](https://opengameart.org/content/25-spooky-sound-effects)
* Shotgun sound by [Marregheriti](https://freesound.org/people/Marregheriti/sounds/266105/)

Made with [trivial-gamekit](https://github.com/borodust/trivial-gamekit)
