(cl:in-package :notalone)


(defstruct keyframe
  (origin (vec2 0 0) :type vec2 :read-only t)
  (end (vec2 0 0) :type vec2 :read-only t)
  (time 0 :type single-float :read-only t))


(defclass animation ()
  ((sequence :initarg :sequence :initform nil)
   (looped-p :initarg :looped-p :initform nil)
   (started :initform 0 :reader start-time-of)))


(defun make-animation (sequence &key looped-p)
  (let ((frames (loop for (x-orig y-orig x-end y-end time) in (sort sequence #'< :key #'fifth)
                   collect (make-keyframe :origin (vec2 x-orig y-orig)
                                          :end (vec2 x-end y-end)
                                          :time (ge.util:f time)))))
    (make-instance 'animation
                   :looped-p looped-p
                   :sequence (make-array (length frames)
                                         :element-type 'keyframe
                                         :initial-contents frames))))


(defun start-animation (animation current-time)
  (with-slots (started) animation
    (setf started current-time)))


(defun animation-length (animation)
  (with-slots (sequence) animation
    (- (keyframe-time (aref sequence (1- (length sequence))))
       (keyframe-time (aref sequence 0)))))


(defun get-looped-time (animation time)
  (let* ((animation-length (animation-length animation)))
    (if (= animation-length 0)
        0
        (mod time animation-length))))


(defun get-frame (animation current-time)
  (with-slots (sequence started looped-p) animation
    (let* ((time-delta (- current-time started))
           (animation-timestamp (if looped-p (get-looped-time animation time-delta) time-delta)))
      (multiple-value-bind (result idx)
          (ge.util:search-sorted animation-timestamp sequence :test #'= :key #'keyframe-time)
        (or result (aref sequence (max (1- idx) 0)))))))
