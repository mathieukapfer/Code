import matplotlib.pyplot as plt
import numpy as np

fig, ax = plt.subplots(1, 1)
x = np.arange(-10, 10, 0.1)

ax.plot(x, np.sin(x))
ax.grid(True)

plt.show()
