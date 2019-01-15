(cl:in-package :notalone)

(defvar *black* (vec4 0 0 0 1))
(defvar *white* (vec4 1 1 1 1))

(defvar *viewport-width* 800)
(defvar *viewport-height* 600)
(defvar *viewport-origin* (vec2 0 0))
(defvar *viewport-center* (vec2 (/ *viewport-width* 2) (/ *viewport-height* 2)))


(define-constant +diagonal-unit+ 0.70710677
  :test #'=)

;;;
;;; Rendering
;;;
(defgeneric render (object)
  (:method (object) (declare (ignore object))))


(defclass renderable () ())


(defmethod render :around ((this renderable))
  (with-pushed-canvas ()
    (call-next-method)))


;;;
;;; Position
;;;
(defgeneric (setf position-of) (vec2 positionable))


(defclass positionable ()
  ((position :initform (vec2 0 0) :initarg :position :reader position-of)
   (angle :initform 0 :initarg :angle :accessor angle-of)))


(defmethod (setf position-of) ((vec vec2) (this positionable))
  (setf (x (position-of this)) (x vec)
        (y (position-of this)) (y vec))
  (position-of this))


(defmethod (setf position-of) ((vec vec2) (this positionable))
  (setf (x (position-of this)) (x vec)
        (y (position-of this)) (y vec))
  (position-of this))



;;;
;;; Moving
;;;
(defclass movable (positionable)
  ((velocity :initform (vec2 0 0) :accessor velocity-of)
   (last-updated :initform (bodge-util:real-time-seconds))))


(defun calc-position (movable current-time)
  (with-slots (last-updated) movable
    (if (/= current-time last-updated)
        (let ((time-delta (- current-time last-updated)))
          (setf last-updated current-time
                (position-of movable) (add (position-of movable)
                                           (mult (velocity-of movable) time-delta))))
        (position-of movable))))

;;;
;;; Keyboard
;;;

(defgeneric press-key (keyboard key)
  (:method (keyboard key)))

(defgeneric release-key (keyboard key)
  (:method (keyboard key)))


(defclass keyboard ()
  ((pressed-keys :initform nil :reader key-combination-of)
   (state-listener :initarg :on-state-change)))


(defun %invoke-state-listener (keyboard)
  (with-slots (state-listener) keyboard
    (when state-listener
      (funcall state-listener keyboard))))


(defmethod press-key ((keyboard keyboard) key)
  (with-slots (pressed-keys state-listener) keyboard
    (push key pressed-keys)
    (%invoke-state-listener keyboard)))


(defmethod release-key ((keyboard keyboard) key)
  (with-slots (pressed-keys) keyboard
    (deletef pressed-keys key)
    (%invoke-state-listener keyboard)))


(defun key-combination-pressed-p (keyboard &rest keys)
  (with-slots (pressed-keys) keyboard
    (set-equal (intersection pressed-keys keys) keys)))
