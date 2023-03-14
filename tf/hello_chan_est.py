import tensorflow as tf
import scipy.io
import numpy as np
import mat73
import matplotlib.pyplot as plt

# script params
# =================================================================
training = False
evaluate = True
traindata_size = 256
nb_input_depth = 2   # value '2' means one layer with real and complex value
weight_file = "chan_test_25600"

# =================================================================
# cnn definition
input_shape = (1, 612, 14, nb_input_depth)
x = tf.random.normal(input_shape)

model = tf.keras.models.Sequential([
    tf.keras.layers.Conv2D(64, 9, activation='relu', input_shape=(612, 14, nb_input_depth), padding="same"),
    tf.keras.layers.Conv2D(64, 5, activation='relu', padding="same"),
    tf.keras.layers.Conv2D(64, 5, activation='relu', padding="same"),
    tf.keras.layers.Conv2D(32, 5, activation='relu', padding="same"),
#    tf.keras.layers.Conv2D(nb_input_depth, 5, activation='relu', padding="same"),
    tf.keras.layers.Conv2D(nb_input_depth, 5, padding="same"),
])

y = model(x)
print(y.shape)
print(y.dtype)

# read mat files
if traindata_size <= 25600:
    trainDataMat = scipy.io.loadmat(f"trainData_{traindata_size}.mat")
    trainLabelsMat = scipy.io.loadmat(f"trainLabels_{traindata_size}.mat")
else:
    trainDataMat = mat73.loadmat(f"trainData_{traindata_size}.mat")
    trainLabelsMat = mat73.loadmat("trainLabels_{traindata_size}.mat")

# get batch lenght i.e. last column
batchLen = len(trainDataMat['trainData'][1][1][1])

# get data from dictionnary and split batch in train and test subset
x_train = trainDataMat['trainData'][:,:,:,0:batchLen//2]
y_train = trainLabelsMat['trainLabels'][:,:,:,0:batchLen//2]
x_test = trainDataMat['trainData'][:,:,:,batchLen//2+1:batchLen]
y_test = trainLabelsMat['trainLabels'][:,:,:,batchLen//2+1:batchLen]

# move batch column first
x_train_t =  np.transpose(x_train,[3,0,1,2])
y_train_t =  np.transpose(y_train,[3,0,1,2])
x_test_t =  np.transpose(x_test,[3,0,1,2])
y_test_t =  np.transpose(y_test,[3,0,1,2])

print(x_train_t.shape)
print(y_train_t.shape)
print(x_test_t.shape)
print(y_test_t.shape)

if nb_input_depth == 1:
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
              metrics=[tf.keras.metrics.MeanSquaredError()])

# display model information
model.summary()

# train or execute
if training:
    print("Training in progress\n")
    # fit
    if nb_input_depth == 1:
        # work with real (or imaginary) part
        # train
        model.fit(x_train_r, y_train_r, epochs=5)
    else:
        # work with complex value
        # train
        model.fit(x_train_t, y_train_t, validation_data=(x_test_t, y_test_t),  epochs=5 )

    model.save(weight_file)
else:
    print("Load previous weight\n")
    model.load_weights(weight_file)

# evaluate
if evaluate:
    print("Evaluate")
    if nb_input_depth == 1:
        # test
        model.evaluate(x_test_r, y_test_r)
    else:
        model.fit(x_train_t, y_train_t, validation_data=(x_test_t, y_test_t),  epochs=1 )
        # test
        model.evaluate(x_test_t, y_test_t)


# display one example
for num in range(x_test[0,0,0].shape[0]):
    plt.figure()

    # display grid
    plt.subplot(141)
    plt.title("input grid")
    plt.imshow(x_test[:,:,0,num], cmap='hot', extent = [0, 14, 0, 20])

    # compute model estimation
    m_test = model(x_test_t[num:num+1,:,:,:])[0,:,:,0]

    # get range
    _min = min(np.min(y_test[:, :, 0, num]), np.min(m_test))
    _max = max(np.max(y_test[:, :, 0, num]), np.min(m_test))

    # display perfect estimation
    plt.subplot(142)
    plt.title("perfect")
    plt.imshow(y_test[:, :, 0, num], cmap='hot', vmin=_min, vmax=_max, extent=[0, 14, 0, 20])

    # display model estimation
    plt.subplot(143)
    plt.title("model")
    plt.imshow(m_test, cmap='hot', vmin=_min, vmax=_max, extent=[0, 14, 0, 20])

    # display error (same range)
    ax= plt.subplot(144)
    #plt.imshow(m_test-y_test[:,:,0,num], cmap='hot', vmin = _min, vmax = _max, extent = [0, 14, 0, 20])
    plt.title("hist abs diff")
    er = np.abs((m_test-y_test[:,:,0,num]).numpy())
    plt.hist(er.reshape([-1]), bins=30)

    # display standard deviation of error
    std_dev = np.std(er)
    plt.text(0.99, 0.99, s=f'{std_dev:0.5}', ha='right', va='top', transform=ax.transAxes)

    print(f'std:{std_dev}')

    plt.show() # block=False)
