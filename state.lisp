(cl:in-package :notalone)


(defgeneric shoot (keyboard)
  (:method (keyboard)))


(defclass game-state () ())


(defmethod act ((this game-state))
  (declare (ignore this)))


;;;
;;;
;;;
(defclass resource-preparation (game-state) ())


(defmethod render ((this resource-preparation))
  (draw-rect *viewport-origin* *viewport-width* *viewport-height* :fill-paint *black*)
  (draw-text "NOTALONE" (vec2 320 400) :fill-color *white*)
  (draw-text "Loading..." (vec2 330 100) :fill-color *white*))


;;;
;;;
;;;
(defclass game-start (game-state)
  ((start-callback :initarg :start)))


(defmethod initialize-instance :after ((this game-start) &key)
  (play-sound 'crackly-groan :looped-p t))


(defmethod press-key ((this game-start) (key (eql :enter)))
  (with-slots (start-callback) this
    (stop-sound 'crackly-groan)
    (funcall start-callback)))


(defmethod render ((this game-start))
  (draw-rect *viewport-origin* *viewport-width* *viewport-height* :fill-paint *black*)
  (draw-text "NOTALONE" (vec2 320 400) :fill-color *white*)
  (draw-text "Press Enter to start" (vec2 280 100) :fill-color *white*))


;;;
;;;
;;;
(defclass game (game-state)
  ((keyboard)
   (last-groan :initform 0)
   (end-callback :initarg :end)
   (last-zombie-spawned :initform 0)
   (world :initarg :world)))


(defmethod press-key ((this game) key)
  (with-slots (keyboard) this
    (press-key keyboard key)))


(defmethod release-key ((this game) key)
  (with-slots (keyboard) this
    (release-key keyboard key)))


(defmethod shoot ((this game))
  (with-slots (world) this
    (fire-shotgun world)))


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


(defmethod look-at ((this game) x y)
  (with-slots (world) this
    (look-at (player-of world) x y)))


(defmethod initialize-instance :after ((this game) &key)
  (with-slots (keyboard world) this
    (labels ((update-velocity (keyboard)
               (setf (velocity-of (player-of world)) (mult (key-combination-to-velocity keyboard)
                                                           *player-speed*))))
      (setf keyboard (make-instance 'keyboard :on-state-change #'update-velocity))
      (play-sound 'orbital-colossus))))


(defmethod act ((this game))
  (with-slots (world last-zombie-spawned end-callback last-groan) this
    (lead-zombies world)
    (unless (dead-p (player-of world))
      (let ((current-time (ge.util:real-time-seconds))
            (player-position (position-of (player-of world))))
        (when (> (- current-time last-groan) 2)
          (play-sound (aref +zombie-spawn-sounds+ (random (length +zombie-spawn-sounds+))))
          (setf last-groan current-time))
        (when (> (- current-time last-zombie-spawned) 1)
          (setf last-zombie-spawned current-time)
          (let* ((angle (random (* 2 pi)))
                 (position (add player-position (mult (rotate-vec (vec2 1 0) angle)
                                                      (+ 300 (random 300))))))
            (spawn-zombie world (x position) (y position)))))
      (when (zombies-won-p world)
        (kill-player (player-of world))
        (funcall end-callback)))))


(defmethod render ((this game))
  (with-slots (world) this
    (render world)))

;;;
;;;
;;;
(defclass game-end (game-state)
  ((world :initarg :world)
   (restart-callback :initarg :restart)))


(defmethod render ((this game-end))
  (with-slots (world) this
    (render world)
    (draw-text "Press Enter to restart game" (vec2 250 100) :fill-color *white*)))


(defmethod look-at ((this game-end) x y)
  (with-slots (world) this
    (look-at (player-of world) x y)))


(defmethod press-key ((this game-end) (key (eql :enter)))
  (with-slots (restart-callback) this
    (funcall restart-callback)))
