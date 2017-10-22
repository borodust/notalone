(in-package :notalone)


(defclass world (renderable)
  ((player :initform (make-instance 'player) :reader player-of)
   (zombies :initform nil)
   (junk :initform nil)
   (shots :initform nil)))


(defun rotate-vec (vec angle)
  (vec2 (- (* (x vec) (cos angle)) (* (y vec) (sin angle)))
        (+ (* (x vec) (sin angle)) (* (y vec) (cos angle)))))


(defun zombie-hit-p (player zombie)
  (let ((player-pos (position-of player)))
    (intersect-p player-pos (add player-pos (mult (rotate-vec (vec2 1 0) (angle-of player)) 130))
                 (add (vec2 30 35) (position-of zombie)) 40)))


(defun fire-shotgun (world)
  (with-slots (shots player zombies) world
    (setf shots (loop for shot in shots
                   unless (shot-expired-p shot (ge.util:real-time-seconds))
                   collect shot))
    (let* ((player-pos (position-of player))
           (shot (make-instance 'shotgun
                                :position (vec2 (x player-pos) (y player-pos))
                                :angle (angle-of player))))
      (pull-trigger shot)
      (push shot shots))
    (setf zombies (loop for zombie in zombies
                     unless (zombie-hit-p player zombie)
                     collect zombie))))


(defun spawn-zombie (world x y)
  (with-slots (zombies) world
    (push (make-instance 'zombie :position (vec2 x y)) zombies)))


(defun lead-zombies (world)
  (with-slots (zombies) world
    (loop for zombie in zombies
       do (seek-player zombie (player-of world)))))


(defmethod render ((this world))
  (with-slots (player zombies junk shots) this
    (let ((player-position (calc-position player (ge.util:epoch-seconds))))
      (draw-rect *viewport-origin* *viewport-width* *viewport-height* :fill-paint *black*)
      (ge.vg:translate-canvas (x *viewport-center*) (y *viewport-center*))
      (ge.vg:with-pushed-canvas ()
        (ge.vg:rotate-canvas (angle-of player))
        (render player))
      (loop for zombie in zombies
         do (ge.vg:with-pushed-canvas ()
              (let ((zombie-pos (calc-position zombie (ge.util:epoch-seconds))))
                (ge.vg:translate-canvas (- (x zombie-pos) (x player-position))
                                        (- (y zombie-pos) (y player-position))))
              (render zombie)))
      (loop for thing in junk
         do (ge.vg:with-pushed-canvas ()
              (ge.vg:translate-canvas (- (x (position-of junk)) (x player-position))
                                      (- (y (position-of junk)) (y player-position)))
              (render junk)))
      (loop for shot in shots
         do (ge.vg:with-pushed-canvas ()
              (let ((shot-position (position-of shot)))
                (ge.vg:translate-canvas (- (x shot-position) (x player-position))
                                        (- (y shot-position) (y player-position))))
              (ge.vg:rotate-canvas (angle-of shot))
              (render shot))))))
