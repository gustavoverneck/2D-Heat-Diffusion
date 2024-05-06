import os
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.animation import FuncAnimation

def runFortranCode(fortran_filename):
    # Run the fortran code
    os.system('gfortran -o ' + fortran_filename + ' ' + "ex.o")
    os.system('./' + "ex.o")
    os.system('rm ' + "ex.o")
    return

def readOutput(output_filename):
    # Read the output file
    data = []
    output_filename = output_filename
    with open(output_filename, 'r') as f:
        output = f.readlines()
        l = 0
        data.append([[],[],[]])
        for line in output:
            data[l][0].append(float(line.split()[0]))
            data[l][1].append(float(line.split()[1]))
            data[l][2].append(float(line.split()[2]))
            data.append([[],[],[]])
            if float(line.split()[0])==100 and float(line.split()[1])==100:   # x, y, T
                l += 1
    return data

def animate(i):
    print(i/400*100, "%")
    plt.clf()
    x = np.array(data[i][0])
    y = np.array(data[i][1])
    T = np.array(data[i][2])
    plt.scatter(x, y, c=T, cmap='jet')
    plt.colorbar()
    return

def init():
    plt.scatter([], [], c=[], cmap='jet')
    x = np.array(data[0][0])
    y = np.array(data[0][1])
    T = np.array(data[0][2])
    plt.scatter(x, y, c=T, cmap='jet')
    plt.colorbar()
    return

if __name__ == '__main__':
    runFortranCode("diffusionEqD2Q4.f90")
    data = readOutput("output.dat")

    fig = plt.figure()
    axis = plt.axes(xlim=(0, 100), ylim=(0, 100))
    mapa = axis.scatter([], [], c=[], cmap='jet')

    anim = FuncAnimation(fig, animate, frames=400, interval=20)
    anim.save('heat_diffusion.mp4',  
          writer = 'ffmpeg', fps = 30) 