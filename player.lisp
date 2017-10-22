(in-package :notalone)


(defparameter *shotgun-fire* (make-animation '((0 0 160 160 0.0)
                                               (160 0 320 160 0.15)
                                               (320 0 480 160 0.2)
                                               (480 0 600 160 0.3)
                                               (0 0 0 0 0.4))))

(defclass player (movable positionable renderable)
  ((position-updated :initform (ge.util:epoch-seconds))))


(defun calc-position (player current-time)
  (with-slots (position-updated) player
    (if (/= current-time position-updated)
        (let ((time-delta (- current-time position-updated)))
          (setf position-updated current-time
                (position-of player) (add (position-of player)
                                          (mult (velocity-of player) time-delta))))
        (position-of player))))


(defun look-at (player x y)
  (setf (angle-of player) (- (atan (- y (y *viewport-center*)) (- x (x *viewport-center*)))
                             (/ pi 2))))


(defmethod render ((this player))
  (let ((start-angle (* 2.5 (/ pi 8)))
        (end-angle (* 5.5 (/ pi 8)))
        (radius 250)
        (aa-delta 1.0))
    (draw-arc *viewport-origin* radius start-angle end-angle :fill-paint *white*)
    (draw-polygon (list (vec2 -5 0) (vec2 5 0)
                        (vec2 (* radius (cos start-angle)) (+ aa-delta (* radius (sin start-angle))))
                        (vec2 (* radius (cos end-angle)) (+ aa-delta (* radius (sin end-angle)))))
                  :fill-paint *white*)
    (draw-arc (vec2 0 -9) 10 start-angle end-angle :fill-paint *black*)
    (let ((frame (get-frame *shotgun-fire* (ge.util:real-time-seconds))))
      (draw-image (vec2 -80 0) :shotgun-fire
                  :image-origin (keyframe-origin frame)
                  :image-end (keyframe-end frame)))))
