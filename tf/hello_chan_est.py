import tensorflow as tf
import scipy.io
import numpy

#mnist = tf.keras.datasets.mnist

#(x_train, y_train), (x_test, y_test) = mnist.load_data()
#x_train, x_test = x_train / 255.0, x_test / 255.0

input_shape = (1, 612, 14, 1)
x = tf.random.normal(input_shape)

model = tf.keras.models.Sequential([
    # NOTE: to handle both real and imagnary part,
    # the input dim should be input_shape=(612, 14, 2)
    tf.keras.layers.Conv2D(64, 9, activation='relu', input_shape=(612, 14, 1), padding="same"),
    tf.keras.layers.Conv2D(64, 5, activation='relu', padding="same"),
    tf.keras.layers.Conv2D(64, 5, activation='relu', padding="same"),
    tf.keras.layers.Conv2D(32, 5, activation='relu', padding="same"),
    # NOTE: to handle both real and imagnary part,
    # the nb filter of last layer should be 2
    tf.keras.layers.Conv2D(1, 5, activation='relu', padding="same"),
])

y = model(x)
print(y.shape)
print(y.dtype)

# read mat files
trainDataMat = scipy.io.loadmat("chan_est_trainData2.mat")
trainLabelsMat = scipy.io.loadmat("chan_est_trainLabels2.mat")

# get batch lenght i.e. last column
batchLen = len(trainDataMat['trainData'][1][1][1])

# get data from dictionnary and split batch in train and test subset
x_train = trainDataMat['trainData'][:,:,:,0:batchLen//2]
y_train = trainLabelsMat['trainLabels'][:,:,:,0:batchLen//2]
x_test = trainDataMat['trainData'][:,:,:,batchLen//2+1:batchLen]
y_test = trainLabelsMat['trainLabels'][:,:,:,batchLen//2+1:batchLen]

# move batch column first
x_train_t =  numpy.transpose(x_train,[3,0,1,2])
y_train_t =  numpy.transpose(x_train,[3,0,1,2])
x_test_t =  numpy.transpose(x_test,[3,0,1,2])
y_test_t =  numpy.transpose(x_test,[3,0,1,2])

print(x_train_t.shape)
print(y_train_t.shape)
print(x_test_t.shape)
print(y_test_t.shape)

# extract real part
x_train_r = x_train_t[:,:,:,0:1]
y_train_r = y_train_t[:,:,:,0:1]
x_test_r = x_test_t[:,:,:,0:1]
y_test_r = y_test_t[:,:,:,0:1]

print(x_train_r.shape)
print(y_train_r.shape)
print(x_test_r.shape)
print(y_test_r.shape)

# compile
model.compile(optimizer='adam',
              loss=tf.keras.losses.MeanSquaredError(),
              metrics=['accuracy'])
# train
model.fit(x_train_r, y_train_r, epochs=5)

# test
model.evaluate(x_test_r, y_test_r)
