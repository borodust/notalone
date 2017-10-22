(in-package :notalone)


(defclass world (renderable)
  ((player :initform (make-instance 'player) :reader player-of)
   (zombie :initform (make-instance 'zombie))
   (junk :initform (make-instance 'junk))
   (shots :initform nil)))


(defun fire-shotgun (world)
  (with-slots (shots player) world
    (setf shots (loop for shot in shots
                   unless (shot-expired-p shot (ge.util:real-time-seconds))
                   collect shot))
    (let* ((player-pos (position-of player))
           (shot (make-instance 'shotgun
                                :position (vec2 (x player-pos) (y player-pos))
                                :angle (angle-of player))))
      (pull-trigger shot)
      (push shot shots))))


(defmethod render ((this world))
  (with-slots (player zombie junk shots) this
    (let ((player-position (calc-position player (ge.util:epoch-seconds))))
      (draw-rect *viewport-origin* *viewport-width* *viewport-height* :fill-paint *black*)
      (ge.vg:translate-canvas (x *viewport-center*) (y *viewport-center*))
      (ge.vg:with-pushed-canvas ()
        (ge.vg:rotate-canvas (angle-of player))
        (render player))
      (ge.vg:with-pushed-canvas ()
        (ge.vg:translate-canvas (- (x (position-of zombie)) (x player-position))
                                (- (y (position-of zombie)) (y player-position)))
        (render zombie))
      (ge.vg:with-pushed-canvas ()
        (ge.vg:translate-canvas (- 100 (x player-position)) (- 10 (y player-position)))
        (render junk))
      (loop for shot in shots
         do (ge.vg:with-pushed-canvas ()
              (let ((shot-position (position-of shot)))
                (ge.vg:translate-canvas (- (x shot-position) (x player-position))
                                        (- (y shot-position) (y player-position))))
              (ge.vg:rotate-canvas (angle-of shot))
              (render shot))))))
