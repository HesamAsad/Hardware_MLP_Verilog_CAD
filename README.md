# Hardware implementation of a MLP using Verilog

<img src="https://github.com/HesamAsad/Hardware_MLP_Verilog/blob/master/report.jpg">

In this project, the goal is to implement a simple MLP (Multi-Layer Perceptron) model of neural networks. A neural network for image classification based on
the MNIST dataset is implemented in Verilog. The neural network hardware is implemented as a set of **processing units** (PUs) and a controller. 
Each PUs is a multiply-and-accumulate unit that has eight inputs. It has **eight** multipliers, an adder tree, and an activation function (here ReLU).

The most common form of neural networks is the Feed-Forward Multi-Layer Perceptron (MLP). A feed-forward neural network is an ANN wherein
connections between the neurons do not form a cycle. An n-layer MLP consists of one input layer, n-2 intermediate (hidden layers),
and one output layer. Each layer consists of a set of basic processing elements or neurons. An individual
neuron is connected to several neurons in the previous layer, from which it receives data, and also it is
connected to several neurons in the next layer, to which it sends data. Except for the input nodes, each
neuron uses a nonlinear activation function.

The pre-trained model is a simple MLP neural network that classifies the MNIST dataset. The original
MNIST dataset's images have dimensions of `28 x 28 pixels`, totally included `784` input features. In order
to simplify the classifier neural network, the size of images is reduced to `62` features using some feature
reduction algorithms. So, in this case, our neural network will have **62 input features.**

MNIST dataset has 10 output classes corresponding to the digits from 0 to 9, in which by recognizing the
digit i, the i'th output becomes one. To identify the label of an input image, the maximum value between
the outputs of 10 neurons must be selected. If neuron i has the highest output value, the input image tag
will be i.

The MLP in this project has `62 inputs` in the input layer, `10 output` neurons in the
output layer, and also one **hidden layer** with `30 neurons` is considered for this issue. In both layers of our
MLP model for MNIST classification, the `ReLU` function is considered as an activation function.

