(cl:in-package :notalone)


(defvar *player-speed* 100) ; px/sec


(defclass player (movable renderable)
  ((dead-p :initform nil :reader dead-p)))


(defun kill-player (player)
  (with-slots (dead-p) player
    (setf dead-p t)))


(defgeneric look-at (player x y)
  (:method (player x y)))

(defmethod look-at ((player player) x y)
  (setf (angle-of player) (atan (- y (y *viewport-center*)) (- x (x *viewport-center*)))))


(defmethod render ((this player))
  (with-pushed-canvas ()
    (rotate-canvas (- (/ pi 2)))
    (let ((start-angle (* 2.5 (/ pi 8)))
          (end-angle (* 5.5 (/ pi 8)))
          (radius 250)
          (aa-delta 1.0))
      (draw-arc *viewport-origin* radius start-angle end-angle :fill-paint *white*)
      (draw-polygon (list (vec2 -5 0) (vec2 5 0)
                          (vec2 (* radius (cos start-angle)) (+ aa-delta (* radius (sin start-angle))))
                          (vec2 (* radius (cos end-angle)) (+ aa-delta (* radius (sin end-angle)))))
                    :fill-paint *white*)
      (draw-arc (vec2 0 -9) 10 start-angle end-angle :fill-paint *black*))))
