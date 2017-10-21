(in-package :notalone)


(defclass notalone (gamekit:gamekit-system)
  ((world :initform (make-instance 'world)))
  (:default-initargs
    :viewport-width 800
    :viewport-height 600
    :viewport-title "notALone"))


(defmethod post-initialize :after ((this notalone))
  (with-slots (world) this
    (flet ((%look-at (x y)
             (look-at (player-of world) x y)))
      (bind-cursor #'%look-at))))


(defmethod draw ((this notalone))
  (with-slots (world) this
    (render world)))


(defun play-game ()
  (gamekit:start 'notalone))
