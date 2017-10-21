(in-package :notalone)


(defclass zombie (positionable renderable) ())


(defmethod render ((this zombie))
  (draw-image *viewport-origin* :zombie))
