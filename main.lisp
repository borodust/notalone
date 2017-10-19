(in-package :notalone)


(defvar *black* (vec4 0 0 0 1))
(defvar *white* (vec4 1 1 1 1))

(defclass notalone (gamekit:gamekit-system)
  ()
  (:default-initargs
    :viewport-width 800
    :viewport-height 600))


(defmethod draw ((this notalone))
  (draw-rect (vec2 0 0) 800 600 :fill-paint *black*)
  (ge.vg:with-pushed-canvas ()
    (ge.vg:translate-canvas 400 300)
    (ge.vg:rotate-canvas (* (mod (* 100 (ge.util:epoch-seconds)) 360) (/ pi 180)))
    (draw-flashlight)))


(defun draw-flashlight ()
  (let ((start-angle (* 2.5 (/ pi 8)))
        (end-angle (* 5.5 (/ pi 8)))
        (radius 250)
        (aa-delta 1.0))
    (draw-arc (vec2 0 0) radius start-angle end-angle :fill-paint *white*)
    (draw-polygon (list (vec2 -25 0) (vec2 25 0)
                        (vec2 (* radius (cos start-angle)) (+ aa-delta (* radius (sin start-angle))))
                        (vec2 (* radius (cos end-angle)) (+ aa-delta (* radius (sin end-angle)))))
                  :fill-paint *white*)
    (draw-arc (vec2 0 -95) 100 start-angle end-angle :fill-paint *black*)))
