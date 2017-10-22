(in-package :notalone)


(defstruct keyframe
  (origin (vec2 0 0) :type vec2 :read-only t)
  (end (vec2 0 0) :type vec2 :read-only t)
  (time 0 :type single-float :read-only t))


(defclass animation ()
  ((sequence :initarg :sequence :initform nil)))


(defun make-animation (sequence)
  (let ((frames (loop for (x-orig y-orig x-end y-end time) in (sort sequence #'< :key #'fifth)
                   collect (make-keyframe :origin (vec2 x-orig y-orig)
                                          :end (vec2 x-end y-end)
                                          :time (ge.util:f time)))))
    (make-instance 'animation :sequence (make-array (length frames)
                                                    :element-type 'keyframe
                                                    :initial-contents frames))))


(defun get-frame (animation time)
  (with-slots (sequence) animation
    (let* ((animation-length (- (keyframe-time (aref sequence (1- (length sequence))))
                                (keyframe-time (aref sequence 0))))
           (clamped (if (= animation-length 0)
                        0
                        (mod time animation-length))))
      (multiple-value-bind (result idx)
          (ge.util:search-sorted clamped sequence :test #'= :key #'keyframe-time)
        (or result (aref sequence (max (1- idx) 0)))))))
