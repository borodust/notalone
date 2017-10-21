(in-package :notalone)


(defclass world (renderable)
  ((player :initform (make-instance 'player) :reader player-of)
   (zombie :initform (make-instance 'zombie))
   (junk :initform (make-instance 'junk))))


(defmethod initialize-instance :after ((this world) &key)
  (with-slots (player zombie junk) this
    (setf (x-of player) 400
          (y-of player) 300

          (x-of zombie) 300
          (y-of zombie) 400

          (x-of junk) 400
          (y-of junk) 350)))


(defmethod render ((this world))
  (with-slots (player zombie junk) this
    (draw-rect (vec2 0 0) 800 600 :fill-paint *black*)
    (render player)
    (render zombie)
    (render junk)))
