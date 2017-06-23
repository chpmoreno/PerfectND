# PerfectND - The Perfect Natural Dryer
This repository contains the project "PerfectND": a presentation and the scripts used to develop our first approach to the prototype of our product. The product is a tool to improve citizents quality of life through an optimized methodology to select the moment and amount of time to leave the clothes drying to avoid bad smells.

In this first approach we measure the temperature, humidity and pressure in the enviorment where the clothes are placed. With this measures the model detects when the clothes are already dry and when they start smelling bad due to exposure in city air. 
    cnn_model.py - Defines/builds the 3-layer CNN and the image preprocessing function
    ImageConvNet.py - Organizes the plant images and trains the CNN
    run_cv_rpi.py - Script that lets the Pi take an image every 60seconds and classifies the underlying plant as being healthy or not. If a disease is detected then a notification is send to a slack channel.

In order to obtain the necessary training data please download it like this:
