(in-package :notalone)


(define-constant +diagonal-unit+ 0.70710677
  :test #'=)


(defclass notalone (gamekit:gamekit-system)
  ((world :initform (make-instance 'world))
   (last-zombie-spawned :initform 0)
   (keyboard))
  (:default-initargs
    :resource-path (asdf:system-relative-pathname :notalone "assets/")
    :viewport-width *viewport-width*
    :viewport-height *viewport-height*
    :viewport-title "notALone"))


(defun key-combination-to-velocity (keyboard)
  (cond
    ((key-combination-pressed-p keyboard :w :d) (vec2 +diagonal-unit+ +diagonal-unit+))
    ((key-combination-pressed-p keyboard :s :d) (vec2 +diagonal-unit+ (- +diagonal-unit+)))
    ((key-combination-pressed-p keyboard :a :s) (vec2 (- +diagonal-unit+) (- +diagonal-unit+)))
    ((key-combination-pressed-p keyboard :a :w) (vec2 (- +diagonal-unit+) +diagonal-unit+))
    ((key-combination-pressed-p keyboard :w) (vec2 0 1))
    ((key-combination-pressed-p keyboard :a) (vec2 -1 0))
    ((key-combination-pressed-p keyboard :s) (vec2 0 -1))
    ((key-combination-pressed-p keyboard :d) (vec2 1 0))
    (t (vec2 0 0))))


(defmethod post-initialize :after ((this notalone))
  (with-slots (world keyboard) this
    (flet ((%look-at (x y)
             (look-at (player-of world) x y)))
      (bind-cursor #'%look-at))
    (labels ((update-velocity (keyboard)
               (setf (velocity-of (player-of world)) (mult (key-combination-to-velocity keyboard)
                                                           *player-speed*)))
             (%bind-button (button)
               (bind-button button :pressed
                            (lambda ()
                              (press-key keyboard button)))
               (bind-button button :released
                            (lambda ()
                              (release-key keyboard button)))))
      (setf keyboard (make-instance 'keyboard :on-state-change #'update-velocity))
      (%bind-button :w)
      (%bind-button :a)
      (%bind-button :s)
      (%bind-button :d))
    (bind-button :mouse-left :pressed (lambda () (fire-shotgun world)))))


(defun unbind-buttons ()
  (loop for button in '(:w :a :s :d :mouse-left)
     do (bind-button button :pressed nil)
     do (bind-button button :released nil)))


(defmethod act ((this notalone))
  (with-slots (world last-zombie-spawned) this
    (lead-zombies world)
    (unless (dead-p (player-of world))
      (let ((current-time (ge.util:real-time-seconds))
            (player-position (position-of (player-of world))))
        (when (> (- current-time last-zombie-spawned) 1)
          (setf last-zombie-spawned current-time)
          (let* ((angle (random (* 2 pi)))
                 (position (add player-position (mult (rotate-vec (vec2 1 0) angle)
                                                      (+ 300 (random 300))))))
            (spawn-zombie world (x position) (y position)))))
      (when (zombies-won-p world)
        (kill-player (player-of world))
        (unbind-buttons)))))


(defmethod initialize-resources ((this notalone))
  (import-image :zombie "images/zombie.png")
  (import-image :shotgun-fire "images/shotgun_fire.png"))


(defmethod draw ((this notalone))
  (with-slots (world) this
    (render world)))


(defun play-game ()
  (gamekit:start 'notalone))
