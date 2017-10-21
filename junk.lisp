(in-package :notalone)


(defclass junk (positionable renderable) ())


(defmethod render ((this junk))
  (draw-rect (vec2 0 0) 80 30 :stroke-paint (vec4 0 0 0 1) :thickness 1.5))
