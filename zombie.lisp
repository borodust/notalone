(cl:in-package :notalone)


(define-image 'zombie "images/zombie.png")
(define-sound 'brains-1 "sounds/spooky/brains.ogg")
(define-sound 'brains-2 "sounds/spooky/brains2.ogg")
(define-sound 'brains-3 "sounds/spooky/brains3.ogg")
(define-sound 'groan "sounds/spooky/groan.ogg")
(define-sound 'crackly-groan "sounds/spooky/crackly_groan.ogg")


(define-constant +zombie-spawn-sounds+ #(brains-1 brains-2 brains-3 groan)
  :test #'equalp)


(defparameter *zombie-walk-front* (make-animation '((0 219 62 291 0)
                                                    (124 219 186 291 0.25)
                                                    (0 219 62 291 0.5))
                                                  :looped-p t))


(defparameter *zombie-walk-back* (make-animation '((0 72 62 144 0)
                                                   (125 72 186 144 0.25)
                                                   (0 72 62 144 0.5))
                                                 :looped-p t))


(defparameter *zombie-walk-right* (make-animation '((0 144 62 219 0)
                                                    (121 145 186 219 0.25)
                                                    (0 144 62 219 0.5))
                                                  :looped-p t))


(defparameter *zombie-walk-left* (make-animation '((0 0 60 72 0)
                                                   (120 1 186 72 0.25)
                                                   (0 0 60 72 0.5))
                                                 :looped-p t))


(defparameter *zombie-speed* 110)


(defclass zombie (movable renderable) ())


(defun seek-player (zombie player)
  (if (dead-p player)
      (setf (velocity-of zombie) (vec2 0 0))
      (let* ((zombie-position (position-of zombie))
             (player-position (position-of player)))
        (setf (velocity-of zombie) (mult (ge.ng:normalize (vec2 (- (x player-position)
                                                                     (x zombie-position)
                                                                     30)
                                                                  (- (y player-position)
                                                                     (y zombie-position)
                                                                     35)))
                                         *zombie-speed*)))))


(defmethod render ((this zombie))
  (let* ((frame (get-frame *zombie-walk-front* (bodge-util:real-time-seconds)))
         (origin (keyframe-origin frame))
         (end (keyframe-end frame)))
    (draw-image *viewport-origin* 'zombie
                :origin (keyframe-origin frame)
                :width (- (x end) (x origin))
                :height (- (y end) (y origin)))))
