(in-package :notalone)

(defclass zombie (positionable renderable) ())


(defmethod render ((this zombie))
  (draw-rect (vec2 0 0) 80 140 :stroke-paint *black* :thickness 1.5))
