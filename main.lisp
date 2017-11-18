(in-package :notalone)


(define-constant +diagonal-unit+ 0.70710677
  :test #'=)


(define-sound 'orbital-colossus "sounds/Orbital_Colossus.ogg")


(defgame notalone ()
  ((world :initform (make-instance 'world))
   (game-state))
  (:resource-path (:notalone (asdf:system-relative-pathname :notalone "assets/")))
  (:viewport-width *viewport-width*)
  (:viewport-height *viewport-height*)
  (:viewport-title "NOTALONE")
  (:prepare-resources nil))


(defmethod post-initialize :after ((this notalone))
  (with-slots (game-state) this
    (flet ((%look-at (x y)
             (look-at game-state x y)))
      (bind-cursor #'%look-at))
    (labels ((%bind-button (button)
               (bind-button button :pressed
                            (lambda ()
                              (press-key game-state button)))
               (bind-button button :released
                            (lambda ()
                              (release-key game-state button)))))
      (%bind-button :w)
      (%bind-button :a)
      (%bind-button :s)
      (%bind-button :d)
      (%bind-button :enter))
    (bind-button :mouse-left :pressed (lambda () (shoot game-state)))
    (setf game-state (make-instance 'resource-preparation))
    (prepare-resources this
                       'zombie 'brains-1 'brains-2 'brains-3 'groan 'crackly-groan
                       'shotgun-fire 'shotgun
                       'orbital-colossus)))


(defmethod notice-resources ((this notalone) &rest resource-names)
  (declare (ignore resource-names))
  (with-slots (game-state world) this
    (labels ((restart-game ()
               (setf world (make-instance 'world))
               (start-game))
             (end-game ()
               (setf game-state (make-instance 'game-end :world world :restart #'restart-game)))
             (start-game ()
               (setf game-state (make-instance 'game :end #'end-game :world world))))
      (setf game-state (make-instance 'game-start :start #'start-game)))))


(defun unbind-buttons ()
  (loop for button in '(:w :a :s :d :mouse-left)
     do (bind-button button :pressed nil)
     do (bind-button button :released nil)))


(defmethod draw ((this notalone))
  (with-slots (game-state) this
    (render game-state)))


(defmethod act ((this notalone))
  (with-slots (game-state) this
    (act game-state)))


(defun play-game (&optional blocking)
  (gamekit:start 'notalone :blocking blocking))
