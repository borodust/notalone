(in-package :notalone)


(defclass shotgun (positionable renderable)
  ((fire-animation)))


(defmethod initialize-instance :after ((this shotgun) &key)
  (with-slots (fire-animation) this
    (setf fire-animation (make-animation '((0 0 160 160 0.0)
                                           (160 0 320 160 0.1)
                                           (320 0 480 160 0.15)
                                           (480 0 600 160 0.20)
                                           (0 0 0 0 0.3))))))


(defun pull-trigger (shotgun)
  (with-slots (fire-animation) shotgun
    (start-animation fire-animation (ge.util:real-time-seconds))))


(defun shot-expired-p (shotgun current-time)
  (with-slots (fire-animation) shotgun
    (> (- current-time (start-time-of fire-animation))
       (animation-length fire-animation))))


(defmethod render ((this shotgun))
  (with-slots (fire-animation) this
  (ge.vg:with-pushed-canvas ()
    (ge.vg:rotate-canvas (- (/ pi 2)))
    (let ((frame (get-frame fire-animation (ge.util:real-time-seconds))))
      (draw-image (vec2 -80 0) :shotgun-fire
                  :image-origin (keyframe-origin frame)
                  :image-end (keyframe-end frame))))))
