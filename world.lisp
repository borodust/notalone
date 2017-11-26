(in-package :notalone)


(defclass world (renderable)
  ((player :initform (make-instance 'player) :reader player-of)
   (frags :initform 0)
   (zombies :initform nil)
   (junk :initform nil)
   (shots :initform nil)))


(defun zombie-hit-p (player zombie)
  (let ((player-pos (position-of player)))
    (intersect-p player-pos (add player-pos (mult (rotate-vec (vec2 1 0) (angle-of player)) 130))
                 (add (vec2 30 35) (position-of zombie)) 40)))


(defun fire-shotgun (world)
  (with-slots (shots player zombies frags) world
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
                     as hit-p = (zombie-hit-p player zombie)
                     when hit-p do (incf frags)
                     unless hit-p collect zombie))))


(defun spawn-zombie (world x y)
  (with-slots (zombies) world
    (push (make-instance 'zombie :position (vec2 x y)) zombies)))


(defun lead-zombies (world)
  (with-slots (zombies) world
    (loop for zombie in zombies
       do (seek-player zombie (player-of world)))))


(defun zombies-won-p (world)
  (with-slots (zombies player) world
    (loop for zombie in zombies
       thereis (< (ge.math:vector-length (subt (position-of player)
                                               (add (vec2 30 35) (position-of zombie))))
                  50))))


(defmethod render ((this world))
  (with-slots (player zombies junk shots frags) this
    (let ((player-position (calc-position player (ge.util:real-time-seconds))))
      (draw-rect *viewport-origin* *viewport-width* *viewport-height* :fill-paint *black*)
      (draw-text (format nil "~A" frags) (vec2 10 10) :fill-color *white*)
      (translate-canvas (x *viewport-center*) (y *viewport-center*))
      (with-pushed-canvas ()
        (rotate-canvas (angle-of player))
        (render player))
      (loop for zombie in zombies
         do (with-pushed-canvas ()
              (let ((zombie-pos (calc-position zombie (ge.util:real-time-seconds))))
                (translate-canvas (- (x zombie-pos) (x player-position))
                                  (- (y zombie-pos) (y player-position))))
              (render zombie)))
      (loop for thing in junk
         do (with-pushed-canvas ()
              (translate-canvas (- (x (position-of junk)) (x player-position))
                                      (- (y (position-of junk)) (y player-position)))
              (render junk)))
      (loop for shot in shots
         do (with-pushed-canvas ()
              (let ((shot-position (position-of shot)))
                (translate-canvas (- (x shot-position) (x player-position))
                                        (- (y shot-position) (y player-position))))
              (rotate-canvas (angle-of shot))
              (render shot)))
      (when (dead-p player)
        (draw-text "YOU DIED" (vec2 -50 100) :fill-color *black*)
        (draw-text "YOU DIED" (vec2 -50 -100) :fill-color *white*)))))
