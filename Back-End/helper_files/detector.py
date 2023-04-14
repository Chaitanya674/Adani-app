from unittest import result
import torch
import numpy as np
import cv2
import os

model = torch.hub.load('ultralytics/yolov5', 'custom', path='yolov5/runs/train/exp10/weights/last.pt')

class detector():
    #detection from a folder
    def detection_image(self, dir_path):
        for (root,dirs,files) in os.walk(dir_path, topdown=True):
            for images in files:
                img = f'{dir_path}/{images}'
                results = model(img)
                results.print()
                print(result)

    #for video Camera
    def detection_video(self):
        cap = cv2.VideoCapture(0)
        while cap.isOpened():
            ret, frame = cap.read()
            results = model(frame)
            cv2.imshow('YOLO', np.squeeze(results.render()))
            if cv2.waitKey(10) & 0xFF == ord('q'):
                break
        cap.release()
        cv2.destroyAllWindows()