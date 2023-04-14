import torch
import numpy as np
import matplotlib.pyplot as plt
import data_gen 
import cv2
from data_gen import *
import os


'''Declaring the Object from the library'''

'''Detection throygh a directory'''
# dec.detection_image('./result')
'''detection through a Video Cam''' 

'''Detection in an image and then saving it as result.jpg'''
model = torch.hub.load('ultralytics/yolov5', 'custom', path='yolov5/runs/train/exp8/weights/last.pt')

cap = cv2.VideoCapture(0)

while cap.isOpened():
    ret, frame = cap.read()
    results = model(frame)
    cv2.imshow('YOLO', np.squeeze(results.render()))
    if cv2.waitKey(10) & 0xFF == ord('q'):
        break
cap.release()
cv2.destroyAllWindows()

def detection_image( dir_path):
    for (root,dirs,files) in os.walk(dir_path, topdown=True):
        for images in files:
            img = f'{dir_path}/{images}'
            results = model(img)
            plt.imshow(np.squeeze(results.render()))
            plt.axis('off')
            plt.savefig("./test/test1.jpg" ,bbox_inches = 'tight')

# detection_image("./test")

# img = r'result\img7.jpg'
# results = model(img)
# results.print()
# plt.imshow(np.squeeze(results.render()))
# plt.axis('off')
# df = results.pandas().xyxy[0]
# results.show()
# plt.savefig("result19.jpg",bbox_inches = 'tight')
# print(df.loc[:,"name"])