(in-package :notalone)


(defclass world (renderable)
  ((player :initform (make-instance 'player) :reader player-of)
   (zombie :initform (make-instance 'zombie))
   (junk :initform (make-instance 'junk))))


(defmethod render ((this world))
  (with-slots (player zombie junk) this
    (let ((player-position (calc-position player (ge.util:epoch-seconds))))
      (draw-rect *viewport-origin* *viewport-width* *viewport-height* :fill-paint *black*)
      (ge.vg:with-pushed-canvas ()
        (ge.vg:translate-canvas (x *viewport-center*) (y *viewport-center*))
        (ge.vg:rotate-canvas (angle-of player))
        (render player))
      (ge.vg:with-pushed-canvas ()
        (ge.vg:translate-canvas (- 300 (x player-position)) (- 400 (y player-position)))
        (render zombie))
      (ge.vg:with-pushed-canvas ()
        (ge.vg:translate-canvas (- 400 (x player-position)) (- 350 (y player-position)))
        (render junk)))))
