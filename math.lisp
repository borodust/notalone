(cl:in-package :notalone)

;; https://codereview.stackexchange.com/a/86428
(defun intersect-p (segment-start segment-end circle-center circle-radius)
  (let* ((p1 segment-start)
         (p2 segment-end)
         (q circle-center)
         (r circle-radius)
         (v (subt p2 p1))
         (a (ge.ng:dot v v))
         (b (* 2 (ge.ng:dot v (subt p1 q))))
         (c (+ (ge.ng:dot p1 p1) (ge.ng:dot q q)
               (- (* 2 (ge.ng:dot p1 q)))
               (- (expt r 2))))
         (disc (- (expt b 2) (* 4 a c))))
    (if (< disc 0)
        nil
        (let* ((sqrt-disc (sqrt disc))
               (t1 (/ (+ (- b) sqrt-disc)
                      (* 2 a)))
               (t2 (/ (- (- b) sqrt-disc)
                      (* 2 a))))
          (or (<= 0 t1 1)
              (<= 0 t2 1))))))


(defun rotate-vec (vec angle)
  (vec2 (- (* (x vec) (cos angle)) (* (y vec) (sin angle)))
        (+ (* (x vec) (sin angle)) (* (y vec) (cos angle)))))
