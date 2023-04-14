from flask import Flask, request, json
import torch
import numpy as np
from flask_pymongo import PyMongo
import matplotlib.pyplot as plt
import os
from PIL import Image
import pytesseract

app = Flask(__name__ , static_folder='result')

#######################
#Connecting to the data Base
app.config['MONGO_URI'] = "mongodb://localhost:27017/company"
mongo = PyMongo(app)
#######################

@app.route('/text' , methods=['POST' ,'GET'])
def result_return():
    if 'file' in request.files:
        image = request.files['file']
        image.save('./static/'+image.filename)
        img = Image.open(fr"./static/{image.filename}")
        pytesseract.pytesseract.tesseract_cmd = r'.\Tesseract-OCR\tesseract'
        text = pytesseract.image_to_string(img)
        text_num = Licence_number_dec(text)
        text_lic_num = Licence_number_dec_with_lic(text)
        img1 = open(f'./static/{image.filename}' , 'rb')
        mongo.save_file(image.filename , img1)
        img1.close()
        mongo.db.result_info.insert_one({ 'filename' : image.filename, "file_for" : 'Adani_product_verification',
        'number' : f'{text_num}' , 'data' : f'{text_lic_num}'})
        in_db = mongo.db.Batch_No.find_one({"ID": f"{text_num}"})
        if in_db:
            T = "product is of Fortune"
        else:
            T = "profuct in not of Fortune"
        return json.dumps({"message" : f"{text_lic_num} \n {text_num} \n{T}" }) , os.remove(fr'./static/{image.filename}')
    else:
        return "Erorr no file found"

@app.route("/api" , methods=['POST', 'GET'])
def handle_form ():
    if 'file' in request.files:
        image  = request.files['file']
        model = torch.hub.load('ultralytics/yolov5', 'custom', path='yolov5/runs/train/exp11/weights/last.pt')
        model.classes = [16,17,18,19,20,21,22,23,24,25]
        image.save('./static/'+image.filename)
        img = fr'./static/{image.filename}'
        results = model(img)
        plt.imshow(np.squeeze(results.render()))
        plt.axis('off')
        plt.savefig("./result/result-"+image.filename ,bbox_inches = 'tight')
        df = results.pandas().xyxy[0]
        result = df.loc[:,"name"]
        result_img = open(f'./result/result-{image.filename}' , "rb")
        mongo.save_file("result-"+image.filename , result_img)
        mongo.db.result_info.insert_one({ 'filename' : image.filename,"file_of" : 'Adani_product_detection' ,'data' : f'{df}', 'result': f"{result}"})
        result_img.close()
        return json.dumps({"message" : f"{result}"}) , os.remove(fr"./result/result-{image.filename}"), os.remove(fr'./static/{image.filename}')
    else:
        return "Erorr no file found"

@app.route("/app" , methods=['POST', 'GET'])
def handle_form ():
    if 'file' in request.files:
        img = request.files['file']
        img.save(img.filename)
    # Load the TFLite model

    print("send")
    interpreter = tf.lite.Interpreter(model_path="./model.tflite")
    interpreter.allocate_tensors()

    # Get input and output tensors
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    # Load the JPEG image from the request and resize it to the model's input size
    image = tf.io.decode_jpeg(request.files['file'].read(), channels=3)
    image = tf.image.resize(image, (224, 224))

    # Convert the image to uint8 type
    image = tf.cast(image, tf.uint8)

    # Add batch dimension to the image
    image = np.expand_dims(image, axis=0)

    # Set the input tensor
    interpreter.set_tensor(input_details[0]['index'], image)

    # Run the model
    interpreter.invoke()

    # Get the output tensor
    output = interpreter.get_tensor(output_details[0]['index'])

    # Get the predicted class
    predicted_class = np.argmax(output)

    # Return the predicted class as a JSON response
    return jsonify({'class': int(predicted_class)})


def Licence_number_dec(txt):
    index = txt.find("Lic. No. : ")
    only_lic = txt[index+11:index+11+14]
    return only_lic

def Licence_number_dec_with_lic(txt):
    index = txt.find("Lic. No. : ")
    with_lic = txt[index:index+11+14]
    return  with_lic

if __name__ =="__main__":
    app.run(debug = True)