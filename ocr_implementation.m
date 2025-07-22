%OCR IMPLEMENTATION USING MATLAB AND RASPBERRY PI
while true
    x = input("Press the Enter key: ", 's');
    clf;
    if (x == "")
        ocr_rec()
    elseif(x=='q')
        return
    end
end

function ocr_rec()    
% Execute the SSH command to capture an image
status = system('ssh -x sam@10.5.6.56 "raspistill -o img.jpg"');

% Check the return status
if status == 0
    disp('Image captured successfully!');
else
    disp('Error: Failed to capture the image.');
end


% Transfer the captured image to your local machine
status = system('scp sam@10.5.6.56:/home/sam/img.jpg ./');

% Check the return status
if status == 0
    disp('Image transferred successfully!');
else
    disp('Error: Failed to transfer the image.');
end

    % 'img' variable stores the image file read by the function 'imread()'
    img = imread("C:/Users/Afeera Firdoose/Desktop/img.jpg");

    if size(img, 3) == 3  % Checks if the image is color (RGB)
        img_gray = rgb2gray(img); % Converts to grayscale image if colored
    else
        img_gray = img; % If already gray-scaled, original image file is stored.
    end

    % Asks the user if the inputted image is a digital text or handwritten
    % text
    answer = questdlg('Is the image handwritten or a digital text?', ...
                      'Select Image Type', ...
                      'Handwritten Text', 'Digital Text', 'Handwritten Text');

    % If else loop used to apply features according to users selection

    % Digital Text pre-processing
    if strcmp(answer, 'Digital Text')
        img_adjusted = imadjust(img_gray); %enhances the contrast of the gray-scaled image

        figure;
        imshow(img_adjusted); % Display adjusted image
        title('Contrast enhanced image');

        img_binary = imbinarize(img_adjusted); %converts the adjusted image to a black/white image (binarized)

        figure;
        imshow(img_binary); % Display binarized image
        title('Binarized image');

        img_filtered = medfilt2(img_binary, [3, 3]); % Applying median filter 

        struct_element = strel('disk', 1);  %creates a structural element in a disk shape for ease of applying morphological operations
        img_cleaned = imopen(img_filtered, struct_element); %performs morphological operations to remove small noise.

        figure;
        imshow(img_cleaned); % Display cleaned image after applying morphological operations

        % Perform OCR on cleaned image
        extracted_text = ocr(img_filtered); 

    else
        % Handwritten Text pre-processing
        img_adjusted = imadjust(img_gray); % Enhance contrast for handwritten text

        img_binary = imbinarize(img_adjusted); % Binarize the image

       
        % Applying Gaussian filter for smoothening
        gaussian_filter = fspecial('gaussian', [3, 3], 0.5); % Create 3x3 Gaussian filter
        img_smoothed = imfilter(img_binary, gaussian_filter); % Apply smoothing filter

        figure;
        imshow(img_smoothed); % Display smoothed image
        title('Gaussian filter applied to image');
        struct_element = strel('disk', 1); % Structuring element for morphological operation
        img_cleaned = imopen(img_smoothed, struct_element); % Clean small noise with morphological operations
        % Perform OCR on the cleaned and smoothed image
        extracted_text = ocr(img_smoothed); % OCR on smoothed image
    end

    % Extract text using OCR
    detected_text = extracted_text.Text; % Extract detected text from OCR results

    % Allow user to manually correct the text using edit box
    corrected_text = edited_text(detected_text); % Function to let user edit the detected text

    % Display the raw and corrected OCR outputs
    disp('Raw OCR Output:');
    disp(detected_text);
    disp('Corrected OCR Output:');
    disp(corrected_text);

    % Display the cleaned image after preprocessing
    figure;
    imshow(img_cleaned);
    title('Cleaned Image');

    % Display bounding boxes around recognized words in the original image
    figure;
    imshow(img);
    title('OCR Results with Bounding Boxes');
    hold on;
    for i = 1:numel(extracted_text.Words)
        rectangle('Position', extracted_text.WordBoundingBoxes(i, :), 'EdgeColor', 'red'); % Bounding boxes
        text(extracted_text.WordBoundingBoxes(i, 1), extracted_text.WordBoundingBoxes(i, 2) - 10, ...
             extracted_text.Words{i}, 'Color', 'blue', 'FontSize', 10); % Text for recognized words
    end
    hold off;

function corrected_text = edited_text(detected_text)

    % Function to allow the user to manually edit the extracted text
    figure_box = figure('Name', 'Edit OCR Text', 'Position', [300, 300, 600, 400]); % Create dialog box
    text_box = uicontrol('Style', 'edit', 'String', detected_text, 'Position', [10, 50, 580, 300], 'Max', 2, 'Min', 0); % Input detected text

    % Add a button to confirm text after editing
    uicontrol('Style', 'pushbutton', 'String', 'Confirm Edit', 'Position', [250, 10, 100, 30], 'Callback', @(src, event) uiresume(figure_box));

    uiwait(figure_box); % Waits until user clicks the button

    corrected_text = get(text_box, 'String'); % Get the corrected text

    close(figure_box); % Close the dialog box after user has confirmed edit
end


end