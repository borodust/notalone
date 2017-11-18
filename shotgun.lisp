(in-package :notalone)


(define-image 'shotgun-fire "images/shotgun_fire.png")
(define-sound 'shotgun "sounds/shotgun.wav")

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
    (play 'shotgun)
    (start-animation fire-animation (ge.util:real-time-seconds))))


(defun shot-expired-p (shotgun current-time)
  (with-slots (fire-animation) shotgun
    (> (- current-time (start-time-of fire-animation))
       (animation-length fire-animation))))


(defmethod render ((this shotgun))
  (with-slots (fire-animation) this
  (with-pushed-canvas ()
    (rotate-canvas (- (/ pi 2)))
    (let* ((frame (get-frame fire-animation (ge.util:real-time-seconds)))
           (origin (keyframe-origin frame))
           (end (keyframe-end frame)))
      (draw-image (vec2 -80 0) 'shotgun-fire
                  :origin origin
                  :width (- (x end) (x origin))
                  :height (- (y end) (y origin)))))))
