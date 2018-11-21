# DeepLightFieldSSR

# Light Field Spatial Super-Resolution Using Deep Efficient Spatial-Angular Separable Convolution

### Requirements and Dependencies

- Matlab
- cuda and cudnn (For GPU. Please modify install.m if not using cudnn)

### Installation

    # Start MATLAB
    $ matlab
    >> install

### Training

Please first download the dataset from http://lightfields.stanford.edu/

    >> train_Spatial_SR(scale, depth, gpu)

scale: needs to be 2, 3 or 4. <br />
depth: the desired model depth (recommended 10). <br />
gpu: 1 if using GPU, otherwise 0. <br />

### Testing Pretrained Models

Please first download all images from the miscellenous class from http://lightfields.stanford.edu/

    >> test_pretrained(model_scale, gpu)

model_scale: needs to be 2, 3 or 4. <br />
gpu: 1 if using GPU, otherwise 0. <br />

### Authors

Henry W. F Yeung*, Junhui Hou*, XiaoMing Chen, Jie Chen, Zhibo Chen and Yuk Ying Chung

*Contributed equally to this paper.
