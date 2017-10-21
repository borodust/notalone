(in-package :notalone)

(defvar *black* (vec4 0 0 0 1))
(defvar *white* (vec4 1 1 1 1))

(defvar *viewport-width* 800)
(defvar *viewport-height* 600)
(defvar *viewport-origin* (vec2 0 0))
(defvar *viewport-center* (vec2 (/ *viewport-width* 2) (/ *viewport-height* 2)))


;;;
;;; Rendering
;;;
(defgeneric render (object)
  (:method (object) (declare (ignore object))))


(defclass renderable () ())


(defmethod render :around ((this renderable))
  (ge.vg:with-pushed-canvas ()
    (call-next-method)))


;;;
;;; Position
;;;
(defgeneric (setf position-of) (vec2 positionable))


(defclass positionable ()
  ((position :initform (vec2 0 0) :reader position-of)
   (angle :initform 0 :accessor angle-of)))


(defmethod (setf position-of) ((vec vec2) (this positionable))
  (setf (x (position-of this)) (x vec)
        (y (position-of this)) (y vec))
  (position-of this))



;;;
;;; Moving
;;;
(defclass movable ()
  ((velocity :initform (vec2 0 0) :accessor velocity-of)))

;;;
;;; Keyboard
;;;
(defclass keyboard ()
  ((pressed-keys :initform nil :reader key-combination-of)
   (state-listener :initarg :on-state-change)))


(defun %invoke-state-listener (keyboard)
  (with-slots (state-listener) keyboard
    (when state-listener
      (funcall state-listener keyboard))))


(defun press-key (keyboard key)
  (with-slots (pressed-keys state-listener) keyboard
    (push key pressed-keys)
    (%invoke-state-listener keyboard)))


(defun release-key (keyboard key)
  (with-slots (pressed-keys) keyboard
    (deletef pressed-keys key)
    (%invoke-state-listener keyboard)))


(defun key-combination-pressed-p (keyboard &rest keys)
  (with-slots (pressed-keys) keyboard
    (set-equal (intersection pressed-keys keys) keys)))
