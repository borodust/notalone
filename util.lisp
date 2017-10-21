(in-package :notalone)

(defvar *black* (vec4 0 0 0 1))
(defvar *white* (vec4 1 1 1 1))


(defgeneric render (object)
  (:method (object) (declare (ignore object))))


(defclass renderable () ())


(defmethod render :around ((this renderable))
  (ge.vg:with-pushed-canvas ()
    (call-next-method)))


(defclass positionable ()
  ((x :initform 0 :accessor x-of)
   (y :initform 0 :accessor y-of)
   (angle :initform 0 :accessor angle-of)))


(defmethod render :before ((this positionable))
  (ge.vg:translate-canvas (x-of this) (y-of this))
  (ge.vg:rotate-canvas (angle-of this)))
