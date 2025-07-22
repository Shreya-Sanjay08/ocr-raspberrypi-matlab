# 🔍 OCR Text Extractor – Raspberry Pi + MATLAB

An OCR system that captures and extracts **handwritten or printed text** using MATLAB's OCR capabilities and a Raspberry Pi camera module.

## 🎯 Features
- Capture image using Raspberry Pi camera
- Transfer image to MATLAB via SSH/SCP
- Apply image preprocessing (grayscale, binarization, filtering)
- Perform text extraction using `ocr()` function
- UI interface for manual text correction
- Display bounding boxes for recognized words

## 🛠 Tech Stack
- **Hardware**: Raspberry Pi 3B+, Pi Camera V2
- **Software**: MATLAB, Image Processing Toolbox
- **Languages**: MATLAB Script, Bash

## 📦 Project Structure
- `capture_image.sh` – Pi-side script
- `ocr_main.m` – MATLAB main script
- `image_processing.m` – Preprocessing
- `ui_text_edit.m` – Correction GUI

## 📸 Screenshots

** Dialogue box that helps users edit the message**
<img width="621" height="517" alt="image" src="https://github.com/user-attachments/assets/27ed718c-b1c1-47fb-975b-35d5e24cbfcd" />

** Image of bounding boxes around the identified words**
<img width="619" height="375" alt="image" src="https://github.com/user-attachments/assets/d3a52942-d1ac-4086-98be-bf9c573c619a" />


## 📈 Results
- Tested on handwritten + printed text
- Accurate bounding boxes and OCR output
