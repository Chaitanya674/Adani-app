import os

class data_gen():

    def start_train(self):
        os.system('cd yolov5 && python train.py --img 320 --batch 16 --epochs 500 --data dataset.yml --weights yolov5s.pt --workers 2')